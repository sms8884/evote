<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page contentType="text/html; charset=utf-8" %>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>

<!-- meta -->
<jsp:include page="/WEB-INF/views/mobile/common/meta.jsp"/>
<!-- //meta -->

<script src="${siteJsPath}/jquery.cycle.all.min.js" type="text/javascript"></script>
<link href="${siteCssPath}/main.css" type="text/css" rel="stylesheet"  />

<script language="javascript" type="text/javascript">
//<![CDATA[
	
	function tab_menu(num){	
		event.preventDefault();
		var f = $('.tabmenu').find('li');
		for ( var i = 0; i < f.length; i++ ) {			
			if ( i == num) {
				f.eq(i).addClass('active');	
				$('.menu_tab0' + i ).show(); 
			} else {	
				f.eq(i).removeClass('active');					
				$('.menu_tab0' + i ).hide();
			}
		}
	};

	$(function() {
		
		$('.mainVisual').slick({
			dots: true,
			infinite: true,
			speed: 500,
			arrows: false,
			slidesToShow: 1,
			slidesToScroll: 1,
			autoplay: true,
			autoplaySpeed: 2000,
			cssEase: 'linear'
		});
		
		$('.mainVisual').find('.bt').each(function(){
			$(this).mouseover(function(){
				$(this).find('img').attr('src',$(this).find('img').attr('src').replace('_off','_on'))
			})
			$(this).mouseout(function(){
				$(this).find('img').attr('src',$(this).find('img').attr('src').replace('_on','_off'))
			})
		});

		$('#divMainBanner').slick({
			dots: true,
			arrows: false
		});
		
		$(".moreBtn").on("click", function(e) {
			e.preventDefault();
			if($(".menu_tab00").is(":visible")) {
				location.href = "/biz/biz_list";
			} else if($(".menu_tab01").is(":visible")) {
				location.href = "/board/cmit/list";
			}
		});

	});

	<c:if test="${not empty popupList}">
	$(function() {
		<c:forEach items="${popupList}" var="list" varStatus="status">
		<c:if test="${status.first}">

			$("#destTitle").html('<c:out value="${fn:replace(list.destTitle, crcn, br)}" escapeXml="false"/>');
			
			var destStartDate = '<fmt:formatDate value="${list.destStartDate}" pattern="yyyy.MM.dd"/>';
			var destEndDate = '<fmt:formatDate value="${list.destEndDate}" pattern="yyyy.MM.dd"/>';
			$("#destDate").text(destStartDate + " ~ " + destEndDate);
			$("#destImage").attr("src", '/file-download/<c:out value="${list.mobImageList[0].fileSeq}"/>');

			if('<c:out value="${list.dest}"/>' == "V") {
				$("#destText1").text("진행중인 투표");	
				$("#destText2").text("투표기간");	
				$("#destText3").text("투표 참여하기").on("click", function() {
					location.href = "/vote/vote-main";
				});
			} else if('<c:out value="${list.dest}"/>' == "P") {
				$("#destText1").text("진행중인 공모");
				$("#destText2").text("공모기간");
				$("#destText3").text("공모 신청하기").on("click", function() {
					location.href = "/proposal/guide";
				});
			}
			
			if($.cookie("_nomore_${list.bpSeq}") == undefined){
				$('.openPop, .popfade').show();
			}

			$('.openPopClose, .mpclose').on('click',function(){
				if($("#popChk").is(":checked")) {
					$.cookie("_nomore_${list.bpSeq}", "done", { expires : 7, path : '/'});
				}
				$('.openPop, .popfade').hide();
			});
			
		</c:if>
		</c:forEach>
	});
	</c:if>
 
//]]>
</script>

</head>

<body>

<!-- header -->
<jsp:include page="/WEB-INF/views/mobile/common/header.jsp"/>
<!-- //header -->

