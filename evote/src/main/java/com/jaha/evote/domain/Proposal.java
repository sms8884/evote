package com.jaha.evote.domain;

import java.io.Serializable;
import java.text.SimpleDateFormat;
import java.util.Date;

import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;

import com.jaha.evote.domain.type.ProposalStatus;

/**
 * <pre>
 * Class Name : ProposalVO.java
 * Description : Description
 *  
 * Modification Information
 * 
 * Mod Date         Modifier    Description
 * -----------      --------    ---------------------------
 * 2016. 7. 14.     shavrani      Generation
 * </pre>
 *
 * @author shavrani
 * @since 2016. 7. 14.
 * @version 1.0
 */
public class Proposal implements Serializable {

    private static final long serialVersionUID = 9010745454529595898L;

    private final SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

    private Integer propSeq;

    private Integer psSeq;

    private String siteCd;

    private String realmCd;

    private String realmNm;

    private String bizNm;

    private String cnslYn;

    private String budget;

    private String startDate;

    private String endDate;

    private String location;

    private String necessity;

    private String bizCont;

    private String effect;

    private ProposalStatus status;

    private String statusText;

    private int readCnt;

    private int symCnt;

    private int commentCnt;

    private String memberYn;

    private EncryptedString reqNm;

    private EncryptedString reqPhone;

    private String reqAddr;

    private EncryptedString reqEmail;

    private EncryptedString reqPw;

    private Date regDate;

    private Long regUser;

    private EncryptedString regName;

    private String regSggNm;

    private String regEmdNm;

    private String regEmail;

    private Date modDate;

    private Long modUser;

    private String deleteYn;

    /** 공감 선택 여부 */
    private String symYn;

    /** 게시자 여부 */
    private String ownerYn;

    /** 댓글쓰기가능여부 */
    private String cmtYn;

    /** 검토결과 */
    private String reviewResult;

    /** 첨부파일 유무 */
    private String fileYn;

    public Integer getPropSeq() {
        return propSeq;
    }

    public void setPropSeq(Integer propSeq) {
        this.propSeq = propSeq;
    }

    public Integer getPsSeq() {
        return psSeq;
    }

    public void setPsSeq(Integer psSeq) {
        this.psSeq = psSeq;
    }

    public String getSiteCd() {
        return siteCd;
    }

    public void setSiteCd(String siteCd) {
        this.siteCd = siteCd;
    }

    public String getRealmCd() {
        return realmCd;
    }

    public void setRealmCd(String realmCd) {
        this.realmCd = realmCd;
    }

    public String getRealmNm() {
        return realmNm;
    }

    public void setRealmNm(String realmNm) {
        this.realmNm = realmNm;
    }

    public String getBizNm() {
        return bizNm;
    }

    public void setBizNm(String bizNm) {
        this.bizNm = bizNm;
    }

    public String getCnslYn() {
        return cnslYn;
    }

    public void setCnslYn(String cnslYn) {
        this.cnslYn = cnslYn;
    }

    public String getBudget() {
        return budget;
    }

    public void setBudget(String budget) {
        this.budget = budget;
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

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }

    public String getNecessity() {
        return necessity;
    }

    public void setNecessity(String necessity) {
        this.necessity = necessity;
    }

    public String getBizCont() {
        return bizCont;
    }

    public void setBizCont(String bizCont) {
        this.bizCont = bizCont;
    }

    public String getEffect() {
        return effect;
    }

    public void setEffect(String effect) {
        this.effect = effect;
    }

    public String getStatusText() {
        return statusText;
    }

    public void setStatusText(String statusText) {
        this.statusText = statusText;
    }

    public int getReadCnt() {
        return readCnt;
    }

    public void setReadCnt(int readCnt) {
        this.readCnt = readCnt;
    }

    public int getSymCnt() {
        return symCnt;
    }

    public void setSymCnt(int symCnt) {
        this.symCnt = symCnt;
    }

    public int getCommentCnt() {
        return commentCnt;
    }

    public void setCommentCnt(int commentCnt) {
        this.commentCnt = commentCnt;
    }

    public String getMemberYn() {
        return memberYn;
    }

    public void setMemberYn(String memberYn) {
        this.memberYn = memberYn;
    }

    public String getReqAddr() {
        return reqAddr;
    }

    public void setReqAddr(String reqAddr) {
        this.reqAddr = reqAddr;
    }

    public Date getRegDate() {
        return regDate;
    }

    public String getRegDateText() {
        return sdf.format(regDate);
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

    public String getRegSggNm() {
        return regSggNm;
    }

    public void setRegSggNm(String regSggNm) {
        this.regSggNm = regSggNm;
    }

    public String getRegEmdNm() {
        return regEmdNm;
    }

    public void setRegEmdNm(String regEmdNm) {
        this.regEmdNm = regEmdNm;
    }

    public String getRegEmail() {
        return regEmail;
    }

    public void setRegEmail(String regEmail) {
        this.regEmail = regEmail;
    }

    public Date getModDate() {
        return modDate;
    }

    public String getModDateText() {
        return sdf.format(modDate);
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

    public String getDeleteYn() {
        return deleteYn;
    }

    public void setDeleteYn(String deleteYn) {
        this.deleteYn = deleteYn;
    }

    @Override
    public String toString() {
        return ToStringBuilder.reflectionToString(this, ToStringStyle.MULTI_LINE_STYLE);
    }

    public String getSymYn() {
        return symYn;
    }

    public void setSymYn(String symYn) {
        this.symYn = symYn;
    }

    public String getOwnerYn() {
        return ownerYn;
    }

    public void setOwnerYn(String ownerYn) {
        this.ownerYn = ownerYn;
    }

    public String getCmtYn() {
        return cmtYn;
    }

    public void setCmtYn(String cmtYn) {
        this.cmtYn = cmtYn;
    }

    public ProposalStatus getStatus() {
        return status;
    }

    public void setStatus(ProposalStatus status) {
        this.status = status;
    }

    public String getReviewResult() {
        return reviewResult;
    }

    public void setReviewResult(String reviewResult) {
        this.reviewResult = reviewResult;
    }

    /**
     * @return the fileYn
     */
    public String getFileYn() {
        return fileYn;
    }

    /**
     * @param fileYn the fileYn to set
     */
    public void setFileYn(String fileYn) {
        this.fileYn = fileYn;
    }

    public EncryptedString getReqNm() {
        return reqNm;
    }

    public void setReqNm(EncryptedString reqNm) {
        this.reqNm = reqNm;
    }

    public EncryptedString getReqPhone() {
        return reqPhone;
    }

    public void setReqPhone(EncryptedString reqPhone) {
        this.reqPhone = reqPhone;
    }

    public EncryptedString getReqEmail() {
        return reqEmail;
    }

    public void setReqEmail(EncryptedString reqEmail) {
        this.reqEmail = reqEmail;
    }

    public EncryptedString getReqPw() {
        return reqPw;
    }

    public void setReqPw(EncryptedString reqPw) {
        this.reqPw = reqPw;
    }

    public EncryptedString getRegName() {
        return regName;
    }

    public void setRegName(EncryptedString regName) {
        this.regName = regName;
    }

}
