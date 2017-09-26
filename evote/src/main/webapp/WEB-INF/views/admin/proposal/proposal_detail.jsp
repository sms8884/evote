<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>
<!-- meta -->
<jsp:include page="/WEB-INF/views/admin/common/meta.jsp" />
<!-- //meta -->

<script type="text/javascript" src="<c:url value="/resources/library/form/jquery.MultiFile.js" />"></script>

<title> 은평구 참여예산 정책제안 </title>
<meta http-equiv="X-UA-Compatible" content="IE=edge"/>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />

<style type="text/css">
._white-space {
    white-space: pre-wrap;
}
</style>

<script type="text/javascript">
$(document).ready(function(){	
	//첨부파일	
	var attachFilemax = 3 - "${attachFileList.size()}";
	$('#attachFile').MultiFile({ 	
		max: attachFilemax, 
		accept: 'hwp', 
		maxfile: 2097152, 
		preview: false,
		previewCss: 'max-height:100px; max-width:100px;',	
		STRING: {
			remove: '<img src="${siteImgPath}/common/btn_delete.gif">',
			denied: 'hwp형식의 파일만 등록이 가능합니다. 등록파일 확장자 : $ext',
			duplicate: '같은 파일을 선택하셨습니다.\n등록파일 : $file',
			toomuch: '업로드파일은 10MB를 넘을수 없습니다. ($size)',
			toomany: '한개의 파일만 등록 가능합니다. (max: $max)',
			toobig: '업로드파일은 10MB를 넘을수 없습니다. (max $size)'
		}
	});
	//이미지파일
	var imageFilemax = 3 - "${auditImageFileList.size()}";
	$('#imageFile').MultiFile({ 
		max: imageFilemax, 
		accept: 'gif|jpg|png|jpeg',
		maxfile: 2097152,	
		preview: true,
		previewCss: 'max-height:100px; max-width:100px;',	
		STRING: {
			remove: '<img src="${siteImgPath}/common/btn_delete.gif">',
			denied: 'jpg, png, gif형식의 이미지만 등록이 가능합니다. 등록파일 확장자 : $ext',
			duplicate: '같은 파일을 선택하셨습니다.\n등록파일 : $file',
			toomuch: '업로드파일은 10MB를 넘을수 없습니다. ($size)',
			toomany: '한개의 파일만 등록 가능합니다. (max: $max)',
			toobig: '업로드파일은 10MB를 넘을수 없습니다. (max $size)'
		}
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
});

var attachCount=0;
$(function(){
	gfnSetPeriodDatePicker("startDate", "endDate", "startDateBtn", "endDateBtn");	
});


function fnCommentHide(cmtSeq, hideYn){	
	var confirmMsg = "";
	if(hideYn == "Y"){
		confirmMsg = "<spring:message code="message.common.info.001" arguments="숨김처리" />"; // 하시겠습니까?
	} else {
		confirmMsg = "<spring:message code="message.common.info.001" arguments="숨김처리해제" />"; // 하시겠습니까?
	}
	
	//$.cookie('_adminProposalDetailCurrentScrollTop', $(document).scrollTop());// 스크롤 위치고정목적 쿠키
	
	if(confirm(confirmMsg)){
		$.ajax({
	        url: '<c:url value="/admin/proposal/detail/comment/hide" />',
	        type: 'post',
	        async : false,
	        dataType: "html",
	        data: {
	        	"propSeq" : $("#propSeq").val(),
	            "cmtSeq" : cmtSeq,
	            "hideYn" : hideYn
	        },
	        success: function(data) {
	            if(data == -1){
	                alert("<spring:message code="message.proposal.info.001" />");
	                fnList();                   
	            } else {
	                location.reload();
	            }
	        },
	        error: function(xhr, status, error) {
	            alert("error : ajax fail!! [ fnSympathy ]");
	        }
	    });
	}
	
}

function fnCommentAuth(userSeq, cmtYn){
    
	var confirmMsg = "";
    if(cmtYn == "N"){
        confirmMsg = "<spring:message code="message.common.info.001" arguments="댓글권한차단" />"; // 하시겠습니까?
    } else {
        confirmMsg = "<spring:message code="message.common.info.001" arguments="댓글권한허용" />"; // 하시겠습니까?
    }
    
    //$.cookie('_adminProposalDetailCurrentScrollTop', $(document).scrollTop());// 스크롤 위치고정목적 쿠키
    
    if(confirm(confirmMsg)){
		$.ajax({
			url: '<c:url value="/admin/proposal/detail/comment/auth" />',
	        type: 'post',
	        async : false,
	        dataType: "html",
	        data: {
	        	"propSeq" : $("#propSeq").val(),
	            "userSeq": userSeq,
	            "cmtYn": cmtYn
	        },
	        success: function(data) {
	            if(data == -1){
	            	alert("<spring:message code="message.proposal.info.001" />");
	                fnList();                     
	            } else {
	            	location.reload();
	            }
	        },
	        error: function(xhr, status, error) {
	            alert("error : ajax fail!! [ fnSympathy ]");
	        }
	    });
    }
}

function fnSave(){
		//저장하시겠습니까?
	if(confirm("<spring:message code="message.common.info.001" arguments="저장" />")){
		if($("#status").val() == 'PENDING'){

		}else{ 				
	        if( gfnValidation( $("#startDate"), "<spring:message code="message.common.header.002" arguments="사업기간 시작일을" />" ) == false ){ return; }
	        if( gfnValidation( $("#endDate"), "<spring:message code="message.common.header.002" arguments="사업기간 종료일을" />") == false ){ return; }
	        if( gfnValidation( $("#budget"), "<spring:message code="message.common.header.002" arguments="소요예산을" />" ) == false ){ return; }
	        if( gfnValidation( $("#location"), "<spring:message code="message.common.header.002" arguments="사업위치를" />" ) == false ){ return; }
	        if( gfnValidation( $("#subcmit"), "<spring:message code="message.common.header.002" arguments="분과위원회를" />" ) == false ){ return; }
	        if( gfnValidation( $("#bizCont"), "<spring:message code="message.common.header.002" arguments="내용을" />" ) == false ){ return; }
	        if( gfnValidation( $("#lawDetail"), "<spring:message code="message.common.header.002" arguments="법률조례기준을" />" ) == false ){ return; }
	        if( gfnValidation( $("#reviewDetail"), "<spring:message code="message.common.header.002" arguments="검토의견을" />" ) == false ){ return; }
	        if( gfnValidation( $("#reviewDept"), "<spring:message code="message.common.header.002" arguments="검토부서를" />" ) == false ){ return; }
	        if( gfnValidation( $("#reviewer"), "<spring:message code="message.common.header.002" arguments="검토자를" />" ) == false ){ return; }
	        if( gfnValidation( $("#cmitDetail"), "<spring:message code="message.common.header.002" arguments="참여예산위원회 검토의견" />" ) == false ){ return; }
	        //if( gfnValidation( $("#auditCmitBudget"), "<spring:message code="message.common.header.002" arguments="참여예산위원회 사업비를" />" ) == false ){ return; }
	        //if( gfnValidation( $("#auditGnrBudget"), "<spring:message code="message.common.header.002" arguments="주민총회 사업비를" />" ) == false ){ return; }
	        //if( gfnValidation( $("#auditRank"), "<spring:message code="message.common.header.002" arguments="주민총회 순위를" />" ) == false ){ return; }
		}
		
		$("#frm").prop("action", "<c:url value="/admin/proposal/detail/save" />").submit();
	}
}

function fnDeleteFile(obj, fileSeq){
	$('<input type="hidden" name="deleteFileSeq" value="'+fileSeq+'" />').appendTo("#frm");
	$(obj).parent().remove(); 
	return false;
}

function fnList(url){
	location.href = $("#listUrl").val();
}

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
	
	<jsp:include page="/WEB-INF/views/admin/common/header.jsp" />
		
	<div class="containerWrap">
		<div class="subNav">
			<ul class="subNavUl">
				<li class="subNavHome"><img src="${siteImgPath }/common/home.png" alt="home"/></li>
				<li>제안</li>
				<li>상세보기</li>
			</ul>
		</div>

		<div class="container">
			<div class="contentWrap">

				<jsp:include page="/WEB-INF/views/admin/common/lnb.jsp" />
				
				<div class="content">
					<h3 class="contentTit">제안 상세보기</h3>						
						<div class="mainContent">
							<div class="offerTit">
								<c:out value="${proposal.bizNm }" />
								<p class="point"><c:out value="${proposal.realmNm }" /></p>
							</div>

							<div class="boardView boardView2">
								<table cellpadding="0" cellspacing="0" class="tbL" summary="제안사업 상세보기 - 등록자, 등록일, 조회수, 처리상태, 소요사업비, 사업기간, 사업위치, 제안취지, 내용, 기대효과를 보는 화면입니다." >
									<caption>제안사업 상세보기</caption>
									<colgroup>
										<col width="15%"/>
										<col width="35%"/>
										<col width="15%"/>
										<col width="35%"/>
									</colgroup>
									<tbody>
										<tr>
											<th scope="row">신청인</th>
											<td><c:out value="${proposal.reqNm.decValue }" /></td>
											<th scope="row">연락처</th>
											<td><c:out value="${proposal.reqPhone.decValue}" /></td>
										</tr>
										<tr>
											<th scope="row">주소</th>
											<td><c:out value="${proposal.reqAddr }" /></td>
											<th scope="row">이메일</th>
											<td><c:out value="${proposal.reqEmail.decValue }" /></td>
										</tr>
										<tr>
											<th scope="row">등록일</th>
											<td><c:out value="${proposal.regDateText }" /></td>
											<th scope="row">조회수</th>
											<td><c:out value="${proposal.readCnt }" /></td>
										</tr>
										<tr>
											<th scope="row">처리상태</th>
											<td colspan="3"><c:out value="${proposal.statusText }" /></td>
										</tr>
										<tr>
											<th scope="row">소요사업비</th>
											<td colspan="3"><c:out value="${proposal.budget }"/> </td>
										</tr>
										<tr>
											<th scope="row">사업기간</th>
											<td colspan="3"><c:out value="${proposal.startDate }" /> ~ <c:out value="${proposal.endDate }" /></td>
										</tr>
										<tr>
											<th scope="row">사업위치</th>
											<td colspan="3"><c:out value="${proposal.location }" /></td>
										</tr>
										<tr>
											<th scope="row">제안취지</th>
											<td colspan="3" class="_white-space"><c:out value="${proposal.necessity }" /></td>
										</tr>
										<tr>
											<th scope="row">내용</th>
											<td colspan="3" class="_white-space"><c:out value="${proposal.bizCont }" /></td>
										</tr>
										<tr>
											<th scope="row">기대효과</th>
											<td colspan="3" class="_white-space"><c:out value="${proposal.effect }" /></td>
										</tr>
										<tr>
											<th scope="row">사진</th>
											<td colspan="3">
											    <c:forEach items="${imageFileList }" var="item">
												    <dl class="photo1">
	                                                    <dt><a href="/file-download/${item.fileSeq }" ><c:out value="${item.fileSrcNm }" /></a></dt>
	                                                    <dd><img src="<c:url value="/file-download/${item.fileSeq }" />" alt="사례이미지" /></dd>
	                                                </dl>
											    </c:forEach>
											</td>
										</tr>
										<tr>
											<th scope="row">신청서 등록</th>
											<td colspan="3">
											    <c:forEach items="${attachFileList }" var="item">
				                                    <a href="/file-download/${item.fileSeq }" ><c:out value="${item.fileSrcNm }" /></a>
				                                </c:forEach>
											</td>
										</tr>
									</tbody>
								</table>
							</div>
                            <form name="frm" id="frm" method="post" enctype="multipart/form-data" >
	                            <input type="hidden" name="propSeq" id="propSeq" value="<c:out value="${param.propSeq }" />" />
	   						    <input type="hidden" name="listUrl" id="listUrl" value="<c:out value="${listUrl}"/>" />
	                            <input type="hidden" name="bizNm" id="bizNm" value="<c:out value="${proposal.bizNm }" />" />
							<p class="pTit2">검토 의견 작성</p>
							<div class="boardView boardView2">
								<table class="tbL" summary="사업기간, 소요예산, 사업위치, 분과위원회, 구분, 내용에 대한 검토의견- 법률 조례기준, 검토의견(타당성, 시급성, 사업효과, 수혜범위 등), 검토결과, 검토부서, 사진, 첨부파일과 참여예산(분과)위원회 검토의견을 볼 수 있는 표입니다." >
									<caption>검토의견</caption>
									<colgroup>
										<col width="15%"/>
										<col width="35%"/>
										<col width="15%"/>
										<col width="35%"/>
									</colgroup>
									<tbody>
										<tr>
										<th scope="row">사업기간</th>
											<td colspan="3">
												<label for="startT" class="hidden">시작날짜입력</label><input type="text" class="it " name="startDate" id="startDate" readonly="readonly" 
													<c:if test="${!empty proposalAudit.startDate }">value="<c:out value='${proposalAudit.startDate }'/>"</c:if>
													<c:if test="${empty proposalAudit.startDate }">value="<c:out value='${proposal.startDate }'/>"</c:if> />
												<img id="startDateBtn" src="${siteImgPath }/common/icon_cal.gif" alt="시작날짜선택"  />
												<label for="endT" class="hidden">끝나는날짜입력</label><input type="text" class="it " name="endDate" id="endDate" readonly="readonly" 
													<c:if test="${!empty proposalAudit.endDate }">value="<c:out value='${proposalAudit.endDate}'/>"</c:if>
													<c:if test="${empty proposalAudit.endDate }">value="<c:out value='${proposal.endDate }'/>"</c:if>	 />												
												<img id="endDateBtn" src="${siteImgPath }/common/icon_cal.gif" alt="끝나는날짜선택" />
											</td>
										</tr>
										<tr>
											<th scope="row">소요예산</th>
											<td colspan="3">
												<input type="text" class="it wid461" name="budget" id="budget" maxlength="20"
													<c:if test="${!empty proposalAudit.budget }">value="<c:out value='${proposalAudit.budget}'/>"</c:if>
													<c:if test="${empty proposalAudit.budget }">value="<c:out value='${proposal.budget }'/>"</c:if> /> <span class="textAfter">원</span>
											</td>
										</tr>
										<tr>
											<th scope="row">사업위치</th>
											<td><input type="text" class="it wid100" name="location" id="location" maxlength="100"			
												<c:if test="${!empty proposalAudit.location  }">value="<c:out value='${proposalAudit.location }'/>"</c:if>
												<c:if test="${empty proposalAudit.location  }">value="<c:out value='${proposal.location }'/>"</c:if> /></td>
											<th scope="row">분과위원회</th>
											<td><input type="text" class="it wid100" name="subcmit" id="subcmit" value="<c:out value="${proposalAudit.subcmit }" />" /></td>
										</tr>
										<tr>
											<th scope="row">내용</th>
											<td colspan="3">
												<div class="writeW">
													<textarea name="bizCont" id="bizCont" cols="10" rows="10" title="내용 입력" class="wid100" maxlength="2000" onkeyup="return checkmaxlength(this,'최대 2000자까지 입력가능합니다.');"><c:if test="${!empty proposalAudit.bizCont}"><c:out value='${proposalAudit.bizCont}'/></c:if><c:if test="${empty proposalAudit.bizCont}"><c:out value='${proposal.bizCont}'/></c:if></textarea>
												</div>
												<span class="red2">최대 2000자까지 입력가능</span>
											</td>
										</tr>
										<tr>
											<th scope="col" colspan="4">검토의견</th>
										</tr>
										<tr>
											<th scope="row">법률 &middot; 조례 기준</th>
											<td colspan="3">
												<select name="lawResult" id="lawResult" class="wid125">
													<option value="Y" <c:if test="${proposalAudit.lawResult == 'Y' }">selected</c:if> >적격</option>
													<option value="N" <c:if test="${proposalAudit.lawResult == 'N' }">selected</c:if> >부적격</option>
												</select>
												<input type="text" class="it wid461" name="lawDetail" id="lawDetail" value="<c:out value="${proposalAudit.lawDetail }" />" maxlength="100" />
											</td>
										</tr>
										<tr>
											<th scope="row">검토의견 (타당성, 시급성, 사업효과, 수헤범위 등)</th>
											<td colspan="3">
												<div class="writeW">
													<textarea name="reviewDetail" id="reviewDetail" cols="10" rows="10" class="wid100" maxlength="2000" onkeyup="return checkmaxlength(this,'최대 2000자까지 입력가능합니다.');"><c:out value="${proposalAudit.reviewDetail }" /></textarea>
												</div>
												<span class="red2">최대 2000자까지 입력가능</span>
											</td>
										</tr>
										<tr>
											<th scope="row">검토 부서</th>
											<td><input type="text" class="it wid100" name="reviewDept" id="reviewDept" value="<c:out value="${proposalAudit.reviewDept }" />" maxlength="50"/></td>
											<th scope="row">검토자</th>
											<td>
											 <input type="text" class="it wid100" name="reviewer" id="reviewer" maxlength="25"
											    <c:choose><c:when test="${proposalAudit.reviewer != null }">value='<c:out value="${proposalAudit.reviewer }" />'</c:when>
											    <c:otherwise>value='<c:out value="${av.mgrNm.decValue }" />' </c:otherwise></c:choose> />
											</td>
										</tr>
										<tr>
											<th scope="row">검토 결과</th>
											<td colspan="3">
												<select name="reviewResult" id="reviewResult" class="wid125">
													<option value="Y" <c:if test="${proposalAudit.reviewResult == 'Y' }">selected</c:if> >적합</option>
													<option value="N" <c:if test="${proposalAudit.reviewResult == 'N' }">selected</c:if> >부적합</option>
												</select>
											</td>
										</tr>
										<tr>
											<th scope="row" rowspan="2">사진</th>
											<td colspan="3">
												 <div class="fileBox">
												   <input type="button" class="filebutton" value="첨부"/>										   
												   <input type="file" class="fileupload" name="imageFile" id="imageFile" />
												   	<p class="upload">
														<span class="red2">※ gif, jpg, jpeg, png형식의 이미지 파일만 첨부 가능합니다.</span>
														<span class="red2">※ 1개의 파일을 첨부할 수 있습니다.(파일 용량제한: 2MB)</span>
													</p>
												</div>
											</td>
										</tr>
										<tr>											
											<td colspan="3">											
												<c:forEach items="${auditImageFileList }" var="item" >
                                                <div class="photoD imageFileCount" style="margin-top:10px;">
                                                    <dl class="photo1">
                                                        <dt><a href="/file-download/${item.fileSeq }" ><c:out value="${item.fileSrcNm }" /></a></dt>
                                                        <dd><img src="<c:url value="/file-download/${item.fileSeq }" />" alt="<c:out value="${item.fileSrcNm }" />" /></dd>
                                                    </dl>
                                                    <a href="#;" class="delete" onclick="fnDeleteFile(this, ${item.fileSeq})" ><img src="${siteImgPath }/common/btn_delete.gif" alt="삭제하기"/></a>
                                                </div>
                                                </c:forEach>
											</td>
										</tr>
										<tr>
											<th scope="row">첨부파일</th>
											<td colspan="3">
                                              <div class="fileBox">
													<input type="button" class="filebutton" value="첨부"/>										
													<input type="file" class="fileupload" name="attachFile" id="attachFile" />											
													<p class="upload">
														<span class="red2">※ 한글파일(hwp 파일)만 등록이 가능합니다.</span>
														<span class="red2">※ 최대 3개의 파일을 첨부할 수 있습니다.(파일 용량제한: 2MB)</span>
													</p>
												</div>
                                                <c:forEach items="${auditAttachFileList }" var="item" >
                                                    <div class="filebox attachFileCount" style="margin-top:10px;">
	                                                    <a href="/file-download/${item.fileSeq }" ><c:out value="${item.fileSrcNm }" /></a>
	                                                    <button class='fileAdd' onclick="fnDeleteFile(this, ${item.fileSeq})">삭제</button>	                                                   
                                                    </div>
                                                </c:forEach>
                                            </td>
										</tr>
										<tr>
											<th scope="col" colspan="4" class="colorblue">참여예산(분과)위원회 검토 의견</th>
										</tr>
										<tr>
											<th scope="row" class="colorblue">검토의견</th>
											<td colspan="3">
												<select name="cmitResult" id="cmitResult" class="wid125">
													<option value="Y" <c:if test="${proposalAudit.cmitResult == 'Y' }">selected</c:if> >적격</option>
													<option value="N" <c:if test="${proposalAudit.cmitResult == 'N' }">selected</c:if> >부적격</option>
												</select>
												<input type="text" name="cmitDetail" id="cmitDetail" class="it wid461" value="<c:out value="${proposalAudit.cmitDetail }" />"  />
											</td>
										</tr>
									</tbody>
								</table>
							</div>

							<p class="pTit2">심사결과</p>
							<div class="boardView">
								<table cellpadding="0" cellspacing="0" class="tbL" summary="참여예산위원회와 주민총회의 심사결과, 조정사업비, 순위를 보여주는 표입니다." >
									<caption>심사결과</caption>
									<colgroup>
										<col width="15%"/>
										<col width="43%%"/>
										<col width="*"/>
									</colgroup>
									<thead>
										<th scope="col">&nbsp;	</th>
										<th scope="col">참여예산위원회</th>
										<th scope="col">주민총회</th>
									</thead>
									<tbody>
										<tr>
											<th scope="row">심사결과</th>
											<td>
												<select name="auditCmitResult" id="auditCmitResult" class="wid100" >
													<option value="Y" <c:if test="${proposalAudit.auditCmitResult == 'Y' }">selected</c:if> >선정</option>
													<option value="N" <c:if test="${proposalAudit.auditCmitResult == 'N' }">selected</c:if> >미선정</option>
												</select>
											</td>
											<td>
												<select name="auditGnrResult" id="auditGnrResult" class="wid100">
													<option value="Y" <c:if test="${proposalAudit.auditGnrResult == 'Y' }">selected</c:if> >선정</option>
                                                    <option value="N" <c:if test="${proposalAudit.auditGnrResult == 'N' }">selected</c:if> >미선정</option>
												</select>
											</td>
										</tr>
										<tr>
											<th scope="row">사업비</th>
											<td>
												<input type="text" name="auditCmitBudget" id="auditCmitBudget" class="it wid141" maxlength="25" value="${proposalAudit.auditCmitBudget}"/> <span class="textAfter">원</span>
											</td>
											<td>
												<input type="text" name="auditGnrBudget" id="auditGnrBudget" class="it wid141" maxlength="25" value="${proposalAudit.auditGnrBudget }"/> <span class="textAfter">원</span>
											</td>
										</tr>
										<tr>
											<th scope="row">순위</th>
											<td>-</td>
											<td>
												<input type="text" name="auditRank" id="auditRank" class="OnlyNumber it wid141" maxlength="6" value="<c:out value="${proposalAudit.auditRank }" />" /> <span class="textAfter">위</span>
											</td>
										</tr>
									</tbody>
								</table>
							</div>

							<div class="tbBot">
								<div class="btnFr font">
									<select name="status" id="status" class="wid125">
										<c:forEach items="${codeList }" var="item" >
										    <option value="<c:out value="${item.cdId }" />" <c:if test="${proposal.status eq item.cdId }">selected</c:if> ><c:out value="${item.cdNm }" /></option>
										</c:forEach>
									</select>
									<a href="#;" class="btn_blue2img" onclick="fnSave()" >검토의견 저장하기</a>
									<a href="#" class="btn_reset" onclick="fnList();">목록보기</a>
								</div>
							</div>
                            </form>
                            <div class="btnC bNone">
                                <a class="heart loginMbt1 layer" rel="loginMbtLayer"><fmt:formatNumber value="${proposal.symCnt }" pattern="#,###" /></a>
                            </div>

							<div class="replyBox">
								<p class="rCaption">댓글 <span><c:out value="${commentListCount }" /></span></p>
								<ul class="rList">
								<c:forEach items="${commentList }" var="item" varStatus="idx">
								    <li>
                                        <span class="nick"><c:out value="${item.nickname }" /></span> <span><c:out value="${item.regDateText }" /></span> <c:if test="${item.reportCnt > 0 }"><span class="RedNoti">신고 <fmt:formatNumber value="${item.reportCnt }" pattern="#,###" /></span></c:if>
                                        <c:if test="${item.hideYn eq 'Y' }">
                                            <p class="red">숨김 처리된 댓글입니다.</p>
                                        </c:if>
                                        <p><c:out value="${item.cont }" /></p>
                                        <div class="btnFr">
                                            <span class="bt_agree">동의합니다 <fmt:formatNumber value="${item.agreeCntY }" pattern="#,###" /></span>
                                            <span class="bt_agree">동의하지 않습니다 <fmt:formatNumber value="${item.agreeCntN }" pattern="#,###" /></span>
                                        </div>
                                        <a href="#" class="more">더보기</a>
                                        <div class="moreBox">
                                            <c:choose>
                                                <c:when test="${item.hideYn eq 'Y' }">
                                                    <a href="#;" onclick="fnCommentHide(${item.cmtSeq},'N')" >댓글숨김해제</a>     
                                                </c:when>
                                                <c:otherwise>
                                                    <a href="#;" onclick="fnCommentHide(${item.cmtSeq},'Y')" >댓글숨김</a>
                                                </c:otherwise>
                                            </c:choose>
                                            
                                            <c:choose>
                                                <c:when test="${item.cmtYn eq 'N' }">
                                                    <a href="#;" onclick="fnCommentAuth(${item.regUser},'Y')" >댓글권한허용</a>
                                                </c:when>
                                                <c:otherwise>
                                                    <a href="#;" onclick="fnCommentAuth(${item.regUser},'N')" >댓글권한차단</a>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </li>
								</c:forEach>
								</ul>
							</div>
						</div>
				</div>

			</div><!--contentWrap-->

		</div><!--container-->
	</div><!--containerWrap-->

	<jsp:include page="/WEB-INF/views/admin/common/footer.jsp" />
	
</body>
</html>
