<%@ page contentType="text/html; charset=utf-8" %>
<form id="searchForm" name="searchForm" method="POST">
	<input type="hidden" id="pageNo" name="pageNo" value="${searchParam.pageNo}"/>
	<input type="hidden" id="searchStartDate" name="searchStartDate" value="${searchParam.searchStartDate}"/>
	<input type="hidden" id="searchEndDate" name="searchEndDate" value="${searchParam.searchEndDate}"/>
	<input type="hidden" id="searchCategoryCd" name="searchCategoryCd" value="${searchParam.searchCategoryCd}"/>
	<input type="hidden" id="searchTarget" name="searchTarget" value="${searchParam.searchTarget}"/>
	<input type="hidden" id="searchText" name="searchText" value="${searchParam.searchText}"/>
	<input type="hidden" id="searchMyPostYn" name="searchMyPostYn" value="${searchParam.searchMyPostYn}"/>
</form>