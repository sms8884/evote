<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page contentType="text/html; charset=utf-8" %>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>

<!-- meta -->
<jsp:include page="/WEB-INF/views/front/common/meta.jsp"/>
<!-- //meta -->

<link href="${siteCssPath}/etc.css" type="text/css" rel="stylesheet"  />
<link href="/resources/ev-web/css/board.css" type="text/css" rel="stylesheet"  />

<script language="javascript" type="text/javascript">
//<![CDATA[
	$(document).ready(function(){
		$('.gnb').topmenu({ d1: 0, d2: 1, d3: 0 });
		
		if("${userInfo.termsAgreeYn}" == "Y") {
			$("#tmpTermsAgreeYn").addClass("on");
		}
		
		$('#userPw').on('keypress', function(e) {
			if (e.which == 13) {
				modifyUserInfo();
			}
		});
		
	});
	
	function modifyTerms() {
		
		if ($("#termsAgreeYn").val() == "Y") {
			$("#termsAgreeYn").val("N");
		} else {
			$("#termsAgreeYn").val("Y");
		}
		
        $.ajax({
            type: 'POST',
            url: '/member/terms-agree',
            dataType: 'json',
            data: {"termsAgreeYn": $("#termsAgreeYn").val() },
            success: function (data) {
            	if(data.result == true) {
            		if($("#termsAgreeYn").val() == "Y") {
            			alert("선택동의 처리되었습니다.");
            		} else {
            			alert("선택동의 해제 처리되었습니다.");
            		}
            	}
            },
            error: function (jqXHR, textStatus, errorThrown) {
                console.log(errorThrown);
                console.log(textStatus);
            }
        });
	}
	
	function modifyUserInfo() {
		$("#form").attr("action", "/member/modify");
		$("#form").attr("method", "POST");
		$("#form").submit();
	}
	
	function modifyPasswd() {
		location.href = "/member/modify-passwd";
	}
	
	function openLoginLayer() {
		var layer = $("#loginLayer");
		layer.fadeIn().css({ 'width': 460 });
		layer.css({
			'margin-top' : -(layer.height() / 2),
			'margin-left' : -(layer.width() / 2)
		});
		$('body').append('<div class="fade"></div>');
		$('.fade').css({'filter' : 'alpha(opacity=80)'}).fadeIn();
		return false;
	}
	
	function withdrawal() {
		if( !$("#tmpCheck").hasClass("on") ) {
			alert("필수 항목에 동의해야 진행할 수 있습니다.");
			return;
		}
		if(confirm("탈퇴 하시겠습니까?")) {
			$("#form").attr("action", "/member/withdrawal-proc");
			$("#form").attr("method", "POST");
			$("#form").submit();
		}
	}
	
//]]>
</script>
</head>
<body>

<!-- header -->
<jsp:include page="/WEB-INF/views/front/common/header.jsp"/>
<!-- //header -->

<div class="location">
	<p>
		<a href="#"><img src="${siteImgPath}/common/locationHome.png" alt="홈"/></a>
		<span>회원정보</span>
		<span>내 정보 조회</span>
	</p>
</div>

