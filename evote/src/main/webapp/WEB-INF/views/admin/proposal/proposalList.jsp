<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>

<!-- meta -->
<jsp:include page="/WEB-INF/views/admin/common/meta.jsp" />
<!-- //meta -->

<style type="text/css">
._contentArea {
    width : 80%;
    height : 700px;
    margin: 0 auto;
    background-color: white;
    padding: 5px 10px 5px 10px;
}
._searchArea {
    width : 100%;
    height : 100px;
}
._middleArea{
    width : 100%;
    height : 30px;
}
._dataArea {
    width : 100%;
    height : 500px;
}
._pagingArea{
    width : 100%;
    height : 30px;
    margin-top : 20px;
    text-align: center;
}
._pagingArea a {
    margin-right : 10px;
}
._pagingArea span {
    margin-right : 10px;
}
._dataTable {
    width: 100%;
}

._dataTable thead tr {
    height: 50px;
}
._dataTable tbody tr {
    height: 40px;
}
._dataTable th {
    background-color: #eaeaea;
}
._on {
    color: red;
}
._move {
    cursor: pointer;
    color: blue;
    text-decoration: underline;
}
._move:HOVER{
    color: gray;
}
._psSearchType {
    width:100%;
    height: 30px;
    margin-top: 10px;
}
._psSearchType div {
    float: left;
    margin-left: 10px;
    cursor: pointer;
}
._psSearchType div:hover {
    color: orange;
}
._psTypeActive {
    color: orange;
}
</style>

<script langauge="javascript">

function gfnPagingRander(areaId, nPageNum, nPageSize, nCount){
    var nGroupNumn,  //블럭 번호
    nTotalPage,      //전체 페이지
    nFromPage,       //시작 페이지
    nToPage;         //종료 페이지
    
    var nTotalPage = 0;
    var nNaviSize = 10;  //블럭 사이즈 설정

    if (nCount != 0){
        nTotalPage  = Math.floor((nCount - 1) / nPageSize) + 1;
        if (nPageNum > nTotalPage) {
            nPageNum = nTotalPage;
        }
        
        nGroupNum = Math.ceil((nPageNum / nNaviSize))-1;
        nFromPage = (nGroupNum * nNaviSize)+1
        nToPage     = (nFromPage + nNaviSize - 1);
        if (nToPage >= nTotalPage) {
            nToPage = nTotalPage;
        }
    }else{
        nTotalPage = 0;
    }
    var startNum = ((nPageNum-1) * nPageSize) + 1;
    
    var pagingDiv = "";
    //console.log(nFromPage  +'######'+ nToPage+'#####'+nTotalPage+'####'+nPageNum);
    if (nTotalPage != 0 && nTotalPage != 1) {
        pagingDiv +="\n<div class='_page'>\n";
        if (nFromPage > 1) {
            pagingDiv += "<a class=\"\"";
            pagingDiv += "title=첫번째페이지 href=\"#\" onclick=\"gfnMovePage("+ 1 +")\" >처음</a>";
            pagingDiv += "<a class=\"page_btn prev\" href=\"#\"";
            pagingDiv += "title=이전 10페이지 onclick=\"gfnMovePage("+ (nFromPage-1) +")\" >이전";
            pagingDiv += "</a>";
        }
        for (var i = nFromPage; i <= nToPage; i++) {
            if (i == nPageNum) {
                pagingDiv += "<span class=\"_on\">" + i+ "</span>";
            } else {
                //pagingDiv += "<span class=\"page_num\">";
                pagingDiv += "<a href=\"#\" onclick=\"gfnMovePage("+ i +")\">" + i + "</a>";
                //pagingDiv += "</span>";
            }
        }
        if (nToPage < nTotalPage) {
            pagingDiv += "<a class=\"page_btn next\"";
            pagingDiv += "title=\"다음\" href=\"#\" onclick=\"gfnMovePage("+ (nToPage + 1)+" )\" >다음</a>&#160;";
            pagingDiv += "<a class=\"page_btn end\" href=\"#\"";
            pagingDiv += "title=\"마지막페이지\" onclick=\"gfnMovePage("+ nTotalPage+" )\" >마지막";
            pagingDiv += "</a>";
        }
        pagingDiv += "</div>\n";
    } else {
        pagingDiv += "&nbsp;";
    }
    $('#'+areaId).html(pagingDiv);
}

