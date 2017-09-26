<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page contentType="text/html; charset=utf-8" %>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>

<!-- meta -->
<jsp:include page="/WEB-INF/views/mobile/common/meta.jsp"/>
<!-- //meta -->

<link href="${siteCssPath}/board.css" type="text/css" rel="stylesheet"  />

<script language="javascript" type="text/javascript">
//<![CDATA[
	$(document).ready(function(){
		gfnSetPeriodDatePicker("startDate", "endDate");
	});
	
	function fnList() {
		$("#_tempFrm").attr("action", "/proposal/list");
		$("#_tempFrm").attr("method", "POST");
		$("#_tempFrm").submit();
	}
	
	function fnSave(){
		
		<c:if test="${userType eq 'PROPOSAL'}">
			if(gfnValidation($("#reqNm"),"<spring:message code='message.common.header.002' arguments='신청인을'/>") == false){
		        return;
		    }
		    if(gfnValidation($("#reqAddr"),"<spring:message code='message.common.header.003' arguments='주소를'/>") == false){
		        return;
		    }
		    if(gfnValidation($("#reqEmail"),"<spring:message code='message.common.header.002' arguments='이메일을'/>") == false){
		        return;
		    }
		    if(gfnEmailCheck($("#reqEmail").val()) == false){
		    	// 잘못된 이메일 주소입니다. 이메일 주소를 확인한 다음 다시 입력해주세요.
		        alert("<spring:message code='message.member.join.007'/>");
		        $("#reqEmail").focus();
		        return;
		    }
		</c:if>
		
		if($("input[name=realmCd]:checked").length == 0){
			alert("<spring:message code='message.common.header.003' arguments='구분을'/>");
			return;
		}
		
		if(gfnValidation($("#bizNm"),"<spring:message code='message.common.header.002' arguments='사업명을'/>") == false){
	        return;
	    }
		if(gfnValidation($("#budget"),"<spring:message code='message.common.header.002' arguments='사업비를'/>") == false){
	        return;
	    }
		if(gfnValidation($("#startDate"),"<spring:message code='message.common.header.003' arguments='사업기간 시작일을'/>") == false){
	        return;
	    }
		if(gfnValidation($("#endDate"),"<spring:message code='message.common.header.003' arguments='사업기간 종료일을'/>") == false){
	        return;
	    }
		if(gfnValidation($("#location"),"<spring:message code='message.common.header.002' arguments='사업위치를'/>") == false){
	        return;
	    }
		if(gfnValidation($("#necessity"),"<spring:message code='message.common.header.002' arguments='제안취지를'/>") == false){
	        return;
	    }
		if(gfnValidation($("#bizCont"),"<spring:message code='message.common.header.002' arguments='내용을'/>") == false){
	        return;
	    }
		if(gfnValidation($("#effect"),"<spring:message code='message.common.header.002' arguments='기대효과를'/>") == false){
	        return;
	    }
		
		<c:if test="${userType eq 'PROPOSAL'}">
		if(gfnValidation($("#reqPw"),"<spring:message code='message.common.header.002' arguments='비밀번호를'/>") == false){
	        return;
	    }
		</c:if>
		
		var fiileSizeCheck = true;
		
	    $("input[name=imageFile]").each(function(){
	        if(gfnFileExtCheck($(this), ['jpg','jpeg','gif','png']) == false){
	        	fiileSizeCheck = false;
	            return false;
	        }
	        
	        //파일이 선택된 항목만 체크
	        var fileSize = gfnGetFileSize(this);
	        if(fileSize != -1){
	            //MAX파일용량 2MB
	            if(fileSize > 2097152){
	                alert("파일용량을 초과하였습니다.");
	                this.focus();
	                fiileSizeCheck = false;
	                return false;  
	            }
	        }
	            
	    });
	    if(fiileSizeCheck == false){
	        return;
	    }
		
	    fiileSizeCheck = true;
	    
	    $("input[name=attachFile]").each(function(){
	        if(gfnFileExtCheck($(this), ['hwp']) == false){
	        	fiileSizeCheck = false;
	            return false;
	        }
	        
	        //파일이 선택된 항목만 체크
	        var fileSize = gfnGetFileSize(this);
	        if(fileSize != -1){
	            //MAX파일용량 2MB
	            if(fileSize > 2097152){
	                alert("파일용량을 초과하였습니다.");
	                this.focus();
	                fiileSizeCheck = false;
	                return false;  
	            }
	        }
	            
	    });
	    if(fiileSizeCheck == false){
	        return;
	    }
	    
	    if(confirm("저장하시겠습니까?")){
	    	$("#dataFrm").prop("action", "<c:url value="/proposal/save" />").submit();    	
	    }
		
	}
 	
	$(function() {
		$("#btnImageFile").on('click', $.ProposalFile.btnImageFile);
		$("#btnAttachFile").on('click', $.ProposalFile.btnAttachFile);
	});
	
	$.ProposalFile = {
			
			IMAGE_COUNT : 0,
			ATTACH_COUNT : 0,
			MAX_IMAGE_COUNT : 3,
			MAX_ATTACH_COUNT : 3,
			FILE_INDEX : 1,
			FILE_PREFIX : "__tmpFile_",
			IMAGE_PREFIX : "__tmpImage_",
			IMAGE_DL_PREFIX : "__tmpImageDL_",
			
			btnImageFile : function(e) {
		    	e.preventDefault();
		    	var fileIndex = $.ProposalFile.FILE_INDEX++;
		    	var fileBoxId = $.ProposalFile.FILE_PREFIX + fileIndex;
		    	$('#imageTD').append("<input type='file' id='" + fileBoxId + "' name='imageFile' onchange='$.ProposalFile.setImage(\"" + fileIndex + "\")' style='display: none;'/>");
			    $('#' + fileBoxId).click();
			},
		
			btnAttachFile : function(e) {
				e.preventDefault();
				var fileIndex = $.ProposalFile.FILE_INDEX++;
				var fileBoxId = $.ProposalFile.FILE_PREFIX + fileIndex;
				$('#attachTD').append("<input type='file' id='" + fileBoxId + "' name='attachFile' onchange='$.ProposalFile.setAttach(\"" + fileIndex + "\")' style='display: none;'/>");
				$('#' + fileBoxId).click();
			},
				
		    setImage : function(fileIndex) {
		    	$.ProposalFile.IMAGE_COUNT++;
				$("#imageTR").show();
				if($.ProposalFile.IMAGE_COUNT >= $.ProposalFile.MAX_IMAGE_COUNT) {
					$("#btnImageFile").hide();
				}
				var fileName = $("#" + $.ProposalFile.FILE_PREFIX + fileIndex)[0].files[0].name;
				var imageId = $.ProposalFile.IMAGE_PREFIX + fileIndex;

				var imageTag = "<dl class='photo1' id='" + $.ProposalFile.IMAGE_DL_PREFIX + fileIndex + "'>"
							 + "<dt>" + fileName + "</dt>"
							 + "<dd><img id='" + imageId + "'/><a href='#' onclick='return false;'><img src='${siteImgPath}/sub1/photoDel.png' onclick='$.ProposalFile.removeImage(" + fileIndex + ");'/></a></dd>"
							 + "</dl>";
				
				$("#imageTD").append(imageTag);
				
			    var file = $("#" + $.ProposalFile.FILE_PREFIX + fileIndex)[0].files[0];

			    var reader  = new FileReader();
			    reader.addEventListener("load", function () {
			    	$("#" + imageId).attr("src", reader.result);
			    }, false);
			    if (file) {
			        reader.readAsDataURL(file);
			    }
		    },

			setAttach : function(fileIndex) {
				$.ProposalFile.ATTACH_COUNT++;
				$("#attachTR").show();
				if($.ProposalFile.ATTACH_COUNT >= $.ProposalFile.MAX_ATTACH_COUNT) {
					$("#btnAttachFile").hide();
				}
				var fileName = $("#" + $.ProposalFile.FILE_PREFIX + fileIndex)[0].files[0].name;
				var attachTag = "<p class='file'><a href='#' class='fileName'>" + fileName + "</a><a href='#' class='fileDel' onclick='$(this).parent().remove(); $.ProposalFile.removeAttach(" + fileIndex + "); return false;'>삭제하기</a></p>";
				$("#attachTD").append(attachTag);
			},

			removeImage : function(idx) {
				$.ProposalFile.IMAGE_COUNT--;
				$("#btnImageFile").show();
				$("#" + $.ProposalFile.IMAGE_DL_PREFIX + idx).remove();
				$("#" + $.ProposalFile.FILE_PREFIX + idx).remove();
				if($.ProposalFile.IMAGE_COUNT <= 0) {
					$("#imageTR").hide();
				}
			},
			
			removeAttach : function(idx) {
				$.ProposalFile.ATTACH_COUNT--;
				$("#btnAttachFile").show();
				$("#" + $.ProposalFile.FILE_PREFIX + idx).remove();
				if($.ProposalFile.ATTACH_COUNT <= 0) {
					$("#attachTR").hide();
				}
			},
		    
		    init : function(imageCount, attachCount, maxImageCount, maxAttachCount){
		    	$.ProposalFile.IMAGE_COUNT = imageCount;
		    	$.ProposalFile.ATTACH_COUNT = attachCount;
		    	$.ProposalFile.MAX_IMAGE_COUNT = maxImageCount;
		    	$.ProposalFile.MAX_ATTACH_COUNT = maxAttachCount;
		    }

		};
	
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
		<span>주민참여예산제</span>
		<span>정책제안</span>
		<span>정책제안 등록하기</span>
	</div>

	<div class="boardWrite">

		<p class="writeTit" style="font-size: 14px;">※ 사진, 신청서 등의 파일 첨부는 PC(웹)에서만 가능합니다.</p>

		<p class="writeTit">신청인 정보 입력</p>
		<form name="dataFrm" id="dataFrm" method="post" enctype="multipart/form-data">
			<table cellpadding="0" cellspacing="0" class="tbL" summary="" >
				<colgroup>
					<col width="80"/><col width="*"/>
				</colgroup>
				<tbody>
				
					<c:choose>
						<c:when test="${_accountInfo.hasRole('USER')}">
							<tr>
								<th scope="row">신청인</th>
								<td><c:out value="${userInfo.userNm.decValue}" /></td>
							</tr>
							<tr>
								<th scope="row">연락처</th>
								<td><c:out value="${userInfo.phone.decValue}"/></td>
							</tr>
							<tr>
								<th scope="row">주소</th>
								<td><c:out value="${userInfo.emdNm}"/></td>
							</tr>
							<tr>
								<th scope="row">이메일</th>
								<td><c:out value="${userInfo.email.decValue}" /></td>
							</tr>
						
						</c:when>
