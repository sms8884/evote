/**
 * Copyright (c) 2016 JAHA SMART CORP., LTD ALL RIGHT RESERVED
 */
package com.jaha.evote.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.jaha.evote.common.util.NumberUtils;
import com.jaha.evote.common.util.XecureUtil;
import com.jaha.evote.domain.Member;
import com.jaha.evote.domain.common.CodeDetail;
import com.jaha.evote.domain.common.FileInfo;
import com.jaha.evote.domain.type.FileGrpType;
import com.jaha.evote.domain.type.FileType;
import com.jaha.evote.domain.type.UserType;
import com.jaha.evote.mapper.CommitteeMapper;
import com.jaha.evote.mapper.common.FileMapper;

/**
 * <pre>
 * Class Name : CommitteeService.java
 * Description : Description
 *  
 * Modification Information
 * 
 * Mod Date         Modifier    Description
 * -----------      --------    ---------------------------
 * 2016. 10. 24.     jjpark      Generation
 * </pre>
 *
 * @author jjpark
 * @since 2016. 10. 24.
 * @version 1.0
 */
@Service
public class CommitteeService extends BaseService {

    @Autowired
    private CommitteeMapper committeeMapper;

    @Autowired
    FileMapper fileMapper;

    @Autowired
    MemberService memberService;

    @Autowired
    CodeService codeService;

    /**
     * 위원공모 카운트
     * 
     * @return
     */
    public int getCmitContestCount() {
        return committeeMapper.selectCmitContestCount();
    }

    /**
     * 어드민 > 위원공모 목록
     * 
     * @param param
     * @return
     */
    public List<HashMap<String, Object>> getCmitContestList(HashMap<String, Object> param) {
        logger.debug("CommitteeService > CmitContestList");
        param.put("site_cd", getSiteCd());
        String user_type = "";
        if (getUserType() == UserType.ADMIN) {
            user_type = "ADMIN";
        } else {
            user_type = "ETC";
        }
        param.put("user_type", user_type);

        List<HashMap<String, Object>> result = committeeMapper.selectCmitContestList(param);
        for (int i = 0; i < result.size(); i++) {
            String utmp = XecureUtil.decString((String) result.get(i).get("userNm"));
            result.get(i).put("userNm", utmp);
        }
        return result;
    }

    /**
     * 어드민>위원공모 등록
     * 
     * @param param
     * @return
     */
    @SuppressWarnings("unchecked")
    @Transactional
    public int insertCmitContest(HashMap<String, Object> param) {
        logger.debug("CommitteeService > insertCmitContest");
        // 등록자 정보 셋팅
        param.put("reg_user", getUserSeq());
        param.put("site_cd", getSiteCd());

        // 위원공모 등록
        committeeMapper.insertCmitContest(param);

        List<FileInfo> attachList = (List<FileInfo>) param.get("attachList");
        long cmit_seq = (long) param.get("cmit_seq");

        if (cmit_seq > 0) {

            // 첨부파일 등록
            if (attachList != null && !attachList.isEmpty()) {
                for (FileInfo fileInfo : attachList) {
                    fileInfo.setFileGrpSeq(cmit_seq);
                    fileInfo.setRegUser(getUserSeq());
                    fileMapper.insertFileInfo(fileInfo);
                }
            }
        }
        return 0;
    }

    /**
     * 주민참여위원 단건조회
     * 
     * @param ps_seq
     * @return
     */
    public HashMap<String, Object> selectCmitContest(int ps_seq) {
        logger.debug("CommitteeService > selectCmitContest");
        HashMap<String, Object> param = new HashMap<String, Object>();
        param.put("ps_seq", ps_seq);
        param.put("site_cd", getSiteCd());
        HashMap<String, Object> result = committeeMapper.selectCmtiContest(param);

        if (result != null) {
            long psSeq = ps_seq;
            List<FileInfo> attachList = fileMapper.selectFileInfoList(psSeq, FileGrpType.CMIT, FileType.ATTACH);
            result.put("attachList", attachList);
        }

        return result;
    }


    /**
     * 주민참여위원회 공모 수정
     * 
     * @param param
     * @return
     */
    @SuppressWarnings("unchecked")
    @Transactional
    public int updateCmitContest(HashMap<String, Object> param) {
        logger.debug("CommitteeService > updateCmitContest");
        param.put("mod_user", getUserSeq());
        committeeMapper.updateCmitContest(param);

        List<FileInfo> attachList = (List<FileInfo>) param.get("attachList");
        long cmit_seq = (long) param.get("ps_seq");

        if (cmit_seq > 0) {

            // 첨부파일 등록
            if (attachList != null && !attachList.isEmpty()) {
                for (FileInfo fileInfo : attachList) {
                    fileInfo.setFileGrpSeq(cmit_seq);
                    fileInfo.setRegUser(getUserSeq());
                    fileMapper.insertFileInfo(fileInfo);
                }
            }
        }

        return 0;
    }

    /**
     * 주민참여위원회 공모 삭제
     * 
     * @param ps_seq
     * @return
     */
    @Transactional
    public int deleteCmitContest(int ps_seq) {
        logger.debug("CommitteeService > deleteCmitContest");
        return committeeMapper.deleteCmitContest(ps_seq);
    }

