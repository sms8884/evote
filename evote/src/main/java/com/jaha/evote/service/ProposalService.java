package com.jaha.evote.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import com.jaha.evote.common.exception.EvoteBizException;
import com.jaha.evote.common.util.FileUploadUtil;
import com.jaha.evote.common.util.Messages;
import com.jaha.evote.common.util.NumberUtils;
import com.jaha.evote.common.util.XecureUtil;
import com.jaha.evote.domain.Config;
import com.jaha.evote.domain.EncryptedString;
import com.jaha.evote.domain.GcmInfo;
import com.jaha.evote.domain.Member;
import com.jaha.evote.domain.PropComment;
import com.jaha.evote.domain.Proposal;
import com.jaha.evote.domain.ProposalAudit;
import com.jaha.evote.domain.Pssrp;
import com.jaha.evote.domain.PublicSubscription;
import com.jaha.evote.domain.common.FileInfo;
import com.jaha.evote.domain.type.CodeType;
import com.jaha.evote.domain.type.ConfigType;
import com.jaha.evote.domain.type.FileGrpType;
import com.jaha.evote.domain.type.FileType;
import com.jaha.evote.domain.type.GcmType;
import com.jaha.evote.domain.type.ProposalStatus;
import com.jaha.evote.domain.type.UserStatus;
import com.jaha.evote.mapper.ConfigMapper;
import com.jaha.evote.mapper.ProposalMapper;
import com.jaha.evote.mapper.PublicSubscriptionMapper;
import com.jaha.evote.mapper.common.FileMapper;

/**
 * <pre>
 * Class Name : ProposalService.java
 * Description : 정책제안 서비스
 *  
 * Modification Information
 * 
 * Mod Date         Modifier    Description
 * -----------      --------    ---------------------------
 * 2016. 7. 14.     shavrani    Generation
 * 2016. 10. 10.    jjpark      GCM 추가
 * </pre>
 *
 * @author shavrani
 * @since 2016. 7. 14.
 * @version 1.0
 */
@Service
public class ProposalService extends BaseService {

    @Autowired
    private ProposalMapper proposalMapper;

    @Autowired
    private ConfigMapper configMapper;

    @Autowired
    private PublicSubscriptionMapper publicSubscriptionMapper;

    @Autowired
    private FileMapper fileMapper;

    @Autowired
    private FileService fileService;

    @Autowired
    private GcmService gcmService;


    @Autowired
    private FileUploadUtil fileUploadUtil;

    @Autowired
    private Messages messages;

    @Value("${service.site.url}")
    private String serviceSiteUrl;

    /**
     * 메인화면 정책제안 리스트
     * 
     * @param params
     * @return
     */
    public List<Proposal> selectMainProposalList() {
        return proposalMapper.selectMainProposalList(getSiteCd());
    }

    /**
     * 정책제안 리스트
     * 
     * @param params
     * @return
     */
    public List<Proposal> selectProposalList(Map<String, Object> params) {

        Member member = getLoginMember();
        if (member != null) {
            params.put("userSeq", member.getUserSeq());
        }

        params.put("siteCd", getSiteCd());
        params.put("statusCodeGroup", CodeType.CODE_GROUP_PROPOSAL_STATUS.getCode());
        return proposalMapper.selectProposalList(params);
    }

    /**
     * 정책제안 리스트(어드민)
     * 
     * @param params
     * @return
     */
    @Transactional(readOnly = true)
    public List<Proposal> selectProposalListAdmin(Map<String, Object> params) {
        params.put("siteCd", getSiteCd());
        params.put("statusCodeGroup", CodeType.CODE_GROUP_PROPOSAL_STATUS.getCode());
        return proposalMapper.selectProposalList(params);
    }

    /**
     * 정책제안 엑셀 리스트
     * 
     * @param params
     * @return
     */
    @Transactional(readOnly = true)
    public List<HashMap<String, Object>> selectProposalListExcel(Map<String, Object> params) {
        params.put("siteCd", getSiteCd());
        params.put("statusCodeGroup", CodeType.CODE_GROUP_PROPOSAL_STATUS.getCode());
        return proposalMapper.selectProposalListExcel(params);
    }

    /**
     * 정책제안 리스트 count ( 조회조건만 적용한 limit구문 제외한 count, paging에 사용 )
     * 
     * @param params
     * @return
     */
    @Transactional(readOnly = true)
    public int selectProposalListCount(Map<String, Object> params) {
        params.put("siteCd", getSiteCd());
        return proposalMapper.selectProposalListCount(params);
    }

