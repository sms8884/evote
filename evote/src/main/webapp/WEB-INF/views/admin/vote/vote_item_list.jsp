<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>

<!-- meta -->
<jsp:include page="/WEB-INF/views/admin/common/meta.jsp" />
<!-- //meta -->

<link href="${siteCssPath}/eh.css" type="text/css" rel="stylesheet"  />
<script src="${siteJsPath}/jquery.tablednd.js" language="javascript" type="text/javascript" charset="utf-8"></script>

<style>  
.mytable { border-collapse:collapse; }  
.mytable th, .mytable td { border:1px solid black; }

div.loginMbtLayer					{ padding:0 17px 16px; border:2px solid #000; }
div.loginMbtLayer p.tit				{ height:81px; line-height:81px; border-bottom:1px solid #e7e7e7; font-size:25px; font-weight:bold; text-align:center; }
div.loginMbtLayer1					{ padding:0 17px 16px; border:2px solid #000; }
div.loginMbtLayer1 p.tit			{ height:81px; line-height:81px; border-bottom:1px solid #e7e7e7; font-size:25px; font-weight:bold; text-align:center; }
div.loginMbtLayerCon				{ position:relative; }
div.loginMbtLayerCon p.txt1			{ text-align:center; font-size:18px; font-weight:bold; }
div.loginMbtLayerCon p.txt2			{ text-align:center; font-size:24px; color:#1278e1; padding:15px 0 30px; font-weight:bold; }
div.loginMbtLayerCon p.txt3			{ text-align:center; font-size:18px; padding:15px 0 30px; font-weight:bold; }
div.loginMbtLayerCon p.inptxt		{ width:100%; height:60px; font-size:18px; padding:15px 0 30px;}
div.loginMbtLayerCon .widinputxt	{ width:99%; height:60px; font-size:18px; }
div.loginMbtLayerCon a.bt			{ width:100%; height:60px; display:block; background:#1278e1; text-align:center; }
div.loginMbtLayerCon a.bt:hover		{ background:#393d4c; }
div.loginMbtLayerCon a.bt span		{ display:inline-block; height:60px; line-height:60px; color:#fff; font-size:18px; padding:0 0 0 25px; background:url(${siteImgPath}/btn_sel.png) 0 46% no-repeat; }
div.loginMbtLayerCon a.btW1			{ width:49%; height:56px; display:inline-block; background:#fff; text-align:center; border:2px solid #343434 }
div.loginMbtLayerCon a.btW1:hover	{ background:#f5f5f5; }
div.loginMbtLayerCon a.btW1 span	{ display:inline-block; height:60px; line-height:60px; font-size:18px;  }
div.loginMbtLayerCon a.btC1			{ width:49%; height:60px; display:inline-block; background:#1278e1; text-align:center; }
div.loginMbtLayerCon a.btC1:hover	{ background:#393d4c; }
div.loginMbtLayerCon a.btC1 span	{ display:inline-block; height:60px; line-height:60px; color:#fff; font-size:18px; padding:0 0 0 25px; background:url(${siteImgPath}/btn_sel.png) 0 46% no-repeat; }
div.loginMbtLayerCon a.layerClose	{ position:absolute; top:-76px; right:-10px; display:inline-block; padding:10px; }
</style>
<script langauge="javascript">

//검색
function searchData(){
	$('#form').attr('action', "/admin/vote/vote_item_list").submit();		
}

//투표등록
function registerData(){
	$('#form').attr('action', "/admin/vote/vote_item_reg_form").submit();		
}

//투표수정
function modifyData(id){
	$("#biz_seq").val(id);
	$('#form').attr('action', "/admin/vote/vote_item_mod_form").submit();		
}

//투표삭제
function deleteData(id){
	$("#biz_seq").val(id);
	$('#form').attr('action', "/admin/vote/delVoteItem").submit();		
}

<c:if test="${empty param.search_realm_cd or param.search_realm_cd eq 'ALL'}">
$(function() {
	$("#voteTable").tableDnD({
		onDragClass: "dragRow"
	});	
});

function modifyVoteOrder() {
	var itemList = [];
	$("#voteTable").find("tr").find("td:first").each(function(idx) {
		var biz_seq = $(this).find("input:first").val();
		var dp_ord = idx + 1;
		var voteItem = {'biz_seq':biz_seq,'dp_ord':dp_ord};
		itemList.push(voteItem);
	});
	
	$.ajax({
		type : "POST",
		url : "/admin/vote/modify-vote-order",
		data: JSON.stringify(itemList),
		contentType: "application/json; charset=utf-8",
		success : function(data) {
			if(data == true) {
				location.reload();
			}
		},
		error : function(error) {
			console.log(error);
		}
	});

}
</c:if>

<%--
function openLayer() {
	var layer = $("#excelLayer");
	layer.fadeIn().css({ 'width': 400 });
	layer.css({
		'margin-top' : -(layer.height() / 2),
		'margin-left' : -(layer.width() / 2)
	});
	$('body').append('<div class="fade"></div>');
	$('.fade').css({'filter' : 'alpha(opacity=80)'}).fadeIn();
	return false;		
}

function closeLayer() {
	$('.fade, .layer_block').fadeOut(function(){
		$('.fade').remove();
	});
}

function uploadExcelData() {
	$('#excelForm').attr('action', "/admin/vote/item/excel-upload").submit();
}
--%>
</script>
</head>
<body>

	<!-- header -->
	<jsp:include page="/WEB-INF/views/admin/common/header.jsp" />
	<!-- //header -->
	<div class="containerWrap">
		<div class="subNav">
			<ul class="subNavUl">
				<li class="subNavHome"><img src="${siteImgPath}/common/home.png" alt="home"/></li>
				<li><a href="/admin/vote/vote_list">투표</a></li>	
				<li>사업관리</li>
			</ul>
		</div>

		<div class="container">
			<div class="contentWrap">
			<jsp:include page="/WEB-INF/views/admin/common/lnb.jsp" />				
				<div class="content">
					<h3 class="contentTit">${voteInfo.title} > 투표대상사업목록</h3>
					
					<div class="mainContent">	
						<form id="form" name="form" method="post" class="searchTb">
						<input type="hidden" id="vote_seq" name="vote_seq" value="${voteInfo.vote_seq}"/>
						<input type="hidden" id="biz_seq" name="biz_seq"/>
						
							<fieldset id="" class="">
								<table cellpadding="0" cellspacing="0" class="" summary="" >
									<caption></caption>
									<colgroup>
										<col width="105"/><col width="*"/>
										<col width="105"/><col width="151"/>
									</colgroup>
									<tbody>
										<tr>
											<th scope="row" class="bln">검색</th>
											<td colspan="3">
												<select id="search_realm_cd" name="search_realm_cd">
													<option value="">==  분야  ==</option>
													<c:if test="${!empty voteRealmList}">
														<c:forEach var="realm" items="${voteRealmList}" varStatus="status" >
															<option value="${realm.realm_cd}" <c:if test="${realm.realm_cd == param.search_realm_cd}">selected="selected"</c:if> >${realm.realm_nm}</option>
														</c:forEach>
													</c:if>		
												</select>
												<label for="con" class="hidden">검색내용 입력하기</label><input type="text" id="seach_string" name="seach_string" value="${param.seach_string}" class="it wid461" title=""/>
											</td>
										</tr>
									</tbody>
								</table>
								<div class="btnC">
									<a href="javascript:searchData();" class="btn_blue">검색</a>
								</div>
							</fieldset>
						</form>
						<div class="ResultBox">
							<p>총 ${totalRecord} 건이 검색되었습니다.</p>
							<c:choose>
								<c:when test="${empty param.search_realm_cd or param.search_realm_cd eq 'ALL'}">
									<a href="javascript:modifyVoteOrder();" class="btn_blue" style="float: left;">순서저장</a>
								</c:when>
								<c:otherwise>
									<p style="float: left;">순서 조정은 전체 목록에서만 가능합니다.</p>
								</c:otherwise>
							</c:choose>
<%--
							<a href="#" onclick="openLayer(); return false;" class="btn_blue">일괄등록</a>
--%>
							<a href="#" onclick="registerData(); return false;" class="btn_blue">신규등록</a>
							<a href="/admin/vote/vote_list" class="btn_reset">목록보기</a>
							
						</div>
					
						<div class="boardView voteBoard">
							<table id="voteTable" cellpadding="0" cellspacing="0" class="tbL" summary="공모관리의 선택, 번호, 제목, 공모기간, 등록일을 알 수 있는 표입니다." >
								<caption>투표관리</caption>
								<colgroup>
									<col width="10%"/>
									<col width="40%"/>
									<col width="25%"/>
									<col width="25%"/>
								</colgroup>
								<thead>
									<th scope="col">연번</th>
									<th scope="col">제목</th>
									<th scope="col">분야</th>
									<th scope="col">투표관리</th>
								</thead>
								<tbody>
								<c:if test="${!empty voteItemList}">
									<c:forEach var="item" items="${voteItemList}" varStatus="status" >
									<tr>
										<td>${item.dp_ord}<input type="hidden" value="${item.biz_seq}"/></td>
										<td><a href="javascript:modifyData('${item.biz_seq}')">${item.biz_nm}</a></td> 	
										<td>${item.realm_nm}</td>																									
										<td> 
											<div class="btn_reset2box">
												<input class="btn_reset2" type="button" value="수정" onclick="javascript:modifyData('${item.biz_seq}');" />
											</div>	
											<div class="btn_gray2box">
												<input class="btn_gray2" type="button" value="삭제" onclick="javascript:deleteData('${item.biz_seq}');" />
											</div>										
										</td>
									</tr>
									</c:forEach>
								</c:if>
									<c:if test="${empty voteItemList}">
										<tr>
											<td colspan="4" align="center">목록이 없습니다.</td>
										</tr>
									</c:if>		
								</tbody>
							</table>
						</div>
					</div>
				</div>
			</div><!--contentWrap-->
		</div><!--container-->
	</div><!--containerWrap-->
	
<%-- 
	<div id="excelLayer" class="loginMbtLayer layer_block">
		<p class="tit">엑셀파일 일괄등록</p>
		<div class="loginMbtLayerCon">
			<p class="pwchangeBox">
				
				<form id="excelForm" method="POST" enctype="multipart/form-data">
					<div class='fileBox' style="padding-bottom: 15px;">
						<input type='button' class='filebutton' value='첨부'/> 
						<input type='file' class='fileupload' name='excelFile' onchange='$(this).next().val($(this).val());'/> 
						<input type='text' class='textbox' readonly='readonly'/> 
					</div>
					<input type="hidden" name="vote_seq" value="${voteInfo.vote_seq}"/>
				</form>
				
			</p>
			<a href="#" onclick="closeLayer(); return false;" class="btW1"><span>취소</span></a>
			<a href="#" onclick="uploadExcelData(); return false;" class="btC1"><span>확인</span></a>
			<a href="#" onclick="closeLayer(); return false;" class="layerClose"><img src="${siteImgPath}/common/layerClose.png" alt="닫기"/></a>
		</div>
	</div>
--%>
	
	<!-- footer --> 
	<jsp:include page="/WEB-INF/views/admin/common/footer.jsp" />
	<!-- //footer -->

</body>
</html>