    /**
     * 주민참여위원회 공모 강제종료
     * 
     * @param ps_seq
     * @return
     */
    @Transactional
    public int stopCmitContest(int ps_seq) {
        logger.debug("CommitteeService > stopCmitContest");
        return committeeMapper.stopCmitContest(ps_seq);
    }

    /**
     * 주민참여위원회 공모 사용자 화면 단건조회
     * 
     * @return
     */
    public HashMap<String, Object> selectCmitContest() {
        logger.debug("CommitteeService > selectCmitContest");
        HashMap<String, Object> param = new HashMap<String, Object>();
        param.put("site_cd", getSiteCd());
        param.put("user_seq", getUserSeq());
        HashMap<String, Object> result = committeeMapper.selectCmtiContestReq(param);
        if (result != null) {
            int psSeq = (int) result.get("ps_seq");
            long ps_seq = psSeq;
            List<FileInfo> attachList = fileMapper.selectFileInfoList(ps_seq, FileGrpType.CMIT, FileType.ATTACH);
            result.put("attachList", attachList);
        }
        return result;
    }

    /**
     * 사용자>주민참여위원회 신청하기 폼 정보
     * 
     * @param ps_seq
     * @return
     */
    public HashMap<String, Object> selectFormInfo(int ps_seq) {
        logger.debug("CommitteeService > selectFormInfo");
        HashMap<String, Object> result = new HashMap<String, Object>();
        result.put("user_seq", getUserSeq());
        result.put("ps_seq", ps_seq);
        Member memInfo = memberService.getUserInfoById(result); // 사용자정보
        result.put("memInfo", memInfo);
        HashMap<String, Object> param = new HashMap<String, Object>();
        param.put("cdGrpId", "CMIT_CTG");
        param.put("depth", "1");
        List<CodeDetail> subCmit1 = codeService.getCodeListMap(param); // 분과1
        param.put("depth", "2");
        List<CodeDetail> subCmit2 = codeService.getCodeListMap(param); // 분과 2
        result.put("subCmit1", subCmit1);
        result.put("subCmit2", subCmit2);
        return result;
    }

    /**
     * 사용자 > 주민참여위원회 공모 신청서 등록
     * 
     * @param param
     * @return
     */
    @SuppressWarnings("unchecked")
    @Transactional
    public int inserCmitContestReq(HashMap<String, Object> param) {
        param.put("site_cd", getSiteCd());
        param.put("user_seq", getUserSeq());
        String phone = XecureUtil.encString((String) param.get("phone"));
        param.put("phone", phone);


        committeeMapper.insertCmitContestReq(param);
        List<FileInfo> imageList = (List<FileInfo>) param.get("imageList");
        List<FileInfo> attachList = (List<FileInfo>) param.get("attachList");
        long req_seq = (long) param.get("req_seq");
        if (req_seq > 0) {

            // 이미지 파일 등록
            if (imageList != null && !imageList.isEmpty()) {
                for (FileInfo fileInfo : imageList) {
                    fileInfo.setFileGrpSeq(req_seq);
                    fileInfo.setRegUser(getUserSeq());
                    fileMapper.insertFileInfo(fileInfo);
                }
            }

            // 첨부파일 등록
            if (attachList != null && !attachList.isEmpty()) {
                for (FileInfo fileInfo : attachList) {
                    fileInfo.setFileGrpSeq(req_seq);
                    fileInfo.setRegUser(getUserSeq());
                    fileMapper.insertFileInfo(fileInfo);
                }
            }

        }
        return 0;
    }

    /**
     * 사용자 > 위원공모 신청서 목록
     * 
     * @param param
     * @return
     */
    public List<HashMap<String, Object>> getCmitContestReqList(HashMap<String, Object> param) {
        logger.debug("CommitteeService > getCmitContestReqList");
        param.put("site_cd", getSiteCd());
        param.put("user_seq", getUserSeq());

        List<HashMap<String, Object>> result = committeeMapper.selectCmitContestReqList(param);
        for (int i = 0; i < result.size(); i++) {
            String utmp = XecureUtil.decString((String) result.get(i).get("userNm"));
            result.get(i).put("userNm", utmp);
        }
        return result;
    }

    /**
     * 사용자 > 위원공모 신청서 상세보기
     * 
     * @param req_seq
     * @return
     */
    public HashMap<String, Object> getCmitContestReq(int req_seq) {

        logger.debug("CommitteeService > getCmitContestReq");

        HashMap<String, Object> param = new HashMap<String, Object>();
        param.put("user_seq", getUserSeq());
        param.put("ps_seq", req_seq);
        param.put("site_cd", getSiteCd());

        Member memInfo = memberService.getUserInfoById(param); // 사용자정보
        param.put("req_seq", req_seq);

        HashMap<String, Object> result = committeeMapper.selectCmitContestReq(param);
        String ptmp = XecureUtil.decString((String) result.get("phone"));
        result.put("phone", ptmp);
        result.put("memInfo", memInfo);

        List<FileInfo> attachFiles = fileMapper.selectFileInfoList(Long.valueOf(req_seq), FileGrpType.CMIT_REQ, FileType.ATTACH);
        List<FileInfo> imageFiles = fileMapper.selectFileInfoList(Long.valueOf(req_seq), FileGrpType.CMIT_REQ, FileType.IMAGE);

        if (attachFiles != null && !attachFiles.isEmpty()) {
            result.put("attachFile", attachFiles.get(0));
        }

        if (imageFiles != null && !imageFiles.isEmpty()) {
            result.put("imageFile", imageFiles.get(0));
        }

        return result;
    }

