<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page contentType="text/html; charset=utf-8" %>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>

<!-- meta -->
<jsp:include page="/WEB-INF/views/mobile/common/meta.jsp"/>
<!-- //meta -->
<link href="${siteCssPath}/board.css" type="text/css" rel="stylesheet"  />

<script language="javascript" type="text/javascript">

	function writeProc() {
		
		<c:if test="${userType eq 'QNA'}">
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
		
		<c:if test="${userType eq 'QNA'}">
		if($("#password").val() == "") {
			alert("<spring:message code='message.common.header.002' arguments='비밀번호를'/>");
			$("#password").focus();
			return;
		} else if($("#password").val().length < 6) {
			alert("<spring:message code='message.member.join.010'/>");
			return;
		}
	    </c:if>
	    
		if($("#tmpSecYn").is(":checked")) {
			$("#secYn").val("Y");
		} else {
			$("#secYn").val("N");
		}
		
		$("#boardForm").attr("action", "/board/${board.boardName}/write-proc");
		$("#boardForm").attr("method", "POST");
		$("#boardForm").submit();
	}

	function list() {
		$("#searchForm").attr("action", "/board/${board.boardName}/list");
		$("#searchForm").attr("method", "POST");
		$("#searchForm").submit();		
	}

</script>

</head>
<body>

<!-- header -->
<jsp:include page="/WEB-INF/views/mobile/common/header.jsp"/>
<!-- //header -->

<div class="wrap">

	<!-- board-breadcrumb -->
	<jsp:include page="/WEB-INF/views/mobile/board/board-breadcrumb.jsp"/>
	<!-- //board-breadcrumb -->

	<div class="boardWrite">

		<p class="writeTit">문의하기</p>
		
		<form name="boardForm" id="boardForm" enctype="multipart/form-data">
		
		<input type="hidden" id="secYn" name="secYn"/>
		
		<table cellpadding="0" cellspacing="0" class="tbL" summary="" >
			<colgroup>
				<col width="80"/><col width="*"/>
			</colgroup>
			<tbody>
				<tr>
					<th scope="row">작성자</th>
					<td>
						<c:choose>
							<c:when test="${_accountInfo.hasRole('USER')}"><c:out value="${_accountInfo.userNm.decValue}"/></c:when>
							<c:otherwise><p class="inputBox"><input type="text" class="it " name="append1" id="append1" placeholder=" 이름을 입력해주세요"/></p></c:otherwise>
						</c:choose>
						<strong>※ 작성자 이름, 연락처, 이메일은 다른 사용자에게는 노출되지 않고 담당자에게만 공개됩니다</strong>
					</td>
				</tr>
				<tr>
					<th scope="row">연락처</th>
					<td>
						<c:if test="${_accountInfo.hasRole('USER') or userType eq 'QNA'}">
							<c:out value="${_accountInfo.phone.decValue}"/>
						</c:if>
					</td>
				</tr>
				<tr>
					<th scope="row">이메일</th>
					<td>
						<c:choose>
							<c:when test="${_accountInfo.hasRole('USER')}"><c:out value="${_accountInfo.email.decValue}"/></c:when>
							<c:otherwise><p class="inputBox"><input type="text" class="it " name="append3" id="append3" placeholder=" 이메일을 입력해주세요"/></p></c:otherwise>
						</c:choose>
						<strong>※ 문의에 대한 답변은 이메일로 발송됩니다. 정확한 이메일을 입력해주세요.</strong>
					</td>
				</tr>
				<tr>
					<th scope="row">구분</th>
					<td>
						<c:if test="${board.cateUseYn eq 'Y'}">
							<select id="categoryCd" name="categoryCd" title="문의내용 구분" style="width:100px;">
								<c:forEach items="${boardCategoryList}" var="list">
									<option value="${list.categoryCd}"><c:out value="${list.categoryNm}"/></option>
								</c:forEach>
							</select>
						</c:if>
						<c:if test="${board.secUseYn eq 'Y'}">
							<label><input type="checkbox" class="ip " id="tmpSecYn" value="" name=""/>비공개 문의</label>
							<strong>※ 비공개문의 선택 시 문의내용이 공개되지 않습니다</strong>
						</c:if>
					</td>
				</tr>
				<tr>
					<th scope="row">제목</th>
					<td><p class="inputBox"><input type="text" class="it " name="title" id="title"/></p></td>
				</tr>
				<tr>
					<th scope="row" colspan="2">문의내용</th>
				</tr>
				<tr>
					<td colspan="2" class="bln">
						<p class="textareaBox"><textarea name="cont" id="cont" style="text-indent:0px;"></textarea></p>
						<strong>2000자까지 입력 가능</strong>
					</td>
				</tr>
				
				<c:if test="${userType eq 'QNA'}">
					<tr>
						<th scope="row">비밀번호</th>
						<td>
							<p class="inputBox"><input type="password" class="it " name="password" id="password"/></p>
							<strong>※ 비밀번호를 입력해주세요.</strong>
						</td>
					</tr>
				</c:if>
				
			</tbody>
		</table>
		
		</form>
		
		<p class="writeBt">
			<a href="#" class="blue" onclick="writeProc(); return false;">등록하기</a>
			<a href="#" class="gray" onclick="list(); return false;">목록보기</a>
		</p>
	</div>

	<jsp:include page="/WEB-INF/views/mobile/board/board-search-form.jsp" />
	
	<!-- footer -->
	<jsp:include page="/WEB-INF/views/mobile/common/footer.jsp"/>
	<!--// footer -->
	
</div>

</body>
</html>
