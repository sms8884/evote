package com.jaha.evote.domain;

import java.io.Serializable;
import java.text.SimpleDateFormat;
import java.util.Date;

import com.jaha.evote.common.util.StringUtils;


/**
 * <pre>
 * Class Name : PropComment.java
 * Description : Description
 *  
 * Modification Information
 * 
 * Mod Date         Modifier    Description
 * -----------      --------    ---------------------------
 * 2016. 7. 22.     shavrani      Generation
 * </pre>
 *
 * @author shavrani
 * @since 2016. 7. 22.
 * @version 1.0
 */
public class PropComment implements Serializable {

    private static final long serialVersionUID = 5489934071556391355L;

    private final SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

    private Integer cmtSeq;

    private Integer propSeq;

    private String cont;

    private String hideYn;

    private int agreeCntY;

    private int agreeCntN;

    private int reportCnt;

    private Date regDate;

    private Long regUser;

    private String regName;

    private String nickname;

    private Date modDate;

    private Long modUser;

    private String cmtYn;

    /** 게시자 여부 */
    private String ownerYn;

    public Integer getCmtSeq() {
        return cmtSeq;
    }

    public void setCmtSeq(Integer cmtSeq) {
        this.cmtSeq = cmtSeq;
    }

    public Integer getPropSeq() {
        return propSeq;
    }

    public void setPropSeq(Integer propSeq) {
        this.propSeq = propSeq;
    }

    public String getCont() {
        return cont;
    }

    public void setCont(String cont) {
        this.cont = cont;
    }

    public String getHideYn() {
        return hideYn;
    }

    public void setHideYn(String hideYn) {
        this.hideYn = hideYn;
    }

    public int getAgreeCntY() {
        return agreeCntY;
    }

    public void setAgreeCntY(int agreeCntY) {
        this.agreeCntY = agreeCntY;
    }

    public int getAgreeCntN() {
        return agreeCntN;
    }

    public void setAgreeCntN(int agreeCntN) {
        this.agreeCntN = agreeCntN;
    }

    public int getReportCnt() {
        return reportCnt;
    }

    public void setReportCnt(int reportCnt) {
        this.reportCnt = reportCnt;
    }

    public Date getRegDate() {
        return regDate;
    }

    public void setRegDate(Date regDate) {
        this.regDate = regDate;
    }

    public String getRegDateText() {
        return sdf.format(regDate);
    }

    public Long getRegUser() {
        return regUser;
    }

    public void setRegUser(Long regUser) {
        this.regUser = regUser;
    }

    public String getRegName() {
        return regName;
    }

    public void setRegName(String regName) {
        this.regName = regName;
    }

    public String getNickname() {
        return nickname;
    }

    public void setNickname(String nickname) {
        this.nickname = nickname;
    }

    public Date getModDate() {
        return modDate;
    }

    public void setModDate(Date modDate) {
        this.modDate = modDate;
    }

    public String getModDateText() {
        String modDateText = "";
        if (!StringUtils.isNull(modDate)) {
            modDateText = sdf.format(modDate);
        }
        return modDateText;
    }

    public Long getModUser() {
        return modUser;
    }

    public void setModUser(Long modUser) {
        this.modUser = modUser;
    }

    public String getCmtYn() {
        return cmtYn;
    }

    public void setCmtYn(String cmtYn) {
        this.cmtYn = cmtYn;
    }

    public String getOwnerYn() {
        return ownerYn;
    }

    public void setOwnerYn(String ownerYn) {
        this.ownerYn = ownerYn;
    }

}
