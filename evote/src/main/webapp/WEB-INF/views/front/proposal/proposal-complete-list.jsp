<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>

<!-- meta -->
<jsp:include page="/WEB-INF/views/front/common/meta.jsp"/>
<!-- //meta -->

<script language="javascript" type="text/javascript">
//<![CDATA[
	$(document).ready(function(){
		$('.gnb').topmenu({ d1: 1, d2: 3, d3:2});
		
		fnSetSearchData();
		
	});
	
	function fnSearch(idx){
		
		if( $("#checkMyProposal").hasClass('on') ) {
			$("#myProposal").val("Y");
		} else {
			$("#myProposal").val("N");
		}
		
		$("#sortItem").val(idx);
	    $("#searchFrm").prop("action", "/proposal/complete-list").submit();
	}
	
	function fnSetSearchData(){
	    var _tempFrm = $("#_tempFrm");
	    $("#isPs").val(_tempFrm.children("[name=isPs]").val());
	    $("#startDate").val(_tempFrm.children("[name=startDate]").val());
	    $("#endDate").val(_tempFrm.children("[name=endDate]").val());
	    $("#status").val(_tempFrm.children("[name=status]").val());
	    $("#bizNm").val(_tempFrm.children("[name=bizNm]").val());
	    
	    // 최근순/공감순/조회순
	    var sortItem = _tempFrm.children("[name=sortItem]").val();
        if(sortItem == 1) {
        	$("#sort1").addClass("on");
        } else if(sortItem == 2) {
        	$("#sort2").addClass("on");
        } else {
        	$("#sort0").addClass("on");
        }

        // 전체/상시/공모 tab
	    var isPs = _tempFrm.children("[name=isPs]").val();
	    if(isPs == "Y"){
	    	$("#tabPs3").addClass("on");
	    } else if(isPs == "N"){
	    	$("#tabPs2").addClass("on");
	    } else {
	    	$("#tabPs1").addClass("on");
	    }
	    
	    if($("#myProposal").val() == "Y") {
	    	$("#checkMyProposal").addClass("on");
	    } 
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
	    $("#_tempFrm").prop("action", "<c:url value="/proposal/complete-list" />").submit();
	}
	
	function fnMoveDetail(propSeq) {
		$('#_tempFrm').prop('method', 'post');
	    $('#_tempFrm').prop('action', '/proposal/complete-detail/' + propSeq).submit();
	}
	
	function fnWriteForm() {
		$('#_tempFrm').prop('method', 'post');
	    $('#_tempFrm').prop('action', '<c:url value="/proposal/write" />').submit();
	}
	
	
	
	
	
//]]>
</script>
</head>
<body>

<!-- header -->
<jsp:include page="/WEB-INF/views/front/common/header.jsp"/>
<!-- //header -->

<div class="location">
	<p>
		<a href="#"><img src="${siteImgPath}/common/locationHome.png" alt="홈"/></a>
		<span>주민참여예산제</span>
		<span>정책제안</span>
	</p>
</div>

