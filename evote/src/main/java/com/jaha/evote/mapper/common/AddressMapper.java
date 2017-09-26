/**
 * Copyright (c) 2016 JAHA SMART CORP., LTD ALL RIGHT RESERVED
 */
package com.jaha.evote.mapper.common;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.jaha.evote.domain.common.Address;

/**
 * <pre>
 * Class Name : AddressMapper.java
 * Description : 주소 매퍼
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
public interface AddressMapper {

    /**
     * 시도 목록 조회
     * 
     * @return
     */
    public List<Address> selectSidoList();

    /**
     * 시군구 목록 조회
     * 
     * @param sidoCode
     * @return
     */
    public List<Address> selectSggList(String sidoCode);

    /**
     * 읍면동 목록 조회
     * 
     * @param sggCode
     * @return
     */
    public List<Address> selectEmdList(String sggCode);

    /**
     * 특정 지역 조회
     * 
     * @param regionCd
     * @return
     */
    public Address selectAddress(String regionCd);
}
