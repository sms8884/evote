/**
 * Copyright (c) 2016 JAHA SMART CORP., LTD ALL RIGHT RESERVED
 */
package com.jaha.evote.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import com.jaha.evote.common.util.FileUploadUtil;
import com.jaha.evote.common.util.NumberUtils;
import com.jaha.evote.domain.VoteMaster;
import com.jaha.evote.domain.VoteRealm;
import com.jaha.evote.domain.common.FileInfo;
import com.jaha.evote.domain.type.AgeGroup;
import com.jaha.evote.domain.type.FileGrpType;
import com.jaha.evote.domain.type.FileType;
import com.jaha.evote.domain.type.UserType;
import com.jaha.evote.mapper.VoteMapper;

/**
 * <pre>
 * Class Name : VoteService.java
 * Description : 투표 서비스
 *  
 * Modification Information
 * 
 * Mod Date         Modifier    Description
 * -----------      --------    ---------------------------
 * 2016. 9. 29.     jjpark      Generation
 * </pre>
 *
 * @author jjpark
 * @since 2016. 9. 29.
 * @version 1.0
 */
@Service
public class VoteService extends BaseService {

    @Autowired
    private VoteMapper voteMapper;

    @Autowired
    private FileService fileService;

    @Autowired
    private FileUploadUtil fileUploadUtil;

    /**
     * 사용자 > 투표 정보
     * 
     * @param param
     * @return
     */
    @Transactional(readOnly = true)
    public HashMap<String, Object> getVoteInfo(HashMap<String, Object> param) {
        logger.debug("VoteService > getVoteInfo");
        return voteMapper.getVoteInfo(param);
    }

    /**
     * 사용자 > 투표분야 정보가져오기 (해당 사용자가 선택한 개수, 사용자 타입(청년,성인)에 해당하는것만 가져온다.)
     * 
     * @param param
     * @return
     */
    @Transactional(readOnly = true)
    public List<HashMap<String, Object>> getUserVoteRealmList(HashMap<String, Object> param) {
        logger.debug("VoteService > getUserVoteRealmList");
        return voteMapper.getUserVoteRealmList(param);
    }

    /**
     * 사용자 > 사업제안 상세 > 투표분야 정보 가져오기.
     * 
     * @param param
     * @return
     */
    @Transactional(readOnly = true)
    public HashMap<String, Object> getUserVoteRealm(HashMap<String, Object> param) {
        logger.debug("VoteService > getUserVoteRealm");
        return voteMapper.getUserVoteRealm(param);
    }

    /**
     * 사용자 >사업제안 > 리스트 개수
     * 
     * @param param
     * @return
     */
    @Transactional(readOnly = true)
    public int voteItemListCount(HashMap<String, Object> param) {
        return voteMapper.voteItemListCount(param);
    }

    /**
     * 사용자 > 사업 제안 리스트
     * 
     * @param param
     * @return
     */
    @Transactional(readOnly = true)
    public List<HashMap<String, Object>> voteItemList(HashMap<String, Object> param) {
        logger.debug("VoteService > voteItemList");
        return voteMapper.voteItemList(param);
    }

    /**
     * 사용자 > 사업 제안 정보
     * 
     * @param param
     * @return
     */
    @Transactional(readOnly = true)
    public HashMap<String, Object> getVoteItem(HashMap<String, Object> param) {
        logger.debug("VoteService > getVoteItem");
        return voteMapper.getVoteItem(param);
    }

    /**
     * 사용자 > 선택한 사업 제안 정보
     * 
     * @param param
     * @return
     */
    @Transactional(readOnly = true)
    public HashMap<String, Object> getSelectVoteItem(HashMap<String, Object> param) {
        logger.debug("VoteService > getSelectVoteItem");
        return voteMapper.getSelectVoteItem(param);
    }

