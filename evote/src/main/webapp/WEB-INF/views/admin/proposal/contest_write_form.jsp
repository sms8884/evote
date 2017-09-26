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
	$( "#start_date, #end_date").datepicker({
	    dateFormat: 'yy-mm-dd',
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

	//시간
	var dateStr = '';
	for(var i = 0; i <= 23; i++) {
		dateStr = (i < 10) ? '0' + i : i;
		$('#start_hour, #end_hour').append('<option value="' + dateStr + '">' + dateStr + '</option>');
	}
	
	var shour ='${contest.startDate}';
	if(shour != ""){		
		shour = '<fmt:formatDate pattern="HH" value="${contest.startDate}"/>';
		$("#start_hour").val(shour).prop("selected", "selected");		
	}else{
		$("#start_hour").val("09").prop("selected", "selected");		
	}
	var ehour ='${contest.endDate}';
	if(ehour != ""){
		ehour = '<fmt:formatDate pattern="HH" value="${contest.endDate}"/>';
		$("#end_hour").val(ehour).prop("selected", "selected");
	}else{
		$("#end_hour").val("18").prop("selected", "selected");
	} 
		
	 var realmfileYn = "${contest.realmfileYn}";
	//첨부파일	
	$('#realmfile').MultiFile({ 	
		max: 1, 
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
		},
		afterFileSelect: function(element, value, master_element) {
	    	$("#realmfileYn").val('Y');
	    },
	    afterFileRemove: function(element, value, master_element) {
	    	$("#realmfileYn").val(realmfileYn);
	     }
	});
	
	 var methodfileYn = "${contest.methodfileYn}";	
	//첨부파일	
	$('#methodfile').MultiFile({ 	
		max: 1, 
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
		},
		afterFileSelect: function(element, value, master_element) {
	    	$("#methodfileYn").val('Y');
	    },
	    afterFileRemove: function(element, value, master_element) {
	    	$("#methodfileYn").val(methodfileYn);
	     }
	});
	
	 var imgpcfileYn ="${contest.imgpcfileYn}";	
	//이미지파일
	$('#imgpcfile').MultiFile({ 
		max: 1, 
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
		},
		afterFileSelect: function(element, value, master_element) {
	    	$("#imgpcfileYn").val('Y');
	    },
	    afterFileRemove: function(element, value, master_element) {
	    	$("#imgpcfileYn").val(imgpcfileYn);
	     }
	});
	
	 var imgmobfileYn ="${contest.imgmobfileYn}";
	//이미지파일
	$('#imgmobfile').MultiFile({ 
		max: 1, 
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
		},
		afterFileSelect: function(element, value, master_element) {
	    	$("#imgmobfileYn").val('Y');
	    },
	    afterFileRemove: function(element, value, master_element) {
	    	$("#imgmobfileYn").val(imgmobfileYn);
	     }
	});

}); //end docu ready

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

