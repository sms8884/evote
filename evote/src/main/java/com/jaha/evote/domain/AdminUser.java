/**
 * Copyright (c) 2016 by jahasmart.com. All rights reserved.
 *
 * 2016. 7. 11.
 */
package com.jaha.evote.domain;

import java.io.Serializable;
import java.util.Date;

/**
 * <pre>
 * Class Name : AdminUserVO.java
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
public class AdminUser extends Account implements Serializable {

    private static final long serialVersionUID = 2219331998314612807L;

    public static final String ATTRIBUTE_NAME = "_adminInfo";

    private long mgrSeq;
    private String regionCd;
    private String mgrId;
    private EncryptedString mgrPw;
    private EncryptedString mgrNm;
    private EncryptedString mgrEmail;
    private String mgrDept;
    private String mgrNickname;
    private EncryptedString mgrTel;
    private String useYn;
    private String mailReceiveYn;
    private Date lastLoginDate;
    private Date regDate;
    private Date modDate;

    public long getMgrSeq() {
        return mgrSeq;
    }

    public void setMgrSeq(long mgrSeq) {
        this.mgrSeq = mgrSeq;
    }

    public String getRegionCd() {
        return regionCd;
    }

    public void setRegionCd(String regionCd) {
        this.regionCd = regionCd;
    }

    public String getMgrId() {
        return mgrId;
    }

    public void setMgrId(String mgrId) {
        this.mgrId = mgrId;
    }

    public EncryptedString getMgrPw() {
        return mgrPw;
    }

    public void setMgrPw(EncryptedString mgrPw) {
        this.mgrPw = mgrPw;
    }

    public EncryptedString getMgrNm() {
        return mgrNm;
    }

    public void setMgrNm(EncryptedString mgrNm) {
        this.mgrNm = mgrNm;
    }

    public EncryptedString getMgrEmail() {
        return mgrEmail;
    }

    public void setMgrEmail(EncryptedString mgrEmail) {
        this.mgrEmail = mgrEmail;
    }

    public String getMgrDept() {
        return mgrDept;
    }

    public void setMgrDept(String mgrDept) {
        this.mgrDept = mgrDept;
    }

    public String getMgrNickname() {
        return mgrNickname;
    }

    public void setMgrNickname(String mgrNickname) {
        this.mgrNickname = mgrNickname;
    }

    public EncryptedString getMgrTel() {
        return mgrTel;
    }

    public void setMgrTel(EncryptedString mgrTel) {
        this.mgrTel = mgrTel;
    }

    public String getUseYn() {
        return useYn;
    }

    public void setUseYn(String useYn) {
        this.useYn = useYn;
    }

    public String getMailReceiveYn() {
        return mailReceiveYn;
    }

    public void setMailReceiveYn(String mailReceiveYn) {
        this.mailReceiveYn = mailReceiveYn;
    }

    public Date getLastLoginDate() {
        return lastLoginDate;
    }

    public void setLastLoginDate(Date lastLoginDate) {
        this.lastLoginDate = lastLoginDate;
    }

    public Date getRegDate() {
        return regDate;
    }

    public void setRegDate(Date regDate) {
        this.regDate = regDate;
    }

    public Date getModDate() {
        return modDate;
    }

    public void setModDate(Date modDate) {
        this.modDate = modDate;
    }

}
