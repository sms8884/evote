<%@ page contentType="text/html; charset=utf-8" %>

<div id="termsLayer1" class="loginMbtLayer layer_block">
	<p class="tit"><c:out value="${termsService.termsTitle}"/></p>
	<div class="loginMbtLayerCon">
		<p class="txt1" style="overflow-y:scroll; height : 400px; text-align: left;"><c:out value="${fn:replace(termsService.termsCont, entermark, '<br/>')}" escapeXml="false"/></p>
		<p class="txt2"></p>
		<a href="#" class="bt layerClose2"><span>확인</span></a>
		<a href="#" class="layerClose"><img src="${siteImgPath}/common/layerClose.png" alt="닫기"/></a>
	</div>
</div>

<div id="termsLayer2" class="loginMbtLayer layer_block">
	<p class="tit"><c:out value="${termsPrivacy2.termsTitle}"/></p>
	<div class="loginMbtLayerCon">
		<p class="txt1" style="overflow-y:scroll; height : 400px; text-align: left;"><c:out value="${fn:replace(termsPrivacy2.termsCont, entermark, '<br/>')}" escapeXml="false"/></p>
		<p class="txt2"></p>
		<a href="#" class="bt layerClose2"><span>확인</span></a>
		<a href="#" class="layerClose"><img src="${siteImgPath}/common/layerClose.png" alt="닫기"/></a>
	</div>
</div>

<div id="termsLayer3" class="loginMbtLayer layer_block">
	<p class="tit"><c:out value="${termsPrivacy3.termsTitle}"/></p>
	<div class="loginMbtLayerCon">
		<p class="txt1" style="overflow-y:scroll; height : 400px; text-align: left;"><c:out value="${fn:replace(termsPrivacy3.termsCont, entermark, '<br/>')}" escapeXml="false"/></p>
		<p class="txt2"></p>
		<a href="#" class="bt layerClose2"><span>확인</span></a>
		<a href="#" class="layerClose"><img src="${siteImgPath}/common/layerClose.png" alt="닫기"/></a>
	</div>
</div>
 
<script>
function openTermsLayer(idx) {
	var layer = $("#termsLayer" + idx);
	layer.fadeIn().css({ 'width': 600 });
	layer.css({
		'margin-top' : -(layer.height() / 2),
		'margin-left' : -(layer.width() / 2)
	});
	$('body').append('<div class="fade"></div>');
	$('.fade').css({'filter' : 'alpha(opacity=80)'}).fadeIn().on("click", function() {
		$('.fade, .layer_block').fadeOut(function(){
			$('.fade').remove();
		});
	});
}
</script>