    /**
     * 정책제안 단일 검색
     * 
     * @param params
     * @return
     */
    @Transactional(readOnly = true)
    public Proposal selectProposal(Map<String, Object> params) {

        Member member = getLoginMember();
        if (member != null) {
            params.put("userSeq", member.getUserSeq());
        }

        if (params == null || params.get("propSeq") == null) {

            logger.debug("### params ::: [{}]", params);

            // 해당 제안이 존재하지않습니다.
            throw new EvoteBizException(messages.getMessage("message.proposal.info.001"));
        }

        params.put("siteCd", getSiteCd());
        params.put("statusCodeGroup", CodeType.CODE_GROUP_PROPOSAL_STATUS.getCode());
        return proposalMapper.selectProposal(params);
    }

    /**
     * 정책제안 단일 검색(어드민)
     * 
     * @param params
     * @return
     */
    @Transactional(readOnly = true)
    public Proposal selectProposalAdmin(Map<String, Object> params) {
        if (params == null || params.get("propSeq") == null) {

            logger.debug("### params ::: [{}]", params);

            // 해당 제안이 존재하지않습니다.
            throw new EvoteBizException(messages.getMessage("message.proposal.info.001"));
        }

        params.put("siteCd", getSiteCd());
        params.put("statusCodeGroup", CodeType.CODE_GROUP_PROPOSAL_STATUS.getCode());
        return proposalMapper.selectProposal(params);
    }

    /**
     * 정책제안 저장
     * 
     * @param proposal
     * @param imageList
     * @param attachList
     * @param deleteFileSeq
     * @return
     */
    @Transactional
    public int saveProposal(Proposal proposal, List<FileInfo> imageList, List<FileInfo> attachList, String deleteFile) {

        // 신규 등록 여부
        boolean isNewProposal = false;;
        if (proposal.getPropSeq() == null) {
            isNewProposal = true;
        }

        int result = proposalMapper.saveProposal(proposal);

        if (result > 0) {

            // fileService

            long fileGrpSeq = proposal.getPropSeq();
            String fileDesc = "";

            if (imageList != null && !imageList.isEmpty()) {
                fileDesc = "proposal [ " + proposal.getBizNm() + " ]의 image file"; // 파일 설명
                for (FileInfo fileInfo : imageList) {
                    fileInfo.setFileGrpSeq(fileGrpSeq);
                    fileInfo.setFileDesc(fileDesc);
                    fileService.insertFileInfo(fileInfo);
                }


            }

            if (attachList != null && !attachList.isEmpty()) {
                fileDesc = "proposal [ " + proposal.getBizNm() + " ]의 attach file"; // 파일 설명
                for (FileInfo fileInfo : attachList) {
                    fileInfo.setFileGrpSeq(fileGrpSeq);
                    fileInfo.setFileDesc(fileDesc);
                    fileService.insertFileInfo(fileInfo);
                }
            }

            // 파일 삭제
            //            if (deleteFileSeq != null && deleteFileSeq.length > 0) {
            //                for (Long fileSeq : deleteFileSeq) {
            //                    fileService.deleteFileInfo(fileSeq);
            //                }
            //            }
            if (StringUtils.isNotEmpty(deleteFile)) {

                String[] deleteFiles = deleteFile.split("[|]");
                FileInfo fileInfo = null;
                long tmpFileSeq = 0L;

                for (String delFileSeq : deleteFiles) {
                    tmpFileSeq = NumberUtils.toLong(delFileSeq, 0L);
                    fileInfo = new FileInfo();
                    fileInfo.setFileSeq(NumberUtils.toLong(delFileSeq, 0L));
                    fileInfo.setModUser(getUserSeq());
                    if (tmpFileSeq > 0) {
                        fileMapper.deleteFileInfo(fileInfo);
                    }
                }

            }

            //=================================================================
            // SEND GCM [2016-10-10] 추가 : by jjpark
            //=================================================================

            // 신규 등록 여부
            if (isNewProposal) {

                GcmInfo gcmInfo = this.getProposalGcmInfo(proposal);

                if (gcmInfo != null) {

                    Config config = new Config();
                    config.setSiteCd(getSiteCd());
                    config.setUserStat(UserStatus.AVAILABLE);
                    config.setConfigGroup(ConfigType.CONFIG_GROUP_PUSH.getCode());  // 푸시설정그룹
                    config.setConfigCode(ConfigType.CONFIG_PUSH_NEW.getCode());     // 새글알림

                    // 유효한 회원 중 PUSH 설정이 Y 인 회원 목록
                    List<String> pushKeyList = configMapper.selectPushKeyList(config);

                    // PUSH 전송
                    gcmService.send(gcmInfo, pushKeyList, ConfigType.CONFIG_PUSH_NEW.getCode());

                }

            }


        }

        return result;
    }


