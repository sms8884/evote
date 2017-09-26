package com.jaha.evote.domain.common;

import java.io.Serializable;

public class Address implements Serializable {

    private static final long serialVersionUID = 6332518775792576457L;

    /** 행정구역코드 */
    private String regionCd;

    /** 시도명 */
    private String sidoNm;

    /** 시군구명 */
    private String sggNm;

    /** 읍면동명 */
    private String emdNm;

    /** 출력순서 */
    private int sortOrder;

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

    public int getSortOrder() {
        return sortOrder;
    }

    public void setSortOrder(int sortOrder) {
        this.sortOrder = sortOrder;
    }

}
