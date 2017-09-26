<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page contentType="text/html; charset=utf-8" %>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>

<!-- meta -->
<jsp:include page="/WEB-INF/views/front/common/meta.jsp"/>
<!-- //meta -->

<script language="javascript" type="text/javascript">
//<![CDATA[
	$(document).ready(function(){
		$('.gnb').topmenu({ d1: 3, d2: 4});
	});
	
	function modifyProc() {

		<c:if test="${empty _accountInfo}">
		if($("#append1").val() == "") {
			alert("<spring:message code='message.common.header.002' arguments='이름을'/>");
			$("#append1").focus();
			return;
		}
		if($("#append3").val() == "") {
			alert("<spring:message code='message.common.header.002' arguments='이메일을'/>");
			$("#append3").focus();
			return;
		} else {
			var regEmail = /([\w-\.]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([\w-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)$/;
	        if(!regEmail.test($("#append3").val())) {
	        	alert('<spring:message code="message.login.email.004"/>');
	            $("#append3").focus();
	            return;
	        }
		}
		</c:if>
		
		if($("#title").val() == "") {
			alert("<spring:message code='message.common.header.002' arguments='제목을'/>");
			$("#title").focus();
			return;
		}
		
		if($("#cont").val() == "") {
			alert("<spring:message code='message.common.header.002' arguments='내용을'/>");
			$("#cont").focus();
			return;
		}

		if($("#password").val() == "") {
			alert("<spring:message code='message.common.header.002' arguments='비밀번호를'/>");
			$("#password").focus();
			return;
		} else if($("#password").val().length < 6) {
			alert("<spring:message code='message.member.join.010'/>");
			return;
		}
		
		if($("#tmpSecYn").hasClass("on")) {
			$("#secYn").val("Y");
		} else {
			$("#secYn").val("N");
		}
		
		$("#boardForm").attr("action", "/board/${board.boardName}/modify-proc");
		$("#boardForm").attr("method", "POST");
		$("#boardForm").submit();
	}

	function list() {
		$("#searchForm").attr("action", "/board/${board.boardName}/list");
		$("#searchForm").attr("method", "POST");
		$("#searchForm").submit();		
	}
//]]>
</script>
</head>
<body>

<!-- header -->
<jsp:include page="/WEB-INF/views/front/common/header.jsp"/>
<!-- //header -->

<!-- board-breadcrumb -->
<jsp:include page="/WEB-INF/views/front/board/board-breadcrumb.jsp"/>
<!-- //board-breadcrumb -->

<div id="container" class="container">
	<div class="containerWrap">
	
		<!-- LNB -->
		<jsp:include page="/WEB-INF/views/front/common/lnb.jsp">
			<jsp:param name="menuName" value="notice"/>
		</jsp:include>
		<!-- //LNB -->
			
		<div class="contentsWrap">
			<h3 class="contentTit">문의하기</h3>
			<div class="contents">
				<div class="boardWrite">
					
					<form name="boardForm" id="boardForm" enctype="multipart/form-data">
				
					<input type="hidden" id="secYn" name="secYn"/>
					<input type="hidden" name="postSeq" value="${boardPost.postSeq}"/>
					
					<table cellpadding="0" cellspacing="0" class="tbL" summary="" >
						<caption>신청인 정보 입력하기</caption>
						<colgroup>
									<col width="15%"/>
									<col width="*"/>
						</colgroup>
						<tbody>
							<tr>
								<th>작성자</th>
								<td>
									<c:choose>
										<c:when test="${_accountInfo.hasRole('USER')}"><c:out value="${_accountInfo.userNm.decValue}"/></c:when>
										<c:otherwise><input type="text" name="append1" id="append1" value="${boardPost.append1}" placeholder=" 이름을 입력해주세요" style="width:350px; height:30px; border:1px solid #d3d0c9;"/></c:otherwise>
									</c:choose>
									<p>
										<span class="red2">※ 작성자 이름, 연락처, 이메일은 다른 사용자에게는 노출되지 않고 담당자에게만 공개됩니다.</span>
									</p>
								</td>
							</tr>
							<tr>
								<th>연락처</th>
								<td>
									<label for="P_number" class="P_number">휴대폰</label>
									<c:choose>
										<c:when test="${_accountInfo.hasRole('USER')}"><c:out value="${_accountInfo.phone.decValue}"/></c:when>
										<c:otherwise><c:out value="${boardPost.append2}"/></c:otherwise>
									</c:choose>
								</td>
							</tr>
							<tr>
								<th>이메일</th>
								<td>
									<c:choose>
										<c:when test="${_accountInfo.hasRole('USER')}"><c:out value="${_accountInfo.email.decValue}"/></c:when>
										<c:otherwise><input type="text" name="append3" id="append3" placeholder=" 이메일을 입력해주세요" value="${boardPost.append3}" style="width:350px; height:30px; border:1px solid #d3d0c9;"/></c:otherwise>
									</c:choose>
									<p>
										<span class="red2">※ 문의에 대한 답변은 이메일로 발송됩니다. 정확한 이메일을 입력해주세요.</span>
									</p>
								</td>
							</tr>
							<tr>
								<th>구분</th>
								<td colspan="3">
									<c:if test="${board.cateUseYn eq 'Y'}">
										<select id="categoryCd" name="categoryCd" title="문의내용 구분" class="wid100">
											<c:forEach items="${boardCategoryList}" var="list">
												<option value="${list.categoryCd}"><c:out value="${list.categoryNm}"/></option>
											</c:forEach>
										</select>
										<script>$("#categoryCd").val("${boardPost.categoryCd}");</script>
									</c:if>
									
									<c:if test="${board.secUseYn eq 'Y'}">
										<p class="closed_chk" ><a href="#" id="tmpSecYn" title="" class="chk">비공개문의</a></p>
										<c:if test="${boardPost.secYn eq 'Y'}">
											<script>$("#tmpSecYn").addClass("on");</script>
										</c:if>
										<p>
											<span class="red2">※ 비공개문의 선택 시 문의내용이 공개되지 않습니다.</span>
										</p>
									</c:if>
									
								</td>
							</tr>
							<tr>
								<th>제목</th>
								<td>
									<input type="text" name="title" id="" value="${boardPost.title}" style="width:580px; height:30px; border:1px solid #d3d0c9;"/>
								</td>
							</tr>
							<tr>
								<th scope="row">문의내용</th>
								<td colspan="3">
									<div class="writeW">
										<textarea name="cont" cols="10" rows="10" title="제안취지 입력" style="width:570px;"><c:out value="${boardPost.cont}"/></textarea>
									</div>
								</td>
							</tr>
							
							<c:if test="${!_accountInfo.hasRole('USER')}">
							<tr>
								<th scope="row">비밀번호</th>
								<td colspan="3">
									<input type="password" name="password" id="password" style="width:350px; height:30px; border:1px solid #d3d0c9;"/>
									<p>
										<span class="red2">※ 글 작성 시 등록한 비밀번호를 입력하세요</span>
									</p>
								</td>
							</tr>
							</c:if>
							
						</tbody>
						<script language="javascript" type="text/javascript">
						//<![CDATA[
						 false;
							$('.closed_chk').find('.chk').on('click',function(){
								if ($(this).hasClass('on')){
									$(this).removeClass('on');
								}else{
									$(this).addClass('on');
								}
								return false;
							})
						//]]>
						</script>
					</table>
					
					</form>
					
				</div>
				<div class="btnR">
					<a href="#" class="btn_blue" onclick="modifyProc(); return false;">수정하기</a>
					<a href="#" class="btn_reset" onclick="list(); return false;">취소</a>
				</div>
				
				<jsp:include page="/WEB-INF/views/front/board/board-search-form.jsp" />
				
			</div>
		</div>
	</div>
</div>

<!-- footer -->
<jsp:include page="/WEB-INF/views/front/common/footer.jsp"/>
<!-- //footer -->

</body>
</html>
