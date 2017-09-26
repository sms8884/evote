/**
 * Copyright (c) 2016 JAHA SMART CORP., LTD ALL RIGHT RESERVED
 */
package com.jaha.evote.service;

import java.util.HashMap;
import java.util.List;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.googlecode.ehcache.annotations.Cacheable;
import com.jaha.evote.domain.common.CodeDetail;
import com.jaha.evote.domain.common.CodeGroup;
import com.jaha.evote.mapper.common.CodeMapper;

/**
 * <pre>
 * Class Name : CodeService.java
 * Description : 코드 서비스
 *  
 * Modification Information
 * 
 * Mod Date         Modifier    Description
 * -----------      --------    ---------------------------
 * 2016. 9. 29.     jjpark      Generation
 * 2016. 10. 17.    jjpark      getCodeList 캐시 적용
 * </pre>
 *
 * @author jjpark
 * @since 2016. 9. 29.
 * @version 1.0
 */
@Service
public class CodeService extends BaseService {

    @Autowired
    private CodeMapper codeMapper;

    /**
     * 코드 그룹 목록 조회
     * 
     * @return
     */
    public List<CodeGroup> getCodeGroupList() {
        List<CodeGroup> groupList = codeMapper.selectCodeGroupList();
        return groupList;
    }

    /**
     * 코드 목록 조회
     * 
     * @param cdGrpId
     * @return
     */
    @Cacheable(cacheName = "codeListCache")
    public List<CodeDetail> getCodeList(String cdGrpId) {
        if (StringUtils.isEmpty(cdGrpId)) {
            logger.debug("### cdGrpId is empty: [{}]", cdGrpId);
            return null;
        }
        return codeMapper.selectCodeList(cdGrpId);
    }

    /**
     * 코드 정보 조회
     * 
     * @param cdGrpId
     * @param cdId
     * @return
     */
    @Cacheable(cacheName = "codeInfoCache")
    public CodeDetail getCodeInfo(String cdGrpId, String cdId) {
        if (!StringUtils.isNoneEmpty(cdGrpId, cdId)) {
            logger.debug("### cdGrpId [{}], cdId [{}]", cdGrpId, cdId);
            return null;
        }
        return codeMapper.selectCodeInfo(cdGrpId, cdId);
    }

    /**
     * 조건별 코드 목록 조회
     * 
     * @param param
     * @return
     */
    public List<CodeDetail> getCodeListMap(HashMap<String, Object> param) {
        return codeMapper.selectCodeListMap(param);
    }



}
