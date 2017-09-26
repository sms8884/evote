/**
 * Copyright (c) 2016 JAHA SMART CORP., LTD ALL RIGHT RESERVED
 */
package com.jaha.evote.domain;

import java.io.Serializable;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.jaha.evote.domain.type.UserStatus;

/**
 * <pre>
 * Class Name : Config.java
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
public class Config implements Serializable {

    private static final long serialVersionUID = -4907292922127579703L;

    public static String USER_NOT_FOUND_CODE = "10";
    public static String USER_NOT_FOUND_MESSAGE = "사용자 정보 없음";

    @JsonIgnore
    private long userSeq;

    @JsonIgnore
    private String siteCd;

    @JsonIgnore
    private UserStatus userStat;

    private String configGroup;
    private String configCode;
    private String configName;
    private String configDesc;
    private String useYn;

    public long getUserSeq() {
        return userSeq;
    }

    public void setUserSeq(long userSeq) {
        this.userSeq = userSeq;
    }

    public String getSiteCd() {
        return siteCd;
    }

    public void setSiteCd(String siteCd) {
        this.siteCd = siteCd;
    }

    public UserStatus getUserStat() {
        return userStat;
    }

    public void setUserStat(UserStatus userStat) {
        this.userStat = userStat;
    }

    public String getConfigGroup() {
        return configGroup;
    }

    public void setConfigGroup(String configGroup) {
        this.configGroup = configGroup;
    }

    public String getConfigCode() {
        return configCode;
    }

    public void setConfigCode(String configCode) {
        this.configCode = configCode;
    }

    public String getConfigName() {
        return configName;
    }

    public void setConfigName(String configName) {
        this.configName = configName;
    }

    public String getConfigDesc() {
        return configDesc;
    }

    public void setConfigDesc(String configDesc) {
        this.configDesc = configDesc;
    }

    public String getUseYn() {
        return useYn;
    }

    public void setUseYn(String useYn) {
        this.useYn = useYn;
    }

}
