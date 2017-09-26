<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page contentType="text/html; charset=utf-8" %>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>

<!-- meta -->
<jsp:include page="/WEB-INF/views/mobile/common/meta.jsp"/>
<!-- //meta -->

<link href="${siteCssPath}/board.css" type="text/css" rel="stylesheet"  />

<script language="javascript" type="text/javascript">

	$(function() {
		$("#bizNm").on("focus",function() {
			$(this).css('background-image','none');
		}).on("blur",function() {
			if($(this).val() == "") {
				var imageUrl = "${siteImgPath}/sub3/boardSearch.png";
				$(this).css('background', 'url(' + imageUrl + ') 50% 50% no-repeat');
				$(this).css('background-size', '71px 16px');
			} else {
				$(this).css('background-image','none');
			}
		});
		
		fnSetSearchData();
		
		var totalCnt = "${pagingHelper.totalCnt}";
		
		if(totalCnt >= 10) {
			$("#spanListCount").text(10);
		} else {
			$("#spanListCount").text(totalCnt);
		}
		
	});
	
	function fnSearch(idx){
		
		if( $("#checkMyProposal").hasClass('on') ) {
			$("#myProposal").val("Y");
		} else {
			$("#myProposal").val("N");
		}
		
		$("#sortItem").val(idx);
	    $("#searchFrm").prop("action", "/proposal/complete-list").submit();
	}
	
	function fnSetSearchData(){
	    var _tempFrm = $("#_tempFrm");
	    $("#isPs").val(_tempFrm.children("[name=isPs]").val());
	    $("#startDate").val(_tempFrm.children("[name=startDate]").val());
	    $("#endDate").val(_tempFrm.children("[name=endDate]").val());
	    $("#status").val(_tempFrm.children("[name=status]").val());
	    $("#bizNm").val(_tempFrm.children("[name=bizNm]").val());
	    
	    if($("#bizNm").val() != "") {
	    	$("#bizNm").css('background-image','none');
	    }
	    
	    // 최근순/공감순/조회순
	    var sortItem = _tempFrm.children("[name=sortItem]").val();
	    if(sortItem == 1) {
	    	$("#sort1").addClass("on");
	    } else if(sortItem == 2) {
	    	$("#sort2").addClass("on");
	    } else {
	    	$("#sort0").addClass("on");
	    }
	
	    // 전체/상시/공모 tab
	    var isPs = _tempFrm.children("[name=isPs]").val();
	    if(isPs == "Y"){
	    	$("#tabPs3").addClass("on");
	    } else if(isPs == "N"){
	    	$("#tabPs2").addClass("on");
	    } else {
	    	$("#tabPs1").addClass("on");
	    }
	    
	    if($("#myProposal").val() == "Y") {
	    	$("#checkMyProposal").addClass("on");
	    } 
	}
	
	function fnMovePsType(psSearchType){
		$("#_tempFrm").empty();
		if(psSearchType != 1){
			var isPs = "N";//상시
			if(psSearchType == 3){
				isPs = "Y";//공모
			}
			$('<input type="hidden" name="isPs" />').val(isPs).appendTo("#_tempFrm");	
		}
		$("#_tempFrm").prop("method", "post");
	    $("#_tempFrm").prop("action", "<c:url value="/proposal/complete-list" />").submit();
	}
	
	function fnMoveDetail(propSeq) {
		$('#_tempFrm').prop('method', 'post');
	    $('#_tempFrm').prop('action', '/proposal/complete-detail/' + propSeq).submit();
	}
	
	function fnWriteForm() {
		$('#_tempFrm').prop('method', 'post');
	    $('#_tempFrm').prop('action', '<c:url value="/proposal/write" />').submit();
	}

    function morePage() {
    	
        $('#pageNo').val( Number($('#pageNo').val()) + 1 );
	    
        $.ajax({
            type: 'POST',
            url: '/proposal/list/more',
            dataType: 'json',
            data: $("#_tempFrm").serialize(),
            success: function (data) {
            	if(data.proposalList.length > 0) {
            		$("#spanListCount").text( Number($("#spanListCount").text()) + data.proposalList.length);
	            	for(var idx=0; idx < data.proposalList.length; idx++) {
	            		var item = data.proposalList[idx];
	            		var symYnClass = "bla1";
	            		if(item.symYn == "Y") {
	            			symYnClass = " on";
	            		}
	        			var html = "<li class=''>"
	        					 + "<a href='#' onclick='fnMoveDetail(" + item.propSeq + "); return false;'>" + item.bizNm + "</a>"
	        					 + "<span>" + item.regDateText + " | 조회수 " + item.readCnt + "</span>"
	        					 + "<p>"
	        					 + "<a href='#' class='" + symYnClass + "'>" + item.symCnt + "</a>"
	        					 + "<a href='#' class='bla2'>" + item.commentCnt + "</a>"
	        					 + "</p>"
	        					 + "</li>";
	        		 	$("#ulProposalList").append(html);
	            	}
            	} else {
            		alert("조회된 데이터가 없습니다.");
            	}
            },
            error: function (jqXHR, textStatus, errorThrown) {
                console.log(errorThrown);
                console.log(textStatus);
            }
        });
        
    }
    
