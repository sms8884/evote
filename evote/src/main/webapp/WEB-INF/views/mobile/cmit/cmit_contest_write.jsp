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
		var birthDateTmp = '${formInfo.memInfo.birthDate}';
		var birthMonth = birthDateTmp.substring(0,2);
		var birthDay = birthDateTmp.substring(2,4);
		var birthDate= '${formInfo.memInfo.birthYear}' + '.' + birthMonth +'.' + birthDay+'.' ;
		$("#birth").text(birthDate);
		});
	
	function fnSave(){
		
		if( !$("#ck_terms").hasClass("on") ) {
			// 필수 항목에 동의해야 진행할 수 있습니다
			alert('<spring:message code="message.member.join.001" />');
			$("#ck_terms").focus();
			return;
		}
		
		if(gfnValidation($("#phone"),"<spring:message code='message.common.header.002' arguments='연락처를'/>") == false){
	        return;
	    }
	
		if(gfnValidation($("#addr2"),"<spring:message code='message.common.header.002' arguments='주소를'/>") == false){
	        return;
	    }
		if(gfnValidation($("#job"),"<spring:message code='message.common.header.003' arguments='직업을'/>") == false){
	        return;
	    }
		if(gfnValidation($("#subCmit1"),"<spring:message code='message.common.header.002' arguments='위원회'/>") == false){
	        return;
	    }
		if(gfnValidation($("#intro"),"<spring:message code='message.common.header.002' arguments='자기소개를'/>") == false){
	        return;
	    }
		
		if($("#subCmit1").val() == "C01" && $("#subCmit2").val()=="") {
 			alert("<spring:message code='message.common.header.002' arguments='분과를'/>");
 			$("#subCmit2").focus();
 			return;
 		}
		var regNumber = /^[0-9]*$/;
 		if(!regNumber.test($("#phone").val())) {
 		    alert('연락처는 숫자만 입력해주세요.');
 		   $("#phone").focus();
 		    return;
 		}
 		
 		
 		if(!$(".fileName").text()){
 			alert("신청서를 등록해주세요")
 			return;
 		}
 		
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
	    
	    $("#cmitContestForm").attr("action", "/cmit/cmit_contest_write");
  		$("#cmitContestForm").attr("method", "POST");
  		$("#cmitContestForm").submit();
		
	}
 	
	$(function() {
		$("#btnImageFile").on('click', $.ProposalFile.btnImageFile);
		$("#btnAttachFile").on('click', $.ProposalFile.btnAttachFile);
	});
	
	$.ProposalFile = {
			
			IMAGE_COUNT : 0,
			ATTACH_COUNT : 0,
			MAX_IMAGE_COUNT : 1,
			MAX_ATTACH_COUNT : 1,
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
	
	/* 분과선택하기  */
	function selectCmit1(){
	
		if($("#subCmit1").val() == 'C01'){
			$("#subCmit2").text('');
			var list = new Array(); 
			var cmitStr = '';
			'<c:forEach var="item" items="${formInfo.subCmit2}" >'
				cmitStr +='<option value="'+"${item.cdId}"+'">'+"${item.cdNm}"+'</option>'
			'</c:forEach>'
			$("#subCmit2").append(cmitStr);
			}else{
				$("#subCmit2").text('');
				var cmitStr = '<option value="">분과선택없음</option>'
				$("#subCmit2").append(cmitStr);	
			}
				
	}
/*//분과선택하기  */
	/* 취소하기 */
	function cancel(){
		if(confirm("입력된 항목이 저장되지 않습니다. 계속하시곘습니까?")){
			history.back();
		}
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
		<span>신청하기</span>
	</div>
	
	<div class="boardWrite">
		
		<p class="writeTit">은평구 개인정보수집ㆍ이용 동의서</p>
		
		<ul class="chkArea" style="height: 250px;">
		
			<li style="font-size: 13px; font-weight: bold; line-height: 22px;">
				- 개인정보의 수집, 이용 목적 : 주민참여위원회 위원 선정 및 위원회 운영관련 사항<br/>
				- 개인정보 수집항목 : 성명, 생년월일, 성별, 주소, 연락처(자택,직장,휴대폰), 이메일<br/>
				- 개인정보 보유 및 이용기간 : 위원 모집 ~ 해촉시까지<br/>
				- 동의 거부 권리안내 : 신청자는 본 개인정보 수집, 이용에 대한 동의를 거부할 수 있으며 이 경우 주민참여위원회 위원 신청이 제한됩니다.<br/>
				- 개인정보 수집 담당자 : 은평구청 희망마을담당관<br/>&nbsp;&nbsp;(☎ : 351-6473~5)<br/>
				<a href="#;" class="chk" id="ck_terms">개인정보수집ㆍ이용 동의서에 동의합니다.<span>(필수)</span></a>
			</li>
		</ul>
	
		<script language="javascript" type="text/javascript">
		//<![CDATA[
			$('#ck_terms').on('click',function(){
				if ($(this).hasClass('on')){
					$(this).removeClass('on');
				}else{
					$(this).addClass('on');
				}
			});
		//]]>
		</script>
	
	</div>


<form method="post" class="searchTb" id="cmitContestForm" name="cmitContestForm"  enctype="multipart/form-data">
	<div class="boardWrite">

		<p class="writeTit">신청인 정보 입력</p>
		<table cellpadding="0" cellspacing="0" class="tbL" summary="" >
			<colgroup>
				<col width="80"/><col width="*"/>
			</colgroup>
			<tbody>
				<tr>
					<th scope="row">신청인</th>
					<td>${formInfo.memInfo.userNm.decValue}</td>
				</tr>
				<tr>
					<th scope="row">휴대폰번호</th>
					<td>${formInfo.memInfo.phone.decValue}</td>
				</tr>
				<tr>
					<th scope="row">이메일</th>
					<td>${formInfo.memInfo.email.decValue}</td>
				</tr>
				<tr>
					<th scope="row">연락처</th>
					<td><p class="inputBox"><input type="text" class="it " id="phone" name="phone"/></p></td>
				</tr>
				<tr>
					<th scope="row">주소</th>
					<td>
						
						<select name="addr1" id="addr1" class="wid100">
							<c:forEach var="list" items="${emdList}">
								<option value="<c:out value="${list.emdNm}"/>"><c:out value="${list.emdNm}"/></option>
							</c:forEach>
						</select>
						
						<%-- <p class="inputBox"><input type="text" name="addr1" id="addr1" readonly="readonly" value="${formInfo.memInfo.emdNm}"/></p> --%>
						
						<p class="inputBox"><input type="text" name="addr2" id="addr2" /></p>
					</td>
				</tr>
				<tr>
					<th scope="row">생년월일</th>
					<td id="birth"></td>
				</tr>
				<tr>
					<th scope="row">직업</th>
					<td><p class="inputBox"><input type="text" class="it " id="job" name="job"/></p></td>
				</tr>
				<tr>
					<th scope="row">성별</th>
					<td>	
						   	<c:if test="${formInfo.memInfo.gender eq 'M'}">남성</c:if>
							<c:if test="${formInfo.memInfo.gender eq 'F'}">여성	</c:if>
						</td>
				</tr>
				<tr>
					<th scope="row">희망분과</th>
					<td>
					<select  id="subCmit1" name="subCmit1" title="분과선택"  onchange="selectCmit1()">
										<option value="" selected="selected">〓위원회 선택〓</option>
										<c:forEach var="item" items="${formInfo.subCmit1}"  end="3">
											<option value="${item.cdId}" >${item.cdNm}</option>
										</c:forEach>
									</select>
									<select  id="subCmit2" name="subCmit2" title="분과선택" >
										<option value="" selected="selected">〓분과 선택〓</option>
									</select>
					</td>
				</tr>
					<tr>
					<th scope="row" colspan="2">자기소개서</th>
				</tr>
				<tr>
					<td colspan="2" class="bln">
						<p class="textareaBox"><textarea name="intro" id="intro" cols="" rows="" title="" style="text-indent: 0px;"></textarea></p>
					</td>
				</tr>
				<!-- ///////// -->
				<tr>
						<th scope="row" colspan="2">사진 <a href="#" class="file" id="btnImageFile"><span>첨부</span></a></th>
					</tr>
					<tr>
						<td colspan="2" class="bln">
							<strong>※ gif, jpg, jpeg, png형식의 이미지 파일만 등록할 수 있습니다</strong>
						</td>
					</tr>
					
					<tr id="imageTR" style="display: none;">
						<td colspan="2" class="bln" id="imageTD"></td>
					</tr>
					
					<tr>
						<th scope="row" colspan="2">신청서 등록<a href="#" class="file" id="btnAttachFile"><span>첨부</span></a></th>
					</tr>
					<tr>
						<td colspan="2" class="bln">
							<strong>※ hwp 파일만 등록이 가능합니다 (용량제한 : 2MB).</strong>
						</td>
					</tr>
					<tr id="attachTR" style="display: none;">
						<td colspan="2" class="bln" id="attachTD"></td>
					</tr>
				<!-- ///////// -->
			</tbody>
		</table>			
		<p class="writeBt">
			<a href="javascript:cancel()" class="gray">취소</a>
			<a href="javascript:fnSave()" class="blue">등록하기</a>
		</p>
	</div>
	<input type="hidden" value="${formInfo.ps_seq}" name="ps_seq"  id="ps_seq"/>
	</form>

	<!-- footer -->
	<jsp:include page="/WEB-INF/views/mobile/common/footer.jsp"/>
	<!--// footer -->
</div>

</body>
</html>
