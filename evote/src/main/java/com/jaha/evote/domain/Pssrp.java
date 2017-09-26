package com.jaha.evote.domain;

import java.io.Serializable;
import java.util.Date;

import org.springframework.web.multipart.MultipartFile;

public class Pssrp implements Serializable {

    private static final long serialVersionUID = -7327034877936853771L;

    private Integer psSeq; // 공모일련번호
    private String siteCd; // 사이트코드
    private String title; // 공모제목
    private String opScale; // 운영규모
    private String gnrScope; // 일반사업 사업범위
    private String gnrScale; // 일반사업 전체규모
    private String gnrStd; // 일반사업 사업비기준
    private String trgScope;// 목적사업 사업범위
    private String trgScale;// 목적사업 사업규모
    private String trgStd;// 목적사업 사업비기준
    private String reqDest;// 신청대상
    private String reqRealm;// 신청분야
    private String reqMethod;// 신청방법
    private String bizScale;// 사업선정방법
    private String regulation;// 규정
    private String delYn;// 삭제여부
    private String ineligibleBiz;// 부적격사업
    private Date startDate;// 신청시작일
    private Date endDate;// 신청종료일
    private Date regDate;// 등록일
    private Long regUser;// 등록자
    private Date modDate;// 수정일
    private Long modUser;// 수정자

    private Integer proposalCnt;// 제안갯수
    private String status;// 상태(대기,종료,진행중)
    private MultipartFile realmfile;// 신청분야파일
    private MultipartFile methodfile;// 신청방법파일
    private MultipartFile imgpcfile;// 흐름도이미지(PC)
    private MultipartFile imgmobfile;// 흐름도 이미지(Mobile)
    private String realmfileYn;// 신청분야파일 여부
    private String methodfileYn;// 신청방법파일 여부
    private String imgpcfileYn;// 흐름도이미지(PC) 여부
    private String imgmobfileYn;// 흐름도 이미지(Mobile) 여부

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

    public String getRegulation() {
        return regulation;
    }

    public void setRegulation(String regulation) {
        this.regulation = regulation;
    }

    public String getDelYn() {
        return delYn;
    }

    public void setDelYn(String delYn) {
        this.delYn = delYn;
    }

    public String getIneligibleBiz() {
        return ineligibleBiz;
    }

    public void setIneligibleBiz(String ineligibleBiz) {
        this.ineligibleBiz = ineligibleBiz;
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

    public Integer getProposalCnt() {
        return proposalCnt;
    }

    public void setProposalCnt(Integer proposalCnt) {
        this.proposalCnt = proposalCnt;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public MultipartFile getRealmfile() {
        return realmfile;
    }

    public void setRealmfile(MultipartFile realmfile) {
        this.realmfile = realmfile;
    }

    public MultipartFile getMethodfile() {
        return methodfile;
    }

    public void setMethodfile(MultipartFile methodfile) {
        this.methodfile = methodfile;
    }

    public MultipartFile getImgpcfile() {
        return imgpcfile;
    }

    public void setImgpcfile(MultipartFile imgpcfile) {
        this.imgpcfile = imgpcfile;
    }

    public MultipartFile getImgmobfile() {
        return imgmobfile;
    }

    public void setImgmobfile(MultipartFile imgmobfile) {
        this.imgmobfile = imgmobfile;
    }

    public String getRealmfileYn() {
        return realmfileYn;
    }

    public void setRealmfileYn(String realmfileYn) {
        this.realmfileYn = realmfileYn;
    }

    public String getMethodfileYn() {
        return methodfileYn;
    }

    public void setMethodfileYn(String methodfileYn) {
        this.methodfileYn = methodfileYn;
    }

    public String getImgpcfileYn() {
        return imgpcfileYn;
    }

    public void setImgpcfileYn(String imgpcfileYn) {
        this.imgpcfileYn = imgpcfileYn;
    }

    public String getImgmobfileYn() {
        return imgmobfileYn;
    }

    public void setImgmobfileYn(String imgmobfileYn) {
        this.imgmobfileYn = imgmobfileYn;
    }



}
