<%@ page contentType="text/html; charset=utf-8" %>

<div id="header">
	<h1 class="logo"><a href="/"><spring:message code="default.mobile.title" /></a></h1>
	<a href="#" class="topBt"><img src="${siteImgPath}/common/topBt_off.png" alt=""/></a>
	<jsp:include page="/WEB-INF/views/mobile/common/topMenu.jsp"/>

<!-- GNB -->
<ul class="gnb">

	<c:choose>
		<c:when test="${not empty gnbList}">
			
			<c:set var="beforeLevel" value="0"/>
			
			<c:forEach items="${gnbList}" var="list" varStatus="status">

				<c:if test="${list.level eq 1}">
					<c:if test="${beforeLevel eq 2}">
							</li>
						</ul>
					</c:if>
					<c:if test="${beforeLevel ne 0}">
								<a href="#" class="gnbSubBt"><img src="${siteImgPath}/common/gnbSubClose.png" alt=""/></a>
							</div>
						</li>
					</c:if>
					<li class="gnb${list.dpOrd}"><a href="#"><c:out value="${list.menuNm}"/></a>
						<div class="gnbSub">
							<ul class="">
				</c:if>
				
				<c:if test="${list.level eq 2}">
					<c:if test="${beforeLevel eq 2}">
						</li>
					</c:if>
					<c:if test="${beforeLevel eq 3}">
							</ul>
						</li>
					</c:if>
					<li><a href="${list.menuUrl}"><c:out value="${list.menuNm}"/></a>
				</c:if>
				
				<c:if test="${list.level eq 3}">
					<c:if test="${beforeLevel eq 2}">
						<ul class="">
					</c:if>
					<li><a href="${list.menuUrl}"><c:out value="${list.menuNm}"/></a></li>
				</c:if>
				
				<c:if test="${status.last}">
									</li>
								</ul>
							<a href="#" class="gnbSubBt"><img src="${siteImgPath}/common/gnbSubClose.png" alt=""/></a>
						</div>
					</li>
				</c:if>

				<c:set var="beforeLevel" value="${list.level}"/>
				
			</c:forEach>
				
		</c:when>
		
		<c:otherwise>
		
			<li class="gnb1"><a href="#">주민참여예산제</a>
				<div class="gnbSub">
					<ul class="">
						<li><a href="/proposal/intro">소개</a></li>
						<li><a href="/proposal/plan">운영계획</a></li>
						<li><a href="/proposal/guide">정책제안</a>
							<ul class="">
								<li><a href="/proposal/list">제안사업</a></li>
								<li><a href="/proposal/complete-list">검토완료</a></li>
							</ul>
						</li>
						<li><a href="/biz/biz_list">사업현황</a></li>
					</ul>
					<a href="#" class="gnbSubBt"><img src="${siteImgPath}/common/gnbSubClose.png" alt=""/></a>
				</div>
			</li>
			<li class="gnb2"><a href="#">주민참여위원회</a>
				<div class="gnbSub">
					<ul class="">
						<li><a href="/cmit/part">위원회역할</a></li>
						<li><a href="/board/cmit/list">위원회활동</a></li>
						<li><a href="/cmit/cmit_contest_req">위원공모</a></li>
					</ul>
					<a href="#" class="gnbSubBt"><img src="${siteImgPath}/common/gnbSubClose.png" alt=""/></a>
				</div>
			</li>
			<li class="gnb3"><a href="#">주민알림</a>
				<div class="gnbSub">
					<ul class="">
						<li><a href="/board/notice/list">공지사항</a></li>
						<li><a href="/board/gallery/list">갤러리</a></li>
						<li><a href="/board/data/list">자료실</a></li>
						<li><a href="/board/qna/list">문의하기</a></li>
					</ul>
					<a href="#" class="gnbSubBt"><img src="${siteImgPath}/common/gnbSubClose.png" alt=""/></a>
				</div>
			</li>
		
		</c:otherwise>
		
	</c:choose>

</ul>
<!-- //GNB -->
	
</div>
<script language="javascript" type="text/javascript">
//<![CDATA[
$('.topBt').on('click',function(){
	if ($(this).hasClass('on')){
		$(this).find('img').attr('src',$(this).find('img').attr('src').replace('_on','_off'))
		$(this).removeClass('on').next('.topMenu').hide();
		$('.fade').remove();
	}else{
		$(this).find('img').attr('src',$(this).find('img').attr('src').replace('_off','_on'))
		$(this).addClass('on').next('.topMenu').show();
		$('.gnbSub').hide();
		$('.fade').remove();
		$('.wrap').append('<div class="fade" style="width:100%; height:100%; background:#000; opacity:0.6; z-index:99; position:absolute; top:0; left:0;"></div>');
	}
})

$('.gnb>li>a').on('click',function(){
	$('.gnbSub').hide();
	$(this).next('div').show();
	$('.fade').remove();
	$('.wrap').append('<div class="fade" style="width:100%; height:100%; background:#000; opacity:0.6; z-index:99; position:absolute; top:0; left:0;"></div>');
})

$('.gnbSubBt').on('click',function(){
	$('.gnbSub').hide();
	$('.fade').remove();
})
//]]>
</script>