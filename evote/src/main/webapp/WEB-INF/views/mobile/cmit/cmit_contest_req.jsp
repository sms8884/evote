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
	if('${cmitReqItem.reqSeq}' != ''){
		$("#reqView").css('display','block');
	}
	
});

function reqWrite(psSeq){
	if('${sessionScope._accountInfo}' ==''){
		var layer = $("#loginLayer");
		layer.fadeIn().css({ 'width': 300 });
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
<jsp:include page="/WEB-INF/views/mobile/common/header.jsp"/>
<!-- //header -->

<div class="wrap">
	<div class="location">
		<img src="${siteImgPath}/common/locaHome.png" alt=""/>
		<span>주민참여위원회</span>
		<span>위원공모</span>
	</div>
	<div class="containerWrap">
		<div class="contents pd0">
			<div class="boardView">
		
				<div class="pTit2Wrap">
					<p class="pTit2">주민참여위원공모</p>	
				</div>
				
				<div class="boardView">
					<p class="budgetView">
						<strong>${cmitReqItem.title} </strong>
						<span class="subtxt">우리구에서는 구정에 상시적인 주민의 참여를 통하여 행정의 민주성과 투명성을 제고하고 주민과 함께하는 참여자치 실현을 위해주민참여제도를 운영하고 있습니다. 
						구민을 대표하여 참여할 주민참여위원회 위원을 모집하오니 관심있는 주민 여러분의 많은 참여 바랍니다.
						</span>
						
<!-- 						<a href="#" class="dlbtn">신청서 다운로드</a> -->
						<a href="/file-download/${cmitReqItem.attachList[0].fileSeq}" class="dlbtn" >신청서 다운로드</a>
						
						<br/><br/><br/><br/><br/>
						※ 사진, 신청서 등의 파일 첨부는 PC(웹)에서만 가능합니다.
						
					</p>
				</div>

				<a href="#" title="" onclick="reqWrite(${cmitReqItem.ps_seq})" class="listBt "><span>신청하기</span></a>
				<a href="/cmit/cmit_contest_reqList" class="listBt" id="reqView" style="display: none;"><span>신청내역 보기</span></a>
			</div>
		</div>
		
		<!--로그인팝업  -->
		<div id="loginLayer" class="layer_block layerPop">
			<p class="layerTit">
				<strong>로그인</strong>
				<a href="#" class="layerClose"><img src="${siteImgPath}/common/layerClose.png" alt=""/></a>
			</p>
			<div class="layerCont">
				<p style="margin: 10px 0 10px 0; text-align: center;"><strong><spring:message code="message.cmit.001"/></strong></p>
				<p class="bt">
					<a href="/member/join" class="ok" style="float:none;"><span>회원가입</span></a>
					<a href="/login" class="ok" style="float:none;"><span>로그인</span></a>
				</p>
			</div>
		</div>
		<!--//로그인팝업  -->

	</div>
	
	<!-- footer -->
	<jsp:include page="/WEB-INF/views/mobile/common/footer.jsp"/>
	<!--// footer -->
</div>



</body>
</html>