//저장하기
function fnSave(){

	if( gfnValidation( $("#title"), '<spring:message code="message.admin.common.001" arguments="공모제목을"/>' ) == false ){ return; }
	if( gfnValidation( $("#opScale"), '<spring:message code="message.admin.common.001" arguments="운영규모를"/>' ) == false ){ return; }
	if( gfnValidation( $("#gnrScope"), '<spring:message code="message.admin.common.001" arguments="일반사업 사업범위를"/>' ) == false ){ return; }
	if( gfnValidation( $("#gnrScale"), '<spring:message code="message.admin.common.001" arguments="일반사업 전체규모를"/>' ) == false ){ return; }
	if( gfnValidation( $("#gnrStd"), '<spring:message code="message.admin.common.001" arguments="일반사업 사업비기준을"/>' ) == false ){ return; }
	if( gfnValidation( $("#trgScope"), '<spring:message code="message.admin.common.001" arguments="목적사업 사업범위을"/>' ) == false ){ return; }
	if( gfnValidation( $("#trgScale"), '<spring:message code="message.admin.common.001" arguments="목적사업 전체규모를"/>' ) == false ){ return; }
	if( gfnValidation( $("#trgStd"), '<spring:message code="message.admin.common.001" arguments="목적사업 사업비기준을"/>' ) == false ){ return; }
	if( gfnValidation( $("#start_date"), '<spring:message code="message.admin.common.002" arguments="신청기간 시작일을"/>' ) == false ){ return; }
	if( gfnValidation( $("#end_date"), '<spring:message code="message.admin.common.002" arguments="신청기간 종료일을"/>' ) == false ){ return; }
	var start_date = replaceAll($("#start_date").val(),"-","" )+$("#start_hour").val();
	var end_date = replaceAll($("#end_date").val(),"-","" )+$("#end_hour").val();	
	if(start_date >= end_date){	
		 //투표종료일이 투표시작일보다 과거 일시로 설정되어 저장할 수 없습니다
		 alert('<spring:message code="message.admin.vote.004"/>');
		 $("#end_date").focus();
		return;
	}
	if( gfnValidation( $("#reqDest"), '<spring:message code="message.admin.common.001" arguments="신청대상을"/>' ) == false ){ return; }
	if( gfnValidation( $("#reqRealm"), '<spring:message code="message.admin.common.001" arguments="신청분야를"/>' ) == false ){ return; }
	if($("#realmfileYn").val() == 'N'){
    	alert('<spring:message code="message.admin.common.002" arguments="신청분야파일을"/>');
    	$("#realmfileYn").focus();
    	return;
	}
	if( gfnValidation( $("#reqMethod"), '<spring:message code="message.admin.common.001" arguments="신청방법을"/>' ) == false ){ return; }
	if($("#methodfileYn").val() == 'N'){
    	alert('<spring:message code="message.admin.common.002" arguments="신청방법파일을"/>');
    	$("#methodfileYn").focus();
    	return;
	}
	if( gfnValidation( $("#bizScale"), '<spring:message code="message.admin.common.001" arguments="사업선정방법을"/>' ) == false ){ return; }
	if( gfnValidation( $("#ineligibleBiz"), '<spring:message code="message.admin.common.002" arguments="부적격사업을"/>' ) == false ){ return; }
	if( gfnValidation( $("#regulation"), '<spring:message code="message.admin.common.001" arguments="규정을"/>' ) == false ){ return; }	
	
	if($("#imgpcfileYn").val() == 'N'){
    	alert('<spring:message code="message.admin.common.002" arguments="추진흐름도 PC 이미지파일을 "/>');
    	$("#imgpcfileYn").focus();
    	return;
	}
	if($("#imgmobfileYn").val() == 'N'){
    	alert('<spring:message code="message.admin.common.002" arguments="추진흐름도 모바일 이미지파일을 "/>');
    	$("#imgmobfileYn").focus();
    	return;
	}
	
	$.ajax({
		type : "POST",
		url: '<c:url value="/admin/proposal/checkContest" />',
        type: 'post',
        async : false,
        dataType: "html",
        data: {
        	"psSeq" : $("#psSeq").val(),
        	"ckStartDate" : $("#start_date").val()+$("#start_hour").val(),
        	"ckEndDate" : $("#end_date").val()+$("#end_hour").val()
        },	        
        success: function(data) {
            if(data > 0){
                alert("<spring:message code="message.admin.proposal.012" />");
                $("#start_date").focus();
				return;
            } else {            	
            	$('#form').attr('action', "/admin/proposal/contest_write").submit();
            }
        },		
        error: function(xhr, status, error) {
            alert("error : ajax fail!! [ checkContest ]");
        }
	});
	
}


//파일 삭제
function fileDelete(seq, obj){		
	$.ajax({
		type : "POST",
		url : "/admin/proposal/file-delete/"+seq ,			
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
			//파일 삭제에 실패하였습니다.
			alert('<spring:message code="message.admin.vote.020"/>')
			console.log('<spring:message code="message.admin.vote.020"/>');
		}
	});
}

