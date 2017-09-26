/**
 * Copyright (c) 2016 JAHA SMART CORP., LTD ALL RIGHT RESERVED
 */
package com.jaha.evote.domain;

import java.io.Serializable;
import java.util.Date;

/**
 * <pre>
 * Class Name : VoteMaster.java
 * Description : Description
 *  
 * Modification Information
 * 
 * Mod Date         Modifier    Description
 * -----------      --------    ---------------------------
 * 2016. 11. 14.     jjpark      Generation
 * </pre>
 *
 * @author jjpark
 * @since 2016. 11. 14.
 * @version 1.0
 */
public class VoteMaster implements Serializable {

    private static final long serialVersionUID = -6881790708167592621L;

    private long voteSeq;
    private String siteCd;
    private String regionCd;
    private String title;
    private Date startDate;
    private Date endDate;
    private String voteStatus;
    private String bizDpType;
    private String target;
    private String targetText;
    private String voteType;
    private int choiceCnt;
    private String resultDpYn;
    private String voteInfo;
    private int voterCnt;
    private String voteResult;
    private int dpOrd;
    private Date regDate;
    private long regUser;
    private Date modDate;
    private long modUser;

    public long getVoteSeq() {
        return voteSeq;
    }

    public void setVoteSeq(long voteSeq) {
        this.voteSeq = voteSeq;
    }

    public String getSiteCd() {
        return siteCd;
    }

    public void setSiteCd(String siteCd) {
        this.siteCd = siteCd;
    }

    public String getRegionCd() {
        return regionCd;
    }

    public void setRegionCd(String regionCd) {
        this.regionCd = regionCd;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
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

    public String getVoteStatus() {
        return voteStatus;
    }

    public void setVoteStatus(String voteStatus) {
        this.voteStatus = voteStatus;
    }

    public String getBizDpType() {
        return bizDpType;
    }

    public void setBizDpType(String bizDpType) {
        this.bizDpType = bizDpType;
    }

    public String getTarget() {
        return target;
    }

    public void setTarget(String target) {
        this.target = target;
    }

    public String getTargetText() {
        return targetText;
    }

    public void setTargetText(String targetText) {
        this.targetText = targetText;
    }

    public String getVoteType() {
        return voteType;
    }

    public void setVoteType(String voteType) {
        this.voteType = voteType;
    }

    public int getChoiceCnt() {
        return choiceCnt;
    }

    public void setChoiceCnt(int choiceCnt) {
        this.choiceCnt = choiceCnt;
    }

    public String getResultDpYn() {
        return resultDpYn;
    }

    public void setResultDpYn(String resultDpYn) {
        this.resultDpYn = resultDpYn;
    }

    public String getVoteInfo() {
        return voteInfo;
    }

    public void setVoteInfo(String voteInfo) {
        this.voteInfo = voteInfo;
    }

    public int getVoterCnt() {
        return voterCnt;
    }

    public void setVoterCnt(int voterCnt) {
        this.voterCnt = voterCnt;
    }

    public String getVoteResult() {
        return voteResult;
    }

    public void setVoteResult(String voteResult) {
        this.voteResult = voteResult;
    }

    public int getDpOrd() {
        return dpOrd;
    }

    public void setDpOrd(int dpOrd) {
        this.dpOrd = dpOrd;
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

}
