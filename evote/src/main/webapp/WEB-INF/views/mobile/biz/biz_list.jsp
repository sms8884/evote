<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page contentType="text/html; charset=utf-8" %>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>
<!-- meta -->
<jsp:include page="/WEB-INF/views/mobile/common/meta.jsp"/>
<!-- //meta -->
<link href="${siteCssPath}/board.css" type="text/css" rel="stylesheet"  />

<script language="javascript" type="text/javascript">
//<![CDATA[
	$(document).ready(function(){
		setSelectDate();
		var search_year = '${params.search_year}';
		var search_string = '${params.search_string}';
		
		if(search_year != ''){
 			$("#search_year > option[value="+search_year+"]").attr("selected", "true");	
 		}
		if(search_string != ''){
			
			$("#search_string").css("background","none");	
			$("#search_string").val(search_string);	
		}
	});
	
	/* 2012 년부터 현재 년도 +1년까지 셀렉트박스 생성 */
	function setSelectDate(){
		var today = new Date();
		var year = today.getFullYear();
		var standard  = year - 2012;
		for(var i = 0 ; i<=standard ; i++){
			if( i==0 ){
				var tmp2 =	"<option value='"+(year+1)+"'>"+(year+1)+"</option>";				
				$("#search_year").append(tmp2);
			}
			var tmp = "<option value='"+(year-i)+"'>"+(year-i)+"</option>";
			$("#search_year").append(tmp);
		}
	}
	/*/// 셀렉트 박스생성 END */

	function numberWithCommas(x) {
    	return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
	}
	
	function viewMore(){
		$('#pageNo').val( Number($('#pageNo').val()) + 1 );
	    $.ajax({
	        type: 'POST',
	        url: '/biz/biz_list/more',
	        dataType: 'json',
	        data: $("#form").serialize(),
	        success: function (data) {
	        	if(data.businessList.length > 0) {
	            	for(var idx=0; idx < data.businessList.length; idx++) {
	            		var item = data.businessList[idx];
					/* 추가10개로 데이터 추가 */            		
	        			var html = '<div class="budgetBox" onclick="detailBiz('+item.biz_seq+')">'
	        							+'<div class="box_inner">'
	        							+'<div class="cont">';
	        							if(item.state == "실행중"){
	        								html+= '<div class="budget_ing">실행중 </div>';
	        							}else{
	        								html+= '<div class="budget_end"> 완료 </div>';
	        							}
	        					html+= '<p class="budgetTit"><a href="/biz/biz_view/'+item.biz_seq+' "class="title">"'+item.biz_name+'"</a></p>'
	  									+'<p>'+ '<span class="won">소요예산 ' + numberWithCommas(item.budget) + ' <em>천원</em></span>'
	  									+'<span class="heart">'+item.sympathyCnt+'</span>'
	  									+	'</p> </div> <div class="img">';
	  								 if(item.fileSeq != null){
	  									 html += '<p><img src="/file-download/'+item.fileSeq+'"  width="89px" alt=""></p>';
	  								 }
	  							html+='</div> </div> </div>'		
					/*// 추가10개로 데이터 추가 */            		
	  									
	        		 	$("#bizContents").append(html);
	            	}
	        	}else{
	        		alert('더이상 데이터가 없습니다');
	        	}
	        },
	        error: function (jqXHR, textStatus, errorThrown) {
	            console.log(errorThrown);
	            console.log(textStatus);
	        }
	    });
				
	}
	
	function searchData(){
		$("#pageNo").val(1);
 		$("#form").submit();
 	}
 	
	function detailBiz(bizSeq){
		location.href="/biz/biz_view/"+bizSeq;
	}

	$(function() {
		$("#search_string").on("focus",function() {
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
		
		<c:if test="${not empty params.search_string}">
			$("#search_string").css('background-image','none');
		</c:if>
	});
	
//]]>
</script>
<body>

<!-- header -->
<jsp:include page="/WEB-INF/views/mobile/common/header.jsp"/>
<!-- //header -->


<div class="wrap">
	<div class="location">
		<img src="${siteImgPath}/common/locaHome.png" alt=""/>
		<span>주민참여예산제</span>
		<span>사업현황</span>
	</div>
	
	<form id='form' name='form' method="post"  class="searchTb">			
		<div class="sub4Select">
			<select name="search_year" id="search_year" title="">
				<option value="" selected = "selected">전체</option>
			</select>
		</div>

		<div class="boardSearch">
			<input type="text" class="iptxt" title="" value="" name="search_string" id="search_string" style="text-indent: 10px;"/>
			<input type="button" class="ipbtn" title="" value="검색" name="" onclick="searchData()" />
		</div>
		<input type="hidden" id="search_gubun"  name="search_gubun" value="TITLE"/>
		<input type="hidden" id="pageNo" name="pageNo" value="${pagingHelper.pageNo}"/>
	</form>
	
	<div class="containerWrap">

		<div class="sub4reslutTxt">
			<p>총 <fmt:formatNumber value="${pagingHelper.totalCnt}" pattern="#,###"/>건이 검색되었습니다.</p>
		</div>
		<c:if test="${!empty businessList}">
		<div class="budgetWrap" id = "bizContents">
		<c:forEach var="item" items="${businessList}" varStatus="status" >
		
			<div class="budgetBox" onclick="detailBiz(${item.biz_seq})">
				<div class="box_inner">
					<div class="cont">
							<c:if test="${item.state eq '실행중'}">
								<div class="budget_ing">실행중 </div>
							</c:if>
							<c:if test="${item.state eq '완료'}">
								<div class="budget_end">	완료	</div>
							</c:if>
						<p class="budgetTit"><a href="/biz/biz_view/${item.biz_seq}"   class="title">"${item.biz_name}"</a></p>
						<p>
							<span class="won">소요예산 <fmt:formatNumber pattern="#,###" value="${item.budget}" type="number"/> <em>천원</em></span>
							<span class="heart">${item.sympathyCnt}</span>
						</p>
					</div>
					<div class="img">
						<c:if test="${item.fileSeq != null}">
						<p><img src="/file-download/${item.fileSeq}"  width="89px" alt=""></p>
						</c:if>
					</div>
				</div>
			</div>
			</c:forEach>
		</div>
			<p class="boardMore"><a href="javascript:viewMore()"><span>더보기(10)</span></a></p>
		</c:if>
						<c:if test="${empty businessList}">
								<h3 align="center" style="font-size:large; ;">목록이없습니다</h3>
						</c:if>	
		
	</div>
		<!-- footer -->
	<jsp:include page="/WEB-INF/views/mobile/common/footer.jsp"/>
	<!--// footer -->
</div>



</body>
</html>
