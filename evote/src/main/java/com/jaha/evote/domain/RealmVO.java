package com.jaha.evote.domain;

import java.io.Serializable;
import java.text.SimpleDateFormat;
import java.util.Date;

/**
 * <pre>
 * Class Name : RealmVO.java
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
public class RealmVO implements Serializable {

    private static final long serialVersionUID = -3661379744059478416L;

    private final SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

    private String siteCd;

    private String realmCd;

    private String realmNm;

    private String youthYn;

    private String adultTn;

    private int choiceCnt;

    private int dpOrd;

    private Date regDate;

    private Long regUser;

    private String regName;

    private Date modDate;

    private Long modUser;


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

    public String getYouthYn() {
        return youthYn;
    }

    public void setYouthYn(String youthYn) {
        this.youthYn = youthYn;
    }

    public String getAdultTn() {
        return adultTn;
    }

    public void setAdultTn(String adultTn) {
        this.adultTn = adultTn;
    }

    public int getChoiceCnt() {
        return choiceCnt;
    }

    public void setChoiceCnt(int choiceCnt) {
        this.choiceCnt = choiceCnt;
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

    public String getRegName() {
        return regName;
    }

    public void setRegName(String regName) {
        this.regName = regName;
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

}
