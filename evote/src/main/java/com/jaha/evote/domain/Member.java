package com.jaha.evote.domain;

import java.io.Serializable;
import java.util.Date;

import com.jaha.evote.domain.type.UserStatus;

public class Member extends Account implements Serializable {

    private static final long serialVersionUID = 2451497467149243920L;

    public static final String ATTRIBUTE_NAME = "_accountInfo";

    private Long userSeq;
    private String subcmit1;    // 분과코드1
    private String subcmit2;    // 분과코드2
    private String subcmitNm1;  // 분과명1
    private String subcmitNm2;  // 분과명2
    private UserStatus userStat;
    private EncryptedString userNm;
    private String nickname;
    private String birthYear;
    private String birthDate;
    private String gender;
    private EncryptedString email;
    private EncryptedString phone;
    private EncryptedString userPw;
    private String regionCd;
    private String sidoNm;
    private String sggNm;
    private String emdNm;
    private Date lastLoginDate;
    private String termsAgreeYn;
    private Date termsAgreeDate;
    private String cmtYn;   // 댓글사용가능여부
    private Date cmtBanDate;  // 댓글금지일시
    private Long cmtBanUser;  // 댓글금지처리자
    private EncryptedString cmtBanUserNm;  // 댓글금지처리자명
    private String pushYn;
    private String pushKey;

    private String voteStat;    // 투표상태
    private Date banStartDate;  // 금지시작일시
    private Date banEndDate;    // 금지종료일시

    private String accessToken; // access token
    private Date expireTime;    // 토큰만료시간

    private Date regDate;
    private Date modDate;
    private Long modUser;

    private int reportCnt;

    private String errorMessage;
    private String returnUrl;

    public Long getUserSeq() {
        return userSeq;
    }

    public void setUserSeq(Long userSeq) {
        this.userSeq = userSeq;
    }

    public UserStatus getUserStat() {
        return userStat;
    }

    public void setUserStat(UserStatus userStat) {
        this.userStat = userStat;
    }

    public EncryptedString getUserNm() {
        return userNm;
    }

    public void setUserNm(EncryptedString userNm) {
        this.userNm = userNm;
    }

    public String getNickname() {
        return nickname;
    }

    public void setNickname(String nickname) {
        this.nickname = nickname;
    }

    public String getBirthYear() {
        return birthYear;
    }

    public void setBirthYear(String birthYear) {
        this.birthYear = birthYear;
    }

    public String getBirthDate() {
        return birthDate;
    }

    public void setBirthDate(String birthDate) {
        this.birthDate = birthDate;
    }

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

    public EncryptedString getEmail() {
        return email;
    }

    public void setEmail(EncryptedString email) {
        this.email = email;
    }

    public EncryptedString getPhone() {
        return phone;
    }

    public void setPhone(EncryptedString phone) {
        this.phone = phone;
    }

    public EncryptedString getUserPw() {
        return userPw;
    }

    public void setUserPw(EncryptedString userPw) {
        this.userPw = userPw;
    }

    public String getRegionCd() {
        return regionCd;
    }

    public void setRegionCd(String regionCd) {
        this.regionCd = regionCd;
    }

    public String getSidoNm() {
        return sidoNm;
    }

    public void setSidoNm(String sidoNm) {
        this.sidoNm = sidoNm;
    }

    public String getSggNm() {
        return sggNm;
    }

    public void setSggNm(String sggNm) {
        this.sggNm = sggNm;
    }

    public String getEmdNm() {
        return emdNm;
    }

    public void setEmdNm(String emdNm) {
        this.emdNm = emdNm;
    }

    public Date getLastLoginDate() {
        return lastLoginDate;
    }

    public void setLastLoginDate(Date lastLoginDate) {
        this.lastLoginDate = lastLoginDate;
    }

    public String getTermsAgreeYn() {
        return termsAgreeYn;
    }

    public void setTermsAgreeYn(String termsAgreeYn) {
        this.termsAgreeYn = termsAgreeYn;
    }

    public Date getTermsAgreeDate() {
        return termsAgreeDate;
    }

    public void setTermsAgreeDate(Date termsAgreeDate) {
        this.termsAgreeDate = termsAgreeDate;
    }

    public String getCmtYn() {
        return cmtYn;
    }

    public void setCmtYn(String cmtYn) {
        this.cmtYn = cmtYn;
    }

    public String getPushYn() {
        return pushYn;
    }

    public void setPushYn(String pushYn) {
        this.pushYn = pushYn;
    }

    public String getPushKey() {
        return pushKey;
    }

    public void setPushKey(String pushKey) {
        this.pushKey = pushKey;
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

    public Long getModUser() {
        return modUser;
    }

    public void setModUser(Long modUser) {
        this.modUser = modUser;
    }

    public int getReportCnt() {
        return reportCnt;
    }

    public void setReportCnt(int reportCnt) {
        this.reportCnt = reportCnt;
    }

    public String getErrorMessage() {
        return errorMessage;
    }

    public void setErrorMessage(String errorMessage) {
        this.errorMessage = errorMessage;
    }

    public String getReturnUrl() {
        return returnUrl;
    }

    public void setReturnUrl(String returnUrl) {
        this.returnUrl = returnUrl;
    }

    public Date getBanStartDate() {
        return banStartDate;
    }

    public void setBanStartDate(Date banStartDate) {
        this.banStartDate = banStartDate;
    }

    public Date getBanEndDate() {
        return banEndDate;
    }

    public void setBanEndDate(Date banEndDate) {
        this.banEndDate = banEndDate;
    }

    public String getVoteStat() {
        return voteStat;
    }

    public void setVoteStat(String voteStat) {
        this.voteStat = voteStat;
    }

    public Date getCmtBanDate() {
        return cmtBanDate;
    }

    public void setCmtBanDate(Date cmtBanDate) {
        this.cmtBanDate = cmtBanDate;
    }

    public Long getCmtBanUser() {
        return cmtBanUser;
    }

    public void setCmtBanUser(Long cmtBanUser) {
        this.cmtBanUser = cmtBanUser;
    }

    public EncryptedString getCmtBanUserNm() {
        return cmtBanUserNm;
    }

    public void setCmtBanUserNm(EncryptedString cmtBanUserNm) {
        this.cmtBanUserNm = cmtBanUserNm;
    }

    public String getAccessToken() {
        return accessToken;
    }

    public void setAccessToken(String accessToken) {
        this.accessToken = accessToken;
    }

    public Date getExpireTime() {
        return expireTime;
    }

    public void setExpireTime(Date expireTime) {
        this.expireTime = expireTime;
    }

    public String getSubcmit1() {
        return subcmit1;
    }

    public void setSubcmit1(String subcmit1) {
        this.subcmit1 = subcmit1;
    }

    public String getSubcmit2() {
        return subcmit2;
    }

    public void setSubcmit2(String subcmit2) {
        this.subcmit2 = subcmit2;
    }

    public String getSubcmitNm1() {
        return subcmitNm1;
    }

    public void setSubcmitNm1(String subcmitNm1) {
        this.subcmitNm1 = subcmitNm1;
    }

    public String getSubcmitNm2() {
        return subcmitNm2;
    }

    public void setSubcmitNm2(String subcmitNm2) {
        this.subcmitNm2 = subcmitNm2;
    }

}
