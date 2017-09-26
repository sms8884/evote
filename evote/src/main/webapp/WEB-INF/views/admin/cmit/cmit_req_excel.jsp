<%@ page contentType="text/html; charset=utf-8" %>
<% response.setHeader("Content-Disposition","attachment;filename=cmitReq_list.xls"); %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
</head>
<body>
	
	<table border="1">
		<thead>
			<tr>
				<th scope="col">No.</th>
				<th scope="col">신청일</th>
				<th scope="col">신청인</th>
				<th scope="col">회원상태</th>
				<th scope="col">핸드폰번호</th>
				<th scope="col">이메일</th>
				<th scope="col">성별</th>
				<th scope="col">주소</th>
				<th scope="col">생년월일</th>
				<th scope="col">직업</th>
				<th scope="col">위원회</th>
				<th scope="col">분과</th>
				<th scope="col">자기소개서</th>
			</tr>
		</thead>
		<tbody>
		
			<c:if test="${not empty list}">
				<c:forEach items="${list}" var="list" varStatus="status">
					<tr>
						<td><c:out value="${status.index + 1}" /></td>
						<td><fmt:formatDate value="${list.reg_date}" pattern="yyyy-MM-dd"/></td>
						<td><c:out value="${list.user_nm}"/></td>
						
						<td>
							<c:choose>
								<c:when test="${list.user_stat eq 'AVAILABLE'}">회원</c:when>
								<c:when test="${list.user_stat eq 'WITHDRAWAL'}">탈퇴</c:when>
							</c:choose>
						</td>
						
						<td style='mso-number-format:\@'><c:out value="${list.phone}"/></td>
						<td><c:out value="${list.email}"/></td>
						<td>
							<c:if test="${list.gender eq 'M'}">남</c:if>
							<c:if test="${list.gender eq 'F'}">여</c:if>
						</td>
						<td><c:out value="${list.addr1}"/></td>
						<td><c:out value="${list.birth_year}"/> <c:out value="${list.birth_date}"/></td>
						<td><c:out value="${list.job}"/></td>
						<td><c:out value="${list.subCmit1}"/></td>
						<td><c:out value="${list.subCmit2}"/></td>
						<td><c:out value="${list.intro}"/></td>
					</tr>
				</c:forEach>
			</c:if>
			
		</tbody>
	</table>

	
</body>
</html>