<div id="container" class="container">
	<div class="containerWrap">
		<div class="lnb">
			<h2 class="lnbTit">회원정보</h2>
			<ul class="">
				<li><a href="">내 정보 조회</a></li>
			</ul>
		</div>
		
		<div class="contentsWrap">
			<h3 class="contentTit">내 정보 조회</h3>

			<div class="contents paddingnone">
				
				<c:if test="${userInfo.hasRole('USER')}">
				<div class="memberInfo">
					<p class="mITitle">회원 정보</p>
					<dl class="mIDl">
						<dt>이름</dt>
						<dd><c:out value="${userInfo.userNm.decValue}"/></dd>
						<dt>닉네임</dt>
						<dd><c:out value="${userInfo.nickname}"/></dd>
						<dt>로그인 아이디</dt>
						<dd><c:out value="${userInfo.email.decValue}"/></dd>
						<c:if test="${userInfo.userType eq 'CMIT'}">
							<dt>회원권한</dt>
							<dd>주민참여위원</dd>
						</c:if>
					</dl>
				</div>
				</c:if>
				
				<div class="memberInfo_modify">
					<a href="#" onclick="openLoginLayer(); return false;" class="info_modify">정보수정</a>
					<a href="#" onclick="modifyPasswd(); return false;" class="pw_modify">비밀번호 변경</a>
				</div>
				
				<div class="memberInfo">
					<p class="mITitle">기본 정보</p>
					<dl class="mIDl" >
						<dt>지역</dt>
						<dd>
							<c:out value="${userInfo.sidoNm}"/>&nbsp;
							<c:out value="${userInfo.sggNm}"/>&nbsp;
							<c:out value="${userInfo.emdNm}"/>
						</dd>
						<dt>생년/성별</dt>
						<dd>
							<c:out value="${userInfo.birthYear}"/>년생/
							<c:if test="${userInfo.gender eq 'M'}">남성</c:if>
							<c:if test="${userInfo.gender eq 'F'}">여성</c:if>
						</dd>
						<dt>휴대폰번호</dt>
						<dd>
							<c:choose>
								<c:when test="${not empty userInfo.phone and fn:length(userInfo.phone.value) gt 6}">
									<c:out value="${fn:substring(userInfo.phone.decValue, 0, 3)}-${fn:substring(userInfo.phone.decValue, 3, 7)}-****"/>
								</c:when>
								<c:otherwise>
									<c:out value="${userInfo.phone.decValue}"/>
								</c:otherwise>
							</c:choose>
						</dd>
					</dl>
				</div>


				<a href="/logout" class="btn_logout">로그아웃</a>				

				<div class="step1 mI">
					<ul>
						<li>
							<a href="#" class="chk" id="tmpTermsAgreeYn" onclick="modifyTerms(); return false;">문자 수신 동의</a>
							<input type="hidden" id="termsAgreeYn" value="${userInfo.termsAgreeYn}" />
						</li>
						<li>
							<a href="#" class="chk" style="background: none;">개인정보 수집ㆍ이용 동의<span>(선택)</span></a>
							<a href="#" class="more loginMbt1" onclick="openTermsLayer(3); return false;">전체보기</a>
						</li>
					</ul>		

					<script language="javascript" type="text/javascript">
					//<![CDATA[
						$('.allChk').find('.chk').on('click',function(){
							if ($(this).hasClass('on')){
								$(this).removeClass('on');
								$('.step1').find('ul').find('.chk').each(function(){
									$(this).removeClass('on');
								})
							}else{
								$(this).addClass('on');
								$('.step1').find('ul').find('.chk').each(function(){
									$(this).addClass('on');
								})
							}
								return false;
						});
						$('.step1').find('ul').find('.chk').on('click',function(){
							if ($(this).hasClass('on')){
								$(this).removeClass('on');
								$('.allChk').find('.chk').removeClass('on');
							}else{
								$(this).addClass('on');
							}
							return false;
						});
						
					//]]>
					</script>
					<div class="memberL">
						<a href="#?=460" class="memberLbtn" rel="member_leave">회원탈퇴바로가기</a>
					</div>

					<div class="loginMbtLayer layer_block">
						<p class="tit">이용약관</p>
						<div class="loginMbtLayerCon">
							<p class="txt1"></p>
							<p class="txt2"></p>
							<a href="#" class="bt layerClose2"><span>확인</span></a>
							<a href="#" class="layerClose"><img src="${siteImgPath}/common/layerClose.png" alt="닫기"/></a>
						</div>
					</div>
					<div class="member_leave">
						<p class="tit">탈퇴안내</p>
						<div class="member_leaveCon">
							<p class="txt1">탈퇴 후 회원정보는 바로 삭제됩니다.<br/>
							단, 내 정책 제안하기에 글을 게시한 경우, 제안사항 확인을 위해 일정기간 회원정보를<br/> 보관한 후에 삭제합니다</p>
							<p class="txt2">탈퇴 후에도 게시글 및 댓글은 탈퇴 시 자동 삭제되지 않고 그대로 남아 있습니다.<br/> 삭제를 원하는 게시글이 있다면 <span>반드시 탈퇴 전 비공개 처리하거나 삭제하시기 바랍니다.</span><br/> 탈퇴 후에는 회원정보가 삭제되어 본인 여부를 확인할 수 있는 방법이 없어, 게시글을<br/> 임의로 삭제해드릴 수 없습니다.</p>
							<p class="txt3">작성된 게시글은 탈퇴 후 삭제할 수 없습니다.</p>
							<div class="agreeChk">
								<p><a href="#" title="" id="tmpCheck" class="chk"></a>안내 사항을 모두 확인했으며, 이에 동의 합니다.</p>
							</div>
							<a href="#" class="bt layerClose3"><span>닫기</span></a>
							<a href="#" onclick="withdrawal(); return false;" class="bt layerClose4"><span>탈퇴하기</span></a>
							<a href="#" class="layerClose"><img src="${siteImgPath}/common/layerClose.png" alt="닫기"/></a>
						</div>
					</div>
					<script language="javascript" type="text/javascript">
					//<![CDATA[
						$('.agreeChk').find('.chk').on('click',function(){
							if ($(this).hasClass('on')){
							$(this).removeClass('on');
							}else{
								$(this).addClass('on');
							}
							return false;
						});
					//]]>
					</script>
				
				</div>
				
				<div id="loginLayer" class="loginMbtLayer1 layer_block">
					<p class="tit">비밀번호확인</p>
					<div class="loginMbtLayerCon">
						<form id="form" method="post">
						<p class="inptxt"><input type="password" class="it widinputxt" id="userPw" name="userPw" placeholder="비밀번호를 입력해주세요."/></p>
						<a href="#" class="btW1 layerClose2"><span>취소</span></a>
						<a href="#" class="btC1 " onclick="modifyUserInfo(); return false;"><span>확인</span></a>
						<a href="#" class="layerClose"><img src="${siteImgPath}/common/layerClose.png" alt="닫기"/></a>
						</form>
					</div>
				</div>
				
				<form id="form"></form>
				
			</div>
		</div>
	</div>
</div>

<jsp:include page="/WEB-INF/views/front/member/join-terms.jsp"/>

<!-- footer -->
<jsp:include page="/WEB-INF/views/front/common/footer.jsp"/>
<!-- //footer -->

</body>
</html>
