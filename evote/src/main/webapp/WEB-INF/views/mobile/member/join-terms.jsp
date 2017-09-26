<%@ page contentType="text/html; charset=utf-8" %>

<div id="termsLayer1" class="layer_block layerPop">
	<p class="layerTit">
		<strong><c:out value="${termsService.termsTitle}"/></strong>
		<a href="#" class="layerClose"><img src="${siteImgPath}/common/layerClose.png" alt=""/></a>
	</p>
	<div class="layerCont">
		<p class="txt" style="overflow-y:scroll; height : 400px; text-align: left;"><c:out value="${fn:replace(termsService.termsCont, entermark, '<br/>')}" escapeXml="false"/></p>
		<p class="txt"></p>
		<p class="bt">
			<a href="#" class="ok layerClose2" style="width: 100%"><span>확인</span></a>
		</p>
	</div>
</div>

<div id="termsLayer2" class="layer_block layerPop">
	<p class="layerTit">
		<strong><c:out value="${termsPrivacy2.termsTitle}"/></strong>
		<a href="#" class="layerClose"><img src="${siteImgPath}/common/layerClose.png" alt=""/></a>
	</p>
	<div class="layerCont">
		<p class="txt" style="overflow-y:scroll; height : 400px; text-align: left;"><c:out value="${fn:replace(termsPrivacy2.termsCont, entermark, '<br/>')}" escapeXml="false"/></p>
		<p class="txt"></p>
		<p class="bt">
			<a href="#" class="ok layerClose2" style="width: 100%"><span>확인</span></a>
		</p>
	</div>
</div>

<div id="termsLayer3" class="layer_block layerPop">
	<p class="layerTit">
		<strong><c:out value="${termsPrivacy3.termsTitle}"/></strong>
		<a href="#" class="layerClose"><img src="${siteImgPath}/common/layerClose.png" alt=""/></a>
	</p>
	<div class="layerCont">
		<p class="txt" style="overflow-y:scroll; height : 400px; text-align: left;"><c:out value="${fn:replace(termsPrivacy3.termsCont, entermark, '<br/>')}" escapeXml="false"/></p>
		<p class="txt"></p>
		<p class="bt">
			<a href="#" class="ok layerClose2" style="width: 100%"><span>확인</span></a>
		</p>
	</div>
</div>

<script>
function openTermsLayer(idx) {
	var layer = $("#termsLayer" + idx);
	layer.fadeIn().css({ 'width': 340 });
	layer.css({
		'margin-top' : -(layer.height() / 2),
		'margin-left' : -(layer.width() / 2)
	});
	$('body').append('<div class="fade"></div>');
	$('.fade').css({'filter' : 'alpha(opacity=80)'}).fadeIn();
	return false;
}
</script>