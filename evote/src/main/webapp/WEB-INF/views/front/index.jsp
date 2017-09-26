<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page contentType="text/html; charset=utf-8" %>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>

<!-- meta -->
<jsp:include page="/WEB-INF/views/front/common/meta.jsp"/>
<!-- //meta -->

<link href="${siteCssPath}/main.css" type="text/css" rel="stylesheet"  />

<!-- popup js -->
<script src="${commonJsPath}/popup.js" language="javascript" type="text/javascript"></script>
<script src="${commonJsPath}/bannerSlide.js" language="javascript" type="text/javascript" charset="utf-8"></script>
<script src="${commonJsPath}/jquery.popupWindow.js" language="javascript" type="text/javascript" charset="utf-8"></script>

<script language="javascript" type="text/javascript">
//<![CDATA[
	$(document).ready(function(){
		$('.gnb').topmenu({ d1: 0, d2: 0});
		
		$('#slides').slidesjs({
			width: 1920,
			height: 454,
			play: {
				active: true,
				auto: true,
				interval: 5000,
				swap: true
			},
			effect: {
				slide: {
					speed: 1500
				}
			}
		});
 		$('#slides').find('a img').on('mouseover', function(){
			var src = $(this).attr('src').replace('_off', '_on');
			$(this).attr('src', src);
		}).on('mouseout', function(){
			var src = $(this).attr('src').replace('_on', '_off');
			$(this).attr('src', src);
		});
 		
 		bannerMake("left");
 		
	});

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
	}

	var data = {};
	var popupInfo = {};

	function getPopupInfo(bpSeq) {
		return data[bpSeq];
	}
	
	$(function() {

		<c:forEach items="${popupList}" var="list">

		if($.cookie("_p${list.bpSeq}") == undefined){
			$.newPopupWindow({
				windowURL:"/popup/${list.bpSeq}",
				windowName:"popup",
				width:520,
				height:730
			});
		}
		
		</c:forEach>
		
		$(".moreBtn").on("click", function(e) {
			e.preventDefault();
			if($(".menu_tab00").is(":visible")) {
				location.href = "/biz/biz_list";
			} else if($(".menu_tab01").is(":visible")) {
				location.href = "/board/cmit/list";
			}
		});
		
	});
		
//]]>
</script>

</head>

<body>

<!-- header -->
<jsp:include page="/WEB-INF/views/front/common/header.jsp"/>
<!-- //header -->

<div class="mainVisual">
	<div id="slides">
		<p>
			<img src="${siteImgPath}/main/visual1.png" alt="" class="visual">
			<span>
				<img src="${siteImgPath}/main/visual1_slogan.png" alt="" class="slogan"/>
				<a href="/proposal/intro"><img src="${siteImgPath}/main/visual1_bt_off.png" alt=""/></a>
			</span>
		</p>
		<p>
			<img src="${siteImgPath}/main/visual2.png" alt="" class="visual">
			<span>
				<img src="${siteImgPath}/main/visual2_slogan.png" alt="" class="slogan"/>
				<a href="/proposal/intro"><img src="${siteImgPath}/main/visual1_bt_off.png" alt=""/></a>
			</span>
		</p>
	</div>
</div>