    /**
     * 정책제안 삭제처리. ( 실제로는 deleteYn을 update 처리 )
     * 
     * @param propSeq
     * @return
     */
    @Transactional
    public int deleteProposal(long propSeq) {

        Member member = getLoginMember();

        if (member == null) {

            // 삭제권한이 없습니다.
            throw new EvoteBizException(messages.getMessage("message.proposal.022"));

        } else if (propSeq <= 0) {

            // 해당 제안이 존재하지않습니다.
            throw new EvoteBizException(messages.getMessage("message.proposal.info.001"));

        }

        Map<String, Object> params = new HashMap<>();
        params.put("propSeq", propSeq);
        params.put("userSeq", member.getUserSeq());
        params.put("siteCd", getSiteCd());
        params.put("deleteYn", "N");

        Proposal proposal = proposalMapper.selectProposal(params);

        if (proposal == null) {

            // 해당 제안이 존재하지않습니다.
            throw new EvoteBizException(messages.getMessage("message.proposal.info.001"));

        } else if (!"Y".equals(proposal.getOwnerYn())) {

            // 삭제권한이 없습니다.
            throw new EvoteBizException(messages.getMessage("message.proposal.022"));

        } else if (!ProposalStatus.PENDING.equals(proposal.getStatus())) {

            // 삭제권한이 없습니다.
            throw new EvoteBizException(messages.getMessage("message.proposal.022"));
        }

        int result = proposalMapper.deleteProposal(params);

        if (result > 0) {
            fileService.deleteFileGroup(proposal.getPropSeq(), FileGrpType.PROPOSAL);
        }


        return result;
    }

    /**
     * 조회수 count + 1 ( java에서 증가시킨 조회수를 update 처리 )
     * 
     * @param params
     * @return
     */
    @Transactional
    public int updateReadCount(Map<String, Object> params) {
        return proposalMapper.updateProposalItem(params);
    }

    /**
     * 제안공감 count
     * 
     * @param params
     * @return
     */
    public int selectSympathyCount(Map<String, Object> params) {
        return proposalMapper.selectSympathyCount(params);
    }

    /**
     * 제안공감 단일 검색
     * 
     * @param params
     * @return
     */
    public Map<String, Object> selectSympathy(Map<String, Object> params) {
        return proposalMapper.selectSympathy(params);
    }

    /**
     * 제안공감 저장
     * 
     * @param params
     * @return
     */
    @Transactional
    public int insertSympathy(Map<String, Object> params) {
        return proposalMapper.insertSympathy(params);
    }

    /**
     * 제안공감 삭제
     * 
     * @param params
     * @return
     */
    @Transactional
    public int deleteSympathy(Map<String, Object> params) {
        return proposalMapper.deleteSympathy(params);
    }

    /**
     * 정책제안에 해당하는 댓글 리스트
     * 
     * @param params
     * @return
     */
    public List<PropComment> selectCommentList(Map<String, Object> params) {

        Member member = getLoginMember();
        if (member != null) {
            params.put("userSeq", member.getUserSeq());
        }

        return proposalMapper.selectCommentList(params);
    }


    /**
     * 정책제안에 해당하는 댓글 리스트(어드민)
     * 
     * @param params
     * @return
     */
    public List<PropComment> selectCommentListAdmin(Map<String, Object> params) {
        return proposalMapper.selectCommentList(params);
    }

    /**
     * 댓글 단일 검색
     * 
     * @param params
     * @return
     */
    public PropComment selectComment(Map<String, Object> params) {
        Member member = getLoginMember();
        if (member != null) {
            params.put("userSeq", member.getUserSeq());
        }
        return proposalMapper.selectComment(params);
    }