<div class="wrap">
	<div class="mainVisual">
		<div>
			<img src="${siteImgPath}/main/visual1.png" class="visual" alt="">
			<span class="txt" style="width:40%;"><img src="${siteImgPath}/main/visual1_txt.png" alt=""/></span>
			<a href="/proposal/intro" class="bt"><img src="${siteImgPath}/main/visual1_bt_off.png" alt=""/></a>
		</div>
		<div>
			<img src="${siteImgPath}/main/visual2.png" class="visual" alt="">
			<span class="txt" style="width:32%;"><img src="${siteImgPath}/main/visual2_txt.png" alt=""/></span>
			<a href="/proposal/intro" class="bt"><img src="${siteImgPath}/main/visual2_bt_off.png" alt=""/></a>
		</div>
	</div>

	<div class="bannerBox" id="divMainBanner">
		<c:if test="${not empty bannerList}">
			<c:forEach items="${bannerList}" var="list">
				<div>
					<c:set var="bannerLink">
						<c:if test="${list.dest eq 'V'}">/vote/vote-main</c:if>
						<c:if test="${list.dest eq 'P'}">/proposal/guide</c:if>
					</c:set>
					
					<c:if test="${empty list.mobImageList}">
						<img src="${siteImgPath}/main/m_bannerList1.png" alt="배너이미지1" onclick="location.href='${bannerLink}';" style="width: 100%; max-width: 100%;"/>
					</c:if>
					<c:if test="${not empty list.mobImageList}">
						<img src="/file-download/${list.mobImageList[0].fileSeq}" onclick="location.href='${bannerLink}';" style="width: 100%; max-width: 100%;">
					</c:if>
					
					<div class="bannerTxt">
						<p class="bnTxt2">
							<span class="bnTxt1">
								<c:if test="${list.dest eq 'V'}">투표</c:if>
								<c:if test="${list.dest eq 'P'}">공모</c:if>
							</span>
							<c:out value="${list.destTitle}"/>
						</p>
						<p class="bnTxt3">
							<fmt:formatDate value="${list.destStartDate}" pattern="yyyy.MM.dd"/> ~
							<fmt:formatDate value="${list.destEndDate}" pattern="yyyy.MM.dd"/>
						</p>
					</div>
				</div>
			</c:forEach>
		</c:if>
	</div>

	<div class="mainContainer">

		<div class="board">
			<p class="tit">
				<strong>정책제안 함께 생각하기</strong>
				<a href="/proposal/list" class="more">더보기</a>
			</p>
			<ul class="">
				<c:if test="${not empty proposalList}">
					<c:forEach items="${proposalList}" var="list">
						<li><a href="/proposal/detail/${list.propSeq}" class="ellipsis"><c:out value="${list.bizNm}"/></a></li>
					</c:forEach>
				</c:if>
			</ul>
			<a href="/proposal/list" rel="layerPop" class="bookBg layer"><span>내 정책 제안하기</span></a>
		</div>

		<div class="mainCon1_2">
			<div class="status">
				<div class="tabmenu">
					 <ul>
						<li class="active"><a href="" onclick="tab_menu(0)">참여예산 사업현황</a></li>
						<li><a href="" onclick="tab_menu(1);">위원회 활동</a></li> 
					</ul>
					<a href="#" class="moreBtn">더보기</a>
				</div>
				
				<div class="menu_tab00">
					<div class="condition">
						
						<c:if test="${not empty bizList}">
							<ul class="">
							<c:forEach items="${bizList}" var="list" varStatus="status">
								<c:choose>
									<c:when test="${status.first}">
										<li class="img">
											<c:if test="${empty list.fileSeq}">
												<img src="${siteImgPath}/main/m_conditionImg.png" alt="참여예산 사업현황 이미지1"/>
											</c:if>
											<c:if test="${not empty list.fileSeq}">
												<img src="/file-download/${list.fileSeq}" style="width: 94px; height: 63px;"/>
											</c:if>
											<span class="txt">
												<a href="/biz/biz_view/${list.biz_seq}">
													<strong class="elli2"><c:out value="${list.biz_name}"/></strong>
													<p class="elli3"><c:out value="${list.summary}"/></p>
												</a>
												<p class="date"><fmt:formatDate pattern="yyyy.MM.dd" value="${list.reg_date}"/></p>
											</span>
										</li>
									</c:when>
									<c:otherwise>
										<li>
											<span class="txt">
												<a href="/biz/biz_view/${list.biz_seq}">
													<strong><c:out value="${list.biz_name}"/></strong>
													<span><c:out value="${list.summary}"/></span>
												</a>
											</span>
											<span><fmt:formatDate pattern="yyyy.MM.dd" value="${list.reg_date}"/></span>
										</li>

									</c:otherwise>
								</c:choose>
							</c:forEach>
							</u>
						</c:if>
						
					</div>
				</div>
				
				<div class="menu_tab01" style="display:none">
					<div class="condition">
						
						<c:if test="${not empty cmitList}">
							<ul class="">
							<c:forEach items="${cmitList}" var="list" varStatus="status">
								<c:choose>
									<c:when test="${status.first}">
										<li class="img">
											<c:if test="${empty list.imageList}">
												<img src="${siteImgPath}/main/m_conditionImg.png" alt="참여예산 사업현황 이미지1"/>
											</c:if>
											<c:if test="${not empty list.imageList}">
												<img src="/file-download/${list.imageList[0].fileSeq}" style="width: 94px; height: 63px;"/>
											</c:if>
											<span class="txt">
												<a href="/board/cmit/${list.postSeq}">
													<strong class="elli2"><c:out value="${fn:substring(list.title, 0, 14)}"/></strong>
													<p class="elli3"><c:out value="${fn:substring(list.cont, 0, 30)}"/></p>
												</a>
												<p class="date"><fmt:formatDate pattern="yyyy.MM.dd" value="${list.regDate}"/></p>
											</span>
										</li>
									</c:when>
									<c:otherwise>
										<li>
											<a href="/board/cmit/${list.postSeq}">
												<strong><c:out value="${list.title}"/></strong>
												<span><c:out value="${list.cont}"/></span>
											</a>
											<span><fmt:formatDate pattern="yyyy.MM.dd" value="${list.regDate}"/></span>
										</li>
									</c:otherwise>
								</c:choose>
							</c:forEach>
							</ul>
						</c:if>
					
					</div>
				</div>
				
			</div>
		</div>
		
		<div class="notice">
			<p class="tit">
				<strong>공지사항</strong>
				<a href="/board/notice/list" class="more">더보기</a>
			</p>
			
			<c:if test="${not empty noticeList}">
				<ul class="">
				<c:forEach items="${noticeList}" var="list" varStatus="status">
					<c:choose>
						<c:when test="${status.first}">
							<li class="img">
								<a href="/board/notice/${list.postSeq}">
									<c:if test="${empty list.imageList}">
										<img src="${siteImgPath}/main/m_noticeImg1.png" alt="참여예산 사업현황 이미지1"/>
									</c:if>
									<c:if test="${not empty list.imageList}">
										<img src="/file-download/${list.imageList[0].fileSeq}" style="width: 99px; height: 66px;"/>
									</c:if>
									<span class="txt">
										<strong class="elli2"><c:out value="${fn:substring(list.title, 0, 30)}"/></strong>
										<span><fmt:formatDate pattern="yyyy.MM.dd" value="${list.regDate}"/></span>
									</span>
								</a>
							</li>
						</c:when>
						<c:otherwise>
							<li>
								<a href="/board/notice/${list.postSeq}"><c:out value="${list.title}"/></a>
								<span><fmt:formatDate pattern="yyyy.MM.dd" value="${list.regDate}"/></span>
							</li>
						</c:otherwise>
					</c:choose>
				</c:forEach>
				</u>
			</c:if>
			
		</div>

		<ul class="mainBt">
			<li><a href="/proposal/list" class="mainBt1">정책제안</a></li>
			<li><a href="/proposal/complete-list" class="mainBt2">정책검토</a></li>
			<li><a href="/vote/vote-main" class="mainBt3">투표</a></li>
			<li><a href="/biz/biz_list" class="mainBt4">실행</a></li>
		</ul>
	</div>

	<div class="openPop" style="display:none;">
		<div class="mpopup">
			<div class="mpTitle">
				<span style="font-size: 18px;" id="destText1">진행중인 투표</span>
				<span class="mpclose"><img src="${siteImgPath}/common/layerClose.png" alt=""/></span>
			</div>
			<div class="mpHead" id="destTitle"></div>		
			<div class="mdtableWrap">
				<table class="mpTable">		
					<colgroup>
						<col style="width:30%;"/>
						<col style="width:70%;"/>
					</colgroup>
					<tbody>
						<tr>
							<th id="destText2">투표기간</th>
							<td id="destDate"></td>
						</tr>
					</tbody>
				</table>
				<img id="destImage"/>
			</div>
			<div class="mpBtnBox">
				<span class="mpbtnTxt" id="destText3">투표 참여하기</span>
			</div>
		</div>
		<p>
			<input type="checkbox" id="popChk" title="" value="" name=""/><label for="popChk">오늘하루 열지 않기</label>
			<a href="#" class="openPopClose">닫기</a>
		</p>
	</div>
	<div class="popfade" style="display:none;"></div>
 
	<!-- footer -->
	<jsp:include page="/WEB-INF/views/mobile/common/footer.jsp"/>
	<!-- //footer -->
	
</div>

</body>
</html>