<div id="container" class="mainContainer">
	<div class="mainCon1">
		<div class="bannerBox">
			<div class="bxContainer" style="display: block;">
				<ul class="bannerList">
				
					<c:if test="${not empty bannerList}">
						<c:forEach items="${bannerList}" var="list">
							<li style="display:block;">
								
								<c:set var="bannerLink">
									<c:if test="${list.dest eq 'V'}">/vote/vote-main</c:if>
									<c:if test="${list.dest eq 'P'}">/proposal/guide</c:if>
								</c:set>
								<a href="${bannerLink}">
									<c:if test="${empty list.webImageList}">
										<img src="${siteImgPath}/main/bannerList1.png" alt="배너이미지1" >
									</c:if>
									<c:if test="${not empty list.webImageList}">
										<img src="/file-download/${list.webImageList[0].fileSeq}" style="width: 490px; height: 266px;">
									</c:if>
								</a>
								<div class="bannerTxt" style="">
									<p class="bnTxt1">
										<c:if test="${list.dest eq 'V'}">투표</c:if>
										<c:if test="${list.dest eq 'P'}">공모</c:if>
									</p>
									<p class="bnTxt2"><c:out value="${list.destTitle}"/></p>
									<p class="bnTxt3">
										<fmt:formatDate value="${list.destStartDate}" pattern="yyyy.MM.dd"/> ~
										<fmt:formatDate value="${list.destEndDate}" pattern="yyyy.MM.dd"/>
									</p>
								</div>
							</li>
						</c:forEach>
					</c:if>
					
				</ul>
			</div>
			<div class="bxControl">
				<div id="pagingList" class="bxPage">
				
					<c:if test="${not empty bannerList}">
						<c:forEach items="${bannerList}" var="list" varStatus="status">
							<div class="bxPage_item">
								<a href="#" class="bxPage_link <c:if test="${status.first}">active</c:if>"><c:out value="${status.index + 1}"/> </a>
							</div>
						</c:forEach>
					</c:if>
					
				</div>
				<div class="bxControl-direction">
					<a class="bx_prev" href="#">Prev</a>
					<a class="bx_next" href="#">Next</a>
				</div>
			</div>		
		</div>	
		
		<div class="idea">
			<div class="ideaLis">
				<p class="tit">
					<strong>정책제안 함께 생각하기</strong>
					<a href="/proposal/list">더보기</a>
				</p>
				<ul class="">
					<c:if test="${not empty proposalList}">
						<c:forEach items="${proposalList}" var="list">
							<li><a href="/proposal/detail/${list.propSeq}" class="ellipsis"><c:out value="${list.bizNm}"/></a><span><fmt:formatDate pattern="yyyy.MM.dd" value="${list.regDate}"/></span></li>
						</c:forEach>
					</c:if>
				</ul>
			</div>
			<p class="ideaBt"><a href="/proposal/list"><strong>내 정책 제안하기</strong><span>여러분의 정책을 알려주세요<br/>주민이 함께 제안하고 참여하여 추진합니다</span></a></p>
		</div>
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
						<c:forEach items="${bizList}" var="list" varStatus="status">
							<c:choose>
								<c:when test="${status.first}">
									<div class="condition_sub1">
										<c:if test="${empty list.fileSeq}">
											<img src="${siteImgPath}/main/conditionImg.png" alt="참여예산 사업현황 이미지1"/>
										</c:if>
										<c:if test="${not empty list.fileSeq}">
											<img src="/file-download/${list.fileSeq}" style="width: 162px; height: 104px;"/>
										</c:if>
										<span>
											<a href="/biz/biz_view/${list.biz_seq}">
												<strong><c:out value="${list.biz_name}"/></strong>
												<span><c:out value="${list.summary}"/></span>
											</a>
											<span><fmt:formatDate pattern="yyyy.MM.dd" value="${list.reg_date}"/></span>
										</span>
									</div>
									<ul class="conditionList">
								</c:when>
								<c:otherwise>
									<li>
										<a href="/biz/biz_view/${list.biz_seq}">
											<strong class="ellipsis"><c:out value="${list.biz_name}"/></strong>
											<span class="ellipsis"><c:out value="${list.summary}"/></span>
										</a>
										<span><fmt:formatDate pattern="yyyy.MM.dd" value="${list.reg_date}"/></span>
									</li>
									<c:if test="${status.last}">
										</ul>
									</c:if>
								</c:otherwise>
							</c:choose>
						</c:forEach>
					</c:if>
					
				</div>
			</div>
			<div class="menu_tab01" style="display:none">
				<div class="condition">
				
					<c:if test="${not empty cmitList}">
						<c:forEach items="${cmitList}" var="list" varStatus="status">
							<c:choose>
								<c:when test="${status.first}">
									<div class="condition_sub1">
										<c:if test="${empty list.imageList}">
											<img src="${siteImgPath}/main/noticeImg1.png" alt="참여예산 사업현황 이미지1"/>
										</c:if>
										<c:if test="${not empty list.imageList}">
											<img src="/file-download/${list.imageList[0].fileSeq}" style="width: 162px; height: 103px;"/>
										</c:if>
										<span>
											<a href="/board/cmit/${list.postSeq}">
												<strong><c:out value="${fn:substring(list.title, 0, 14)}"/></strong>
												<span><c:out value="${fn:substring(list.cont, 0, 30)}"/></span>
											</a>
											<span><fmt:formatDate pattern="yyyy.MM.dd" value="${list.regDate}"/></span>
										</span>
									</div>
									<ul class="conditionList">
								</c:when>
								<c:otherwise>
									<li>
										<a href="/board/cmit/${list.postSeq}">
											<strong class="ellipsis"><c:out value="${list.title}"/></strong>
											<span class="ellipsis"><c:out value="${list.cont}"/></span>
										</a>
										<span><fmt:formatDate pattern="yyyy.MM.dd" value="${list.regDate}"/></span>
									</li>
									<c:if test="${status.last}">
										</ul>
									</c:if>
								</c:otherwise>
							</c:choose>
						</c:forEach>
					</c:if>
					
				</div>
			</div>
			
		</div>

		<div class="notice">
			<p class="tit underline" >
				<strong>공지사항</strong>
				<a href="/board/notice/list">더보기</a>
			</p>
			
			<c:if test="${not empty noticeList}">
				<c:forEach items="${noticeList}" var="list" varStatus="status">
					<c:choose>
						<c:when test="${status.first}">
							<p class="img">
								<a href="/board/notice/${list.postSeq}">
									<c:if test="${empty list.imageList}">
										<img src="${siteImgPath}/main/noticeImg1.png" alt="참여예산 사업현황 이미지1"/>
									</c:if>
									<c:if test="${not empty list.imageList}">
										<img src="/file-download/${list.imageList[0].fileSeq}" style="width: 162px; height: 103px;"/>
									</c:if>
									<span>
										<span class="imgTitle"><c:out value="${fn:substring(list.title, 0, 30)}"/></span>
										<span><fmt:formatDate pattern="yyyy.MM.dd" value="${list.regDate}"/></span>
									</span>
								</a>
							</p>
							<ul class="">
						</c:when>
						<c:otherwise>
							<li>
								<a href="/board/notice/${list.postSeq}" class="ellipsis"><c:out value="${list.title}"/></a>
								<span><fmt:formatDate pattern="yyyy.MM.dd" value="${list.regDate}"/></span>
							</li>
							<c:if test="${status.last}">
								</ul>
							</c:if>
						</c:otherwise>
					</c:choose>
				</c:forEach>
			</c:if>
			
		</div>
	</div>
	<ul class="mainCon2">
		<li class="mainCon2_1"><a href="/proposal/list"><strong>정책제안</strong><span>정책을 제안해주세요</span></a></li>
		<li class="mainCon2_2"><a href="/proposal/complete-list"><strong>정책검토</strong><span>정책을 검토합니다</span></a></li>
		<li class="mainCon2_3"><a href="/vote/vote-main"><strong>투표</strong><span>정책을 투표해주세요</span></a></li>
		<li class="mainCon2_4"><a href="/biz/biz_list"><strong>실행</strong><span>실행중인 은평구 정책</span></a></li>
	</ul>
</div>

<!-- footer -->
<jsp:include page="/WEB-INF/views/front/common/footer.jsp"/>
<!-- //footer -->

</body>
</html>
