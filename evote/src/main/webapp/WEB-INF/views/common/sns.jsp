<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!-- 투표에서 사용중 삭제 하지 말아주세요 -->

<!-- 카카오톡 용 -->
<%--
meta.jsp 로 이동  
<meta charset="utf-8"/>
<meta http-equiv="X-UA-Compatible" content="IE=edge"/>
<meta name="viewport" content="user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, width=device-width"/>
<script src="//developers.kakao.com/sdk/js/kakao.min.js"></script>
--%>

<!--facebook용-->
<script language="javascript" type="text/javascript">
//<![CDATA[
var mtype = $.cookie('mtype');
var _txt = encodeURIComponent(sh_title);
var _url = encodeURIComponent(sh_url);	
var _br  = encodeURIComponent('\r\n');  

function shareFacebook(){	
	window.open('http://www.facebook.com/sharer/sharer.php?u=' + _url +"&quote=" + _txt);
}
            
function shareTwitter(){     
	window.open('http://twitter.com/intent/tweet?text=' + _txt + '&url=' + _url);
}

function shareBand(){
	var  param ='create/post?text=' + _txt + _br + _url;
	var  a_store='itms-apps://itunes.apple.com/app/id542613198?mt=8';
	var  g_store='market://details?id=com.nhn.android.band';
	var a_proto='bandapp://';
	var g_proto='scheme=bandapp;package=com.nhn.android.band'	
	if(mtype =='app'){
		location.href = "share://band?text=" + _txt + "&url=" + _url;
	}else{
		if(navigator.userAgent.match(/android/i))  {            	
			// Android
			setTimeout(function(){ location.href = 'intent://' + param + '#Intent;' + g_proto + ';end'}, 100);
		}else if(navigator.userAgent.match(/(iphone)|(ipod)|(ipad)/i))  {
			// Apple
			setTimeout(function(){ location.href = a_store; }, 200);          
			setTimeout(function(){ location.href = a_proto + param }, 100);
		}  else  {
			//window.open("http://www.band.us/plugin/share?body="+_txt +"&route=" + _url);
			window.open("http://www.band.us/plugin/share?body="+_txt + _br + _url, "share_band");
		}
	}
}	


//Kakao.init('a25405684ec52d94b6093e10b0426a57'); //앱키
function shareKakao() {  
	if(navigator.userAgent.match(/android|(iphone)|(ipod)|(ipad)/i)){
		if(mtype == 'app'){
			location.href = "share://kakaotalk?text="+_txt +"&url="+sh_url;		
		}else{
			 Kakao.Link.sendTalkLink({	    	
		    	label: sh_title,
		        webButton: {
		            text: sh_title,		            
		            url: sh_url // 앱 설정의 웹 플랫폼에 등록한 도메인의 URL이어야 합니다.
		          }
		      });
		}
	}else{
		alert('이 기능은 모바일에서만 사용할 수 있습니다.');
	}
}
//카카오스토리 
// 스토리 공유 버튼을 생성합니다.	 
function shareStory() {
	Kakao.Story.share({
		url: sh_url,
		text: sh_title
	});
}
//]]>
</script>

<c:choose>
	<c:when test="${param.dest eq 'biz'}">
		<ul class="viewSns">
			<c:if test="${!currentDevice.normal}">
				<li><a id="kakao-link-btn" href="#" onclick="shareKakao(); return false;"><img src="${siteImgPath}/sub1/sns1.gif" alt="카카오톡" width="34px"></a></li>
			</c:if>
			<li><a href="#" onclick="shareFacebook(); return false;"><img src="${siteImgPath}/sub1/sns2.gif" alt="페이스북" width="34px"></a></li>
			<li><a href="#" onclick="shareTwitter(); return false;"><img src="${siteImgPath}/sub1/sns3.gif" alt="트위터" width="34px"></a></li>
			<li><a href="#" onclick="shareBand(); return false;"><img src="${siteImgPath}/sub1/sns4.gif" alt="밴드" width="34px"></a></li>
			<li><a href="#" onclick="shareStory(); return false;"><img src="${siteImgPath}/sub1/sns5.gif" alt="카카오스토리" width="34px"></a></li>
		</ul>
	</c:when>
	<c:otherwise>
		<div class="sns">
			<span>공유하기</span>
			<ul class="">
				<c:if test="${vote_method eq 'MOBILE'}">
				<li><a id="kakao-link-btn" href="#" onclick="shareKakao(); return false;"><img src="${siteImgPath}/sub1/sns1.gif" alt="카카오톡"/></a></li>
				</c:if>
				<li><a href="#" onclick="shareFacebook(); return false;"><img src="${siteImgPath}/sub1/sns2.gif" alt="페이스북"/></a></li>
				<li><a href="#" onclick="shareTwitter(); return false;"><img src="${siteImgPath}/sub1/sns3.gif" alt="트위터"/></a></li>
				<li><a href="#" onclick="shareBand(); return false;"><img src="${siteImgPath}/sub1/sns4.gif" alt="밴드"/></a></li>
				<li><a href="#" onclick="shareStory(); return false;"><img src="${siteImgPath}/sub1/sns5.gif" alt="카카오스토리"/></a></li>
			</ul>
		</div>
	</c:otherwise>
</c:choose>
