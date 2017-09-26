<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page contentType="text/html; charset=utf-8" %>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>

<!-- meta -->
<jsp:include page="/WEB-INF/views/mobile/common/meta.jsp"/>
<!-- //meta -->

<link href="${siteCssPath}/board.css" type="text/css" rel="stylesheet"  />

<script language="javascript" type="text/javascript">

	$(function() {
		gfnSetPeriodDatePicker("startDate", "endDate");
	});
	
	function fnList() {
		$("#_tempFrm").attr("action", "/proposal/list");
		$("#_tempFrm").attr("method", "POST");
		$("#_tempFrm").submit();
	}
	

	function fnSave() {
		<c:if test="${!_accountInfo.hasRole('USER')}">
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
		<c:if test="${!_accountInfo.hasRole('USER')}">
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
	    	<c:if test="${_accountInfo.hasRole('USER')}">
	    	$("#dataFrm").prop("action", "<c:url value="/proposal/save" />").submit();    	
	    	</c:if>
	    	<c:if test="${!_accountInfo.hasRole('USER')}">
	    	$("#dataFrm").prop("action", "<c:url value="/proposal/visitor/save" />").submit();    	
	    	</c:if>
	    }
		
	}

	$(function() {
		$("#btnImageFile").on('click', $.ProposalFile.btnImageFile);
		$("#btnAttachFile").on('click', $.ProposalFile.btnAttachFile);
		var imageCount = "${fn:length(imageFileList)}";
		var attachCount = "${fn:length(attachFileList)}";
		$.ProposalFile.init(imageCount, attachCount, 3, 3);
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
				var attachTag = "<p class='file' style='height: auto;'><a href='#' class='fileName'>" + fileName + "</a><a href='#' class='fileDel' onclick='$(this).parent().remove(); $.ProposalFile.removeAttach(" + fileIndex + "); return false;'>삭제하기</a></p>";
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
		    
			deleteImageFile : function(fileSeq) {
				$('<input type="hidden" name="deleteFileSeq" />').val(fileSeq).appendTo("#dataFrm");
				$.ProposalFile.IMAGE_COUNT--;
				$("#btnImageFile").show();
			},
			
			deleteAttachFile : function(fileSeq) {
				$('<input type="hidden" name="deleteFileSeq" />').val(fileSeq).appendTo("#dataFrm");
				$.ProposalFile.ATTACH_COUNT--;
				$("#btnAttachFile").show();
			},
			
		    init : function(imageCount, attachCount, maxImageCount, maxAttachCount){
		    	$.ProposalFile.IMAGE_COUNT = imageCount;
		    	$.ProposalFile.ATTACH_COUNT = attachCount;
		    	$.ProposalFile.MAX_IMAGE_COUNT = maxImageCount;
		    	$.ProposalFile.MAX_ATTACH_COUNT = maxAttachCount;
				if($.ProposalFile.IMAGE_COUNT >= $.ProposalFile.MAX_IMAGE_COUNT) {
					$("#btnImageFile").hide();
				}
				if($.ProposalFile.ATTACH_COUNT >= $.ProposalFile.MAX_ATTACH_COUNT) {
					$("#btnAttachFile").hide();
				}
		    }

		};
	
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
		<span>정책제안 수정하기</span>
	</div>

	<div class="boardWrite">
		<span class="writeTit">신청인 정보 입력</span>
		<span class="lastChange">최종수정일: 
		<c:choose>
			<c:when test="${not empty proposal.modDate}"><fmt:formatDate pattern="yyyy.MM.dd" value="${proposal.modDate}" /></c:when>
			<c:otherwise><fmt:formatDate pattern="yyyy.MM.dd" value="${proposal.regDate}" /></c:otherwise>
		</c:choose>
		</span>
		
		<form name="dataFrm" id="dataFrm" method="post" enctype="multipart/form-data">
			
			<input type="hidden" name="propSeq" id="propSeq" value="${proposal.propSeq}"/>
			
			<table cellpadding="0" cellspacing="0" class="tbL editNone" summary="" >
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
								<td><p class="inputBox"><input type="text" class="it " name="reqNm" id="reqNm" value="${userInfo.userNm}"/></p></td>
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
								<td><p class="inputBox"><input type="text" class="it" name="reqEmail" id="reqEmail" value="${userInfo.email}"/></p></td>
							</tr>
						</c:when>
--%>						
						<c:otherwise>
							<tr>
								<th scope="row">신청인</th>
								<td><p class="inputBox"><input type="text" class="it " name="reqNm" id="reqNm" value="${proposal.reqNm.decValue}"/></p></td>
							</tr>
							<tr>
								<th scope="row">연락처</th>
								<td><c:out value="${proposal.reqPhone.decValue}"/></td>
							</tr>
							<tr>
								<th scope="row">주소</th>
								<td>
		                            <select name="reqAddr" id="reqAddr" title="주소 선택하기" class="wid100">
		                                <c:forEach items="${emdList}" var="item">
		                                    <option value="${item.regionCd}">${item.emdNm}</option>
		                                </c:forEach>
		                            </select>
		                            <script>$("#reqAddr").val("${proposal.reqAddr}");</script>
								</td>
							</tr>
							<tr>
								<th scope="row">이메일</th>
								<td><p class="inputBox"><input type="text" class="it" name="reqEmail" id="reqEmail" value="${proposal.reqEmail.decValue}"/></p></td>
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
							<c:set var="tmpChecked">
								<c:if test="${proposal.realmCd eq item.realmCd}">checked="checked"</c:if>
							</c:set>
							<input type="radio" class="" title="" value="${item.realmCd}" name="realmCd" id="select_${status.index}" ${tmpChecked}/>
							<label for="select_${status.index}"><c:out value="${item.realmNm}"/></label>
							
						</td>
					</tr>
					</c:forEach>
					
					<tr>
						<th scope="row" colspan="2">사업명</th>
					</tr>
					<tr>
						<td colspan="2" class="bln">
							<p class="inputBox"><input type="text" class="it " name="bizNm" id="bizNm" value="${proposal.bizNm}"/></p>
							<strong>50자까지 입력 가능</strong>
						</td>
					</tr>
					<tr>
						<th scope="row">소요사업비</th>
						<td colspan="2" class="bln">
							<p class="inputBox"><input type="text" class="it " name="budget" id="budget" value="${proposal.budget}"/></p>
						</td>
					</tr>
					<tr>
						<th scope="row" colspan="2">사업기간</th>
					</tr>
					<tr>
						<td colspan="2" class="bln">
							<p class="inputBox50">
								<span>
									<input type="text" class="it " name="startDate" id="startDate" value="${proposal.startDate}" readonly="readonly"/>
									<a href="#" onclick="$('#startDate').focus(); return false;"><img src="${siteImgPath}/sub1/cal.png" alt=""/></a>
								</span>
							</p>
							<span class="wave">~</span>
							<p class="inputBox50">
								<span>
									<input type="text" class="it " name="endDate" id="endDate" value="${proposal.endDate}" readonly="readonly"/>
									<a href="#" onclick="$('#endDate').focus(); return false;"><img src="${siteImgPath}/sub1/cal.png" alt=""/></a>
								</span>
							</p>
						</td>
					</tr>
					<tr>
						<th scope="row" colspan="2">사업위치</th>
					</tr>
					<tr>
						<td colspan="2" class="bln">
							<p class="inputBox"><input type="text" class="it " name="location" id="location" value="${proposal.location}"/></p>
							<strong>50자까지 입력 가능</strong>
						</td>
					</tr>
					<tr>
						<th scope="row" colspan="2">제안취지</th>
					</tr>
					<tr>
						<td colspan="2" class="bln">
							<p class="textareaBox"><textarea name="necessity" id="necessity" cols="" rows="" title=""><c:out value="${proposal.necessity}"/></textarea></p>
							<strong>2000자까지 입력 가능</strong>
						</td>
					</tr>
					<tr>
						<th scope="row" colspan="2">내용</th>
					</tr>
					<tr>
						<td colspan="2" class="bln">
							<p class="textareaBox"><textarea name="bizCont" id="bizCont" cols="" rows="" title=""><c:out value="${proposal.bizCont}"/></textarea></p>
							<strong>2000자까지 입력 가능</strong>
						</td>
					</tr>
					<tr>
						<th scope="row" colspan="2">기대효과</th>
					</tr>
					<tr>
						<td colspan="2" class="bln">
							<p class="textareaBox"><textarea name="effect" id="effect" cols="" rows="" title=""><c:out value="${proposal.effect}"/></textarea></p>
							<strong>2000자까지 입력 가능</strong>
						</td>
					</tr>
					
					<c:if test="${!_accountInfo.hasRole('USER')}">
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
							<strong>※ gif, jpg, jpeg, png형식의 이미지 파일만 첨부할 수 있습니다<br/>※ 최대 3개의 파일을 첨부할 수 있습니다(파일 용량제한: 2MB)</strong>
						</td>
					</tr>
					<tr id="imageTR">
						<td colspan="2" class="bln" id="imageTD">
							<c:if test="${not empty imageFileList}">
								<c:forEach items="${imageFileList}" var="list">
									<dl class="photo1">
										<dt><c:out value="${list.fileSrcNm}"/></dt>
										<dd><img src="/file-download/${list.fileSeq}" alt=""/><a href="#" onclick="$.ProposalFile.deleteImageFile('${list.fileSeq}'); $(this).parent().parent().remove(); return false;"><img src="${siteImgPath}/sub1/photoDel.png" alt=""/></a></dd>
									</dl>
								</c:forEach>
							</c:if>
						</td>
					</tr>
					
					<tr>
						<th scope="row" colspan="2">신청서 등록 <a href="#" class="file" id="btnAttachFile"><span>첨부</span></a></th>
					</tr>
					<tr>
						<td colspan="2" class="bln">
							<strong>※한글파일(hwp)만 첨부할 수 있습니다<br/>※ 최대 3개의 파일을 첨부할 수 있습니다(파일 용량제한: 2MB)</strong>
						</td>
					</tr>
					<tr id="attachTR">
						<td colspan="2" class="bln" id="attachTD">
							<c:if test="${not empty attachFileList}">
								<c:forEach items="${attachFileList}" var="list">
									<p class="file" style="height: auto;">
										<a href="/file-download/${list.fileSeq}" class="fileName"><c:out value="${list.fileSrcNm}"/></a>
										<a href="#" class="fileDel" onclick="$.ProposalFile.deleteAttachFile('${list.fileSeq}'); $(this).parent().remove(); return false;">삭제하기</a>
									</p>
								</c:forEach>
							</c:if>
						</td>
					</tr>
					
				</tbody>
			</table>

		</form>
		
		<p class="writeBt">
			<a href="#" class="blue" onclick="fnSave(); return false;">저장하기</a>
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