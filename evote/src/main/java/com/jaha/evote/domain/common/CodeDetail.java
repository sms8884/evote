package com.jaha.evote.domain.common;

import java.io.Serializable;
import java.util.Date;

public class CodeDetail implements Serializable {

    private static final long serialVersionUID = -6396856359208374503L;

    private String cdGrpId;
    private String cdId;
    private String cdNm;
    private String cdDesc;
    private int sortOrder;
    private int depth;
    private String useYn;
    private String data1;
    private String data2;
    private String data3;
    private String data4;
    private String data5;
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

    public String getCdId() {
        return cdId;
    }

    public void setCdId(String cdId) {
        this.cdId = cdId;
    }

    public String getCdNm() {
        return cdNm;
    }

    public void setCdNm(String cdNm) {
        this.cdNm = cdNm;
    }

    public String getCdDesc() {
        return cdDesc;
    }

    public void setCdDesc(String cdDesc) {
        this.cdDesc = cdDesc;
    }

    public int getSortOrder() {
        return sortOrder;
    }

    public void setSortOrder(int sortOrder) {
        this.sortOrder = sortOrder;
    }

    public int getDepth() {
        return depth;
    }

    public void setDepth(int depth) {
        this.depth = depth;
    }

    public String getUseYn() {
        return useYn;
    }

    public void setUseYn(String useYn) {
        this.useYn = useYn;
    }

    public String getData1() {
        return data1;
    }

    public void setData1(String data1) {
        this.data1 = data1;
    }

    public String getData2() {
        return data2;
    }

    public void setData2(String data2) {
        this.data2 = data2;
    }

    public String getData3() {
        return data3;
    }

    public void setData3(String data3) {
        this.data3 = data3;
    }

    public String getData4() {
        return data4;
    }

    public void setData4(String data4) {
        this.data4 = data4;
    }

    public String getData5() {
        return data5;
    }

    public void setData5(String data5) {
        this.data5 = data5;
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
