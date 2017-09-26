/**
 * Copyright (c) 2016 JAHA SMART CORP., LTD ALL RIGHT RESERVED
 */
package com.jaha.evote.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.jaha.evote.domain.Terms;
import com.jaha.evote.domain.type.TermsType;
import com.jaha.evote.mapper.TermsMapper;

/**
 * <pre>
 * Class Name : TermsService.java
 * Description : 약관 서비스
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
public class TermsService extends BaseService {

    @Autowired
    private TermsMapper termsMapper;

    /**
     * 약관 목록 조회
     * 
     * @return
     */
    public List<Terms> selectTermsList() {
        return termsMapper.selectTermsList();
    }

    /**
     * @param termsType :
     *        service - 서비스이용약관
     *        privacy1 - 개인정보취급(처리)방침
     *        privacy2 - 개인정보 수집•이용 동의(필수)
     *        privacy3 - 개인정보 수집•이용 동의(선택)
     * 
     * @return
     */
    public Terms selectTerms(TermsType termsType) {
        return termsMapper.selectTerms(termsType);
    }

}
