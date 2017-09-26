<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page contentType="text/html; charset=utf-8" %>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>
<!-- meta -->
<jsp:include page="/WEB-INF/views/admin/common/meta.jsp"/>
<!-- //meta -->
<script language="javascript" type="text/javascript">
//<![CDATA[
	$(document).ready(function(){
		var birthDateTmp = '${cmitContestReq.memInfo.birthDate}';
		var birthMonth = birthDateTmp.substring(0,2);
		var birthDay = birthDateTmp.substring(2,4);
		var birthDate= '${cmitContestReq.memInfo.birthYear}' + '.' + birthMonth +'.' + birthDay+'.' ;
		$("#birth").text(birthDate);
	});
	
	function remove(reqSeq){
		if(confirm("삭제하시겠습니까?")){
	 		$.ajax({
	 			url:"/admin/cmit/cmit_contest_reqRemove/"+reqSeq
	 			,type:'POST'
	 			,dataType:"json"
	 			,success: function(data){
	 				if(data==true){
	 					 var form  = $('<form></form>');
	 				     form.attr('action', '/admin/cmit/cmit_contest_reqList');
	 				     form.attr('method', 'post');
	 				     form.attr('target', 'iFrm');
	 				     form.appendTo('body');
	 				     
 	 				    var psSeq = $("<input type='hidden' value='${cmitContestReq.ps_seq}' name='ps_seq' id='ps_seq' >");
	 				     form.append(psSeq);
	 				     form.submit();
	 				}
	 			}
	 			 , error: function(xhr, status, error) {
	 				 alert();
	 	        	if (console && console.log) console.log("error : " + error.message);
	 	        }
	 		});
		}
	}

	function grantSubcmit(reqSeq, userSeq) {
		
		// 주민참여위원 권한을 설정하시겠습니까?
		if(!confirm('<spring:message code="message.admin.member.009" />')) {
			return;
		}
		
		$.ajax({
			type : "POST",
			url : "/admin/member/subcmit/grant",
			data: JSON.stringify({
				"reqSeq":reqSeq,
				"userSeq":userSeq
			}),
			contentType: "application/json; charset=utf-8",
			success : function(data) {
 				if(data == true) {
 					$("#spanUserType").text("주민참여위원 - " + $("#spanSubCmit").text());
 					$("#btnGrantSubCmit").hide();
 					$("#btnRevokeSubCmit").show();
 					// 주민참여위원 권한이 설정되었습니다.
					alert('<spring:message code="message.admin.member.008" />');
				}
			},
			error : function(error) {
				console.log(error);
			}
		});
	}

	function revokeSubcmit(userSeq) {
		
		// 주민참여위원 권한을 해제하시겠습니까?
		if(!confirm('<spring:message code="message.admin.member.003" />')) {
			return;
		}
		
		$.ajax({
			type : "POST",
			url : "/admin/member/subcmit/revoke",
			data: JSON.stringify({"userSeq":userSeq}),
			contentType: "application/json; charset=utf-8",
			success : function(data) {
 				if(data == true) {
 					$("#spanUserType").text("일반");
 					$("#btnGrantSubCmit").show();
 					$("#btnRevokeSubCmit").hide();
 					// 주민참여위원권한이 해제되었습니다.
					alert('<spring:message code="message.admin.member.007" />');
				}
			},
			error : function(error) {
				console.log(error);
			}
		});
	}
	
	$(function() {
		<c:if test="${cmitContestReq.memInfo.userType eq 'EMAIL'}">$("#btnGrantSubCmit").show();</c:if>
		<c:if test="${cmitContestReq.memInfo.userType eq 'CMIT'}">$("#btnRevokeSubCmit").show();</c:if>
	});
	
