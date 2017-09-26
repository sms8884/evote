<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page contentType="text/html; charset=utf-8" %>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>
<!-- meta -->
<jsp:include page="/WEB-INF/views/mobile/common/meta.jsp"/>
<!-- //meta -->
<link href="${siteCssPath}/board.css" type="text/css" rel="stylesheet"  />
<link href="${siteCssPath}/etc.css" type="text/css" rel="stylesheet"  />
<script language="javascript" type="text/javascript">
//<![CDATA[
$(document).ready(function(){
	if('${bizItem.state}'=='완료'){
		$("#progressBox").css("display","none");
	}
	
}); 

function viewMore(){

	if($('#pageNo').val() == ""){
		$('#pageNo').val(1);
	}
	$('#pageNo').val( Number($('#pageNo').val()) + 1 );
$.ajax({
    type: 'POST',
    url: '/cmit/cmit_contest_listMore',
    dataType: 'json',
    data: $("#form").serialize(),
    success: function (data) {
    	if(data.cmitReqList.length > 0) {
        	for(var idx=0; idx < data.cmitReqList.length; idx++) {
        		var item = data.cmitReqList[idx];
				/* 추가10개로 데이터 추가 */            		
    			var html = '<li class="">'
    							+'<a href="/cmit/cmit_contest_reqView/'+item.req_seq+'" >'
    							+'<strong class="">'+item.title+'</strong>'
    							+'<span class="bgtext">'+item.subCmit1;
    							if(item.subCmit2 == ""){
    							}else{
    							html+=	'('+item.subCmit2+')';
    							}
    							html+= '</span>';
     							html +=''+item.reg_date;
    							html +='| 등록자 '+item.userNm+'</span> </a></li>';
				/*// 추가10개로 데이터 추가 */            	
    		 	$("#moreData").append(html);
        	}
    	}else{
    		alert('더이상 데이터가 없습니다');
    	}
    },
    error: function (jqXHR, textStatus, errorThrown) {
        console.log(errorThrown);
        console.log(textStatus);
    }
});
}


//]]>
</script>
</head>
<body>

<!-- header -->
<jsp:include page="/WEB-INF/views/mobile/common/header.jsp"/>
<!-- //header -->

<div class="wrap">
	<div class="location">
		<img src="${siteImgPath}/common/locaHome.png" alt=""/>
		<span>주민참여위원회</span>
		<span>위원공모</span>
		<span>신청내역</span>
	</div>

	<p class="budgetTit">주민참여위원공모 신청내역</p>
	<div class="boardList bgList">
		<div class="boardInfoBox">
			<p>※ 위원공모 신청정보는 주민참여위원<br/> 해촉기간까지 보관됩니다.</p>
		</div>
	<form id='form' name='form' method="post"  class="searchTb">	
		<ul class="" id="moreData">
		<c:forEach var="item" items="${cmitReqList}" varStatus="status" >
			<li class="">
				<a href="/cmit/cmit_contest_reqView/${item.req_seq}" >
					<strong class="">${item.title}</strong>
					<span class="bgtext">${item.subCmit1} <c:if test="${item.subCmit2 == null}"></c:if>
								<c:if test="${not empty item.subCmit2 }">(${item.subCmit2})</c:if></span>
					<span>${item.reg_date} | 등록자 ${item.userNm }</span>
				</a>
			</li>
		</c:forEach>
		</ul>
<%-- 		<input type="hidden" id="pageNo" name="pageNo" value="${pagingHelper.pageNo}"/> --%>
				<input type="hidden" id="pageNo" name="pageNo" value="${pagingHelper.pageNo}"/>
	</form>		
		<p class="boardMore"><a href="javascript:viewMore()"><span>더보기(10)</span></a></p>
	</div>
	
	<!-- footer -->
	<jsp:include page="/WEB-INF/views/mobile/common/footer.jsp"/>
	<!--// footer -->
</div>

</body>
</html>