    /**
     * 댓글 저장 ( ON DUPLICATE KEY UPDATE 사용, insert, update 공용 )
     * 
     * @param propComment
     * @return
     */
    @Transactional
    public int saveComment(PropComment propComment) {

        int result = proposalMapper.saveComment(propComment);

        if (result > 0 && propComment.getCmtSeq() == null) {

            long userSeq = getUserSeq();

            Map<String, Object> params = new HashMap<>();

            params.put("userSeq", userSeq);
            params.put("propSeq", propComment.getPropSeq());
            params.put("siteCd", getSiteCd());

            Proposal proposal = proposalMapper.selectProposal(params);

            if (proposal != null && (proposal.getRegUser() != null && proposal.getRegUser() > 0 && proposal.getRegUser() != userSeq)) {
                GcmInfo gcmInfo = getProposalCommentGcmInfo(proposal);

                if (gcmInfo != null) {

                    Config config = new Config();
                    config.setSiteCd(getSiteCd());
                    config.setUserSeq(proposal.getRegUser());
                    config.setUserStat(UserStatus.AVAILABLE);
                    config.setConfigGroup(ConfigType.CONFIG_GROUP_PUSH.getCode());  // 푸시설정그룹
                    config.setConfigCode(ConfigType.CONFIG_PUSH_CMT.getCode());     // 댓글알림

                    // 유효한 회원 중 PUSH 설정이 Y 인 회원 목록
                    List<String> pushKeyList = configMapper.selectPushKeyList(config);

                    logger.debug("### pushKeyList :: [{}]", pushKeyList);

                    // PUSH 전송
                    gcmService.send(gcmInfo, pushKeyList, ConfigType.CONFIG_PUSH_CMT.getCode());

                }
            }

            logger.debug("### proposal :: {}", proposal);

        }

        return result;
    }

    /**
     * 댓글 숨김처리
     * 
     * @param params
     * @return
     */
    @Transactional
    public int hideComment(Map<String, Object> params) {
        return proposalMapper.hideComment(params);
    }

    /**
     * 댓글 삭제 ( 댓글의 동의/비동의 와 신고도 일괄삭제 )
     * 
     * @param params
     * @return
     */
    @Transactional
    public int deleteComment(Map<String, Object> params) {

        int result = proposalMapper.deleteComment(params);
        if (result > 0) {
            // TODO: 삭제할지 말지...
            proposalMapper.deleteCommentAgree(params);
            proposalMapper.deleteCommentReport(params);
        }
        return result;
    }

    /**
     * 댓글 동의/비동의 저장 ( ON DUPLICATE KEY UPDATE 사용, insert, update 공용 )
     * 
     * @param params
     * @return
     */
    @Transactional
    public int saveCommentAgree(Map<String, Object> params) {
        return proposalMapper.saveCommentAgree(params);
    }

    /**
     * 댓글 신고 단일 조회
     * 
     * @param params
     * @return
     */
    public Map<String, Object> selectCommentReport(Map<String, Object> params) {
        return proposalMapper.selectCommentReport(params);
    }

    /**
     * 댓글 신고 저장
     * 
     * @param params
     * @return
     */
    @Transactional
    public int insertCommentReport(Map<String, Object> params) {
        return proposalMapper.insertCommentReport(params);
    }

    /**
     * 제안검토 저장 ( ON DUPLICATE KEY UPDATE 사용, insert, update 공용 )
     * 
     * @param proposalAudit
     * @return
     */
    @Transactional
    public int saveProposalAudit(ProposalAudit proposalAudit) {
        return proposalMapper.saveProposalAudit(proposalAudit);
    }

    /**
     * 제안검토 단일 조회
     * 
     * @param params
     * @return
     */
    public ProposalAudit selectProposalAudit(Map<String, Object> params) {
        return proposalMapper.selectProposalAudit(params);
    }

    /**
     * 정책제안 상태값 저장
     * 
     * @param proposalAudit
     * @return
     */
    @Transactional
    public int saveProposalStatus(ProposalAudit proposalAudit) {
        return proposalMapper.saveProposalStatus(proposalAudit);
    }

    /**
     * 방문객 정책제안 수정화면
     * 
     * @param propSeq
     * @param visitorPw
     * @return
     */
    public Proposal selectVisitorProposal(long propSeq, String visitorPw) {

        Map<String, Object> params = new HashMap<>();

        params.put("propSeq", propSeq);
        params.put("deleteYn", "N");
        params.put("siteCd", getSiteCd());

        Proposal proposal = proposalMapper.selectProposal(params);

        // 방문객 제안 권한 검증
        String verifyMessage = verifyVisitorProposal(proposal, visitorPw);
        if (verifyMessage != null) {
            throw new EvoteBizException(verifyMessage);
        }

        return proposal;
    }

