/**
 * Copyright (c) 2016 JAHA SMART CORP., LTD ALL RIGHT RESERVED
 */
package com.jaha.evote.common.util;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

/**
 * <pre>
 * Class Name : PagingHelper.java
 * Description : Description
 *  
 * Modification Information
 * 
 * Mod Date         Modifier    Description
 * -----------      --------    ---------------------------
 * 2016. 7. 22.     jjpark      Generation
 * </pre>
 *
 * @author jjpark
 * @since 2016. 7. 22.
 * @version 1.0
 */
public class PagingHelper {

    private int pagingRow;

    private int columnNo;

    private List<Integer> pagingColumn;

    private int totalPage;

    private int totalCnt;

    private int pageNo;

    private int startPageNumOfPaging;

    private int startRow;

    private int startRowDesc;

    private HttpServletRequest request;

    public PagingHelper(HttpServletRequest request) {
        this(request, NumberUtils.toInt(request.getParameter("pagingRow"), 10), 10, -1);
    }

    public PagingHelper(HttpServletRequest request, int totalCount) {
        this(request, 10, 10, -1);
    }

    public PagingHelper(HttpServletRequest request, int rowNo, int columnNo) {
        this(request, rowNo, columnNo, -1);
    }

    public PagingHelper(HttpServletRequest request, int rowNo, int columnNo, int totalCount) {
        this.pageNo = NumberUtils.toInt(request.getParameter("pageNo"), 1);
        this.pagingRow = rowNo;
        this.columnNo = columnNo;
        this.request = request;
    }

    public void setTotalCnt(String totalCnt) {
        setCurrentPageAndTotalRow(null, totalCnt);
    }

    public void setTotalCnt(int totalCnt) {
        setCurrentPageAndTotalRow(null, String.valueOf(totalCnt));
    }

    public int getPageNo() {
        return pageNo;
    }

    public int getTotalPage() {
        return totalPage;
    }

    public int getTotalCnt() {
        return totalCnt;
    }

    public int getStartRow() {
        return startRow;
    }

    public int getStartRowDesc() {
        return startRowDesc;
    }

    public int getPrevPaging() {
        if (startPageNumOfPaging - 1 < 1) {
            return -1;
        } else {
            return startPageNumOfPaging - 1;
        }
    }

    public int getNextPaging() {
        if (startPageNumOfPaging + columnNo > totalPage) {
            return -1;
        } else {
            return startPageNumOfPaging + columnNo;
        }
    }

    public List<Integer> getPagingColumn() {
        return pagingColumn;
    }

    public int getPagingRow() {
        return pagingRow;
    }

    public void setPagingRow(int rowNo) {
        this.pagingRow = rowNo;
    }

    private void setPagingColumn(int startIndex) {
        List<Integer> list = new ArrayList<Integer>();
        int temp = startPageNumOfPaging;
        for (int i = 0; i < columnNo && temp <= totalPage; i++) {
            list.add(Integer.valueOf(temp++));
        }

        pagingColumn = list;
    }

    public void setCurrentPageAndTotalRow(String currentPage, String totalRow) {
        try {
            if (currentPage == null && request != null) {
                currentPage = request.getParameter("pageNo");
            }
            if (StringUtils.isEmpty(currentPage)) {
                currentPage = "1";
            }
            this.pageNo = Integer.parseInt(currentPage.trim());
            this.totalCnt = Integer.parseInt(totalRow.trim());
            if (this.totalCnt % pagingRow == 0) {
                totalPage = this.totalCnt != 0 ? this.totalCnt / pagingRow : 0;
            } else {
                totalPage = this.totalCnt != 0 ? this.totalCnt / pagingRow + 1 : 0;
            }
            startPageNumOfPaging = ((this.pageNo - 1) / columnNo) * columnNo + 1;
            startRow = (this.pageNo - 1) * pagingRow + 1;
            startRowDesc = this.totalCnt - startRow + 1;
            setPagingColumn(this.pageNo);
        } catch (NumberFormatException ex) {
            this.pageNo = 1;
            this.totalCnt = 0;
        }
    }

}
