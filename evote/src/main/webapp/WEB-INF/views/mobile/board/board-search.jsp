<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page contentType="text/html; charset=utf-8" %>
<script language="javascript" type="text/javascript">
	$(function() {
		$("#tmpSearchText").on("focus",function() {
			$(this).css('background-image','none');
		}).on("blur",function() {
			if($(this).val() == "") {
				var imageUrl = "${siteImgPath}/sub3/boardSearch.png";
				$(this).css('background', 'url(' + imageUrl + ') 50% 50% no-repeat');
				$(this).css('background-size', '71px 16px');
			} else {
				$(this).css('background-image','none');
			}
		});
		
		<c:if test="${not empty searchParam.searchText}">
			$("#searchText, #tmpSearchText").val("<c:out value='${searchParam.searchText}'/>");
			$("#tmpSearchText").css('background-image','none');
		</c:if>
	});
</script>
	
	<div class="boardSearch">
		<input type="text" class="iptxt" id="tmpSearchText" style="text-indent: 10px;" />
		<input type="button" class="ipbtn" title="" value="검색" onclick="searchPost();" />
	</div>
<!-- 	
	<input type="hidden" id="pageNo" value="1"/>
	<form id="searchForm">
		<input type="hidden" name="searchTarget" id="tmpSearchTarget" value="TITLE"/>
		<input type="hidden" name="searchText" id="tmpSearchText"/>
		<input type="hidden" name="searchMyPostYn" id="tmpSearchMyPostYn"/>
	</form>
-->