<div id="container" class="container">
	<div class="containerWrap">

		<!-- LNB -->
		<jsp:include page="/WEB-INF/views/front/common/lnb.jsp">
			<jsp:param name="menuName" value="proposal"/>
		</jsp:include>
		<!-- //LNB -->
		
		<div class="contentsWrap">
			<h3 class="contentTit">제안사업</h3>

			<ul class="conTab">
				<li><a href="#" id="tabPs1" onclick="fnMovePsType(1); return false;">전체</a></li>
				<li><a href="#" id="tabPs2" onclick="fnMovePsType(2); return false;">상시</a></li>
				<li><a href="#" id="tabPs3" onclick="fnMovePsType(3); return false;">공모</a></li>
			</ul>
			<div class="contents">
				<form name="searchFrm" id="searchFrm" method="post" action="" class="searchTb">
					<fieldset id="" class="">
							<table cellpadding="0" cellspacing="0" class="" summary="" >
								<colgroup>
									<col width="105"/><col width="258"/>
									<col width="120"/><col width="*"/>
								</colgroup>
								<tbody>
									<tr>
										<td colspan="2" class="bln">
											<a id="checkMyProposal" href="#" class="chk">내 제안 보기</a>
										</td>
										<th scope="row">검토결과</th>
										<td>
					                        <select id="reviewResult" name="reviewResult" style="width:231px;">
					                            <option value="">전체</option>
					                            <option value="Y">적합</option>
					                            <option value="N">부적합</option>
					                        </select>
					                        <script>$("#reviewResult").val("${params.reviewResult}");</script>
										</td>
									</tr>
									<tr>
										<th scope="row" class="bln">제목</th>
										<td colspan="3">
											<input type="text" class="it " name="bizNm" id="bizNm" style="width: 510px;"/>
											<a href="#" class="btn_blue" onclick="fnSearch(); return false;">검색</a>
										</td>
									</tr>
								</tbody>
							</table>
							<script language="javascript" type="text/javascript">
							//<![CDATA[
								$('.searchTb').find('.chk').on('click',function(){
									if ($(this).hasClass('on')){
										$(this).removeClass('on');
									}else{
										$(this).addClass('on');
									}
									return false;
								})
							//]]>
							</script>
							
					</fieldset>
					<input type="hidden" id="sortItem" name="sortItem"/>
					<input type="hidden" id="isPs" name="isPs" value="${param.isPs}" />
					<input type="hidden" id="myProposal" name="myProposal" value="${params.myProposal}" />
				</form>

				<div class="sort">
					<p>
						<a href="#" id="sort0" onclick="fnSearch(''); return false;">최근순</a>
						<a href="#" id="sort1" onclick="fnSearch(1); return false;">공감순</a>
						<a href="#" id="sort2" onclick="fnSearch(2); return false;">조회순</a>
					</p>
					<p class="sNum">총 <c:out value="${pagingHelper.totalCnt}"/> 건</p>
				</div>

				<div class="offer">
					
					<ul class="">
					
						<c:forEach items="${proposalList}" var="item" varStatus="status">
							
							<c:choose>
								<c:when test="${status.index % 2 == 0}"><c:set var="tmpClassName" value=""/></c:when>
								<c:otherwise><c:set var="tmpClassName" value="fR"/></c:otherwise>
							</c:choose>
							
							<li class="${tmpClassName}">
								<a href="#" class="title" onclick="fnMoveDetail(${item.propSeq}); return false;"><c:out value="${item.bizNm }" /></a>
								<p class="date"><c:out value="${item.regDateText }" />  | 조회수 <fmt:formatNumber value="${item.readCnt }" pattern="#,###" /></p>
								<p class="click">
									<c:set var="symYnClass">ok <c:if test="${item.symYn eq 'Y'}">on</c:if></c:set>
									<a href="#" class="${symYnClass}"><fmt:formatNumber value="${item.symCnt }" pattern="#,###" /></a>
									<a href="#" class="reply"><fmt:formatNumber value="${item.commentCnt }" pattern="#,###" /></a>
								</p>
							</li>
						
						</c:forEach>
						
						<c:if test="${empty proposalList}">
						<!--20160818추가-->
						<div class="noReseult" style="font-size:30px; font-weight:bold; color:#B0B0B0; text-align:center; width:100%; min-height:300px; padding-top:100px;">
							조회된 데이터가 없습니다.
						</div>
						<!--20160818추가:e-->
						</c:if>
				
					</ul>
				</div>

				<div class="btnC2">
					<a href="#" class="btn_blue2img" onclick="fnWriteForm(); return false;"><img src="${siteImgPath}/ehimg/c3_bluebtn2bg.png" alt="내 정책 제안하기"/>내 정책 제안하기</a>
				</div>

				<jsp:include page="/WEB-INF/views/front/common/paging.jsp">
					<jsp:param name="formId" value="_tempFrm"/>
					<jsp:param name="action" value="/proposal/complete-list"/>
				</jsp:include>
				
				<jsp:include page="/WEB-INF/views/front/proposal/proposal-search-form.jsp" />

			</div>
		</div>
	</div>
</div>

<!-- footer -->
<jsp:include page="/WEB-INF/views/front/common/footer.jsp"/>
<!-- //footer -->

</body>
</html>