    /**
     * 방문객 제안 수정
     * 
     * @param proposal
     * @param imageList
     * @param attachList
     * @param deleteFile
     * @return
     */
    @Transactional
    public int saveVisitorProposal(Proposal proposal, List<FileInfo> imageList, List<FileInfo> attachList, String deleteFile) {

        Map<String, Object> params = new HashMap<>();

        params.put("propSeq", proposal.getPropSeq());
        params.put("deleteYn", "N");
        params.put("siteCd", getSiteCd());

        Proposal orgProposal = proposalMapper.selectProposal(params);

        // 방문객 제안 권한 검증
        String verifyMessage = verifyVisitorProposal(orgProposal, proposal.getReqPw().getValue());
        if (verifyMessage != null) {
            throw new EvoteBizException(verifyMessage);
        }

        // 암호화
        proposal.setReqNm(new EncryptedString(XecureUtil.encString(proposal.getReqNm().getValue())));
        proposal.setReqEmail(new EncryptedString(XecureUtil.encString(proposal.getReqEmail().getValue())));

        int result = proposalMapper.updateVisitorProposal(proposal);

        if (result > 0) {

            long fileGrpSeq = proposal.getPropSeq();
            String fileDesc = "";

            if (imageList != null && !imageList.isEmpty()) {
                fileDesc = "proposal [ " + proposal.getBizNm() + " ]의 image file"; // 파일 설명
                for (FileInfo fileInfo : imageList) {
                    fileInfo.setFileGrpSeq(fileGrpSeq);
                    fileInfo.setFileDesc(fileDesc);
                    fileService.insertFileInfo(fileInfo);
                }


            }

            if (attachList != null && !attachList.isEmpty()) {
                fileDesc = "proposal [ " + proposal.getBizNm() + " ]의 attach file"; // 파일 설명
                for (FileInfo fileInfo : attachList) {
                    fileInfo.setFileGrpSeq(fileGrpSeq);
                    fileInfo.setFileDesc(fileDesc);
                    fileService.insertFileInfo(fileInfo);
                }
            }

            // 파일 삭제
            //            if (deleteFileSeq != null && deleteFileSeq.length > 0) {
            //                for (Long fileSeq : deleteFileSeq) {
            //                    fileService.deleteFileInfo(fileSeq);
            //                }
            //            }
            if (StringUtils.isNotEmpty(deleteFile)) {

                String[] deleteFiles = deleteFile.split("[|]");
                FileInfo fileInfo = null;
                long tmpFileSeq = 0L;

                for (String delFileSeq : deleteFiles) {
                    tmpFileSeq = NumberUtils.toLong(delFileSeq, 0L);
                    fileInfo = new FileInfo();
                    fileInfo.setFileSeq(NumberUtils.toLong(delFileSeq, 0L));
                    fileInfo.setModUser(getUserSeq());
                    if (tmpFileSeq > 0) {
                        fileMapper.deleteFileInfo(fileInfo);
                    }
                }

            }

        }

        return result;
    }

    /**
     * 방문객 정책제안 삭제처리. ( 실제로는 deleteYn을 update 처리 )
     * 
     * @param propSeq
     * @param visitorPw
     * @return
     */
    @Transactional
    public int deleteVisitorProposal(long propSeq, String visitorPw) {

        Map<String, Object> params = new HashMap<>();

        params.put("propSeq", propSeq);
        params.put("deleteYn", "N");
        params.put("siteCd", getSiteCd());

        Proposal proposal = proposalMapper.selectProposal(params);

        // 방문객 제안 권한 검증
        String verifyMessage = verifyVisitorProposal(proposal, visitorPw);
        if (verifyMessage != null) {
            throw new EvoteBizException(verifyMessage);
        }

        int result = proposalMapper.deleteVisitorProposal(propSeq);

        if (result > 0) {
            fileService.deleteFileGroup(propSeq, FileGrpType.PROPOSAL);
        }

        return result;
    }