//]]>
</script>
</head>
<body>
	
		<!-- header -->
		<jsp:include page="/WEB-INF/views/admin/common/header.jsp"/>
	<!-- //header -->
		
	<div class="containerWrap">
		<div class="subNav">
			<ul class="subNavUl">
				<li class="subNavHome"><img src="${siteImgPath}/common/home.png" alt="home"/></li>
				<li>주민참여위원 공모</li>
				<li>상세보기</li>
			</ul>
		</div>

		<div class="container">
			<div class="contentWrap">

				<!--leftmenu-->
					<jsp:include page="/WEB-INF/views/admin/common/lnb.jsp"/>
				<!--//leftmenu-->
				
				<div class="content">
					<h3 class="contentTit">주민참여위원 신청서 상세보기</h3>
											
						<div class="mainContent">
							
							<div class="boardView boardView2">
								<p class="pTit2">신청인 정보</p>
								<table cellpadding="0" cellspacing="0" class="tbL" summary="제안사업 상세보기 - 등록자, 등록일, 조회수, 처리상태, 소요사업비, 사업기간, 사업위치, 제안취지, 내용, 기대효과를 보는 화면입니다." >
									<caption>제안사업 상세보기</caption>
									<colgroup>
										<col width="15%"/>
										<col width="35%"/>
										<col width="15%"/>
										<col width="35%"/>
									</colgroup>
							<table cellpadding="0" cellspacing="0" class="tbL" summary="제안사업 상세보기 - 등록자, 등록일, 조회수, 처리상태, 소요사업비, 사업기간, 사업위치, 제안취지, 내용, 기대효과, 사진, 신청서 등록 정보를 보는 화면입니다." >
						<caption>제안사업 상세보기</caption>
						<colgroup>
							<col width="15%"/>
							<col width="35"/>
							<col width="15%"/>
							<col width="35%"/>
						</colgroup>
						<tbody>
							<tr>
								<th scope="row">회원상태</th>
								<td colspan="3">		
									<c:choose>
									<c:when test="${cmitContestReq.memInfo.userStat eq 'AVAILABLE'}">회원</c:when>
									<c:when test="${cmitContestReq.memInfo.userStat eq 'WITHDRAWAL'}">탈퇴</c:when>
								</c:choose>
							</td>
							</tr>
							<tr>
								<th scope="row">신청인</th>
								<td>${cmitContestReq.memInfo.userNm.decValue}</td>
								<th scope="row">휴대폰번호</th>
								<td>${cmitContestReq.memInfo.phone.decValue}</td>
							</tr>
							<tr>
								<th scope="row">이메일</th>
								<td>${cmitContestReq.memInfo.email.decValue}</td>
								<th scope="row">연락처</th>
								<td>${cmitContestReq.phone}</td>
							</tr>
							<tr>
								<th scope="row">주소</th>
								<td colspan="3">
									<c:out value="${cmitContestReq.addr1}"/>&nbsp;
									<c:out value="${cmitContestReq.addr2}"/>
								</td>
							</tr>
							<tr>
								<th scope="row">생년월일</th>
								<td id="birth"></td>
								<th scope="row">직업</th>
								<td>${cmitContestReq.job}</td>
							</tr>
							<tr>
								<th scope="row">생년월일</th>
								<td colspan="3">
								<c:if test="${cmitContestReq.memInfo.gender eq 'M'}">
									남자
								</c:if>
								<c:if test="${cmitContestReq.memInfo.gender eq 'F'}">
									여자
								</c:if>
								</td>
							</tr>
							<tr>
								<th scope="row">권한</th>
								<td colspan="3">
									<span id="spanUserType" style="font-size: 14px; display: inline-block; line-height: 32px;">
									<c:if test="${cmitContestReq.memInfo.userType eq 'EMAIL'}">일반</c:if>
									<c:if test="${cmitContestReq.memInfo.userType eq 'CMIT'}">
										주민참여위원 - <c:out value="${cmitContestReq.memInfo.subcmitNm1}"/> 
										<c:if test="${not empty cmitContestReq.memInfo.subcmitNm2}">(<c:out value="${cmitContestReq.memInfo.subcmitNm2}"/>)</c:if>
									</c:if>
									</span>
									<p id="btnRevokeSubCmit" class="condition_btn" style="width: 200px; padding: 0 8px 0 0; float: right; display: none;">
										<a href="#" onclick="revokeSubcmit('${cmitContestReq.user_seq}'); return false;" class="c0" style="float: right; width: auto;">주민참여위원권한 해제</a>
									</p>
								</td>
							</tr>
							<tr>
								<th scope="row">희망분과</th>
								<td colspan="3">
									<span id="spanSubCmit" style="font-size: 14px; display: inline-block; line-height: 32px;">
										<c:out value="${cmitContestReq.subCmit1}"/>
										<c:if test="${not empty cmitContestReq.subCmit2 }">(<c:out value="${cmitContestReq.subCmit2}"/>)</c:if>
									</span>
									<p id="btnGrantSubCmit" class="condition_btn" style="width: 200px; padding: 0 8px 0 0; float: right; display: none;">
										<a href="#" onclick="grantSubcmit('${cmitContestReq.req_seq}', '${cmitContestReq.user_seq}'); return false;" class="c0" style="float: right; width: auto;">주민참여위원권한 설정</a>
									</p>
								</td>
							</tr>
							<tr>
								<th scope="row">자기소개서</th>
								<td colspan="3"><c:out value="${fn:replace(cmitContestReq.intro, crcn, br)}" escapeXml="false"/></td>
							</tr>
							<tr>
								<th scope="row">첨부파일</th>
									<td colspan="3">
									
									<c:if test="${not empty cmitContestReq.attachFile}">
										<p style="padding: 3px;"><a href="/file-download/${cmitContestReq.attachFile.fileSeq}"><c:out value="${cmitContestReq.attachFile.fileSrcNm}"/></a></p>
									</c:if>
									<c:if test="${not empty cmitContestReq.imageFile}">
										<p style="padding: 3px;"><a href="/file-download/${cmitContestReq.imageFile.fileSeq}"><c:out value="${cmitContestReq.imageFile.fileSrcNm}"/></a></p>
									</c:if>

								</td>
							</tr>
						</tbody>
					</table>
							</div>							
							
							<div class="tbBot">
								<div class="btnFr font">
									<a href="#" class="btn_gray" onclick = "remove(${cmitContestReq.req_seq})" >삭제하기</a>
									<a href="javascript:history.back()" class="btn_reset">목록보기</a>
								</div>
							</div>						
						</div>
					
				</div>

			</div><!--contentWrap-->

		</div><!--container-->
	</div><!--containerWrap-->

<!-- footer -->
	<jsp:include page="/WEB-INF/views/admin/common/footer.jsp"/>
<!-- //footer -->
	
</body>
</html>
