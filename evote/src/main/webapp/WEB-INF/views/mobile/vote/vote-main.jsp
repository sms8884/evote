<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!doctype html>
<html lang="en">
<head>

<!-- meta -->
<jsp:include page="/WEB-INF/views/mobile/common/meta.jsp"/>
<!-- //meta -->
<link href="${siteCssPath}/board.css" type="text/css" rel="stylesheet"  />

<script language="javascript" type="text/javascript">

	//상세보기
	function goVote(id){
		var mv = '${mv.userSeq}';	
		if(mv != null && mv !=''){
			var target = $("#target_"+id).val();		
			if(target != 'ALL'){
				var ageGroup = '${ageGroup}';
				if(target == ageGroup){
					$('#vote_seq').val(id);
					$('#form').attr('action', "/vote/vote-list").submit();
				}else{
					//투표 대상이 아닙니다.
					alert('<spring:message code="message.vote.002"/>');
				}
			}else{
				$('#vote_seq').val(id);
				$('#form').attr('action', "/vote/vote-list").submit();
			}
		}else{			
			openLoginLayer();
		}
	}
	
	//결과보기
	function goResultVote(id){
		$('#vote_seq').val(id);
		$('#form').attr('action', "/vote/vote-result").submit();
/* 
		var mv = '${mv.userSeq}';
	
		if(mv != null && mv !=''){
			$('#vote_seq').val(id);
			$('#form').attr('action', "/vote/vote-result").submit();		
		}else{		
			//로그인 후 참여가능합니다.\n로그인 화면으로 이동하시겠습니까?
			if (confirm('<spring:message code="message.vote.001"/>') == true){
				location.href='/login';
			}else{
			    return;
			}
		}
*/
	}

	function openLoginLayer() {
		var layer = $("#loginLayer");
		layer.fadeIn().css({ 'width': 300 });
		layer.css({
			'margin-top' : -(layer.height() / 2),
			'margin-left' : -(layer.width() / 2)
		});
		$('body').append('<div class="fade"></div>');
		$('.fade').css({'filter' : 'alpha(opacity=80)'}).fadeIn();
		return false;
	}
	
</script>

</head>
<body>

<!-- header -->
<jsp:include page="/WEB-INF/views/mobile/common/header.jsp"/>
<!-- //header -->

<form id="form" name="form" method="post">	
	<input type="hidden" id="vote_seq" name="vote_seq">
</form>