    /**
     * 방문객 권한 검증
     * 
     * @param proposal
     * @param visitorPw
     * @return
     */
    private String verifyVisitorProposal(Proposal proposal, String visitorPw) {

        if (proposal == null) {

            /*
             * 1. 제안 정보 없음 msg : 해당 제안이 존재하지않습니다.
             */
            return messages.getMessage("message.proposal.info.001");

        } else if ("Y".equals(proposal.getMemberYn())) {

            /*
             * 2. 가입 회원이 등록한 제안 msg : 해당 제안이 존재하지않습니다.
             */

            return messages.getMessage("message.proposal.info.001");

        } else if (!ProposalStatus.PENDING.equals(proposal.getStatus())) {

            /*
             * 3. 제안 검토대기가 아닐 경우 수정 불가 msg : 수정권한이 없습니다.
             */

            return messages.getMessage("message.proposal.021");

        } else if (visitorPw == null || !XecureUtil.verifyHash64(visitorPw, proposal.getReqPw().getValue())) {

            /*
             * 4. 비밀번호 검증 실패 msg : 비밀번호가 일치하지 않습니다.
             */
            return messages.getMessage("message.proposal.020");
        }

        return null;
    }

    /**
     * 공모 리스트
     * 
     * @param params
     * @return
     */
    @Transactional(readOnly = true)
    public List<Pssrp> selectPssrpList(Map<String, Object> params) {
        params.put("siteCd", getSiteCd());
        return proposalMapper.selectPssrpList(params);
    }

    /**
     * 현재 진행중인 공모 목록 조회
     * 
     * @return
     */
    public PublicSubscription selectCurrentPublicSubscription() {

        String siteCd = getSiteCd();

        List<PublicSubscription> list = publicSubscriptionMapper.selectCurrentPssrpList(siteCd);

        PublicSubscription publicSubscription = null;

        if (list != null && list.size() > 0) {

            publicSubscription = list.get(0);

            List<FileInfo> fileList = fileService.selectFileInfoList(publicSubscription.getPsSeq(), FileGrpType.PSSRP);

            if (fileList != null && fileList.size() > 0) {
                for (FileInfo fileInfo : fileList) {
                    if (FileType.REQ_REALM.equals(fileInfo.getFileType())) {
                        publicSubscription.setReqRealmFile(fileInfo);
                    } else if (FileType.REQ_METHOD.equals(fileInfo.getFileType())) {
                        publicSubscription.setReqMethodFile(fileInfo);
                    } else if (FileType.IMG_WEB.equals(fileInfo.getFileType())) {
                        publicSubscription.setImagePcFile(fileInfo);
                    } else if (FileType.IMG_MOB.equals(fileInfo.getFileType())) {
                        publicSubscription.setImageMobileFile(fileInfo);
                    }
                }
            }
        }

        return publicSubscription;
    }


    /**
     * 공모 리스트 총 카운트
     * 
     * @param params
     * @return
     */
    @Transactional(readOnly = true)
    public int selectPssrpListCount(Map<String, Object> params) {
        params.put("siteCd", getSiteCd());
        return proposalMapper.selectPssrpListCount(params);
    }

    /**
     * 공모 정보
     * 
     * @param params
     * @return
     */
    @Transactional(readOnly = true)
    public Pssrp getPssrp(Map<String, Object> params) {
        params.put("siteCd", getSiteCd());
        return proposalMapper.getPssrp(params);
    }

