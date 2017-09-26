/**
 * Copyright (c) 2016 JAHA SMART CORP., LTD ALL RIGHT RESERVED
 */
package com.jaha.evote.domain;

import java.io.Serializable;
import java.util.Date;

import com.jaha.evote.domain.type.GcmType;

/**
 * <pre>
 * Class Name : PushSendInfo.java
 * Description : Description
 *  
 * Modification Information
 * 
 * Mod Date         Modifier    Description
 * -----------      --------    ---------------------------
 * 2016. 11. 28.     jjpark      Generation
 * </pre>
 *
 * @author jjpark
 * @since 2016. 11. 28.
 * @version 1.0
 */
public class PushSendInfo implements Serializable {

    private static final long serialVersionUID = 1504108728696344896L;

    private long pushSeq;
    private GcmType pushType;
    private String title;
    private String message;
    private String action;
    private int totalCnt;
    private int successCnt;
    private int failureCnt;
    private Date regDate;
    private long regUser;

    public long getPushSeq() {
        return pushSeq;
    }

    public void setPushSeq(long pushSeq) {
        this.pushSeq = pushSeq;
    }

    public GcmType getPushType() {
        return pushType;
    }

    public void setPushType(GcmType pushType) {
        this.pushType = pushType;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public String getAction() {
        return action;
    }

    public void setAction(String action) {
        this.action = action;
    }

    public int getTotalCnt() {
        return totalCnt;
    }

    public void setTotalCnt(int totalCnt) {
        this.totalCnt = totalCnt;
    }

    public int getSuccessCnt() {
        return successCnt;
    }

    public void setSuccessCnt(int successCnt) {
        this.successCnt = successCnt;
    }

    public int getFailureCnt() {
        return failureCnt;
    }

    public void setFailureCnt(int failureCnt) {
        this.failureCnt = failureCnt;
    }

    public Date getRegDate() {
        return regDate;
    }

    public void setRegDate(Date regDate) {
        this.regDate = regDate;
    }

    public long getRegUser() {
        return regUser;
    }

    public void setRegUser(long regUser) {
        this.regUser = regUser;
    }

}
