<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>

<!-- meta -->
<jsp:include page="/WEB-INF/views/admin/common/meta.jsp" />
<!-- //meta -->
<style>  
.mytable { border-collapse:collapse; }  
.mytable th, .mytable td { border:1px solid black; }
</style>
<script langauge="javascript">
/**
 * replaceAll
 * @param arg0 : 문자열
 * @param arg1 : 치환할 문자
 * @param arg2 : 치환될 문자
 */
function replaceAll(arg0, arg1, arg2){	
	return arg0.split(arg1).join(arg2);
}

$(document).ready(function(){
	$( "#start_date, #end_date" ).datepicker({
	    dateFormat: 'yy.mm.dd',
	    prevText: '이전 달',
	    nextText: '다음 달',
	    monthNames: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
	    monthNamesShort: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
	    dayNames: ['일','월','화','수','목','금','토'],
	    dayNamesShort: ['일','월','화','수','목','금','토'],
	    dayNamesMin: ['일','월','화','수','목','금','토'],
	    showMonthAfterYear: true,
	    changeMonth: true,
	    changeYear: true,
	    yearSuffix: '년'
	  });
	
	//날짜버튼 포커스
	$('#img_sd').click(function(event) {
		$('#start_date').datepicker().focus();
	});
	$('#img_ed').click(function(event) {
		$('#end_date').datepicker().focus();
	});
	
	//취소버튼
	$("#btn_cancel").on("click", function(e) {
		e.preventDefault();
		//입력된 내용이 저장되지 않습니다. 목록으로 이동하겠습니까?
		if(confirm('<spring:message code="message.admin.vote.007"/>')){
			$('#form').attr('action', "/admin/vote/vote_list").submit();		
		}
	});
	
	var dateStr = '';
	for(var i = 0; i <= 23; i++) {
		dateStr = (i < 10) ? '0' + i : i;
		$('#start_hour, #end_hour').append('<option value="' + dateStr + '">' + dateStr + '</option>');
	}

	$("#start_hour").val('09').prop("selected", "selected");
	$("#end_hour").val('18').prop("selected", "selected");
	
	//숫자만 입력되게 수정
	$('.OnlyNumber').keypress(function(event) {
	    if(event.which && (event.which < 48 || event.which > 57) && event.which != 8) {
	        event.preventDefault();
	    }
	}).keyup(function(){
	    if( $(this).val() != null && $(this).val() != '' ) {
	        $(this).val( $(this).val().replace(/[^0-9]/g, '') );
	    }
	});
	
	$("#btn_reg").on("click", function(e) {
		e.preventDefault();
		var title = $("#title").val();
		if( gfnValidation( $("#title"), '<spring:message code="message.admin.common.001" arguments="투표제목을"/>' ) == false ){ return; }			
		if( gfnValidation( $("#start_date"), '<spring:message code="message.admin.common.002" arguments="투표진행 시작일을"/>' ) == false ){ return; }			
		if( gfnValidation( $("#end_date"), '<spring:message code="message.admin.common.002" arguments="투표진행 종료일을"/>' ) == false ){ return; }						
		var start_date = replaceAll($("#start_date").val(),"-","" )+$("#start_hour").val();
    	var end_date = replaceAll($("#end_date").val(),"-","" )+$("#end_hour").val();	
		if(start_date >= end_date){	
			 //투표종료일이 투표시작일보다 과거 일시로 설정되어 저장할 수 없습니다
			 alert('<spring:message code="message.admin.vote.004"/>');
			 $("#end_date").focus();
			return;
		}		
		if( gfnValidation( $("#target_text"), '<spring:message code="message.admin.common.001" arguments="투표대상자를"/>' ) == false ){ return; }		
		if( gfnValidation( $("#vote_info"), '<spring:message code="message.admin.common.001" arguments="투표정보를"/>' ) == false ){ return; }		
		if( gfnValidation( $("#vote_result"), '<spring:message code="message.admin.common.001" arguments="투표결과를"/>' ) == false ){ return; }	
		$('#form').attr('action', "/admin/vote/voteReg").submit();		
	});

});


/**
 * textarea 글자 제한
 */
