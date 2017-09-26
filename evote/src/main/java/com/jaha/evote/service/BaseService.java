/**
 * Copyright (c) 2016 JAHA SMART CORP., LTD ALL RIGHT RESERVED
 */
package com.jaha.evote.service;

import java.util.Arrays;
import java.util.List;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.web.context.request.RequestAttributes;
import org.springframework.web.context.request.RequestContextHolder;

import com.jaha.evote.domain.Account;
import com.jaha.evote.domain.AdminUser;
import com.jaha.evote.domain.ISiteInfo;
import com.jaha.evote.domain.Member;
import com.jaha.evote.domain.type.RoleType;
import com.jaha.evote.domain.type.UserType;

/**
 * <pre>
 * Class Name : BaseService.java
 * Description : 베이스 서비스
 *  
 * Modification Information
 * 
 * Mod Date         Modifier    Description
 * -----------      --------    ---------------------------
 * 2016. 7. 26.     jjpark      Generation
 * </pre>
 *
 * @author jjpark
 * @since 2016. 7. 26.
 * @version 1.0
 */
@Service
public abstract class BaseService {

    protected final Logger logger = LoggerFactory.getLogger(getClass());

    /**
     * 사이트 코드 조회
     * 
     * @return
     */
    protected String getSiteCd() {
        return (String) RequestContextHolder.getRequestAttributes().getAttribute(ISiteInfo.ATTRIBUTE_NAME, RequestAttributes.SCOPE_SESSION);
    }

    //    /**
    //     * 로그인 사용자 사이트 코드 조회
    //     * 
    //     * @return
    //     */
    //    @Deprecated
    //    protected String getUserSiteCd() {
    //        //        Account account = getAccount();
    //        //        if (account != null) {
    //        //            return account.getSiteCd();
    //        //        }
    //        return null;
    //    }

    /**
     * 관리자 세션 정보 조회
     * 
     * @return
     */
    protected AdminUser getLoginAdminUser() {
        try {
            return (AdminUser) RequestContextHolder.getRequestAttributes().getAttribute(AdminUser.ATTRIBUTE_NAME, RequestAttributes.SCOPE_SESSION);
        } catch (Exception e) {
            logger.info("### getLoginAdminUser :: AdminUser is NULL");
        }
        return null;
    }

    /**
     * 사용자 세션 정보 조회
     * 
     * @return
     */
    protected Member getLoginMember() {
        try {
            return (Member) RequestContextHolder.getRequestAttributes().getAttribute(Member.ATTRIBUTE_NAME, RequestAttributes.SCOPE_SESSION);
        } catch (Exception e) {
            logger.info("### getLoginMember :: Member is NULL");
        }
        return null;
    }

    /**
     * 계정 정보 조회
     * 
     * @return
     */
    protected Account getAccount() {
        Account account = getLoginAdminUser();
        if (account == null) {
            account = getLoginMember();
        }
        return (Account) account;
    }

    /**
     * 사용자 일련번호 조회
     * 
     * @return
     */
    protected long getUserSeq() {
        AdminUser adminUser = getLoginAdminUser();
        if (adminUser != null) {
            return adminUser.getMgrSeq();
        }
        Member member = getLoginMember();
        if (member != null) {
            return member.getUserSeq();
        }
        return 0L;
    }

    /**
     * 관리자 사이트 여부
     * 
     * @return
     */
    protected boolean isAdminSite() {
        String adminSiteYn = (String) RequestContextHolder.getRequestAttributes().getAttribute(ISiteInfo.ADMIN_SITE_YN_ATTR, RequestAttributes.SCOPE_REQUEST);
        if ("Y".equals(adminSiteYn)) {
            return true;
        } else {
            return false;
        }
    }

    /**
     * 사이트 권한 체크
     * 
     * @param siteList
     * @return
     */
    protected boolean isContainsSiteCd(String strSiteCdList) {
        if (strSiteCdList != null) {
            List<String> siteList = Arrays.asList(strSiteCdList.split("[|]"));
            if (siteList != null && siteList.contains(getSiteCd())) {
                return true;
            }
        }
        return false;
    }

    /**
     * 사용자 타입 조회
     * 
     * @return
     */
    protected UserType getUserType() {
        Account account = getAccount();
        if (account != null) {
            return account.getUserType();
        } else {
            UserType userType = (UserType) getSessionAttr("userType");
            if (userType != null) {
                return userType;
            }
        }
        return null;
    }

    /**
     * 사용자 ROLE 조회
     * 
     * @param roleType
     * @return
     */
    protected boolean hasRole(RoleType roleType) {
        Account account = getAccount();
        if (account != null) {
            return account.hasRole(roleType);
        }
        return false;
    }

    /**
     * 세션 항목 조회
     * 
     * @param attrName
     * @return
     */
    protected Object getSessionAttr(String attrName) {
        if (StringUtils.isEmpty(attrName)) {
            return null;
        } else {
            return getAttribute(attrName, RequestAttributes.SCOPE_SESSION);
        }
    }

    /**
     * attr 조회
     * 
     * @param attrName
     * @param scope
     * @return
     */
    protected Object getAttribute(String attrName, int scope) {
        if (StringUtils.isEmpty(attrName)) {
            return null;
        } else {
            return RequestContextHolder.getRequestAttributes().getAttribute(attrName, scope);
        }
    }
}