    /**
     * 사용자 > 사업제안 선택 > 최종 저장
     * 
     * @param param
     * @throws Exception
     */
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = {Exception.class})
    public void saveVoter(HashMap<String, Object> param) throws Exception {

        logger.debug("VoteService > insertVoterInfo");

        if (getUserSeq() > 0) {
            // 회원 투표자 정보 저장
            voteMapper.insertVoterInfo(param);// voter저장
        } else {
            // 비회원 투표자 정보 저장
            param.put("user_type", UserType.VOTE);
            voteMapper.insertVisitorVoterInfo(param);
        }

        voteMapper.insertVoterChoice(param);// 투표정보저장 (temp에 있는 투표 정보 복사)
        voteMapper.deleteVoterChoiceTemp(param);// 임시저장된 투표정보 삭제
    }

    /**
     * 사용자 > 사업 제안 > 임시저장 리스트 개수
     * 
     * @param param
     * @return
     */
    @Transactional(readOnly = true)
    public int voterChoiceListCnt(HashMap<String, Object> param) {
        logger.debug("VoteService > voterChoiceListCnt");
        return voteMapper.voterChoiceListCnt(param);
    }

    /**
     * 사용자 > 사업 제안 > 임시저장 리스트
     * 
     * @param param
     * @return
     */
    @Transactional(readOnly = true)
    public List<HashMap<String, Object>> voterChoiceList(HashMap<String, Object> param) {
        logger.debug("VoteService > voterChoiceList");
        return voteMapper.voterChoiceList(param);
    }

    /**
     * 사용자 > 사업제안 선택 > 사업제안 정보 임시 저장
     * 
     * @param param
     */
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = {Exception.class})
    public void insertVoterChoiceTemp(HashMap<String, Object> param) {
        logger.debug("VoteService > insertVoterChoiceTemp");
        voteMapper.insertVoterChoiceTemp(param);
    }

    /**
     * 사용자 > 사업제안 선택 > 사업제안 정보 임시 저장 정보삭제
     * 
     * @param param
     */
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = {Exception.class})
    public void deleteVoterChoiceTemp(HashMap<String, Object> param) {
        logger.debug("VoteService > deleteVoterChoiceTemp");
        voteMapper.deleteVoterChoiceTemp(param);
    }

    /**
     * 사용자 > 투표한 사용자 정보 조회
     * 
     * @param param
     * @return
     */
    @Transactional(readOnly = true)
    public HashMap<String, Object> getVoterInfo(HashMap<String, Object> param) {
        logger.debug("VoteService > getVoterInfo");
        return voteMapper.getVoterInfo(param);
    }

    /**
     * 사용자 > 결과
     * 
     * @param param
     * @return
     */
    @Transactional(readOnly = true)
    public List<HashMap<String, Object>> getUserVoteResultList(HashMap<String, Object> param) {
        logger.debug("VoteService > getUserVoteResultList");
        return voteMapper.getUserVoteResultList(param);
    }

    /**
     * 어드민 > 투표 리스트 수
     * 
     * @param param
     * @return
     */
    @Transactional(readOnly = true)
    public int voteListCount(HashMap<String, Object> param) {
        logger.debug("VoteService > voteListCount");
        param.put("site_cd", getSiteCd());// 사이트코드
        return voteMapper.voteListCount(param);
    }

    /**
     * 어드민 > 투표 리스트
     * 
     * @param param
     * @return
     */
    @Transactional(readOnly = true)
    public List<HashMap<String, Object>> voteList(HashMap<String, Object> param) {
        logger.debug("VoteService > voteList");
        param.put("site_cd", getSiteCd());// 사이트코드
        return voteMapper.voteList(param);
    }

    /**
     * 어드민 > 투표 리스트 > 결과
     * 
     * @param param
     * @return
     */
    @Transactional(readOnly = true)
    public List<HashMap<String, Object>> voteResultList(HashMap<String, Object> param) {
        logger.debug("VoteService > voteResultList");
        return voteMapper.voteResultList(param);
    }

    /**
     * 어드민 > 투표 리스트 > 투표자 엑셀다운로드
     * 
     * @param param
     * @return
     */
    @Transactional(readOnly = true)
    public List<HashMap<String, Object>> voterResultList(HashMap<String, Object> param) {
        logger.debug("VoteService > voterResultList");
        return voteMapper.voterResultList(param);
    }

    /**
     * 어드민 > 투표등록
     * 
     * @param param
     * @return
     */
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = {Exception.class})
    public HashMap<String, Object> insertVoteMst(HashMap<String, Object> param) {
        logger.debug("VoteService > insertVoteMst");
        param.put("site_cd", getSiteCd()); // 사이트코드
        voteMapper.insertVoteMst(param);// 투표 저장

        String vote_seq = StringUtils.defaultString(param.get("vote_seq") + "", "");
        param.put("vote_seq", vote_seq);
        if (vote_seq != "") {
            voteMapper.insertVoteRealm(param);// 투표분야저장
        }
        return param;
    }

    /**
     * 어드민 > 투표수정
     * 
     * @param param
     */
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = {Exception.class})
    public void updateVoteMst(HashMap<String, Object> param) {
        logger.debug("VoteService > updateVoteMst");
        param.put("site_cd", getSiteCd()); // 사이트코드
        voteMapper.updateVoteMst(param);
    }

    /**
     * 어드민 > 투표삭제 or 강제종료
     * 
     * @param param
     */
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = {Exception.class})
    public void deleteVoteMst(HashMap<String, Object> param) {
        logger.debug("VoteService > deleteVoteMst");
        voteMapper.deleteVoteMst(param);
    }

    /**
     * 어드민 > 분야 마스터 리스트
     * 
     * @param param
     * @return
     */
    @Transactional(readOnly = true)
    public List<HashMap<String, Object>> realmMastertList(HashMap<String, Object> param) {
        logger.debug("VoteService > realmMastertList");
        param.put("site_cd", getSiteCd()); // 사이트코드
        return voteMapper.realmMastertList(param);
    }

    /**
     * 어드민 > 분야 마스터추가
     * 
     * @param param
     */
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = {Exception.class})
    public void addRealmMaster(HashMap<String, Object> param) {
        logger.debug("VoteService > addRealmMaster");
        param.put("site_cd", getSiteCd()); // 사이트코드
        voteMapper.addRealmMaster(param);
    }

    /**
     * 어드민 > 분야 마스터 삭제
     * 
     * @param param
     */
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = {Exception.class})
    public void deleteRealmMst(HashMap<String, Object> param) {
        logger.debug("VoteService > deleteRealmMst");
        param.put("site_cd", getSiteCd()); // 사이트코드
        voteMapper.deleteRealmMst(param);
    }

    /**
     * 어드민 > 분야 마스터 순서조정
     * 
     * @param param
     */
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = {Exception.class})
    public void ChOrderRealmMaster(HashMap<String, Object> param) {
        logger.debug("VoteService > ChOrderRealmMaster");
        param.put("site_cd", getSiteCd()); // 사이트코드
        String target = StringUtils.defaultString(param.get("target") + "", "");
        if (target.equals("One")) {
            voteMapper.ChOrderRealmMaster(param);
        }

        List<HashMap<String, Object>> resultList = voteMapper.realmMastertList(param);
        for (int i = 0; i < resultList.size(); i++) {
            param.put("dp_ord", i + 1);
            // param.put("site_cd", resultList.get(i).get("site_cd"));
            param.put("realm_cd", resultList.get(i).get("realm_cd"));
            voteMapper.ChOrderRealmMaster(param);
        }
    }

    /**
     * 어드민 > 분야 리스트
     * 
     * @param param
     * @return
     */
    @Transactional(readOnly = true)
    public List<HashMap<String, Object>> voteRealmList(HashMap<String, Object> param) {
        logger.debug("VoteService > voteRealmtList");
        return voteMapper.voteRealmList(param);
    }

    /**
     * 어드민 > 분야 추가
     * 
     * @param param
     */
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = {Exception.class})
    public void addVoteRealm(HashMap<String, Object> param) {
        logger.debug("VoteService > addVoteRealm");
        voteMapper.addVoteRealm(param);
    }

    /**
     * 어드민 > 분야 삭제
     * 
     * @param param
     */
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = {Exception.class})
    public void deleteVoteRealm(HashMap<String, Object> param) {
        logger.debug("VoteService > deleteVoteRealm");
        voteMapper.deleteVoteRealm(param);
    }

    /**
     * 어드민 > 분야 순서조정
     * 
     * @param param
     */
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = {Exception.class})
    public void chOrderVoteRealm(HashMap<String, Object> param) {
        logger.debug("VoteService > chOrderVoteRealm");
        String target = StringUtils.defaultString(param.get("target") + "", "");
        if (target.equals("One")) {
            voteMapper.chOrderVoteRealm(param);
        }

        param.put("chOrd", "yes"); // 사용여부 Y인 애들만 가져와서 순서 정렬
        List<HashMap<String, Object>> resultList = voteMapper.voteRealmList(param);
        for (int i = 0; i < resultList.size(); i++) {
            param.put("dp_ord", i + 1);
            param.put("vote_seq", resultList.get(i).get("vote_seq"));
            param.put("realm_cd", resultList.get(i).get("realm_cd"));
            voteMapper.chOrderVoteRealm(param);
        }
    }

    /**
     * 어드민 > 투표 > 투표사업 리스트
     * 
     * @param param
     * @return
     */
    @Transactional(readOnly = true)
    public List<HashMap<String, Object>> VoteItemWithRealmList(HashMap<String, Object> param) {
        logger.debug("VoteService > VoteItemWithRealmList");
        return voteMapper.VoteItemWithRealmList(param);
    }

    /**
     * 어드민 > 투표 > 투표사업 저장
     * 
     * @param param
     * @param image_file
     * @param attach_file
     * @return
     */
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = {Exception.class})
    public HashMap<String, Object> saveVoteItem(HashMap<String, Object> param, MultipartFile image_file, MultipartFile attach_file) {
        logger.debug("VoteService > insertVoteItem");
        voteMapper.insertVoteItem(param);// 투표사업 저장
        String biz_seq = param.get("biz_seq") + "";
        if (biz_seq != "") { // 투표정보저장성공
            // 파일저장
            if (attach_file != null && attach_file.getSize() > 0) {
                Map<String, String> storeFileMap = fileUploadUtil.saveFile(attach_file, FileGrpType.VOTE);
                FileInfo fileInfo = new FileInfo();
                fileInfo.setFileNm(storeFileMap.get("storeFileName"));
                fileInfo.setFilePath(storeFileMap.get("storeFilePath"));
                fileInfo.setFileExt(storeFileMap.get("storeFileExt"));

                fileInfo.setFileSrcNm(attach_file.getOriginalFilename());
                fileInfo.setFileGrpType(FileGrpType.VOTE);
                fileInfo.setFileType(FileType.ATTACH);
                fileInfo.setFileSize(attach_file.getSize());
                fileInfo.setFileGrpSeq(Long.parseLong(biz_seq));
                fileService.insertFileInfo(fileInfo);
            }

            if (image_file != null && image_file.getSize() > 0) {
                Map<String, String> storeFileMap = fileUploadUtil.saveFile(image_file, FileGrpType.VOTE);
                FileInfo fileInfo = new FileInfo();
                fileInfo.setFileNm(storeFileMap.get("storeFileName"));
                fileInfo.setFilePath(storeFileMap.get("storeFilePath"));
                fileInfo.setFileExt(storeFileMap.get("storeFileExt"));

                fileInfo.setFileSrcNm(image_file.getOriginalFilename());
                fileInfo.setFileGrpType(FileGrpType.VOTE);
                fileInfo.setFileType(FileType.IMAGE);
                fileInfo.setFileSize(image_file.getSize());
                fileInfo.setFileGrpSeq(Long.parseLong(biz_seq));
                fileService.insertFileInfo(fileInfo);
            }
        }
        return param;
    }

    /**
     * 어드민 > 투표 > 투표사업 수정
     * 
     * @param param
     * @param image_file
     * @param attach_file
     */
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = {Exception.class})
    public void updateVoteItem(HashMap<String, Object> param, MultipartFile image_file, MultipartFile attach_file) {
        logger.debug("VoteService > updateVoteItem");
        String biz_seq = param.get("biz_seq") + "";

        // 투표사업 수정
        voteMapper.updateVoteItem(param);

        // 파일저장
        if (attach_file != null && attach_file.getSize() > 0) {
            // 이전파일 삭제
            fileService.deleteFileGroup(Long.parseLong(biz_seq), FileGrpType.VOTE, FileType.ATTACH);
            Map<String, String> storeFileMap = fileUploadUtil.saveFile(attach_file, FileGrpType.VOTE);
            FileInfo fileInfo = new FileInfo();
            fileInfo.setFileNm(storeFileMap.get("storeFileName"));
            fileInfo.setFilePath(storeFileMap.get("storeFilePath"));
            fileInfo.setFileExt(storeFileMap.get("storeFileExt"));

            fileInfo.setFileSrcNm(attach_file.getOriginalFilename());
            fileInfo.setFileGrpType(FileGrpType.VOTE);
            fileInfo.setFileType(FileType.ATTACH);
            fileInfo.setFileSize(attach_file.getSize());
            fileInfo.setFileGrpSeq(Long.parseLong(biz_seq));
            fileService.insertFileInfo(fileInfo);
        }
        // 이미지파일저장
        if (image_file != null && image_file.getSize() > 0) {
            // 이전 파일 삭제
            fileService.deleteFileGroup(Long.parseLong(biz_seq), FileGrpType.VOTE, FileType.IMAGE);

            Map<String, String> storeFileMap = fileUploadUtil.saveFile(image_file, FileGrpType.VOTE);
            FileInfo fileInfo = new FileInfo();
            fileInfo.setFileNm(storeFileMap.get("storeFileName"));
            fileInfo.setFilePath(storeFileMap.get("storeFilePath"));
            fileInfo.setFileExt(storeFileMap.get("storeFileExt"));

            fileInfo.setFileSrcNm(image_file.getOriginalFilename());
            fileInfo.setFileGrpType(FileGrpType.VOTE);
            fileInfo.setFileType(FileType.IMAGE);
            fileInfo.setFileSize(image_file.getSize());
            fileInfo.setFileGrpSeq(Long.parseLong(biz_seq));
            fileService.insertFileInfo(fileInfo);
        }
    }

    /**
     * 어드민 > 투표 > 투표사업 삭제
     * 
     * @param param
     */
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = {Exception.class})
    public void deleteVoteItem(HashMap<String, Object> param) {
        logger.debug("VoteService > deleteVoteItem");
        String biz_seq = param.get("biz_seq") + "";
        voteMapper.deleteVoteItem(param);
        // 파일삭제
        fileService.deleteFileGroup(Long.parseLong(biz_seq), FileGrpType.VOTE);
    }

    /**
     * 어드민 > 투표> 투표 사업 순서조정
     * 
     * @param param
     */
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = {Exception.class})
    public void ChOrderVoteItem(HashMap<String, Object> param) {
        logger.debug("VoteService > ChOrderVoteItem");
        param.put("search_order", "dp_ord"); // 연번 순으로 정렬
        List<HashMap<String, Object>> resultList = voteMapper.voteItemList(param);
        for (int i = 0; i < resultList.size(); i++) {
            param.put("dp_ord", i + 1);
            param.put("biz_seq", resultList.get(i).get("biz_seq"));
            voteMapper.ChOrderVoteItem(param);
        }
    }

    /**
     * 사용자 > 투표> 투표 사업 순서조정
     * 
     * @param param
     * @return
     */
    public HashMap<String, Object> getVoteTabCnt(HashMap<String, Object> param) {
        return voteMapper.getVoteTabCnt(param);
    }

    /**
     * 투표 아이템 순서 조정
     * 
     * @param list
     * @return
     */
    @Transactional
    @SuppressWarnings("unchecked")
    public int updateVoteOrder(List<Object> list) {
        int result = 0;
        if (list != null && !list.isEmpty()) {
            Map<String, Object> map = null;
            for (Object item : list) {
                map = (Map<String, Object>) item;
                voteMapper.updateVoteOrder(map);
                result++;
            }

        }
        return result;
    }


    //=========================================================================
    // 2차 추가
    //=========================================================================

    /**
     * 투표 마스터 순서 조정
     * 
     * @param list
     * @return
     */
    @Transactional
    @SuppressWarnings("unchecked")
    public int updateVoteMstOrder(List<Object> list) {
        int result = 0;
        if (list != null && !list.isEmpty()) {

            // 기존 순서 리셋
            voteMapper.updateResetVoteMstOrder();

            Map<String, Object> map = null;
            for (Object item : list) {
                map = (Map<String, Object>) item;
                voteMapper.updateVoteMstOrder(map);
                result++;
            }

        }
        return result;
    }

    /**
     * 투표 분야 목록 조회
     * 
     * @param strVoteSeq
     * @param ageGroup
     * @return
     */
    public List<VoteRealm> selectVoteRealmList(String strVoteSeq, AgeGroup ageGroup) {
        long voteSeq = NumberUtils.parseLong(strVoteSeq);
        if (voteSeq > 0) {
            return voteMapper.selectVoteRealmList(voteSeq, ageGroup);
        }
        return null;
    }

    /**
     * 투표 시작 스케줄 조회
     * 
     * @return
     */
    public List<VoteMaster> selectVoteStartSchedule() {
        return voteMapper.selectVoteStartSchedule();
    }

    /**
     * 투표 종료 스케줄 조회
     * 
     * @return
     */
    public List<VoteMaster> selectVoteEndSchedule() {
        return voteMapper.selectVoteEndSchedule();
    }

    /**
     * 사업목록 엑셀 업로드
     * 
     * @param excelData
     * @param vote_seq
     * @return
     */
    @Transactional
    public int insertExcelData(List<String[]> excelData, String vote_seq) {

        int result = 0;

        if (excelData != null) {

            // 분야코드를 알 수 없기 때문에 해당 투표의 최소 분야코드 등록
            String minRealmCd = voteMapper.selectMinRealmCd(vote_seq);
            String realmCd = null;
            int tmpValue = 0;

            HashMap<String, Object> voteItem = null;

            for (String[] data : excelData) {

                if (data != null && data.length >= 9) {

                    tmpValue = NumberUtils.parseInt(data[0], 0);

                    if (tmpValue == 0) {
                        realmCd = minRealmCd;
                    } else {
                        realmCd = data[0];
                    }

                    voteItem = new HashMap<>();

                    voteItem.put("vote_seq", vote_seq);
                    voteItem.put("realm_cd", realmCd);
                    voteItem.put("biz_nm", data[1]);
                    voteItem.put("budget", data[2]);
                    voteItem.put("start_date", data[3]);
                    voteItem.put("end_date", data[4]);
                    voteItem.put("location", data[5]);
                    voteItem.put("necessity", data[6]);
                    voteItem.put("biz_cont", data[7]);
                    voteItem.put("effect", data[8]);
                    voteItem.put("user_seq", getUserSeq());

                    voteMapper.insertVoteItem(voteItem);

                    result++;

                } else {
                    logger.error("### data error ");
                }

            }

        }

        return result;
    }

}
