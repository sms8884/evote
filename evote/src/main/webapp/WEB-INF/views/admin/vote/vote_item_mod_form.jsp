<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>
<!-- meta -->
<jsp:include page="/WEB-INF/views/admin/common/meta.jsp" />
<!-- //meta -->

<script type="text/javascript" src="<c:url value="/resources/library/form/jquery.MultiFile.js" />"></script>

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
	
	
	
	//취소버튼
	$("#btn_cancel").on("click", function(e) {
		e.preventDefault();
		//입력된 내용이 저장되지 않습니다. 목록으로 이동하겠습니까?
		if(confirm('<spring:message code="message.admin.vote.007"/>')){
			$('#form').attr('action', "/admin/vote/vote_item_list").submit();		
		}
	});
	
	//수정버튼
	$("#btn_reg").on("click", function(e) {
		e.preventDefault();
		
		if( gfnValidation( $("#biz_nm"), '<spring:message code="message.admin.common.001" arguments="사업명을"/>' ) == false ){ return; }
		if( gfnValidation( $("#budget"), '<spring:message code="message.admin.common.001" arguments="소요예산을"/>' ) == false ){ return; }
		if( gfnValidation( $("#start_date"), '<spring:message code="message.admin.common.001" arguments="사업시작일을"/>' ) == false ){ return; }
		if( gfnValidation( $("#end_date"), '<spring:message code="message.admin.common.001" arguments="사업종료일을"/>' ) == false ){ return; }		
		
		if(replaceAll($("#start_date").val(),".","" ) >= replaceAll($("#end_date").val(),".","" )){	
			 //투표종료일이 투표시작일보다 과거 일시로 설정되어 저장할 수 없습니다
			 alert('<spring:message code="message.admin.vote.004"/>');
			 $("#end_date").focus();
			return;
		}
		//if( gfnValidation( $("#location"), '<spring:message code="message.admin.common.001" arguments="사업위치를"/>' ) == false ){ return; }		
		//if( gfnValidation( $("#necessity"), '<spring:message code="message.admin.common.001" arguments="제안취지를"/>' ) == false ){ return; }
		//if( gfnValidation( $("#biz_cont"), '<spring:message code="message.admin.common.001" arguments="내용을"/>' ) == false ){ return; }
		//if( gfnValidation( $("#effect"), '<spring:message code="message.admin.common.001" arguments="기대효과를"/>' ) == false ){ return; }		
		
		$('#form').attr('action', "/admin/vote/voteItemMod").submit();		
	});

		
	//첨부파일	
	$('#attach_file').MultiFile({ 	
		max: 1, 
		accept: 'hwp', 
		maxfile: 2097152, 
		preview: false,
		previewCss: 'max-height:100px; max-width:100px;',	
		STRING: {
			remove: 'X',
			denied: 'hwp형식의 파일만 등록이 가능합니다. 등록파일 확장자 : $ext',
			duplicate: '같은 파일을 선택하셨습니다.\n등록파일 : $file',
			toomuch: '업로드파일은 10MB를 넘을수 없습니다. ($size)',
			toomany: '한개의 파일만 등록 가능합니다. (max: $max)',
			toobig: '업로드파일은 10MB를 넘을수 없습니다. (max $size)'
		}
	});
	//이미지파일
	$('#image_file').MultiFile({ 
		max: 1, 
		accept: 'gif|jpg|png|jpeg',
		maxfile: 2097152,	
		preview: true,
		previewCss: 'max-height:100px; max-width:100px;',	
		STRING: {
			remove: 'X',
			denied: 'jpg, png, gif형식의 이미지만 등록이 가능합니다. 등록파일 확장자 : $ext',
			duplicate: '같은 파일을 선택하셨습니다.\n등록파일 : $file',
			toomuch: '업로드파일은 10MB를 넘을수 없습니다. ($size)',
			toomany: '한개의 파일만 등록 가능합니다. (max: $max)',
			toobig: '업로드파일은 10MB를 넘을수 없습니다. (max $size)'
		}
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

//동 선택시 위치에 해당 동 이름 가기
function sel_dong() {
    var dong = $("#sel_location").val();
   $("#location").val(dong);
}

//파일 삭제
function fileDelete(seq, obj){		
	$.ajax({
		type : "POST",
		url : "/admin/vote/file-delete/"+seq ,			
		success : function(data) {
			if(data == true) {
			    var tr = $(obj).parent().parent();			    			 
			    tr.focus();
			    tr.remove();
			    //파일이 삭제되었습니다.			    
			    alert('<spring:message code="message.admin.vote.019"/>');		    
			}else{
				//파일 삭제에 실패하였습니다.
				alert('<spring:message code="message.admin.vote.020"/>')
			}
		},
		error : function(error) {
			alert('<spring:message code="message.admin.vote.020"/>')
			console.log('<spring:message code="message.admin.vote.020"/>');
		}
	});
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
				<li>사업관리</li>
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
						<form id="form" name="form" method="post" enctype="multipart/form-data">
						<input type="hidden" id="vote_seq" name="vote_seq" value="${voteInfo.vote_seq}"/>
						<input type="hidden" id="biz_seq" name="biz_seq" value="${VoteItemInfo.biz_seq}"/>
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
										<th scope="row">참여분야</th>
										<td colspan="3">
											<select id="realm_cd" name="realm_cd" style="width:140px;">
												<option value="">==  분야  ==</option>
												<c:if test="${!empty voteRealmList}">
													<c:forEach var="realm" items="${voteRealmList}" varStatus="status" >
														<option value="${realm.realm_cd}"<c:if test="${realm.realm_cd == VoteItemInfo.realm_cd}">selected="selected"</c:if>>${realm.realm_nm}</option>
													</c:forEach>
												</c:if>		
											</select>										
										</td>
									</tr>
									<tr>
										<th scope="row">사업명</th>
										<td colspan="3">
											<input type="text" class="it wid498" id="biz_nm" name="biz_nm" maxlength="40" value="${VoteItemInfo.biz_nm}">
											<span class="red">40자 입력제한</span>
										</td>
									</tr>
									<tr>
										<th scope="row">소요예산</th>
										<td colspan="3">
											<input type="text" class="it wid125" id="budget" name="budget" maxlength="20" value="${VoteItemInfo.budget}"><span class="red">20자 입력제한</span>										
										</td>
									</tr>
									<tr>
										<th scope="row">사업기간</th>
										<td colspan="3">
											<label for="start_date" class="hidden">시작기간 입력하기</label>
											<fmt:parseDate value="${VoteItemInfo.start_date}" var="sdateFmt" pattern="yyyyMMdd"/>
											<fmt:formatDate value="${sdateFmt}" pattern="yyyy.MM.dd" var="sDate" /> 
											<input type="text" class="it wid125"  id="start_date" name="start_date" value="${sDate}" readOnly/><img src="${siteImgPath}/common/icon_cal.gif" id="img_sd"/> ~											
											<label for="end_date" class="hidden">종료기간 입력하기</label>
											<fmt:parseDate value="${VoteItemInfo.end_date}" var="edateFmt" pattern="yyyyMMdd" />
											<fmt:formatDate value="${edateFmt}" pattern="yyyy.MM.dd" var="eDate"/>		
											<input type="text" class="it wid125" id="end_date" name="end_date" value="${eDate}" readOnly/><img src="${siteImgPath}/common/icon_cal.gif" id="img_ed"/>																	
										</td>
									</tr>
									<tr>
										<th scope="row">사업위치</th>
										<td colspan="3">
											<select id="sel_location" name="sel_location" onchange="sel_dong();" style="width:140px;">
												<option value="">직접입력</option>
												<c:if test="${!empty dongList}">
													<c:forEach var="dong" items="${dongList}" varStatus="status" >
														<option value="${dong.emdNm}">${dong.emdNm}</option>
													</c:forEach>
												</c:if>			
											</select>		
											<input type="text" class="it wid125" id="location" name="location" maxlength="100" value="${VoteItemInfo.location}">		
										</td>
									</tr>
									<tr>
										<th scope="row">제안취지</th>
										<td style="border-right-style: none;" colspan="3">
											<div class="writeW">
												<textarea cols="10" rows="10" title="제안취지 입력" class="wid100" id="necessity" name="necessity" maxlength="2000" onkeyup="return checkmaxlength(this,'최대 2000자까지 입력가능합니다.');" >${VoteItemInfo.necessity}</textarea>
											</div>
											<span class="red2">최대 2000자까지 입력가능</span>
										</td>
									</tr>
									<tr>
										<th scope="row">내용</th>
										<td style="border-right-style: none;" colspan="3">
											<div class="writeW">
												<textarea cols="10" rows="10" title="내용입력" class="wid100" id="biz_cont" name="biz_cont" maxlength="2000" onkeyup="return checkmaxlength(this,'최대 2000자까지 입력가능합니다.');">${VoteItemInfo.biz_cont}</textarea>
											</div>
											<span class="red2">최대 2000자까지 입력가능</span>
										</td>
									</tr>
									<tr>
										<th scope="row">기대효과</th>
										<td style="border-right-style: none;" colspan="3">
											<div class="writeW">
												<textarea cols="10" rows="10" title="기대효과 입력" class="wid100" id="effect" name="effect" maxlength="2000" onkeyup="return checkmaxlength(this,'최대 2000자까지 입력가능합니다.');" >${VoteItemInfo.effect}</textarea>
											</div>
											<span class="red2">최대 2000자까지 입력가능</span>
										</td>
									</tr>
									<tr>
										<th scope="row" rowspan="2">사진</th>
										<td colspan="3" style="border-right-style: none;">									
											<div class="fileBox">
											   <input type="button" class="filebutton" value="첨부"/>										   
											   <input type="file" class="fileupload" name="image_file" id="image_file" />
											   	<p class="upload">
													<span class="red2">※ gif, jpg, jpeg, png형식의 이미지 파일만 첨부 가능합니다.</span>
													<span class="red2">※ 1개의 파일을 첨부할 수 있습니다.(파일 용량제한: 2MB)</span>
												</p>
											</div>											
										</td>
									</tr>
									<tr>
										<td colspan="4" style="border-right-style: none;">
										<c:if test="${!empty image_file}">
										 <c:forEach items="${image_file}" var="image" varStatus="status">
											 <div class="photoD">
												<dl class="photo1">														
													<dd>
														<a href="/file-download/${image.fileSeq }"><img src="/file-download/${image.fileSeq}" alt="이미지" style="width:142px; height:100px;"/></a>
														<a href="#" onclick="javascript:fileDelete('${image.fileSeq}', this );return false;" class="btn_gray">삭제하기</a>
													</dd>
												</dl>
											</div>
								          </c:forEach>		
								          </c:if>									
										</td>
									</tr>
									<tr>
										<th scope="row" rowspan="2">첨부파일</th>
										<td colspan="3" style="border-right-style: none;">
											<div class="fileBox">
												<input type="button" class="filebutton" value="첨부"/>										
												<input type="file" class="fileupload" name="attach_file" id="attach_file" />											
													<p class="upload">
													<span class="red2">※ 한글파일(hwp 파일)만 등록이 가능합니다.</span>
													<span class="red2">※ 최대	 1개의 파일을 첨부할 수 있습니다. (파일 용량제한: 2MB)</span>
												</p>
											</div>
										</td>
									</tr>
									<tr>
										<td colspan="4" style="border-right-style: none;">
										<c:if test="${!empty attach_file}">
										   <c:forEach items="${attach_file}" var="attach" varStatus="status">
												<em><a href='/file-download/${attach.fileSeq}'>${attach.fileSrcNm}</a></em>																								
												<a href="#" onclick="javascript:fileDelete('${attach.fileSeq}', this);return false;" class="btn_gray">삭제하기</a>												
									        </c:forEach>
								        </c:if>
										</td>
									</tr>
								</tbody>
							</table>
						</div>
						</form>
						<div class="btnR">
							<a href="#" class="btn_blue" id="btn_reg">수정하기</a>
							<a href="#" class="btn_reset" id="btn_cancel">목록보기</a>
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