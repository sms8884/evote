<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page contentType="text/html; charset=utf-8" %>

<div class="paging">
	<span class="num">
		<c:choose>
			<c:when test="${pagingHelper.prevPaging eq -1}">
				<a href="#"><img src="${siteImgPath}/common/btn_prev1.gif" alt="처음"/></a>
				<a href="#"><img src="${siteImgPath}/common/btn_prev2.gif" alt="이전페이지로 이동"/></a>
			</c:when>
			<c:otherwise>
				<a href="#" onclick="javascript:gotoPage(1); return false;"><img src="${siteImgPath}/common/btn_prev1.gif" alt="처음"/></a>
				<a href="#" onclick="javascript:gotoPage(${pagingHelper.prevPaging}); return false;"><img src="${siteImgPath}/common/btn_prev2.gif" alt="이전페이지로 이동"/></a>
			</c:otherwise>
		</c:choose>
		<em>
		<c:if test="${pagingHelper.totalPage eq 0 }">
			<strong>1</strong>
		</c:if>	
		<c:forEach items="${pagingHelper.pagingColumn}" var="pagingColumn">
			<c:choose>
				<c:when test="${pagingColumn eq pagingHelper.pageNo}">
					<a href="#" class="on">${pagingColumn}</a>
				</c:when>
				<c:otherwise>
					<a href="#" onclick="javascript:gotoPage(${pagingColumn}); return false;">${pagingColumn}</a>
				</c:otherwise>
			</c:choose>
		</c:forEach>
		</em>
		<c:choose>
			<c:when test="${pagingHelper.nextPaging eq -1}">
				<a href="#"><img src="${siteImgPath}/common/btn_next1.gif" alt="다음페이지로 이동"/></a>
				<a href="#"><img src="${siteImgPath}/common/btn_next2.gif" alt="끝"/></a>
			</c:when>
			<c:otherwise>
				<a href="#" onclick="javascript:gotoPage(${pagingHelper.nextPaging}); return false;"><img src="${siteImgPath}/common/btn_next1.gif" alt="다음페이지로 이동"/></a>
				<a href="#" onclick="javascript:gotoPage(${pagingHelper.totalPage}); return false;"><img src="${siteImgPath}/common/btn_next2.gif" alt="끝"/></a>
			</c:otherwise>
		</c:choose>
	</span>
</div>

<script type="text/javascript">
    if($("#pageNo").length == 0) {
    	$("#${param.formId}").append("<input type='hidden' id='pageNo' name='pageNo' value='${pagingHelper.pageNo}' />");
    }
    
    $("input[type='submit'], button[type='submit']").click(function() {
    	$("#pageNo").val(1);    	
    });

    $("#" + "${param.formId}").attr("action", "${param.action}");
    
    function gotoPage(pageNo) {
        $('#pageNo').val(pageNo);
        //validate checkt시 confirm 중복되는 부분 처리 
        var form = document.getElementById("${param.formId}");
    	form.submit();
    }
</script>