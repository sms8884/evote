/**
 * Copyright (c) 2016 JAHA SMART CORP., LTD ALL RIGHT RESERVED
 *
 * 2016. 7. 12.
 */
package com.jaha.evote.common.interceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;
import org.springframework.web.util.WebUtils;

import com.jaha.evote.common.util.StringUtils;
import com.jaha.evote.domain.AdminUser;

/**
 * <pre>
 * Class Name : AdminSessionCheckInterceptor.java
 * Description : Description
 *  
 * Modification Information
 * 
 * Mod Date         Modifier    Description
 * -----------      --------    ---------------------------
 * 2016. 7. 14.     jjpark      Generation
 * </pre>
 *
 * @author jjpark
 * @since 2016. 7. 14.
 * @version 1.0
 */
@Component
public class AdminSessionCheckInterceptor extends HandlerInterceptorAdapter {

    private static final Logger logger = LoggerFactory.getLogger(AdminSessionCheckInterceptor.class);

    @Value("${common.admin.login.url}")
    private String defaultLoginUrl;

    /*
     * (non-Javadoc)
     * @see org.springframework.web.servlet.handler.HandlerInterceptorAdapter#preHandle(javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse, java.lang.Object)
     */
    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {

        String requestURI = request.getRequestURI().trim();
        String requestQueryString = request.getQueryString();

        logger.debug("admin > requestURI : {}", requestURI);

        HttpSession session = request.getSession();

        Long userSeq = 0L;
        String redirectUrl = defaultLoginUrl;

        AdminUser adminSession = (AdminUser) WebUtils.getSessionAttribute(request, AdminUser.ATTRIBUTE_NAME);

        // =====================================================================
        // 1. 관리자 세션 체크
        // =====================================================================

        if (adminSession == null) {

            // current request info
            String requestURL = requestURI;
            requestURL += StringUtils.isNotEmpty(requestQueryString) ? "?" + StringUtils.defaultString(requestQueryString) : "";
            logger.info("requestURL 1 : " + requestURL);
            session.setAttribute("requestURL", requestURL);

            response.sendRedirect(request.getContextPath() + redirectUrl);
            return false;
        }

        if (session != null && adminSession != null) {
            userSeq = adminSession.getMgrSeq();

            // Session에 있는 ID가 존재하는지 확인하여 없으면, 강제 로그아웃 처리
            if (userSeq == null || userSeq == 0) {
                // current request info
                String requestURL = requestURI;
                requestURL += !StringUtils.isNotEmpty(requestQueryString) ? "?" + StringUtils.defaultString(requestQueryString) : "";
                logger.info("requestURL 2 : " + requestURL);
                session.setAttribute("requestURL", requestURL);

                //request.getSession().invalidate();
                response.sendRedirect(request.getContextPath() + redirectUrl);
                return false;
            }

        }

        return super.preHandle(request, response, handler);
    }

}
