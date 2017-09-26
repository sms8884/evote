/**
 * Copyright (c) 2016 JAHA SMART CORP., LTD ALL RIGHT RESERVED
 */
package com.jaha.evote.domain;

import java.io.Serializable;

/**
 * <pre>
 * Class Name : AbstractSearch.java
 * Description : Description
 *  
 * Modification Information
 * 
 * Mod Date         Modifier    Description
 * -----------      --------    ---------------------------
 * 2016. 7. 25.     jjpark      Generation
 * </pre>
 *
 * @author jjpark
 * @since 2016. 7. 25.
 * @version 1.0
 */
public abstract class AbstractSearch implements Serializable {

    private static final long serialVersionUID = 5059706044053563619L;

    /**
     * 조회 대상 페이지
     */
    protected int pageNo;

    /**
     * 페이지 당 row
     */
    protected int pagingRow;

    protected String searchStartDate;
    protected String searchEndDate;
    protected String searchDpYn;
    protected String searchCategoryCd;
    protected String searchTarget;
    protected String searchText;
    protected String searchMyPostYn;
    protected String searchReplyYn;
    protected String searchDest;

    public AbstractSearch() {
        super();
        this.pageNo = 1;
        this.pagingRow = 10;
    }

    public int getPageNo() {
        return pageNo;
    }

    public void setPageNo(int pageNo) {
        this.pageNo = pageNo;
    }

    public int getPagingRow() {
        return pagingRow;
    }

    public void setPagingRow(int pagingRow) {
        this.pagingRow = pagingRow;
    }

    public int getStartRow() {
        return (pageNo - 1) * pagingRow;
    }

    public String getSearchStartDate() {
        return searchStartDate;
    }

    public void setSearchStartDate(String searchStartDate) {
        this.searchStartDate = searchStartDate;
    }

    public String getSearchEndDate() {
        return searchEndDate;
    }

    public void setSearchEndDate(String searchEndDate) {
        this.searchEndDate = searchEndDate;
    }

    public String getSearchDpYn() {
        return searchDpYn;
    }

    public void setSearchDpYn(String searchDpYn) {
        this.searchDpYn = searchDpYn;
    }

    public String getSearchCategoryCd() {
        return searchCategoryCd;
    }

    public void setSearchCategoryCd(String searchCategoryCd) {
        this.searchCategoryCd = searchCategoryCd;
    }

    public String getSearchTarget() {
        return searchTarget;
    }

    public void setSearchTarget(String searchTarget) {
        this.searchTarget = searchTarget;
    }

    public String getSearchText() {
        return searchText;
    }

    public void setSearchText(String searchText) {
        this.searchText = searchText;
    }

    public String getSearchMyPostYn() {
        return searchMyPostYn;
    }

    public void setSearchMyPostYn(String searchMyPostYn) {
        this.searchMyPostYn = searchMyPostYn;
    }

    public String getSearchReplyYn() {
        return searchReplyYn;
    }

    public void setSearchReplyYn(String searchReplyYn) {
        this.searchReplyYn = searchReplyYn;
    }

    public String getSearchDest() {
        return searchDest;
    }

    public void setSearchDest(String searchDest) {
        this.searchDest = searchDest;
    }

}
