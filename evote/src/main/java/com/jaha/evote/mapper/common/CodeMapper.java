/**
 * Copyright (c) 2016 JAHA SMART CORP., LTD ALL RIGHT RESERVED
 */
package com.jaha.evote.mapper.common;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.jaha.evote.domain.common.CodeDetail;
import com.jaha.evote.domain.common.CodeGroup;

/**
 * <pre>
 * Class Name : CodeMapper.java
 * Description : 코드 매퍼
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
@Mapper
public interface CodeMapper {

    /**
     * 코드 그룹 목록 조회
     * 
     * @return
     */
    public List<CodeGroup> selectCodeGroupList();

    /**
     * 코드 목록 조회
     * 
     * @param cdGrpId
     * @return
     */
    public List<CodeDetail> selectCodeList(@Param("cdGrpId") String cdGrpId);

    /**
     * 코드 목록 조회
     * 
     * @param cdGrpId
     * @return
     */
    public List<CodeDetail> selectCodeListMap(HashMap<String, Object> param);

    /**
     * 코드 정보 조회
     * 
     * @param cdGrpId
     * @param cdId
     * @return
     */
    public CodeDetail selectCodeInfo(@Param("cdGrpId") String cdGrpId, @Param("cdId") String cdId);

    /**
     * 행정구역 코드 조회
     * 
     * @param cdId
     * @return
     */
    public String selectRegionCode(@Param("cdId") String cdId);

}
