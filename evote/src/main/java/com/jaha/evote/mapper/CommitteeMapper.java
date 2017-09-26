/**
 * Copyright (c) 2016 JAHA SMART CORP., LTD ALL RIGHT RESERVED
 */
package com.jaha.evote.mapper;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

/**
 * <pre>
 * Class Name : CommitteeMapper.java
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
@Mapper
public interface CommitteeMapper {

    /**
     * 위운공모 카운트
     * 
     * @return
     */
    public int selectCmitContestCount();


    /**
     * 위원공모 목록
     * 
     * @param param
     * @return
     */
    public List<HashMap<String, Object>> selectCmitContestList(HashMap<String, Object> param);

    /**
     * 위원공모 등록
     * 
     * @param param
     * @return
     */
    public int insertCmitContest(HashMap<String, Object> param);

    /**
     * 주민참여위원회 공모 단건조회
     * 
     * @param ps_seq
     * @return
     */
    public HashMap<String, Object> selectCmtiContest(HashMap<String, Object> param);

    /**
     * 주민참여위원회 공모
     * 
     * @return
     */
    public HashMap<String, Object> selectCmtiContestReq(HashMap<String, Object> param);

    /**
     * 주민참여위원회 공모 수정
     * 
     * @param param
     * @return
     */
    public int updateCmitContest(HashMap<String, Object> param);

    /**
     * 주민참여위원회 공모 삭제
     * 
     * @param ps_seq
     * @return
     */
    public int deleteCmitContest(int ps_seq);

    /**
     * 주민참여위원회 공모 강제종료
     * 
     * @param ps_seq
     * @return
     */
    public int stopCmitContest(int ps_seq);

    /**
     * 주민참여위원회 공모 신청서 등록
     * 
     * @param param
     * @return
     */
    public int insertCmitContestReq(HashMap<String, Object> param);

    /**
     * 위원공모 신청서 목록
     * 
     * @param param
     * @return
     */
    public List<HashMap<String, Object>> selectCmitContestReqList(HashMap<String, Object> param);

    /**
     * 주민참여위원회 공모 신청서 단건조회
     * 
     * @param param
     * @return
     */
    public HashMap<String, Object> selectCmitContestReq(HashMap<String, Object> param);

    /**
     * 주민참여위원회 공모 삭제
     * 
     * @param ps_seq
     * @return
     */
    public int deleteCmitContestReq(int ps_seq);


    /**
     * 주민참여위원회 신청서 카운트
     * 
     * @param param
     * @return
     */
    public int selectCmitReqCount(HashMap<String, Object> param);

    /**
     * 관리자 >위원공모 신청서 목록
     * 
     * @param param
     * @return
     */
    public List<HashMap<String, Object>> selectAdmCmitContestReqList(HashMap<String, Object> param);

    /**
     * 위원공모 조회
     * 
     * @param siteCd
     * @param psSeq
     * @return
     */
    public Map<String, Object> selectCmitPssrp(@Param("siteCd") String siteCd, @Param("psSeq") long psSeq);

    /**
     * 위원공모 시작 스케줄 조회
     * 
     * @return
     */
    public List<Map<String, Object>> selectCmitPssrpStartSchedule();

}