function checkmaxlength(obj, msg){	
	var mlength=obj.getAttribute? parseInt(obj.getAttribute("maxlength")) : "";
	if (obj.getAttribute && obj.value.length>=mlength) {		
		alert(msg);
		obj.value=obj.value.substring(0,mlength);		
	}
}



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
				<li>투표관리</li>
			</ul>
		</div>
		<div class="container">
			<div class="contentWrap">
				<!--leftmenu-->
				<jsp:include page="/WEB-INF/views/admin/common/lnb.jsp" />				
				<!-- //leftmenu-->

				<div class="content">
					<h3 class="contentTit">${voteInfo.title} > 사업수정</h3>
					<div class="contents">
					<form id="form" name="form" method="post" action="/admin/vote/voteMod">
						
						<div class="boardWrite">
							<table cellpadding="0" cellspacing="0" class="tbL">
								<caption>투표 수정 상세보기</caption>
								<colgroup>
									<col width="15%"/>
									<col width="*"/>
									<col width="15%"/>
									<col width="15%"/>
								</colgroup>
								<tbody>
									<tr>
										<th scope="row">투표 진행 방식</th>
										<td colspan="3">
											<input type="hidden" id="vote_type" name="vote_type" value="${vote_type}"/>
											<c:if test ="${vote_type eq 'ALL'}">일괄 투표</c:if>
						   					<c:if test ="${vote_type eq 'PART'}">분야별 투표</c:if>
										</td>
									</tr>
									<tr>
										<th scope="row">투표제목</th>
										<td colspan="3">
											<textarea rows="" cols="100" id="title" name="title" maxlength="30"></textarea>
											<span class="red">30자 입력제한</span>
										</td>
									</tr>
									<tr>
										<th scope="row">투표 진행 일시</th>
										<td colspan="3">
											<label for="start_date" class="hidden">시작기간 입력하기</label>
											<input type="text" class="it wid125" id="start_date" name="start_date" value="${start_date}" readOnly/><img src="${siteImgPath}/common/icon_cal.gif" id="img_sd" alt="시작기간 선택"/> 										
											<select  id="start_hour" name="start_hour"></select>시 ~ 
											<label for="end_date" class="hidden">종료기간 입력하기</label>
											<input type="text" class="it wid125" id="end_date" name="end_date" value="${end_date}" readOnly/><img src="${siteImgPath}/common/icon_cal.gif" id="img_ed" alt="종료기간 선택"/>																	
											<select  id="end_hour" name="end_hour"></select>시
										</td>
									</tr>
									<tr>
										<th scope="row">투표 대상</th>
										<td>
											<input type="radio" id="target1" name="target" value="ALL" checked/><label for="target1">전체</label>
											<input type="radio" id="target2" name="target" value="YOUNG" /><label for="target2">청소년</label>
 											<input type="radio" id="target3" name="target" value="ADULT" /><label for="target3">성인</label>
										</td>
										<th scope="row">투표 대상자</th>
										<td>
											<input type="text" class="it wid125" id="target_text" name="target_text" maxlength="100"/>
										</td>
									</tr>
									<tr>
									
										<th scope="row">득표 현황 출력</th>
										<td colspan="3">
											<input type="radio" id="result_dp_yn_y" name="result_dp_yn" value="Y" checked /><label for="result_dp_yn_y">노출</label>
											<input type="radio" id="result_dp_yn_n" name="result_dp_yn" value="N" /><label for="result_dp_yn_n">비노출</label>
		     								<p class="upload">
		     								<span class="red2">* 비노출을 선택할 경우 진행중인 투표의 사업별 득표율이 표시되지 않습니다.</span>
		     								</p>
		     								
										</td>
									</tr>
									<tr>
										<th scope="row">투표정보</th>
										<td style="border-right-style: none;" colspan="3">
											<div class="writeW">
												<textarea cols="10" rows="10" title="투표정보 입력" class="wid100" id="vote_info" name="vote_info" maxlength="2000" onkeyup="return checkmaxlength(this,'최대 2000자까지 입력가능합니다.');" ></textarea>
											</div>
											<span class="red2">최대 2000자까지 입력가능</span>
										</td>
									</tr>
									<tr>
										<th scope="row">투표결과</th>
										<td style="border-right-style: none;" colspan="3">
											<div class="writeW">
												<textarea cols="10" rows="10" title="투표결과 입력" class="wid100"  id="vote_result" name="vote_result" maxlength="2000" onkeyup="return checkmaxlength(this,'최대 2000자까지 입력가능합니다.');"></textarea>
											</div>
											<span class="red2">최대 2000자까지 입력가능</span>
										</td>
									</tr>									
								</tbody>
							</table>
						</div>
						</form>
						<div class="btnR">
							<a href="#" class="btn_blue" id="btn_reg">등록하기</a>
							<a href="#" class="btn_reset" id="btn_cancel">취소</a>
						</div>
					</div>
				</div><!--content-->
			</div><!--contentWrap-->

		</div><!--container-->
	</div><!--containerWrap-->
	<!-- footer --> 
	<jsp:include page="/WEB-INF/views/admin/common/footer.jsp" />
	<!-- //footer -->

</body>
</html>