    /**
     * 공모 정보 저장
     * 
     * @param params
     * @return
     */
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = {Exception.class})
    public Pssrp insertPssrp(Pssrp params) {
        params.setSiteCd(getSiteCd());
        proposalMapper.insertPssrp(params);

        // 파일저장
        MultipartFile realmfile = params.getRealmfile(); // 신청분야
        if (realmfile != null && realmfile.getSize() > 0) {
            Map<String, String> storeFileMap = fileUploadUtil.saveFile(realmfile, FileGrpType.PSSRP);
            FileInfo fileInfo = new FileInfo();
            fileInfo.setFileNm(storeFileMap.get("storeFileName"));
            fileInfo.setFilePath(storeFileMap.get("storeFilePath"));
            fileInfo.setFileExt(storeFileMap.get("storeFileExt"));

            fileInfo.setFileSrcNm(realmfile.getOriginalFilename());
            fileInfo.setFileGrpType(FileGrpType.PSSRP);
            fileInfo.setFileType(FileType.REQ_REALM);
            fileInfo.setFileSize(realmfile.getSize());
            fileInfo.setFileGrpSeq(params.getPsSeq());
            fileService.insertFileInfo(fileInfo);
        }

        MultipartFile methodfile = params.getMethodfile(); // 신청방법
        if (methodfile != null && methodfile.getSize() > 0) {
            Map<String, String> storeFileMap = fileUploadUtil.saveFile(methodfile, FileGrpType.PSSRP);
            FileInfo fileInfo = new FileInfo();
            fileInfo.setFileNm(storeFileMap.get("storeFileName"));
            fileInfo.setFilePath(storeFileMap.get("storeFilePath"));
            fileInfo.setFileExt(storeFileMap.get("storeFileExt"));

            fileInfo.setFileSrcNm(methodfile.getOriginalFilename());
            fileInfo.setFileGrpType(FileGrpType.PSSRP);
            fileInfo.setFileType(FileType.REQ_METHOD);
            fileInfo.setFileSize(methodfile.getSize());
            fileInfo.setFileGrpSeq(params.getPsSeq());
            fileService.insertFileInfo(fileInfo);
        }
        MultipartFile imgpcfile = params.getImgpcfile();// 흐름도PC이미지
        if (imgpcfile != null && imgpcfile.getSize() > 0) {
            Map<String, String> storeFileMap = fileUploadUtil.saveFile(imgpcfile, FileGrpType.PSSRP);
            FileInfo fileInfo = new FileInfo();
            fileInfo.setFileNm(storeFileMap.get("storeFileName"));
            fileInfo.setFilePath(storeFileMap.get("storeFilePath"));
            fileInfo.setFileExt(storeFileMap.get("storeFileExt"));

            fileInfo.setFileSrcNm(imgpcfile.getOriginalFilename());
            fileInfo.setFileGrpType(FileGrpType.PSSRP);
            fileInfo.setFileType(FileType.IMG_WEB);
            fileInfo.setFileSize(imgpcfile.getSize());
            fileInfo.setFileGrpSeq(params.getPsSeq());
            fileService.insertFileInfo(fileInfo);
        }
        MultipartFile imgmobfile = params.getImgmobfile();// 흐름도모바일이미지
        if (imgmobfile != null && imgmobfile.getSize() > 0) {
            Map<String, String> storeFileMap = fileUploadUtil.saveFile(imgmobfile, FileGrpType.PSSRP);
            FileInfo fileInfo = new FileInfo();
            fileInfo.setFileNm(storeFileMap.get("storeFileName"));
            fileInfo.setFilePath(storeFileMap.get("storeFilePath"));
            fileInfo.setFileExt(storeFileMap.get("storeFileExt"));
            fileInfo.setFileSrcNm(imgmobfile.getOriginalFilename());
            fileInfo.setFileGrpType(FileGrpType.PSSRP);
            fileInfo.setFileType(FileType.IMG_MOB);
            fileInfo.setFileSize(imgmobfile.getSize());
            fileInfo.setFileGrpSeq(params.getPsSeq());
            fileService.insertFileInfo(fileInfo);
        }
        return params;
    }

    /**
     * 공모 정보 업데이트
     * 
     * @param params
     * @return
     */
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = {Exception.class})
    public void updatePssrp(Pssrp params) {
        params.setSiteCd(getSiteCd());
        proposalMapper.updatePssrp(params);

        // 파일저장
        MultipartFile realmfile = params.getRealmfile(); // 신청분야
        if (realmfile != null && realmfile.getSize() > 0) {
            // 이전파일 삭제
            fileService.deleteFileGroup(params.getPsSeq(), FileGrpType.PSSRP, FileType.REQ_REALM);
            Map<String, String> storeFileMap = fileUploadUtil.saveFile(realmfile, FileGrpType.PSSRP);
            FileInfo fileInfo = new FileInfo();
            fileInfo.setFileNm(storeFileMap.get("storeFileName"));
            fileInfo.setFilePath(storeFileMap.get("storeFilePath"));
            fileInfo.setFileExt(storeFileMap.get("storeFileExt"));

            fileInfo.setFileSrcNm(realmfile.getOriginalFilename());
            fileInfo.setFileGrpType(FileGrpType.PSSRP);
            fileInfo.setFileType(FileType.REQ_REALM);
            fileInfo.setFileSize(realmfile.getSize());
            fileInfo.setFileGrpSeq(params.getPsSeq());
            fileService.insertFileInfo(fileInfo);
        }

        MultipartFile methodfile = params.getMethodfile(); // 신청방법
        if (methodfile != null && methodfile.getSize() > 0) {
            // 이전파일 삭제
            fileService.deleteFileGroup(params.getPsSeq(), FileGrpType.PSSRP, FileType.REQ_METHOD);
            Map<String, String> storeFileMap = fileUploadUtil.saveFile(methodfile, FileGrpType.PSSRP);
            FileInfo fileInfo = new FileInfo();
            fileInfo.setFileNm(storeFileMap.get("storeFileName"));
            fileInfo.setFilePath(storeFileMap.get("storeFilePath"));
            fileInfo.setFileExt(storeFileMap.get("storeFileExt"));

            fileInfo.setFileSrcNm(methodfile.getOriginalFilename());
            fileInfo.setFileGrpType(FileGrpType.PSSRP);
            fileInfo.setFileType(FileType.REQ_METHOD);
            fileInfo.setFileSize(methodfile.getSize());
            fileInfo.setFileGrpSeq(params.getPsSeq());
            fileService.insertFileInfo(fileInfo);
        }
        MultipartFile imgpcfile = params.getImgpcfile();// 흐름도PC이미지
        if (imgpcfile != null && imgpcfile.getSize() > 0) {
            // 이전파일 삭제
            fileService.deleteFileGroup(params.getPsSeq(), FileGrpType.PSSRP, FileType.IMG_WEB);
            Map<String, String> storeFileMap = fileUploadUtil.saveFile(imgpcfile, FileGrpType.PSSRP);
            FileInfo fileInfo = new FileInfo();
            fileInfo.setFileNm(storeFileMap.get("storeFileName"));
            fileInfo.setFilePath(storeFileMap.get("storeFilePath"));
            fileInfo.setFileExt(storeFileMap.get("storeFileExt"));

            fileInfo.setFileSrcNm(imgpcfile.getOriginalFilename());
            fileInfo.setFileGrpType(FileGrpType.PSSRP);
            fileInfo.setFileType(FileType.IMG_WEB);
            fileInfo.setFileSize(imgpcfile.getSize());
            fileInfo.setFileGrpSeq(params.getPsSeq());
            fileService.insertFileInfo(fileInfo);
        }
        MultipartFile imgmobfile = params.getImgmobfile();// 흐름도모바일이미지
        if (imgmobfile != null && imgmobfile.getSize() > 0) {
            // 이전파일 삭제
            fileService.deleteFileGroup(params.getPsSeq(), FileGrpType.PSSRP, FileType.IMG_MOB);
            Map<String, String> storeFileMap = fileUploadUtil.saveFile(imgmobfile, FileGrpType.PSSRP);
            FileInfo fileInfo = new FileInfo();
            fileInfo.setFileNm(storeFileMap.get("storeFileName"));
            fileInfo.setFilePath(storeFileMap.get("storeFilePath"));
            fileInfo.setFileExt(storeFileMap.get("storeFileExt"));

            fileInfo.setFileSrcNm(imgmobfile.getOriginalFilename());
            fileInfo.setFileGrpType(FileGrpType.PSSRP);
            fileInfo.setFileType(FileType.IMG_MOB);
            fileInfo.setFileSize(imgmobfile.getSize());
            fileInfo.setFileGrpSeq(params.getPsSeq());
            fileService.insertFileInfo(fileInfo);
        }
    }

    /**
     * 공모 정보 종료 및 삭제
     * 
     * @param params
     * @return
     */
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = {Exception.class})
    public void endPssrp(Map<String, Object> params) {
        params.put("siteCd", getSiteCd());
        proposalMapper.endPssrp(params);
    }


    //=========================================================================
    // PRIVATE METHOD
    //=========================================================================

    private GcmInfo getProposalGcmInfo(Proposal proposal) {

        GcmInfo gcmInfo = null;

        if (proposal != null) {
            gcmInfo = new GcmInfo();
            gcmInfo.setGcmType(GcmType.PROPOSAL);
            gcmInfo.setPushMessage(messages.getMessage("push.post.new", "정책제안", proposal.getBizNm()));
            //gcmInfo.setReturnUrl(serviceSiteUrl + "/proposal/detail" + "/" + proposal.getPropSeq());
            gcmInfo.setArgs(new String[] {String.valueOf(proposal.getPropSeq())});
        }

        return gcmInfo;

    }

    private GcmInfo getProposalCommentGcmInfo(Proposal proposal) {

        GcmInfo gcmInfo = null;

        if (proposal != null) {
            gcmInfo = new GcmInfo();
            gcmInfo.setGcmType(GcmType.PROP_CMT);
            gcmInfo.setPushMessage(messages.getMessage("push.proposal.comment", proposal.getBizNm()));
            //gcmInfo.setReturnUrl(serviceSiteUrl + "/proposal/detail" + "/" + proposal.getPropSeq());
            gcmInfo.setArgs(new String[] {String.valueOf(proposal.getPropSeq())});
        }

        return gcmInfo;

    }

}