<%-- 
						<c:when test="${userType eq 'PHONE'}">
							<tr>
								<th scope="row">신청인</th>
								<td><p class="inputBox"><input type="text" class="it " name="reqNm" id="reqNm" /></p></td>
							</tr>
							<tr>
								<th scope="row">연락처</th>
								<td><c:out value="${userInfo.phone}"/></td>
							</tr>
							<tr>
								<th scope="row">주소</th>
								<td><c:out value="${userInfo.emdNm}"/></td>
							</tr>
							<tr>
								<th scope="row">이메일</th>
								<td><p class="inputBox"><input type="text" class="it " name="reqEmail" id="reqEmail" /></p></td>
							</tr>
							
						</c:when>
--%>						
						<c:otherwise>
							<tr>
								<th scope="row">신청인</th>
								<td><p class="inputBox"><input type="text" class="it " name="reqNm" id="reqNm" /></p></td>
							</tr>
							<tr>
								<th scope="row">연락처11</th>
								<td>${userInfo.phone.decValue}</td>
							</tr>
							<tr>
								<th scope="row">주소</th>
								<td>
		                            <select name="reqAddr" id="reqAddr" title="주소 선택하기" class="wid100">
		                                <c:forEach items="${emdList}" var="item">
		                                    <option value="${item.regionCd}">${item.emdNm}</option>
		                                </c:forEach>
		                            </select>
								</td>
							</tr>
							<tr>
								<th scope="row">이메일</th>
								<td><p class="inputBox"><input type="text" class="it " name="reqEmail" id="reqEmail" /></p></td>
							</tr>
						</c:otherwise>
					</c:choose>
										
				</tbody>
			</table>
	
			<p class="writeTit">사업 정보 입력</p>
			<table cellpadding="0" cellspacing="0" class="tbL" summary="" >
				<colgroup>
					<col width="80"/><col width="*"/>
				</colgroup>
				<tbody>
				
					<c:forEach items="${realmList}" var="item" varStatus="status">
					<tr>
						<c:if test="${status.first}">
						<th scope="row" rowspan="${fn:length(realmList)}">구분</th>
						</c:if>
						<td>
							<input type="radio" class="" title="" value="${item.realmCd}" name="realmCd" id="select_${status.index}"/>
							<label for="select_${status.index}"><c:out value="${item.realmNm}"/></label>
						</td>
					</tr>
					</c:forEach>

					<tr>
						<th scope="row">공모선택</th>
						<td>
							<select name="psSeq" class="wid100">
								<option value="">상시공모</option>
								<c:if test="${not empty pssrp}">
								<option value="${pssrp.psSeq}"><c:out value="${pssrp.title}"/></option>
								</c:if>
							</select>
						</td>
					</tr>
								
					<tr>
						<th scope="row" colspan="2">사업명</th>
					</tr>
					<tr>
						<td colspan="2" class="bln">
							<p class="inputBox"><input type="text" class="it " name="bizNm" id="bizNm" maxlength="50" /></p>
							<strong>50자까지 입력 가능</strong>
						</td>
					</tr>
					<tr>
						<th scope="row">소요사업비</th>
						<td colspan="2" class="bln">
							<p class="inputBox"><input type="text" class="it " name="budget" id="budget" /></p>
						</td>
					</tr>
					<tr>
						<th scope="row" colspan="2">사업기간</th>
					</tr>
					<tr>
						<td colspan="2" class="bln">
							<p class="inputBox50">
								<span>
									<input type="text" class="it " title="" name="startDate" id="startDate" readonly="readonly"/>
									<a href="#"><img src="${siteImgPath}/sub1/cal.png" alt="" onclick="$('#startDate').focus(); return false;"/></a>
								</span>
							</p>
							<span class="wave">~</span>
							<p class="inputBox50">
								<span>
									<input type="text" class="it " title="" name="endDate" id="endDate" readonly="readonly"/>
									<a href="#"><img src="${siteImgPath}/sub1/cal.png" alt="" onclick="$('#endDate').focus(); return false;"/></a>
								</span>
							</p>
						</td>
					</tr>
					<tr>
						<th scope="row" colspan="2">사업위치</th>
					</tr>
					<tr>
						<td colspan="2" class="bln">
							<p class="inputBox"><input type="text" class="it " name="location" id="location" maxlength="50"/></p>
							<strong>50자까지 입력 가능</strong>
						</td>
					</tr>
					<tr>
						<th scope="row" colspan="2">제안취지</th>
					</tr>
					<tr>
						<td colspan="2" class="bln">
							<p class="textareaBox"><textarea name="necessity" id="necessity" style="text-indent: 0;"></textarea></p>
							<strong>2000자까지 입력 가능</strong>
						</td>
					</tr>
					<tr>
						<th scope="row" colspan="2">내용</th>
					</tr>
					<tr>
						<td colspan="2" class="bln">
							<p class="textareaBox"><textarea name="bizCont" id="bizCont" style="text-indent: 0;"></textarea></p>
							<strong>2000자까지 입력 가능</strong>
						</td>
					</tr>
					<tr>
						<th scope="row" colspan="2">기대효과</th>
					</tr>
					<tr>
						<td colspan="2" class="bln">
							<p class="textareaBox"><textarea name="effect" id="effect" style="text-indent: 0;"></textarea></p>
							<strong>2000자까지 입력 가능</strong>
						</td>
					</tr>
					
					<c:if test="${userType eq 'PROPOSAL'}">
					<tr>
						<th scope="row">비밀번호</th>
						<td>
							<p class="inputBox"><input type="password" class="it " name="reqPw" id="reqPw"/></p>
							<strong>※ 비밀번호를 입력해주세요.</strong>
						</td>
					</tr>
					</c:if>
					
					<tr>
						<th scope="row" colspan="2">사진 <a href="#" class="file" id="btnImageFile"><span>첨부</span></a></th>
					</tr>
					<tr>
						<td colspan="2" class="bln">
							<strong>※ 최대 3개의 파일을 첨부할 수 있습니다(파일 용량제한:2MB)</strong>
						</td>
					</tr>
					
					<tr id="imageTR" style="display: none;">
						<td colspan="2" class="bln" id="imageTD"></td>
					</tr>
					
					<tr>
						<th scope="row" colspan="2">신청서 등록 <a href="#" class="file" id="btnAttachFile"><span>첨부</span></a></th>
					</tr>
					<tr>
						<td colspan="2" class="bln">
							<strong>※ 최대 3개의 파일을 첨부할 수 있습니다(파일 용량제한:2MB)</strong>
						</td>
					</tr>
	
					<tr id="attachTR" style="display: none;">
						<td colspan="2" class="bln" id="attachTD"></td>
					</tr>
	
				</tbody>
			</table>

			<input type="hidden" name="psSeq" value="${psSeq}"/>
			
		</form>


		<p class="writeBt">
			<a href="#" class="blue" onclick="fnSave(); return false;">등록하기</a>
			<a href="#" class="gray" onclick="fnList(); return false;">목록보기</a>
		</p>
		
		<jsp:include page="/WEB-INF/views/mobile/proposal/proposal-search-form.jsp" />
		
	</div>

	<!-- footer -->
	<jsp:include page="/WEB-INF/views/mobile/common/footer.jsp"/>
	<!-- //footer -->
	
</div>

</body>
</html>