//목록보기
function fnList(){
	//입력된 내용이 저장되지 않습니다. 목록으로 이동하겠습니까?
	if(confirm('<spring:message code="message.admin.vote.007"/>')){
		$('#form').attr('action', "/admin/proposal/contest_list").submit();
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
				<li>제안</li>
				<li>공모관리</li>
				<li>공모저장</li>
			</ul>
		</div>

		<div class="container">
			<div class="contentWrap">
				<!--leftmenu-->
				<jsp:include page="/WEB-INF/views/admin/common/lnb.jsp" />				
				<!--leftmenu-->
				
				<div class="content">
					<h3 class="contentTit">공모저장</h3>
					
					<div class="mainContent">	
						<div class="boardView ">
						  <form name="form" id="form" method="post" enctype="multipart/form-data" >
                            <input type="hidden" name="psSeq" id="psSeq" value="<c:out value="${contest.psSeq }" />" />
							<table cellpadding="0" cellspacing="0" class="tbL" summary="공모제목, 추진개요, 운영규모, 일반사업과 목적사업의 사업범위, 전체규모, 사업비기준을 볼 수 있는 표입니다." >
								<caption>공모저장</caption>
								<colgroup>
									<col width="17%"/>
									<col width="15%"/>
									<col width="68%"/>
								</colgroup>
								<tbody>
									<tr>
										<th scope="row">공모제목</th>
										<td colspan="2">
											<input type="text" class="it wid461"  id="title" name="title" value="<c:out value='${contest.title}'/>" maxlength="30"/><span class="red">30자까지 입력 가능</span>
										</td>
									</tr>
									<tr>
										<th scope="col" colspan="3" class="cols3">추진개요</th>
									</tr>
									<tr>
										<th scope="row">운영규모</th>
										<td colspan="2">
											<input type="text" class="it wid100" id="opScale" name="opScale" value="<c:out value='${contest.opScale}'/>" maxlength="50" />
										</td>
									</tr>
									<tr>
										<th scope="row" rowspan="3">일반사업</th>
										<td class="td2">사업범위</td>
										<td>
											<div class="writeW">
												<textarea cols="10" rows="10" class="wid100" id="gnrScope" name="gnrScope" maxlength="2000" onkeyup="return checkmaxlength(this,'최대 2000자까지 입력가능합니다.');" >${contest.gnrScope}</textarea>
											</div>
											<span class="red2">최대 2000자까지 입력가능</span>
										</td>
									</tr>
									<tr>
										<td class="td2">전체규모</td>
										<td>
											<input type="text" class="it wid100" id="gnrScale" name="gnrScale" value="<c:out value='${contest.gnrScale}'/>" maxlength="50"/>
										</td>
									</tr>
									<tr>
										<td class="td2">사업비기준</td>
										<td>
											<input type="text" class="it wid100" id="gnrStd" name="gnrStd" value="<c:out value='${contest.gnrStd }'/>" maxlength="50"/>
										</td>
									</tr>
									<tr>
										<th scope="row" rowspan="3">목적사업</th>
										<td class="td2">사업범위</td>
										<td>
											<div class="writeW">
												<textarea cols="10" rows="10" class="wid100" id="trgScope" name="trgScope" maxlength="2000" onkeyup="return checkmaxlength(this,'최대 2000자까지 입력가능합니다.');" >${contest.trgScope}</textarea>
											</div>
											<span class="red2">최대 2000자까지 입력가능</span>
										</td>
									</tr>
									<tr>
										<td class="td2">전체규모</td>
										<td>
											<input type="text" class="it wid100" id="trgScale" name="trgScale" value="<c:out value='${contest.trgScale}'/>" maxlength="50"/>
										</td>
									</tr>
									<tr>
										<td class="td2">사업비기준</td>
										<td>
											<input type="text" class="it wid100" id="trgStd" name="trgStd" value="<c:out value='${contest.trgStd}'/>" maxlength="50"/>
										</td>
									</tr>
									<tr>
										<th scope="row">신청기간</th>
										<td colspan="2">
											<label for="start_date" class="hidden">시작기간 입력하기</label>
											<input type="text" class="it wid125" id="start_date" name="start_date" value="<fmt:formatDate pattern="yyyy-MM-dd" value="${contest.startDate}" />" readOnly/><img src="${siteImgPath}/common/icon_cal.gif" id="img_sd"/>
											<select  id="start_hour" name="start_hour"></select>시~
											<label for="end_date" class="hidden">종료기간 입력하기</label>
											<input type="text" class="it wid125" id="end_date" name="end_date" value="<fmt:formatDate pattern="yyyy-MM-dd" value="${contest.endDate}" />" readOnly/><img src="${siteImgPath}/common/icon_cal.gif" id="img_ed"/>																	
											<select  id="end_hour" name="end_hour"></select>시
										</td>
									</tr>
									<tr>
										<th scope="row">신청대상</th>
										<td colspan="2">
											<input type="text" class="it wid461" id="reqDest" name="reqDest" value="<c:out value='${contest.reqDest}'/>" maxlength="100" />
										</td>
									</tr>									
									<tr>
										<th scope="row" rowspan="3">신청분야</th>
										<td colspan="2" style="border-right-style: none;">
											<div class="writeW">
												<textarea cols="10" rows="10" class="wid100" id="reqRealm" name="reqRealm" maxlength="500" onkeyup="return checkmaxlength(this,'최대 500자까지 입력가능합니다.');" >${contest.reqRealm}</textarea>
												<span class="red2">최대 500자까지 입력가능</span>
											</div>
										</td>
									</tr>
									<tr>
										<td colspan="2" style="border-right-style: none;">
											<input type="hidden" id="realmfileYn" value="${contest.realmfileYn}"/>
											<div class="fileBox">
												<input type="button" class="filebutton" value="첨부" name="" id=""/>
												<input type="file" class="fileupload" name="realmfile" id="realmfile" />											
												<p class="upload">
													<span class="red2">※ 한글파일(hwp 파일)만 등록이 가능합니다.</span>
													<span class="red2">※ 최대 1개의 파일을 첨부할 수 있습니다.(파일 용량제한: 2MB)</span>
												</p>
											</div>
										</td>
									</tr>
									<tr>
										<td colspan="2" style="border-right-style: none;">
										<c:if test="${!empty realmfile}">
										   <c:forEach items="${realmfile}" var="realmfile" varStatus="status">
												<em><a href='/file-download/${realmfile.fileSeq}'>${realmfile.fileSrcNm}</a></em>																																	
												<%-- <a href="#" onclick="javascript:fileDelete('${realmfile.fileSeq}', this);return false;" class="btn_gray">삭제하기</a>			 --%>																			
									        </c:forEach>
								        </c:if>
										</td>
									</tr>								
									<tr>
										<th scope="row" rowspan="3">신청방법</th>
										<td colspan="2" style="border-right-style: none;">
											<div class="writeW">
												<textarea cols="10" rows="10" class="wid100" id="reqMethod" name="reqMethod" maxlength="500" onkeyup="return checkmaxlength(this,'최대 500자까지 입력가능합니다.');" >${contest.reqMethod}</textarea>
												<span class="red2">최대 500자까지 입력가능</span>
											</div>
										</td>
										</tr>
										<tr>
										<td colspan="2" style="border-right-style: none;">
											<input type="hidden" id="methodfileYn" value="${contest.methodfileYn}"/>										
											<div class="fileBox">
												<input type="button" class="filebutton" value="첨부" name="" id=""/>												
												<input type="file" class="fileupload" name="methodfile" id="methodfile" />	
												<p class="upload">
													<span class="red2">※ 한글파일(hwp 파일)만 등록이 가능합니다.</span>
													<span class="red2">※ 최대 1개의 파일을 첨부할 수 있습니다.(파일 용량제한: 2MB)</span>
												</p>
											</div>
										</td>
									</tr>
									<tr>
										<td colspan="2" style="border-right-style: none;">
										<c:if test="${!empty methodfile}">
										   <c:forEach items="${methodfile}" var="methodfile" varStatus="status">
												<em><a href='/file-download/${methodfile.fileSeq}'>${methodfile.fileSrcNm}</a></em>																																		
												<%-- <a href="#" onclick="javascript:fileDelete('${methodfile.fileSeq}', this);return false;" class="btn_gray">삭제하기</a> --%>																																	
									        </c:forEach>
								        </c:if>
										</td>
									</tr>								
									<tr>
										<th scope="row">사업선정방법</th>
										<td colspan="2">
											<div class="writeW">
												<textarea cols="10" rows="10" class="wid100" id="bizScale" name="bizScale" maxlength="2000" onkeyup="return checkmaxlength(this,'최대 2000자까지 입력가능합니다.');" >${contest.bizScale}</textarea>
											<span class="red2">최대 2000자까지 입력가능</span>
											</div>
										</td>
									</tr>
									<tr>
										<th scope="row">부적격사업</th>
										<td colspan="2">
											<div class="writeW">
												<textarea cols="10" rows="10" class="wid100" id="ineligibleBiz" name="ineligibleBiz" maxlength="2000" onkeyup="return checkmaxlength(this,'최대 2000자까지 입력가능합니다.');" >${contest.ineligibleBiz}</textarea>
												<span class="red2">최대 2000자까지 입력가능</span>
											</div>
										</td>
									</tr>
									<tr>
										<th scope="col" colspan="3" class="cols3">주민참여예산제 지방보조사업 선정에 대한 사항 규정</th>
									</tr>
									<tr>										
										<td colspan="3">
											<div class="writeW">
												<textarea cols="10" rows="10" class="wid100" id="regulation" name="regulation" maxlength="2000" onkeyup="return checkmaxlength(this,'최대 2000자까지 입력가능합니다.');" >${contest.regulation}</textarea>
											</div>
										</td>
									</tr>	
									<tr>
										<th scope="col" colspan="3" class="cols3">추진흐름도 및 일정</th>
									</tr>														
									<tr>
										<th scope="row" rowspan="2">PC웹</th>
										<td colspan="2" style="border-right-style: none;">									
										   <input type="hidden" id="imgpcfileYn" value="${contest.imgpcfileYn}"/>													  
											<div class="fileBox">
											   <input type="button" class="filebutton" value="첨부" name="" id=""/>	
											   <input type="file" class="fileupload" name="imgpcfile" id="imgpcfile" />
											   	<p class="upload">
													<span class="red2">※ gif, jpg, jpeg, png형식의 이미지 파일만 첨부 가능합니다.</span>
													<span class="red2">※ 1개의 파일을 첨부할 수 있습니다.(파일 용량제한: 2MB)</span>
												</p>
											</div>											
										</td>
									</tr>
									<tr>
										<td colspan="2" style="border-right-style: none;">
										<c:if test="${!empty imgpcfile}">
										 <c:forEach items="${imgpcfile}" var="imgpcfile" varStatus="status">
											 <div class="photoD">
													<dl class="photo1">														
														<dd><a href="/file-download/${imgpcfile.fileSeq }"><img src="/file-download/${imgpcfile.fileSeq}" alt="이미지" style="width:142px; height:100px;"/></a></dd>
													</dl>													
													<%-- <a href="#" onclick="javascript:fileDelete('${imgpcfile.fileSeq}', this );return false;" class="btn_gray">삭제하기</a>	 --%>												
											</div>
								          </c:forEach>		
								          </c:if>									
										</td>
									</tr>																				
									<tr>
										<th scope="row" rowspan="2">모바일</th>
										<td colspan="2" style="border-right-style: none;">									
										   <input type="hidden" id="imgmobfileYn" value="${contest.imgmobfileYn}"/>										 
											<div class="fileBox">
											   <input type="button" class="filebutton" value="첨부" name="" id=""/>		
											   <input type="file" class="fileupload" name="imgmobfile" id="imgmobfile" />
											   	<p class="upload">
													<span class="red2">※ gif, jpg, jpeg, png형식의 이미지 파일만 첨부 가능합니다.</span>
													<span class="red2">※ 1개의 파일을 첨부할 수 있습니다.(파일 용량제한: 2MB)</span>
												</p>
											</div>											
										</td>
									</tr>
									<tr>
										<td colspan="2" style="border-right-style: none;">
										<c:if test="${!empty imgmobfile}">
										 <c:forEach items="${imgmobfile}" var="imgmobfile" varStatus="status">
											 <div class="photoD">
												<dl class="photo1">														
													<dd><a href="/file-download/${imgmobfile.fileSeq }"><img src="/file-download/${imgmobfile.fileSeq}" alt="이미지" style="width:142px; height:100px;"/></a></dd>
												</dl>														
												<%-- <a href="#" onclick="javascript:fileDelete('${imgmobfile.fileSeq}', this );return false;" class="btn_gray">삭제하기</a>					 --%>								
											</div>
								          </c:forEach>		
								          </c:if>									
										</td>
									</tr>																
								</tbody>
							</table>
							</form>
						</div>
					</div>
					<div class="btnR">
						<a href="javascript:fnSave();" class="btn_blue">저장하기</a>
						<a href="javascript:fnList();" class="btn_reset" id="btn_cancel">목록보기</a>
					</div>
				</div>

			</div><!--contentWrap-->

		</div><!--container-->
	</div><!--containerWrap-->

	<!-- footer --> 
	<jsp:include page="/WEB-INF/views/admin/common/footer.jsp" />
	<!-- //footer -->
	

</body>
</html>