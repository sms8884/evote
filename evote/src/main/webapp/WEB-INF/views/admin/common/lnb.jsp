<%@ page contentType="text/html; charset=utf-8" %>

<div class="ad_leftmenu">
	<h2>관리자메뉴</h2>
	
	<c:choose>
		<c:when test="${not empty gnbList}">
			<dl class="lnbmenuDl">
				<c:forEach items="${gnbList}" var="list" varStatus="status">
				
					<c:if test="${status.first}">
						<dt><a href="${list.menuUrl}"><c:out value="${list.menuNm}"/></a></dt>
						<dd>
							<ul class="">
					</c:if>
				
					<c:if test="${list.level eq 1 and status.index gt 0}">
							</ul>
						</dd>
						<dt><a href="${list.menuUrl}"><c:out value="${list.menuNm}"/></a></dt>
						<dd>
							<ul class="">
					</c:if>
					
					<c:if test="${list.level eq 2}">
						<li><a href="${list.menuUrl}"><c:out value="${list.menuNm}"/></a></li>
					</c:if>
					
					<c:if test="${status.last}">
							</ul>
						</dd>
					</c:if>
					
				</c:forEach>
			</dl>
		</c:when>
		
		<c:otherwise>
			<dl class="lnbmenuDl">
				<dt><a href="#">제안</a></dt>
				<dd>
					<ul class="">
						<li><a href="/admin/proposal/proposal_list">제안</a></li>
						<li><a href="/admin/proposal/proposal_review_list">검토완료</a></li>
						<li><a href="/admin/proposal/contest_list">공모관리</a></li>
					</ul>
				</dd>
				<dt><a href="#">투표</a></dt>
				<dd>
					<ul class="">
						<li><a href="/admin/vote/vote_list">투표관리</a></li>
						<li><a href="/admin/vote/realm_mst">투표분야</a></li>
					</ul>
				</dd>
				<dt><a href="#">설문</a></dt>
				<dd>
					<ul class="">
						<li><a href="javascript:preparing();">설문관리</a></li>
						<li><a href="javascript:preparing();">설문결과</a></li>
					</ul>
				</dd>
				<dt><a href="javascript:preparing();">사업현황</a></dt>
				<dd></dd>
				<dt><a href="#">주민알림</a></dt>
				<dd>
					<ul class="">
						<li><a href="/admin/notice/list">공지사항</a></li>
						<li><a href="javascript:preparing();">갤러리</a></li>
						<li><a href="javascript:preparing();">자료실</a></li>
						<li><a href="javascript:preparing();">팝업/배너관리</a></li>
						<li><a href="javascript:preparing();">문의하기</a></li>
					</ul>
				</dd>
				<dt><a href="#">사용자관리</a></dt>
				<dd>
					<ul class="">
						<li><a href="javascript:preparing();">선택동의자</a></li>
						<li><a href="javascript:preparing();">댓글관리</a></li>
						<li><a href="javascript:preparing();">회원</a></li>
					</ul>
				</dd>
				<dt><a href="javascript:preparing();">주민참여위원회</a></dt>
				<dd>
					<ul class="">
						<li><a href="javascript:preparing();">위원회활동</a></li>
						<li><a href="javascript:preparing();">주민참여위원신청서</a></li>
					</ul>
				</dd>
				<dt><a href="#">예산학교</a></dt>
				<dd>
					<ul class="">
						<li><a href="javascript:preparing();">활동</a></li>
					</ul>
				</dd>
				<dt><a href="javascript:preparing();">권한관리</a></dt>
				<dd></dd>
			</dl>
		</c:otherwise>
	</c:choose>
	
	

	
</div>