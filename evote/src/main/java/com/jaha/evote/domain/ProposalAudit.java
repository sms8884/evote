package com.jaha.evote.domain;

import java.io.Serializable;
import java.util.Date;

import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;


/**
 * <pre>
 * Class Name : ProposalAudit.java
 * Description : Description
 *  
 * Modification Information
 * 
 * Mod Date         Modifier    Description
 * -----------      --------    ---------------------------
 * 2016. 8. 8.     shavrani      Generation
 * </pre>
 *
 * @author shavrani
 * @since 2016. 8. 8.
 * @version 1.0
 */
public class ProposalAudit implements Serializable {

    private static final long serialVersionUID = 2607812584184105310L;

    //private final SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

    private Integer propSeq;

    private String status;

    private String statusText;

    private String startDate;

    private String endDate;

    private String budget;

    private String location;

    private String subcmit;

    private String realmCd;

    private String bizCont;

    private String lawResult;

    private String lawDetail;

    private String reviewResult;

    private String reviewDetail;

    private String reviewDept;

    private String reviewer;

    private String cmitResult;

    private String cmitDetail;

    private String auditCmitResult;

    private String auditCmitBudget;

    private String auditGnrResult;

    private String auditGnrBudget;

    private Integer auditRank;

    private Date regDate;

    private Long regUser;

    private Date modDate;

    private Long modUser;

    private String realmNm;

    public Integer getPropSeq() {
        return propSeq;
    }

    public void setPropSeq(Integer propSeq) {
        this.propSeq = propSeq;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getStatusText() {
        return statusText;
    }

    public void setStatusText(String statusText) {
        this.statusText = statusText;
    }

    public String getStartDate() {
        return startDate;
    }

    public void setStartDate(String startDate) {
        this.startDate = startDate;
    }

    public String getEndDate() {
        return endDate;
    }

    public void setEndDate(String endDate) {
        this.endDate = endDate;
    }

    public String getBudget() {
        return budget;
    }

    public void setBudget(String budget) {
        this.budget = budget;
    }

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }

    public String getSubcmit() {
        return subcmit;
    }

    public void setSubcmit(String subcmit) {
        this.subcmit = subcmit;
    }

    public String getRealmCd() {
        return realmCd;
    }

    public void setRealmCd(String realmCd) {
        this.realmCd = realmCd;
    }

    public String getBizCont() {
        return bizCont;
    }

    public void setBizCont(String bizCont) {
        this.bizCont = bizCont;
    }

    public String getLawResult() {
        return lawResult;
    }

    public void setLawResult(String lawResult) {
        this.lawResult = lawResult;
    }

    public String getLawDetail() {
        return lawDetail;
    }

    public void setLawDetail(String lawDetail) {
        this.lawDetail = lawDetail;
    }

    public String getReviewResult() {
        return reviewResult;
    }

    public void setReviewResult(String reviewResult) {
        this.reviewResult = reviewResult;
    }

    public String getReviewDetail() {
        return reviewDetail;
    }

    public void setReviewDetail(String reviewDetail) {
        this.reviewDetail = reviewDetail;
    }

    public String getReviewDept() {
        return reviewDept;
    }

    public void setReviewDept(String reviewDept) {
        this.reviewDept = reviewDept;
    }

    public String getReviewer() {
        return reviewer;
    }

    public void setReviewer(String reviewer) {
        this.reviewer = reviewer;
    }

    public String getCmitResult() {
        return cmitResult;
    }

    public void setCmitResult(String cmitResult) {
        this.cmitResult = cmitResult;
    }

    public String getCmitDetail() {
        return cmitDetail;
    }

    public void setCmitDetail(String cmitDetail) {
        this.cmitDetail = cmitDetail;
    }

    public String getAuditCmitResult() {
        return auditCmitResult;
    }

    public void setAuditCmitResult(String auditCmitResult) {
        this.auditCmitResult = auditCmitResult;
    }

    public String getAuditCmitBudget() {
        return auditCmitBudget;
    }

    public void setAuditCmitBudget(String auditCmitBudget) {
        this.auditCmitBudget = auditCmitBudget;
    }

    public String getAuditGnrResult() {
        return auditGnrResult;
    }

    public void setAuditGnrResult(String auditGnrResult) {
        this.auditGnrResult = auditGnrResult;
    }

    public String getAuditGnrBudget() {
        return auditGnrBudget;
    }

    public void setAuditGnrBudget(String auditGnrBudget) {
        this.auditGnrBudget = auditGnrBudget;
    }

    public Integer getAuditRank() {
        return auditRank;
    }

    public void setAuditRank(Integer auditRank) {
        this.auditRank = auditRank;
    }

    public Date getRegDate() {
        return regDate;
    }

    public void setRegDate(Date regDate) {
        this.regDate = regDate;
    }

    public Long getRegUser() {
        return regUser;
    }

    public void setRegUser(Long regUser) {
        this.regUser = regUser;
    }

    public Date getModDate() {
        return modDate;
    }

    public void setModDate(Date modDate) {
        this.modDate = modDate;
    }

    public Long getModUser() {
        return modUser;
    }

    public void setModUser(Long modUser) {
        this.modUser = modUser;
    }

    @Override
    public String toString() {
        return ToStringBuilder.reflectionToString(this, ToStringStyle.MULTI_LINE_STYLE);
    }

    public String getRealmNm() {
        return realmNm;
    }

    public void setRealmNm(String realmNm) {
        this.realmNm = realmNm;
    }

}
