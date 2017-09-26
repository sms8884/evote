/**
 * Copyright (c) 2016 JAHA SMART CORP., LTD ALL RIGHT RESERVED
 *
 * 2016. 7. 22.
 */
package com.jaha.evote.common.interceptor;

import java.net.URL;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;
import org.springframework.web.util.WebUtils;

import com.jaha.evote.common.util.StringUtils;
import com.jaha.evote.domain.AdminUser;
import com.jaha.evote.domain.ISiteInfo;
import com.jaha.evote.domain.Menu;
import com.jaha.evote.domain.common.CodeDetail;
import com.jaha.evote.domain.type.CodeType;
import com.jaha.evote.domain.type.RoleType;
import com.jaha.evote.service.CodeService;
import com.jaha.evote.service.MenuService;

/**
 * <pre>
 * Class Name : SiteCheckInterceptor.java
 * Description : Description
 *  
 * Modification Information
 * 
 * Mod Date         Modifier    Description
 * -----------      --------    ---------------------------
 * 2016. 7. 22.     jjpark      Generation
 * 2016. 10. 17.    jjpark      사이트 코드 조회 기준 변경
 *                              url base -> code table 기준
 * 2016. 10. 19.    jjpark      GNB 목록 추가
 * </pre>
 *
 * @author jjpark
 * @since 2016. 7. 22.
 * @version 1.0
 */
@Component
public class SiteCheckInterceptor extends HandlerInterceptorAdapter {

    private static final Logger logger = LoggerFactory.getLogger(SiteCheckInterceptor.class);

    @Autowired
    private CodeService codeService;

    @Autowired
    private MenuService menuService;

    @Value("${default.service.site.code}")
    private String defaultServiceSiteCode;

    @Value("${default.service.site.domain}")
    private String defaultServiceSiteDomain;

    /*
     * (non-Javadoc)
     * @see org.springframework.web.servlet.handler.HandlerInterceptorAdapter#preHandle(javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse, java.lang.Object)
     */
    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {

        String requestURL = request.getRequestURL().toString();

        URL url = new URL(requestURL);

        String siteHost = url.getHost();
        String siteCode = "";
        String siteProtocol = url.getProtocol();

        // redirect secure url
        if ("http".equals(siteProtocol) && siteHost.indexOf(defaultServiceSiteDomain) >= 0) {

            String secureURL = requestURL.replace("http://", "https://");

            logger.debug("### redirect secureURL [{}] -->> [{}]", requestURL, secureURL);

            response.sendRedirect(secureURL);
            return false;
        }

        // 코드테이블 기준 사이트코드 조회
        List<CodeDetail> serviceSiteList = codeService.getCodeList(CodeType.CODE_GROUP_SITE_CD.getCode());

        if (serviceSiteList != null && !serviceSiteList.isEmpty()) {
            for (CodeDetail codeDetail : serviceSiteList) {
                if (siteHost.equals(codeDetail.getData1())) {
                    siteCode = codeDetail.getCdId();
                    break;
                }
            }
        }

        // 코드테이블에 없는 사이트 코드일 경우 default site code [ep] 로 설정
        if (StringUtils.isEmpty(siteCode)) {
            siteCode = StringUtils.nvl(defaultServiceSiteCode, "ep");
            logger.debug("### invalid site code [{}]", siteHost);
            logger.debug("### set default site code [{}] -->> [{}]", siteHost, siteCode);
        }

        logger.debug("### siteHost ::: [{}]", siteHost);
        logger.debug("### siteCode ::: [{}]", siteCode);

        WebUtils.setSessionAttribute(request, ISiteInfo.ATTRIBUTE_NAME, siteCode);

        String requestURI = request.getRequestURI().trim();

        // 메뉴 목록
        List<Menu> gnbList = null;

        // front admin site 여부 체크에 사용
        if (requestURI.indexOf("/admin") > -1) {

            request.setAttribute(ISiteInfo.ADMIN_SITE_YN_ATTR, "Y");

            AdminUser adminSession = (AdminUser) WebUtils.getSessionAttribute(request, AdminUser.ATTRIBUTE_NAME);
            if (adminSession != null && adminSession.hasRole(RoleType.SYSTEM)) {
                gnbList = menuService.selectMenuList(true, RoleType.SYSTEM);
            } else {
                gnbList = menuService.selectMenuList(true, RoleType.ADMIN);
            }

        } else {
            request.setAttribute(ISiteInfo.ADMIN_SITE_YN_ATTR, "N");
            gnbList = menuService.selectMenuList(false, RoleType.USER);
        }

        request.setAttribute("gnbList", gnbList);

        /*
         * breadcrumb (게시판 제외)
         * >>> 페이지별 URL 목록 전체가 있어야 해서 일단 사용 안함
         */
        //        if (!requestURI.startsWith("/board")) {
        //            List<Menu> breadcrumbList = menuService.selectBreadcrumb(requestURI);
        //            request.setAttribute("breadcrumbList", breadcrumbList);
        //        }

        return super.preHandle(request, response, handler);

    }

}
