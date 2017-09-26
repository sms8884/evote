/**
 * Copyright (c) 2016 JAHA SMART CORP., LTD ALL RIGHT RESERVED
 */
package com.jaha.evote.service;

import java.util.List;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.jaha.evote.common.exception.RestException;
import com.jaha.evote.domain.Config;
import com.jaha.evote.mapper.ConfigMapper;

/**
 * <pre>
 * Class Name : ConfigService.java
 * Description : Description
 *  
 * Modification Information
 * 
 * Mod Date         Modifier    Description
 * -----------      --------    ---------------------------
 * 2016. 10. 4.     jjpark      Generation
 * </pre>
 *
 * @author jjpark
 * @since 2016. 10. 4.
 * @version 1.0
 */
@Service
public class ConfigService extends BaseService {

    private final String ERROR_USER_NOT_FOUND_CODE = "10";
    private final String ERROR_USER_NOT_FOUND_MESSAGE = "사용자 정보 없음";

    private final String ERROR_PARAM_CODE = "11";
    private final String ERROR_PARAM_MESSAGE = "PARAMETER 오류";

    private final String DEFAULT_ERROR_CODE = "99";


    @Autowired
    private ConfigMapper configMapper;

    /**
     * 사용자 설정 목록 조회
     * 
     * @return
     */
    public List<Config> selectMemberConfig() {

        try {

            long userSeq = getUserSeq();

            if (userSeq > 0) {

                return configMapper.selectMemberConfigList(userSeq);

            } else {
                throw new RestException(ERROR_USER_NOT_FOUND_CODE, ERROR_USER_NOT_FOUND_MESSAGE);
            }

        } catch (RestException re) {
            logger.error("### 사용자 설정 목록 조회 오류 : [{}]", re.getMessage());
            throw new RestException(re.getErrroCode(), re.getErrorMessage());
        } catch (Exception e) {
            logger.error("### 사용자 설정 목록 조회 오류 : [{}]", e.getMessage());
            throw new RestException(DEFAULT_ERROR_CODE, e.getMessage());
        }

    }

    /**
     * 사용자 설정 저장
     * 
     * @param configGroup
     * @param configCode
     * @param useYn
     * @return
     */
    @Transactional
    public int saveMemberConfig(String configGroup, String configCode, String useYn) {

        try {

            if (!StringUtils.isNoneEmpty(configGroup, configCode, useYn)) {
                throw new RestException(ERROR_PARAM_CODE, ERROR_PARAM_MESSAGE + " : configGroup [" + configGroup + "], configCode [" + configCode + "], useYn [" + useYn + "]");
            }

            long userSeq = getUserSeq();

            if (userSeq > 0) {

                Config config = new Config();
                config.setConfigGroup(configGroup);
                config.setConfigCode(configCode);
                config.setUseYn(useYn);
                config.setUserSeq(getUserSeq());

                int result = configMapper.selectConfigCount(config);

                if (result > 0) {
                    return configMapper.saveMemberConfig(config);
                } else {
                    throw new RestException(ERROR_PARAM_CODE, ERROR_PARAM_MESSAGE + " : configGroup [" + configGroup + "], configCode [" + configCode + "]");
                }

            } else {
                throw new RestException(ERROR_USER_NOT_FOUND_CODE, ERROR_USER_NOT_FOUND_MESSAGE);
            }

        } catch (RestException re) {
            logger.error("### 사용자 설정 수정 오류 : [{}]", re.getMessage());
            throw new RestException(re.getErrroCode(), re.getErrorMessage());
        } catch (Exception e) {
            logger.error("### 사용자 설정 수정 오류 : [{}]", e.getMessage());
            throw new RestException(DEFAULT_ERROR_CODE, e.getMessage());
        }

    }

    /**
     * 푸시키 목록 수 조회
     * 
     * @param config
     * @return
     */
    public int selectPushKeyListCount(Config config) {
        return configMapper.selectPushKeyListCount(config);
    }

    /**
     * 푸시키 목록 조회 - PUSH KEY 단일 조회
     * 
     * @param config
     * @return
     */
    public List<String> selectPushKeyList(Config config) {
        return configMapper.selectPushKeyList(config);
    }

}
