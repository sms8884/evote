/**
 * Copyright (c) 2016 JAHA SMART CORP., LTD ALL RIGHT RESERVED
 */
package com.jaha.evote.domain;

import java.io.Serializable;
import java.util.List;

import com.jaha.evote.domain.type.RoleType;
import com.jaha.evote.domain.type.UserType;

/**
 * <pre>
 * Class Name : Account.java
 * Description : Description
 *  
 * Modification Information
 * 
 * Mod Date         Modifier    Description
 * -----------      --------    ---------------------------
 * 2016. 7. 27.     jjpark      Generation
 * 2016. 11. 28.    jjpark      roleType 제거 -->> roles 로 통합
 * </pre>
 *
 * @author jjpark
 * @since 2016. 7. 27.
 * @version 1.0
 */
public class Account implements Serializable {

    private static final long serialVersionUID = 7914788439215226910L;

    protected List<RoleType> roles;

    protected UserType userType;

    protected String siteCd;

    protected String loginIp;

    protected String accessToken;

    /**
     * 권한 조회
     * 
     * @param roleType
     * @return
     */
    public boolean hasRole(RoleType roleType) {
        if (roleType != null && this.roles != null && this.roles.contains(roleType)) {
            return true;
        } else {
            return false;
        }
    }

    /**
     * 관리자 여부 조회
     * 
     * @return
     */
    public boolean isAdmin() {
        if (this.hasRole(RoleType.ADMIN) || this.hasRole(RoleType.SYSTEM)) {
            return true;
        } else {
            return false;
        }
    }


    public UserType getUserType() {
        return userType;
    }

    public void setUserType(UserType userType) {
        this.userType = userType;
    }

    public String getSiteCd() {
        return siteCd;
    }

    public void setSiteCd(String siteCd) {
        this.siteCd = siteCd;
    }

    public String getLoginIp() {
        return loginIp;
    }

    public void setLoginIp(String loginIp) {
        this.loginIp = loginIp;
    }

    public String getAccessToken() {
        return accessToken;
    }

    public void setAccessToken(String accessToken) {
        this.accessToken = accessToken;
    }

    public List<RoleType> getRoles() {
        return roles;
    }

    public void setRoles(List<RoleType> roles) {
        this.roles = roles;
    }

}