function gfnMovePage(pageNum){
    $("#_tempFrm").children("[name=pageNum]").val(pageNum);
    $("#_tempFrm").prop("action", "<c:url value="/admin/proposal/list" />").submit();
}

$(document).ready(function(){
    
    gfnPagingRander("_pagingArea", "${params.pageNum}", "${params.pageSize}", "${proposalListCount}");
    gfnSetPeriodDatePicker("startDate", "endDate");
    $("#startDate, #endDate").css({"width":"150px","height":"22px","cursor":"pointer"}).prop("readonly",true);
    
    //전 검색데이터 셋팅
    fnSetSearchData();
    
});

function fnSearch(){
    $("#searchFrm").prop("action", "<c:url value="/admin/proposal/list" />").submit();
}

function fnSetSearchData(){
    var _tempFrm = $("#_tempFrm");
    $("#isPs").val(_tempFrm.children("[name=isPs]").val());
    $("#startDate").val(_tempFrm.children("[name=startDate]").val());
    $("#endDate").val(_tempFrm.children("[name=endDate]").val());
    $("#status").val(_tempFrm.children("[name=status]").val());
    $("#bizNm").val(_tempFrm.children("[name=bizNm]").val());
    
    /* _searchItem
    var searchItem = _tempFrm.children("[name=searchItem]").val();
    if(searchItem != null && searchItem != ""){
        $("#searchItem").val(searchItem);     
    }
    
    $("#searchKeyword").val(_tempFrm.children("[name=searchKeyword]").val());
    */
    
    var sortItem = _tempFrm.children("[name=sortItem]").val();
    if(sortItem != null && sortItem != ""){
        $("#sortItem").val(sortItem);       
    }
    
    var isPs = _tempFrm.children("[name=isPs]").val();
    $("div[class^=_psType]").removeClass("_psTypeActive");
    if(isPs == "Y"){
        $("._psType3").addClass("_psTypeActive");
    } else if(isPs == "N"){
        $("._psType2").addClass("_psTypeActive");
    } else {
        $("._psType1").addClass("_psTypeActive");
    }
}

function fnMoveDetail(propSeq){
    location.href = "<c:out value="/admin/proposal/detail" />?propSeq="+propSeq;
}

function fnMoveExcelDown(){
    alert("준비중");
}

function fnMovePsType(psSearchType){
    $("#_tempFrm").empty();
    if(psSearchType != 1){
        var isPs = "N";//상시
        if(psSearchType == 3){
            isPs = "Y";//공모
        }
        $('<input type="hidden" name="isPs" />').val(isPs).appendTo("#_tempFrm");   
    }
    $("#_tempFrm").prop("method", "post");
    $("#_tempFrm").prop("action", "<c:url value="/admin/proposal/list" />").submit();
}

