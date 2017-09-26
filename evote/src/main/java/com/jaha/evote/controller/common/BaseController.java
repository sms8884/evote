/**
 * Copyright (c) 2016 JAHA SMART CORP., LTD ALL RIGHT RESERVED
 */
package com.jaha.evote.controller.common;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.util.WebUtils;

import com.jaha.evote.domain.ISiteInfo;

/**
 * <pre>
 * Class Name : BaseController.java
 * Description : Description
 *  
 * Modification Information
 * 
 * Mod Date         Modifier    Description
 * -----------      --------    ---------------------------
 * 2016. 7. 27.     jjpark      Generation
 * </pre>
 *
 * @author jjpark
 * @since 2016. 7. 27.
 * @version 1.0
 */
public abstract class BaseController {

    protected final Logger logger = LoggerFactory.getLogger(getClass());

    protected String getSiteCd(HttpServletRequest request) {
        return (String) WebUtils.getSessionAttribute(request, ISiteInfo.ATTRIBUTE_NAME);
    }

    protected boolean isAdminSite(HttpServletRequest request) {
        String adminSiteYn = (String) request.getAttribute(ISiteInfo.ADMIN_SITE_YN_ATTR);
        if ("Y".equals(adminSiteYn)) {
            return true;
        } else {
            return false;
        }
    }

}
