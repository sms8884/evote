/**
 * Copyright (c) 2016 JAHA SMART CORP., LTD ALL RIGHT RESERVED
 *
 * 2016. 10. 25.
 */
package com.jaha.evote.mapper;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

/**
 * <pre>
 * Class Name : BusinessMapper.java
 * Description : Description
 *  
 * Modification Information
 * 
 * Mod Date     Modifier    		  Description
 * -----------      -----------       ---------------------
 * 2016. 10. 25.        MyoungSeop       Generation
 * </pre>
 *
 * @author AAA
 * @since 2016. 10. 25.
 * @version 1.0
 */
@Mapper
public interface BusinessMapper {

    /**
     * 사업현황 리스트 카운트
     * 
     * @param param
     * @return
     */
    public int selectBusinessListCount(HashMap<String, Object> param);


    /**
     * 사업현황 리스트
     * 
     * @param param
     * @return
     */
    public List<HashMap<String, Object>> selectBusinessList(HashMap<String, Object> param);

    /**
     * 사업현황 최신4 리스트
     * 
     * @param param
     * @return
     */
    public List<HashMap<String, Object>> selectBusinessListTop3();

    /**
     * 사업현황 저장
     * 
     * @param param
     * @return
     */
    public int insertBusiness(HashMap<String, Object> param);

    /**
     * 사업현황 한개 조회
     * 
     * @param biz_seq
     * @return
     */
    public HashMap<String, Object> selectBusiness(HashMap<String, Object> param);

    /**
     * 사업현황 업데이트
     * 
     * @param param
     * @return
     */
    public int updateBusiness(HashMap<String, Object> param);

    /**
     * 사업현황 삭제
     * 
     * @param biz_seq
     * @return
     */
    public int deleteBusiness(int biz_seq);

    /**
     * 사업현황 공감 추가
     * 
     * @param param
     * @return
     */
    public int insertSympathy(HashMap<String, Object> param);

    /**
     * 사업현황 공감 삭제
     * 
     * @param param
     * @return
     */
    public int deleteSympathy(HashMap<String, Object> param);



}
