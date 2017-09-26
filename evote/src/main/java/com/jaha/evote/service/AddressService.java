/**
 * Copyright (c) 2016 JAHA SMART CORP., LTD ALL RIGHT RESERVED
 */
package com.jaha.evote.service;

import java.util.List;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.jaha.evote.domain.common.Address;
import com.jaha.evote.domain.common.CodeDetail;
import com.jaha.evote.domain.type.CodeType;
import com.jaha.evote.mapper.common.AddressMapper;
import com.jaha.evote.mapper.common.CodeMapper;

/**
 * <pre>
 * Class Name : AddressService.java
 * Description : 주소 서비스
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
public class AddressService extends BaseService {

    @Autowired
    private AddressMapper addressMapper;

    @Autowired
    private CodeMapper codeMapper;

    /**
     * 시도 목록 조회
     * 
     * @return
     */
    public List<Address> selectSidoList() {
        return addressMapper.selectSidoList();
    }

    /**
     * 시군구 목록 조회
     * 
     * @param sidoCode
     * @return
     */
    public List<Address> selectSggList(String sidoCode) {
        if (StringUtils.isEmpty(sidoCode)) {
            logger.debug("### sidoCode is empty: [{}]", sidoCode);
            return null;
        }
        return addressMapper.selectSggList(sidoCode);
    }

    /**
     * 읍면동 목록 조회
     * 
     * @param sggCode
     * @return
     */
    public List<Address> selectEmdList(String sggCode) {
        if (StringUtils.isEmpty(sggCode)) {
            logger.debug("### sggCode is empty: [{}]", sggCode);
            return null;
        }
        return addressMapper.selectEmdList(sggCode);
    }

    /**
     * 현재 접속한 사이트의 읍면동 목록 조회
     * 
     * @return
     */
    public List<Address> selectSiteEmdList() {

        CodeDetail codeDetail = codeMapper.selectCodeInfo(CodeType.CODE_GROUP_SITE_CD.getCode(), getSiteCd());

        String regionCode = "";

        // 코드 테이블 > 서비스 사이트 기준 regionCode 조회
        if (codeDetail != null) {
            regionCode = codeDetail.getData2();
        }

        // 코드 테이블에 행정구역코드가 없을 경우 실제 사이트 코드로 행정구역코드 조회
        if (StringUtils.isEmpty(regionCode)) {
            regionCode = codeMapper.selectRegionCode(getSiteCd());
        }

        if (StringUtils.isEmpty(regionCode)) {
            logger.debug("### regionCode is empty: [{}]", regionCode);
            return null;
        }
        return addressMapper.selectEmdList(regionCode);
    }

    /**
     * 특정 지역 조회
     * 
     * @param regionCd
     * @return
     */
    public Address selectAddress(String regionCd) {
        return addressMapper.selectAddress(regionCd);
    }
}
