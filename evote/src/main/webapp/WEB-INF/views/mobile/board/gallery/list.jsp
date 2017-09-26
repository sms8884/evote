<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page contentType="text/html; charset=utf-8" %>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>

<!-- meta -->
<jsp:include page="/WEB-INF/views/mobile/common/meta.jsp"/>
<!-- //meta -->
<link href="${siteCssPath}/board.css" type="text/css" rel="stylesheet"  />

<script language="javascript" type="text/javascript">

	function detail(seq) {
		$("#searchForm").attr("action", "/board/${board.boardName}/" + seq);
		$("#searchForm").attr("method", "POST");
		$("#searchForm").submit();		
	}
	
	function searchPost() {
		$("#searchText").val( $("#tmpSearchText").val() );
		$("#searchForm").attr("action", "/board/${board.boardName}/list");
		$("#searchForm").attr("method", "POST");
		$("#searchForm").submit();
	}

	function morePage() {
    	
        $('#pageNo').val( Number($('#pageNo').val()) + 1 );
	    
        $.ajax({
            type: 'POST',
            url: '/board/${board.boardName}/list/more',
            dataType: 'json',
            data: {
            	'pageNo':$('#pageNo').val(),
            	'searchTarget':'TITLE',
            	'searchText':$('#searchText').val()
            },
            success: function (data) {
            	
            	if(data.boardPostList.length > 0) {
            		$(data.boardPostList).each(function() {
            			if(this.thumbnailSeq != undefined) {
            				var imageSrc = "/file-download/" + this.thumbnailSeq;
            			} else {
            				var imageSrc = "${siteImgPath}/sub3/gallist5.png";
            			}
	        			var html = "<li>"
	       						 + "  <a href='#' onclick='detail(" + this.postSeq + "); return false;'>"
	       						 + "    <img src='" + imageSrc + "' style='width: 130px; height: 76px;'/>"
	       						 + "    <div class='galText'>"
	       						 + "      <p class='Tit'>" + this.title + "</p>"
	       						 + "      <span>" + this.strRegDate + " | 조회수 " + this.readCnt + "</span>"
	       						 + "    </div>"
	       						 + "  </a>"
	       						 + "</li>";
  		 				$("#ulPostList").append(html);
            		});
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

	<!-- board-breadcrumb -->
	<c:choose>
		<c:when test="${board.boardName eq 'cmit'}">
			<div class="location">
				<img src="${siteImgPath}/common/locaHome.png" alt=""/>
				<span>주민참여위원회</span>
				<span><c:out value="${board.boardTitle}"/></span>
			</div>		
		</c:when>
		<c:otherwise>
			<jsp:include page="/WEB-INF/views/mobile/board/board-breadcrumb.jsp"/>
		</c:otherwise>
	</c:choose>
	<!-- //board-breadcrumb -->

	<!-- search box -->
	<jsp:include page="/WEB-INF/views/mobile/board/board-search.jsp" />
	<!-- //search box -->

	<div class="boardList3">
	
		<ul class="" id="ulPostList">
			<c:forEach items="${boardPostList}" var="list" varStatus="status">
	        <li>
				<a href='#' onclick='detail(${list.postSeq}); return false;'>
				<img src='/file-download/${list.thumbnail.fileSeq}' style='width: 130px; height: 76px;'/>
				<div class='galText'>
				<p class='Tit'><c:out value="${list.title}"/></p>
				<span><fmt:formatDate value="${list.regDate}" pattern="yyyy-MM-dd"/> | 조회수 <c:out value="${list.readCnt}"/></span>
				</div>
				</a>
			</li>
			</c:forEach>
		</ul>

		<p class="boardMore"><a href="#" onclick="morePage(); return false;"><span>더보기(10)</span></a></p>
		
	</div>

	<jsp:include page="/WEB-INF/views/mobile/board/board-search-form.jsp" />
	
	<!-- footer -->
	<jsp:include page="/WEB-INF/views/mobile/common/footer.jsp"/>
	<!--// footer -->

</div>

</body>
</html>
