/**
 * Copyright (c) 2016 JAHA SMART CORP., LTD ALL RIGHT RESERVED
 */
package com.jaha.evote.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.jaha.evote.domain.Terms;
import com.jaha.evote.domain.type.TermsType;

/**
 * <pre>
 * Class Name : TermsMapper.java
 * Description : 약관 매퍼
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
public interface TermsMapper {

    /**
     * 약관 목록 조회
     * 
     * @return
     */
    public List<Terms> selectTermsList();

    /**
     * 개별 약관 조회
     * 
     * @param termsType
     * @return
     */
    public Terms selectTerms(@Param("termsType") TermsType termsType);

}
