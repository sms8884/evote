package com.jaha.evote.domain.common;

import java.io.Serializable;
import java.util.Date;

public class CodeGroup implements Serializable {

    private static final long serialVersionUID = -6230798675019403382L;

    private String cdGrpId;
    private String cdGrpNm;
    private String cdGrpDesc;
    private int sortOrder;
    private String useYn;
    private String emaulYn;
    private String advertYn;
    private String evoteYn;
    private String regId;
    private Date regDate;
    private String modId;
    private Date modDate;

    public String getCdGrpId() {
        return cdGrpId;
    }

    public void setCdGrpId(String cdGrpId) {
        this.cdGrpId = cdGrpId;
    }

    public String getCdGrpNm() {
        return cdGrpNm;
    }

    public void setCdGrpNm(String cdGrpNm) {
        this.cdGrpNm = cdGrpNm;
    }

    public String getCdGrpDesc() {
        return cdGrpDesc;
    }

    public void setCdGrpDesc(String cdGrpDesc) {
        this.cdGrpDesc = cdGrpDesc;
    }

    public int getSortOrder() {
        return sortOrder;
    }

    public void setSortOrder(int sortOrder) {
        this.sortOrder = sortOrder;
    }

    public String getUseYn() {
        return useYn;
    }

    public void setUseYn(String useYn) {
        this.useYn = useYn;
    }

    public String getEmaulYn() {
        return emaulYn;
    }

    public void setEmaulYn(String emaulYn) {
        this.emaulYn = emaulYn;
    }

    public String getAdvertYn() {
        return advertYn;
    }

    public void setAdvertYn(String advertYn) {
        this.advertYn = advertYn;
    }

    public String getEvoteYn() {
        return evoteYn;
    }

    public void setEvoteYn(String evoteYn) {
        this.evoteYn = evoteYn;
    }

    public String getRegId() {
        return regId;
    }

    public void setRegId(String regId) {
        this.regId = regId;
    }

    public Date getRegDate() {
        return regDate;
    }

    public void setRegDate(Date regDate) {
        this.regDate = regDate;
    }

    public String getModId() {
        return modId;
    }

    public void setModId(String modId) {
        this.modId = modId;
    }

    public Date getModDate() {
        return modDate;
    }

    public void setModDate(Date modDate) {
        this.modDate = modDate;
    }

}
