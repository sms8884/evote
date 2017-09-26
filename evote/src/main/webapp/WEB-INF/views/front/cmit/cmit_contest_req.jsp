<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page contentType="text/html; charset=utf-8" %>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>
<!-- meta -->
<jsp:include page="/WEB-INF/views/front/common/meta.jsp"/>
<!-- //meta -->
<link href="${siteCssPath}/etc.css" type="text/css" rel="stylesheet"  />
<link href="${siteCssPath}/board.css" type="text/css" rel="stylesheet"  />
<script language="javascript" type="text/javascript">
//<![CDATA[
           
	$(document).ready(function(){
		$('.gnb').topmenu({ d1: 2, d2: 3});
		
		if('${cmitReqItem.reqSeq}' != ''){
			$("#reqView").css('display','inline-block');
		}
	});
	
	function reqWrite(psSeq){
		if('${sessionScope._accountInfo}' ==''){
			var layer = $("#loginLayer");
			layer.fadeIn().css({ 'width': 460 });
			layer.css({
				'margin-top' : -(layer.height() / 2),
				'margin-left' : -(layer.width() / 2)
			});
			$('body').append('<div class="fade"></div>');
			$('.fade').css({'filter' : 'alpha(opacity=80)'}).fadeIn();
			return false;
		}else{
			location.href="/cmit/cmit_contest_wrtieForm/"+psSeq
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
		<span>주민참여위원회</span>
		<span>주민참여위원공모</span>
	</p>
</div>

<div id="container" class="container">
	<div class="containerWrap">
		<!-- LNB -->
		<jsp:include page="/WEB-INF/views/front/common/lnb.jsp">
			<jsp:param name="menuName" value="cmit"/>
		</jsp:include>
		<!-- //LNB -->
		<div class="contentsWrap">
			<h3 class="contentTit">주민참여위원공모</h3>
			<div class="contents" style="height:auto;">
				<div class="committeeCt">
					<p class="ct1">${cmitReqItem.title} </p>
					<p class="ct2">
					  우리구에서는 구정에 상시적인 주민의 참여를 통하여 행정의 민주성과 투명성을<br/> 
					  제고하고 주민과 함께하는 참여자치 실현을 위해 주민참여제도를 운영하고 있습니다.<br/>
					  구민을 대표하여 참여할 주민참여위원회 위원을 모집하오니 관심있는 주민 여러분의<br/>
					  많은 참여 바랍니다.
					</p>
					<div class="committeeCt_app">
						<p><a href="/file-download/${cmitReqItem.attachList[0].fileSeq}" title="주민참여위원회신청서다운로드">신청서 다운로드</a></p>
					</div>
				</div>
				<div class="committeeCt_btnBx">
					<p class="ct_btn1"  id="reqWrite" >
						<a href="#" title="" onclick="reqWrite(${cmitReqItem.ps_seq})">신청하기</a>
					</p>
					<p class="ct_btn2" id="reqView"  style="display:none;"><!--신청한 이력이 있을 경우 노출-->
						<a href="/cmit/cmit_contest_reqList" title=""  >신청내역보기</a>
					</p>
				</div>
			</div>

			<div id="loginLayer" class="loginMbtLayer layer_block">
				<p class="tit">로그인</p>
				<div class="loginMbtLayerCon">
					<p class="txt3"><spring:message code="message.common.cmit.login"/></p>
					<a href="#" onclick="javascript:location.href='/member/join';" class="btC1 layerClose2"><span>회원가입</span></a>
					<a href="#" onclick="javascript:location.href='/login'" class="btC1 layerClose2"><span>로그인</span></a>
					<a href="#" class="layerClose"><img src="${siteImgPath}/common/layerClose.png" alt="닫기"/></a>
				</div>
			</div>
			
		</div>
	</div>
</div>



<!-- footer -->
<jsp:include page="/WEB-INF/views/front/common/footer.jsp"/>
<!-- //footer -->

</body>
</html>
