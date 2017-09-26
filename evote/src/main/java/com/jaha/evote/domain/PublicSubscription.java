/**
 * Copyright (c) 2016 JAHA SMART CORP., LTD ALL RIGHT RESERVED
 */
package com.jaha.evote.domain;

import java.io.Serializable;
import java.util.Date;

import com.jaha.evote.domain.common.FileInfo;

/**
 * <pre>
 * Class Name : PublicSubscription.java
 * Description : Description
 *  
 * Modification Information
 * 
 * Mod Date         Modifier    Description
 * -----------      --------    ---------------------------
 * 2016. 8. 18.     jjpark      Generation
 * </pre>
 *
 * @author jjpark
 * @since 2016. 8. 18.
 * @version 1.0
 */
public class PublicSubscription implements Serializable {

    private static final long serialVersionUID = -3382760558964312724L;

    private int psSeq;
    private String siteCd;
    private String title;
    private String opScale;
    private String gnrScope;
    private String gnrScale;
    private String gnrStd;
    private String trgScope;
    private String trgScale;
    private String trgStd;
    private Date startDate;
    private Date endDate;
    private String reqDest;
    private String reqRealm;
    private String reqMethod;
    private String bizScale;
    private String ineligibleBiz;
    private String regulation;
    private Date regDate;
    private long regUser;
    private Date modDate;
    private long modUser;
    private String delYn;

    private FileInfo reqRealmFile;
    private FileInfo reqMethodFile;
    private FileInfo imagePcFile;
    private FileInfo imageMobileFile;

    public int getPsSeq() {
        return psSeq;
    }

    public void setPsSeq(int psSeq) {
        this.psSeq = psSeq;
    }

    public String getSiteCd() {
        return siteCd;
    }

    public void setSiteCd(String siteCd) {
        this.siteCd = siteCd;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getOpScale() {
        return opScale;
    }

    public void setOpScale(String opScale) {
        this.opScale = opScale;
    }

    public String getGnrScope() {
        return gnrScope;
    }

    public void setGnrScope(String gnrScope) {
        this.gnrScope = gnrScope;
    }

    public String getGnrScale() {
        return gnrScale;
    }

    public void setGnrScale(String gnrScale) {
        this.gnrScale = gnrScale;
    }

    public String getGnrStd() {
        return gnrStd;
    }

    public void setGnrStd(String gnrStd) {
        this.gnrStd = gnrStd;
    }

    public String getTrgScope() {
        return trgScope;
    }

    public void setTrgScope(String trgScope) {
        this.trgScope = trgScope;
    }

    public String getTrgScale() {
        return trgScale;
    }

    public void setTrgScale(String trgScale) {
        this.trgScale = trgScale;
    }

    public String getTrgStd() {
        return trgStd;
    }

    public void setTrgStd(String trgStd) {
        this.trgStd = trgStd;
    }

    public Date getStartDate() {
        return startDate;
    }

    public void setStartDate(Date startDate) {
        this.startDate = startDate;
    }

    public Date getEndDate() {
        return endDate;
    }

    public void setEndDate(Date endDate) {
        this.endDate = endDate;
    }

    public String getReqDest() {
        return reqDest;
    }

    public void setReqDest(String reqDest) {
        this.reqDest = reqDest;
    }

    public String getReqRealm() {
        return reqRealm;
    }

    public void setReqRealm(String reqRealm) {
        this.reqRealm = reqRealm;
    }

    public String getReqMethod() {
        return reqMethod;
    }

    public void setReqMethod(String reqMethod) {
        this.reqMethod = reqMethod;
    }

    public String getBizScale() {
        return bizScale;
    }

    public void setBizScale(String bizScale) {
        this.bizScale = bizScale;
    }

    public String getIneligibleBiz() {
        return ineligibleBiz;
    }

    public void setIneligibleBiz(String ineligibleBiz) {
        this.ineligibleBiz = ineligibleBiz;
    }

    public String getRegulation() {
        return regulation;
    }

    public void setRegulation(String regulation) {
        this.regulation = regulation;
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

    public Date getModDate() {
        return modDate;
    }

    public void setModDate(Date modDate) {
        this.modDate = modDate;
    }

    public long getModUser() {
        return modUser;
    }

    public void setModUser(long modUser) {
        this.modUser = modUser;
    }

    public FileInfo getReqRealmFile() {
        return reqRealmFile;
    }

    public void setReqRealmFile(FileInfo reqRealmFile) {
        this.reqRealmFile = reqRealmFile;
    }

    public FileInfo getReqMethodFile() {
        return reqMethodFile;
    }

    public void setReqMethodFile(FileInfo reqMethodFile) {
        this.reqMethodFile = reqMethodFile;
    }

    public FileInfo getImagePcFile() {
        return imagePcFile;
    }

    public void setImagePcFile(FileInfo imagePcFile) {
        this.imagePcFile = imagePcFile;
    }

    public FileInfo getImageMobileFile() {
        return imageMobileFile;
    }

    public void setImageMobileFile(FileInfo imageMobileFile) {
        this.imageMobileFile = imageMobileFile;
    }

    public String getDelYn() {
        return delYn;
    }

    public void setDelYn(String delYn) {
        this.delYn = delYn;
    }

}
