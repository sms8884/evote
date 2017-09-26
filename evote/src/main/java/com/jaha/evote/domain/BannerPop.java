/**
 * Copyright (c) 2016 JAHA SMART CORP., LTD ALL RIGHT RESERVED
 */
package com.jaha.evote.domain;

import java.io.Serializable;
import java.util.Date;
import java.util.List;

import com.jaha.evote.domain.common.FileInfo;

/**
 * <pre>
 * Class Name : BannerPop.java
 * Description : Description
 *  
 * Modification Information
 * 
 * Mod Date         Modifier    Description
 * -----------      --------    ---------------------------
 * 2016. 10. 28.     jjpark      Generation
 * </pre>
 *
 * @author jjpark
 * @since 2016. 10. 28.
 * @version 1.0
 */
public class BannerPop extends AbstractSearch implements Serializable {

    private static final long serialVersionUID = -4859649367270580521L;

    private long bpSeq;
    private String siteCd;
    private String type;
    private String dest;
    private long destSeq;
    private String title;
    private String dpYn;
    private String dpType;
    private Date startDate;
    private Date endDate;
    private long regUser;
    private Date regDate;
    private long modUser;
    private Date mod_date;

    private List<FileInfo> mobImageList;
    private List<FileInfo> webImageList;

    private String strStartDate;
    private String strStartTime;
    private String strEndDate;
    private String strEndTime;

    private String adminYn; // 관리자여부

    private String destTitle;   // 대상 게시물 타이틀
    private Date destStartDate; // 대상 시작일자
    private Date destEndDate;   // 대상 종료일자

    public long getBpSeq() {
        return bpSeq;
    }

    public void setBpSeq(long bpSeq) {
        this.bpSeq = bpSeq;
    }

    public String getSiteCd() {
        return siteCd;
    }

    public void setSiteCd(String siteCd) {
        this.siteCd = siteCd;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getDest() {
        return dest;
    }

    public void setDest(String dest) {
        this.dest = dest;
    }

    public long getDestSeq() {
        return destSeq;
    }

    public void setDestSeq(long destSeq) {
        this.destSeq = destSeq;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getDpYn() {
        return dpYn;
    }

    public void setDpYn(String dpYn) {
        this.dpYn = dpYn;
    }

    public String getDpType() {
        return dpType;
    }

    public void setDpType(String dpType) {
        this.dpType = dpType;
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

    public long getRegUser() {
        return regUser;
    }

    public void setRegUser(long regUser) {
        this.regUser = regUser;
    }

    public Date getRegDate() {
        return regDate;
    }

    public void setRegDate(Date regDate) {
        this.regDate = regDate;
    }

    public long getModUser() {
        return modUser;
    }

    public void setModUser(long modUser) {
        this.modUser = modUser;
    }

    public Date getMod_date() {
        return mod_date;
    }

    public void setMod_date(Date mod_date) {
        this.mod_date = mod_date;
    }

    public List<FileInfo> getMobImageList() {
        return mobImageList;
    }

    public void setMobImageList(List<FileInfo> mobImageList) {
        this.mobImageList = mobImageList;
    }

    public List<FileInfo> getWebImageList() {
        return webImageList;
    }

    public void setWebImageList(List<FileInfo> webImageList) {
        this.webImageList = webImageList;
    }

    public String getStrStartDate() {
        return strStartDate;
    }

    public void setStrStartDate(String strStartDate) {
        this.strStartDate = strStartDate;
    }

    public String getStrStartTime() {
        return strStartTime;
    }

    public void setStrStartTime(String strStartTime) {
        this.strStartTime = strStartTime;
    }

    public String getStrEndDate() {
        return strEndDate;
    }

    public void setStrEndDate(String strEndDate) {
        this.strEndDate = strEndDate;
    }

    public String getStrEndTime() {
        return strEndTime;
    }

    public void setStrEndTime(String strEndTime) {
        this.strEndTime = strEndTime;
    }

    public String getAdminYn() {
        return adminYn;
    }

    public void setAdminYn(String adminYn) {
        this.adminYn = adminYn;
    }

    public String getDestTitle() {
        return destTitle;
    }

    public void setDestTitle(String destTitle) {
        this.destTitle = destTitle;
    }

    public Date getDestStartDate() {
        return destStartDate;
    }

    public void setDestStartDate(Date destStartDate) {
        this.destStartDate = destStartDate;
    }

    public Date getDestEndDate() {
        return destEndDate;
    }

    public void setDestEndDate(Date destEndDate) {
        this.destEndDate = destEndDate;
    }

}