</script>
</head>
<body>

    <!-- header -->
    <jsp:include page="/WEB-INF/views/admin/common/header.jsp" />
    <!-- //header -->
    <div id="container">
        <div class="_contentArea">
            <div class="_psSearchType">
                <div class="_psType1" onclick="fnMovePsType(1)">전체</div>
                <div class="_psType2" onclick="fnMovePsType(2)">상시</div>
                <div class="_psType3" onclick="fnMovePsType(3)">공모</div>
            </div>
            <form name="searchFrm" id="searchFrm">
                <input type="hidden" name="isPs" id="isPs" />
                <div class="_searchArea">
                    <div style="float:left;margin-right:15px;">
                        <span>등록기간 </span>
                        <input type="text" name="startDate" id="startDate" /> ~ 
                        <input type="text" name="endDate" id="endDate" />
                    </div>
                    <div style="float:left;margin-right:15px;">
                        <span>상태 </span>
                        <select name="status" id="status">
                            <option value="">전체</option>
                            <c:forEach items="${codeList }" var="item" >
                                <option value="<c:out value="${item.cdId }" />"><c:out value="${item.cdNm }" /></option>
                            </c:forEach>
                        </select>
                    </div>
                    <div style="float:left;margin-right:15px;">
                        <!-- _searchItem
                        <select name="searchItem" id="searchItem">
                            <option value="1">사업명</option>
                            <option value="2">작성자</option>
                        </select>
                        <input type="text" name="searchKeyword" id="searchKeyword" />
                        -->
                        <span>제목 </span>
                        <input type="text" name="bizNm" id="bizNm" />
                    </div>
                    <div style="float:left;margin-right:15px;">
                        <input type="button" name="searchBtn" value="검색" onclick="fnSearch()"/>
                    </div>
                </div>
                <div class="_middleArea">
                    <div style="float:left;">
                        <select name="sortItem" id="sortItem">
                            <option value="">등록순</option>
                            <option value="1">공감순</option>
                            <option value="2">조회순</option>
                        </select>
                    </div>
                    <div style="float:right;">
                        총 <span style="font-weight: bold;"><c:out value="${proposalListCount}" /></span>건이 검색되었습니다.
                    </div>
                    <div style="float:right;margin-right:15px;">
                        <input type="button" name="excelDownBtn" value="엑셀다운로드" onclick="fnMoveExcelDown()" />
                    </div>
                </div>
            </form>
            <div class="_dataArea">
                <table class="_dataTable">
                    <thead>
                    <tr>
                        <th>data1</th>
                        <th>data2</th>
                        <th>data3</th>
                        <th>data4</th>
                        <th>data5</th>
                        <th>data6</th>
                        <th>data7</th>
                        <th>data8</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach items="${proposalList }" var="item" >
                        <tr>
                            <td><c:out value="${item.propSeq }" /></td>
                            <td><c:out value="${item.psSeq }" /></td>
                            <td><c:out value="${item.siteCd }" /></td>
                            <td><c:out value="${item.realmCd }" /></td>
                            <td class="_move" onclick="fnMoveDetail('${item.propSeq }')"><c:out value="${item.bizNm }" /></td>
                            <td><c:out value="${item.cnslYn }" /></td>
                            <td><c:out value="${item.budget }" /></td>
                            <td><c:out value="${item.startDate }" /></td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty proposalList}">
                        <tr>
                            <td colspan="8" align="center">조회된 데이터가 없습니다.</td>
                        </tr>
                    </c:if>
                    </tbody>
                </table>
                <div id="_pagingArea" class="_pagingArea"></div>
            </div>
        </div>
    </div>
    <!-- footer -->
    <jsp:include page="/WEB-INF/views/admin/common/footer.jsp" />
    <!-- //footer -->
<form name="_tempFrm" id="_tempFrm">
    <input type="hidden" name="startDate" value="<c:out value="${param.startDate}" />" />
    <input type="hidden" name="endDate" value="<c:out value="${param.endDate}" />" />
    <input type="hidden" name="status" value="<c:out value="${param.status}" />" />
    <!-- _searchItem
    <input type="hidden" name="searchItem" value="<c:out value="${param.searchItem}" />" />
    <input type="hidden" name="searchKeyword" value="<c:out value="${param.searchKeyword}" />" />
     -->
    <input type="hidden" name="bizNm" value="<c:out value="${param.bizNm}" />" />
    <input type="hidden" name="sortItem" value="<c:out value="${param.sortItem}" />" />
    <input type="hidden" name="isPs" value="<c:out value="${param.isPs}" />" />
    <input type="hidden" name="pageNum" />
</form>
</body>
</html>