<div class="wrap">
<c:if test="${!empty voteList}"> <!-- 투표 정보가 있을때 -->
	<div class="location">
		<a href="/"><img src="${siteImgPath}/common/locaHome.png" alt=""/></a>
		<a href="/vote/vote-main"><span>투표</span></a>
	</div>
	<div id="container" class="container">
		<div class="containerWrap">
			<div class="contents">
			
				<!-- sns -->
				<div class="sns_wrap">
					<script type="text/javascript">
						var sh_title = "주민참여예산사업 선정 투표에 참여하세요";
				   		var sh_url = location.href;			
					</script>
					<jsp:include page="/WEB-INF/views/common/sns.jsp"/>
				</div>
				<!-- //sns -->			
				
				<c:forEach var="item" items="${voteList}" varStatus="status" >	
				<!--투표참여완료 여부-->	
				<div class="participation <c:if test="${item.voter_finish_yn eq 'Y'}">end</c:if>">
					<div class="p_line">
					<c:if test="${item.voter_finish_yn eq 'Y'}">
						<div class="sel_top">
							<span>참여 완료</span>
						</div>
					</c:if>	
						<div class="inner">
							<div class="part_top">
								<p class="tit"><c:if test ="${item.status eq 'END'}"><span class="end_ico">마감투표</span></c:if><c:out value="${fn:replace(item.title, crcn, '<br/>')}" escapeXml="false"/></p>
								<p class="date"><fmt:parseDate value="${item.start_date}" var="dateFmt" pattern="yyyyMMddHH"/>
									<fmt:formatDate value="${dateFmt}"  pattern="yyyy.MM.dd HH시"/> ~
									<fmt:parseDate value="${item.end_date}" var="dateFmt" pattern="yyyyMMddHH"/>
									<fmt:formatDate value="${dateFmt}"  pattern="yyyy.MM.dd HH시"/>	
								</p>
								<c:if test ="${item.status eq 'START'}"> <!-- 투표진행 -->
									<p class="time"><span>${item.left_day} 일 ${item.left_hour mod 24}시간 남음</span></p>			
								</c:if>		
							</div>
							<dl class="">
								<dt>투표안내</dt>
								<dd><c:out value="${fn:replace(item.vote_info, crcn, br)}" escapeXml="false"/></dd>
								<dt>투표대상</dt>
								<dd><c:out value="${item.target_text}"/></dd>
							</dl>
							<c:if test ="${item.status eq 'END'}"> <!-- 투표마감 -->
							<div class="vote_result">
								<a href="#" class=""  onClick="javascript:goResultVote('${item.vote_seq}');"><span>투표 결과보기</span></a>
							</div>
							</c:if>
							<c:if test ="${item.status eq 'START'}"> <!-- 투표진행 -->
								<input type="hidden" id="target_${item.vote_seq}" value="${item.target}"/> <!-- 투표 타겟(성인,청소년) -->								
								<c:if test="${item.voter_finish_yn eq 'N'}"><!-- 투표 미참여 -->

									<div class="vote_result">
										<c:choose>
											<c:when test="${_accountInfo.hasRole('USER') or userType eq 'VOTE'}">
												<a href="#" class="ing" onClick="javascript:goVote('${item.vote_seq}'); return false;"><span>투표 참여하기</span></a>
											</c:when>
											<c:otherwise>
												<a href="#" class="ing" onClick="openLoginLayer(); return false;"><span>비회원 투표 참여하기</span></a>
											</c:otherwise>
										</c:choose>
									</div>
									
								</c:if>
								<c:if test="${item.voter_finish_yn eq 'Y'}"> <!-- 투표 참여 -->
									<div class="vote02_btn">
										<a href="#" class="ing" onClick="javascript:goVote('${item.vote_seq}');"><span>투표보기</span></a>
									</div>
								</c:if>
							</c:if>	
						</div>
					</div>
				</div>
				</c:forEach>
			</div> <!-- end contents -->
		</div> <!-- end  div containerWrap-->	
	</div> <!-- end container -->	
</c:if> 
			
<c:if test="${empty voteList}"><!-- 투표 정보가 없을때 -->
	<div id="container" class="container" style="background:#F7F7F7;">
		<div class="containerWrap">
			<div class="contents paddingnone">
				<img src="${siteImgPath}/vote/vote_none.gif" alt="진행중인 투표가없습니다." width="200px">
			</div>
		</div> <!-- end  div container-->	
	</div> <!-- end containerWrap -->	
</c:if>

<!-- redirectURL 설정-->
	<c:set var="req" value="${pageContext.request}" />
	<c:set var="baseURL" value="${fn:replace(req.requestURL, req.requestURI, '')}" />
	<c:set var="params" value="${requestScope['javax.servlet.forward.query_string']}"/>
	<c:set var="requestPath" value="${requestScope['javax.servlet.forward.request_uri']}"/>
	<c:set var="requestURL" value="${baseURL}${requestPath}${not empty params ? '?' += params : ''}" scope="session"/>
<!--// redirectURL 설정-->	

	<div id="loginLayer" class="layer_block layerPop">
		<p class="layerTit">
			<strong>로그인</strong>
			<a href="#" class="layerClose"><img src="${siteImgPath}/common/layerClose.png" alt=""/></a>
		</p>
		<div class="layerCont">
			<p style="margin: 10px 0 10px 0; text-align: center;"><strong><spring:message code="message.vote.017"/></strong></p>
			<p class="bt">
				<a href="/vote/auth-phone" class="ok" style="float:none;"><span>휴대폰인증</span></a>
				<a href="/login" class="ok" style="float:none;"><span>로그인</span></a>
			</p>
		</div>
	</div>
			
	<!-- footer -->
	<jsp:include page="/WEB-INF/views/mobile/common/footer.jsp"/>
	<!-- //footer -->
</div><!-- end div wrap -->

</body>
</html>
