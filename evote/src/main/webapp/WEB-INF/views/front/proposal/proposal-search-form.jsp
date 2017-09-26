<%@ page contentType="text/html; charset=utf-8" %>
<form name="_tempFrm" id="_tempFrm" method="post">
    <input type="hidden" name="startDate" value="${params.startDate}" />
    <input type="hidden" name="endDate" value="${params.endDate}" />
    <input type="hidden" name="status" value="${params.status}" />
    <input type="hidden" name="searchItem" value="${params.searchItem}" />
    <input type="hidden" name="searchKeyword" value="${params.searchKeyword}" />
    <input type="hidden" name="bizNm" value="${params.bizNm}" />
    <input type="hidden" name="sortItem" value="${params.sortItem}" />
    <input type="hidden" name="isPs" value="${params.isPs}" />
    <input type="hidden" name="myProposal" value="${params.myProposal}" />
    <input type="hidden" name="reviewResult" value="${params.reviewResult}" />
    <input type="hidden" name="pageNum" />
    <input type="hidden" id="pageNo" name="pageNo" value="${pagingHelper.pageNo}"/>
    <input type="hidden" id="visitorPw" name="visitorPw"/>
</form>