</script>

</head>
<body>

<!-- header -->
<jsp:include page="/WEB-INF/views/mobile/common/header.jsp"/>
<!-- //header -->

<div class="wrap">
	<div class="location">
		<img src="${siteImgPath}/common/locaHome.png" alt=""/>
		<span>주민참여예산제</span>
		<span>정책제안</span>
		<span>검토완료</span>
	</div>

	<p class="boardTit">제안사업(<span id="spanListCount" style="height: 42px; line-height: 42px; text-align: center; font-size: 16px; color: #1278e1;"></span>/<c:out value="${pagingHelper.totalCnt}"/>)</p>
	<p class="boardTopBt">
		<a href="/proposal/write" class="bookBg"><span>내 정책 제안하기</span></a>
	</p>

	<form name="searchFrm" id="searchFrm" method="post" action="" class="searchTb">
	
		<div class="boardSearch">
			<input type="text" class="iptxt" name="bizNm" id="bizNm" style="text-indent: 10px;"/>
			<input type="button" class="ipbtn" title="" value="검색" onclick="fnSearch(); return false;" />
		</div>
	
		<div class="boardTabChk">
			<c:if test="${_accountInfo.hasRole('USER')}">
				<a id="checkMyProposal" href="#" class="chk">내 제안 보기</a>
			</c:if>
			
			<ul class="">
				<li><a href="#" id="sort0" onclick="fnSearch(''); return false;">최근순</a></li>
				<li><a href="#" id="sort1" onclick="fnSearch(1); return false;">공감순</a></li>
				<li><a href="#" id="sort2" onclick="fnSearch(2); return false;">조회순</a></li>
			</ul>
		</div>
	
		<script language="javascript" type="text/javascript">
		//<![CDATA[
			$('.chk').on('click',function(){
				if ($(this).hasClass('on')){
					$(this).removeClass('on');
				}else{
					$(this).addClass('on');
				}
				return false;
			})
		//]]>
		</script>
	
		<input type="hidden" id="sortItem" name="sortItem"/>
		<input type="hidden" id="isPs" name="isPs" value="${param.isPs}" />
		<input type="hidden" id="myProposal" name="myProposal" value="${params.myProposal}" />
						
	</form>

	<c:if test="${not empty proposalList}">
	<div class="boardList2">
		<ul class="" id="ulProposalList">
			<c:forEach items="${proposalList}" var="item" varStatus="status">
				<li class="">
					<a href="#" onclick="fnMoveDetail(${item.propSeq}); return false;"><c:out value="${item.bizNm }" /></a>
					<span><c:out value="${item.regDateText }" /> | 조회수 <fmt:formatNumber value="${item.readCnt }" pattern="#,###" /></span>
					<p>
						<c:set var="symYnClass">bla1 <c:if test="${item.symYn eq 'Y'}">on</c:if></c:set>
						<a href="#" class="${symYnClass}"><fmt:formatNumber value="${item.symCnt }" pattern="#,###" /></a>
						<a href="#" class="bla2"><fmt:formatNumber value="${item.commentCnt }" pattern="#,###" /></a>
					</p>
				</li>
			</c:forEach>
		</ul>
		<p class="boardMore"><a href="#" onclick="morePage(); return false;"><span>더보기(10)</span></a></p>
	</div>
	</c:if>

	<c:if test="${empty proposalList}">
	<!--20160818추가-->
	<div class="noReseult" style="font-size:30px; font-weight:bold; color:#B0B0B0; text-align:center; width:100%; min-height:300px; padding-top:100px;">
		조회된 데이터가 없습니다.
	</div>
	<!--20160818추가:e-->
	</c:if>

	<jsp:include page="/WEB-INF/views/mobile/proposal/proposal-search-form.jsp" />

	<!-- footer -->
	<jsp:include page="/WEB-INF/views/mobile/common/footer.jsp"/>
	<!-- //footer -->
	
</div>

</body>
</html>