    /**
     * 사용자 > 주민참여위원 신청서 삭제
     * 
     * @param req_seq
     * @return
     */
    public int removeCmitContestReq(int req_seq) {
        return committeeMapper.deleteCmitContestReq(req_seq);
    }


    /**
     * 어드민> 위원공모 신청자 count
     * 
     * @param param
     * @return
     */
    public int getAdmCmitReqCount(HashMap<String, Object> param) {

        logger.debug("CommitteeService > getCmitReqCount");
        param.put("site_cd", getSiteCd());
        return committeeMapper.selectCmitReqCount(param);
    }

    /**
     * 어드민> 위원공모 신청자 리스트
     * 
     * @param param
     * @return
     */
    public List<HashMap<String, Object>> getAdmCmitContestReqList(HashMap<String, Object> param) {
        logger.debug("CommitteeService > getAdmCmitContestReqList");
        param.put("site_cd", getSiteCd());
        List<HashMap<String, Object>> result = committeeMapper.selectAdmCmitContestReqList(param);
        for (int i = 0; i < result.size(); i++) {
            String utmp = XecureUtil.decString((String) result.get(i).get("user_nm"));
            String ptmp = XecureUtil.decString((String) result.get(i).get("phone"));
            result.get(i).put("user_nm", utmp);
            result.get(i).put("phone", ptmp);
        }
        String search_string = XecureUtil.decString((String) param.get("search_string"));
        param.put("search_string", search_string);

        param.put("cdGrpId", "CMIT_CTG");
        param.put("depth", "1");
        List<CodeDetail> subCmit1 = codeService.getCodeListMap(param); // 분과1
        param.put("subCmit1", subCmit1);
        return result;
    }

    /**
     * 신청자 목록 엑셀 다운로드
     * 
     * @param param
     * @return
     */
    public List<HashMap<String, Object>> selectCmitReqMemberListExcel(HashMap<String, Object> param) {
        logger.debug("CommitteeService > selectCmitReqMemberListExcel");
        param.put("site_cd", getSiteCd());
        List<HashMap<String, Object>> result = committeeMapper.selectAdmCmitContestReqList(param);

        for (int i = 0; i < result.size(); i++) {
            String utmp = XecureUtil.decString((String) result.get(i).get("user_nm"));
            String ptmp = XecureUtil.decString((String) result.get(i).get("phone"));
            String etmp = XecureUtil.decString((String) result.get(i).get("email"));
            result.get(i).put("user_nm", utmp);
            result.get(i).put("phone", ptmp);
            result.get(i).put("email", etmp);
        }
        return result;
    }

    /**
     * 관리자 > 위원공모 신청서 상세보기
     * 
     * @param req_seq
     * @return
     */
    public HashMap<String, Object> getAdmCmitContestReq(int req_seq) {
        logger.debug("CommitteeService > getAdmCmitContestReq");
        HashMap<String, Object> param = new HashMap<String, Object>();
        param.put("req_seq", req_seq);
        param.put("site_cd", getSiteCd());

        HashMap<String, Object> result = committeeMapper.selectCmitContestReq(param);
        String ptmp = XecureUtil.decString((String) result.get("phone"));
        param.put("user_seq", result.get("user_seq"));
        Member memInfo = memberService.getUserInfoById(param); // 사용자정보
        result.put("phone", ptmp);
        result.put("memInfo", memInfo);

        List<FileInfo> attachFiles = fileMapper.selectFileInfoList(Long.valueOf(req_seq), FileGrpType.CMIT_REQ, FileType.ATTACH);
        List<FileInfo> imageFiles = fileMapper.selectFileInfoList(Long.valueOf(req_seq), FileGrpType.CMIT_REQ, FileType.IMAGE);

        if (attachFiles != null && !attachFiles.isEmpty()) {
            result.put("attachFile", attachFiles.get(0));
        }

        if (imageFiles != null && !imageFiles.isEmpty()) {
            result.put("imageFile", imageFiles.get(0));
        }

        return result;
    }

    /**
     * 위원공모 조회
     * 
     * @param psSeq
     * @return
     */
    public Map<String, Object> selectCmitPssrp(String strPsSeq) {
        long psSeq = NumberUtils.parseLong(strPsSeq);
        return committeeMapper.selectCmitPssrp(getSiteCd(), psSeq);
    }


    /**
     * 위원공모 시작 스케줄 조회
     * 
     * @return
     */
    public List<Map<String, Object>> selectCmitPssrpStartSchedule() {
        return committeeMapper.selectCmitPssrpStartSchedule();
    }

}
