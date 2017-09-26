
/**  
 * SNS 공유 공통 스크립트 facebook, twitter, band, kakaostory, kakotalk
 */

function gfnShareFacebook(title, url){
    var _txt = encodeURIComponent(title);
    var _url = encodeURIComponent(url);
    window.open('http://www.facebook.com/sharer/sharer.php?u=' + _url +'&quote=' + _txt);
}

function gfnShareTwitter(title, url){
    var _txt = encodeURIComponent(title);
    var _url = encodeURIComponent(url);
    window.open('http://twitter.com/intent/tweet?text=' + _txt + '&url=' + _url);
}
function gfnShareBand(title, url){
	var _txt = encodeURIComponent(title);
    var _url = encodeURIComponent(url);
	var _br  = encodeURIComponent('\r\n');
	
	var mtype = $.cookie('mtype');
	
    var  param ='create/post?text=' + _txt + _br + _url;
    var  a_store='itms-apps://itunes.apple.com/app/id542613198?mt=8';
    var  g_store='market://details?id=com.nhn.android.band';
    var a_proto='bandapp://';
    var g_proto='scheme=bandapp;package=com.nhn.android.band'
    
    if(mtype =='app'){
        location.href = "share://band?text=" + _txt +"&url=" + _url;
    }else{
        if(navigator.userAgent.match(/android/i))  {                
            // Android
            setTimeout(function(){ location.href = 'intent://' + param + '#Intent;' + g_proto + ';end'}, 100);
        }else if(navigator.userAgent.match(/(iphone)|(ipod)|(ipad)/i))  {
            // Apple
            setTimeout(function(){ location.href = a_store; }, 200);          
            setTimeout(function(){ location.href = a_proto + param }, 100);
        }  else  {
            window.open("http://www.band.us/plugin/share?body="+_txt + _br + _url, "share_band");
        }
    }
}

Kakao.init('a25405684ec52d94b6093e10b0426a57'); //앱키

function gfnShareKakao(title, url) {  
	var _txt = encodeURIComponent(title);
    if(navigator.userAgent.match(/android|(iphone)|(ipod)|(ipad)/i)){
        if(mtype == 'app'){
            location.href = "share://kakaotalk?text="+_txt +"&url="+url;        
        }else{
             Kakao.Link.sendTalkLink({          
                label: title,
                webButton: {
                    text: "",
                    url: url // 앱 설정의 웹 플랫폼에 등록한 도메인의 URL이어야 합니다.
                  }
              });
        }
    }else{
        alert('이 기능은 모바일에서만 사용할 수 있습니다.');
    }   
}
//카카오스토리    
function gfnShareStory(_txt, _url) {
    Kakao.Story.share({
        url: _url,
        text: _txt
    });
}