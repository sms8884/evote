/**
 * Copyright (c) 2016 by jahasmart.com. All rights reserved.
 */
package com.jaha.evote.controller.front;

import java.util.List;
import java.util.Map;

import javax.lang.model.type.NullType;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import com.jaha.evote.controller.common.BaseController;
import com.jaha.evote.domain.ApiResponse;
import com.jaha.evote.domain.Config;
import com.jaha.evote.service.ConfigService;

/**
 * <pre>
 * Class Name : ConfigController.java
 * Description : 사용자 설정 컨트롤러
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
@RestController
@RequestMapping
public class ConfigController extends BaseController {

    @Autowired
    private ConfigService configService;

    /**
     * 사용자 설정 목록 조회
     * 
     * @return
     */
    @RequestMapping(value = "/api/config/get", method = RequestMethod.GET)
    public ApiResponse<List<Config>> getMemberConfig() {
        return new ApiResponse<List<Config>>(configService.selectMemberConfig());
    }

    /**
     * 사용자 설정 수정
     * 
     * @param params
     * @return
     */
    @RequestMapping(value = "/api/config/put", method = RequestMethod.PUT)
    public ApiResponse<?> modifyMemberConfig(@RequestBody Map<String, String> params) {

        String configGroup = params.get("configGroup");
        String configCode = params.get("configCode");
        String useYn = params.get("useYn");

        logger.debug("configGroup [{}]", configGroup);
        logger.debug("configCode [{}]", configCode);
        logger.debug("useYn : [{}]", useYn);

        int result = configService.saveMemberConfig(configGroup, configCode, useYn);

        logger.debug("### modifyMemberConfig result : [{}]", result);

        return new ApiResponse<NullType>();
    }

}
