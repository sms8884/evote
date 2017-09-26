<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page contentType="text/html; charset=utf-8" %>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>

<!-- meta -->
<jsp:include page="/WEB-INF/views/mobile/common/meta.jsp"/>
<!-- //meta -->
<link href="${siteCssPath}/board.css" type="text/css" rel="stylesheet"  />

<script language="javascript" type="text/javascript">

	var _act;
	
	function modify(postSeq) {
		$("#searchForm").attr("action", "/board/${board.boardName}/modify/" + postSeq);
		$("#searchForm").attr("method", "POST");
		$("#searchForm").submit();		
	}

	function remove(postSeq) {
		// 삭제하시겠습니까?
		if(confirm('<spring:message code="message.admin.notice.002" />')) {
			$("#searchForm").attr("action", "/board/${board.boardName}/remove/" + postSeq);
			$("#searchForm").attr("method", "POST");
			$("#searchForm").submit();
		}
	}
	
	function list() {
		$("#searchForm").attr("action", "/board/${board.boardName}/list");
		$("#searchForm").attr("method", "POST");
		$("#searchForm").submit();		
	}

	function openLayer(act) {
		_act = act;
		var layer = $("#visitorLayer");
		layer.fadeIn().css({ 'width': 300 });
		layer.css({
			'margin-top' : -(layer.height() / 2),
			'margin-left' : -(layer.width() / 2)
		});
		$('body').append('<div class="fade"></div>');
		$('.fade').css({'filter' : 'alpha(opacity=80)'}).fadeIn();
	}

	function checkPassword() {
		
		var seq = $("#tmpSeq").val();
		var vpw = $("#tmpPw").val();
        $.ajax({
            type: 'POST',
            url: '/board/${board.boardName}/checkPassword',
            dataType: 'json',
            data: {"seq":seq, "vpw":vpw},
            success: function (data) {
            	
            	if(data.result == true) {
            		
        		    if($("#password", "#searchForm").length == 0) {
        		    	$("#searchForm").append("<input type='hidden' id='password' name='password'/>");
        		    }
        		    $("#password").val(vpw);
        		    
            		if(_act == "modify") {
            			modify(seq);
            		} else if(_act == "remove") {
            			remove(seq);
            		}
            		
            	} else {
            		alert(data.message);
            		$("#tmpPw").val("");
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
	<jsp:include page="/WEB-INF/views/mobile/board/board-breadcrumb.jsp"/>
	<!-- //board-breadcrumb -->

	<div class="boardWrite">

		<p class="writeTit">문의하기</p>
		<table cellpadding="0" cellspacing="0" class="tbL" summary="" >
			<colgroup>
				<col width="80"/><col width="*"/>
			</colgroup>
			<tbody>
				<tr>
					<th scope="row">작성자</th>
					<td>
						<c:out value="${fn:substring(boardPost.append1, 0, 1)}OO"/>
					</td>
				</tr>
				<tr>
					<th scope="row">등록일</th>
					<td><fmt:formatDate value="${boardPost.regDate}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
				</tr>
				
				<c:if test="${board.cateUseYn eq 'Y'}">
				<tr>
					<th scope="row">구분</th>
					<td>
						<c:out value="${boardPost.categoryNm}"/>
					</td>
				</tr>
				</c:if>
				
				<tr>
					<th scope="row">제목</th>
					<td><c:out value="${boardPost.title}"/></td>
				</tr>
				<tr>
					<th scope="row" colspan="2">문의내용</th>
				</tr>
				<tr>
					<td colspan="2" class="bln">
						<c:out value="${fn:replace(boardPost.cont, crcn, br)}" escapeXml="false"/>
					</td>
				</tr>
			</tbody>
		</table>

		<c:if test="${boardPost.append4 eq 'Y'}">
		<table cellpadding="0" cellspacing="0" class="tbL" summary="" >
			<colgroup>
				<col width="80"/><col width="*"/>
			</colgroup>
			<tbody>
				<tr>
					<th scope="row">답변일</th>
					<td><fmt:formatDate value="${boardPost.modDate}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
				</tr>
				<tr>
					<th scope="row" colspan="2">답변내용</th>
				</tr>
				<tr>
					<td colspan="2" class="bln">
						<c:out value="${fn:replace(boardPost.append5, crcn, br)}" escapeXml="false"/>
					</td>
				</tr>
			</tbody>
		</table>
		</c:if>
		
		<p class="writeBt">

			<c:choose>
				<c:when test="${boardPost.ownerYn eq 'Y'}">
					<a href="#" onclick="remove('${boardPost.postSeq}'); return false;" class="gray">삭제하기</a>
				</c:when>
				<c:when test="${boardPost.regUser le 0}">
					<a href="#" onclick="openLayer('remove'); return false;" class="gray">삭제하기</a>
				</c:when>
			</c:choose>
						
			<c:if test="${boardPost.append4 ne 'Y'}">
				<c:choose>
					<c:when test="${boardPost.ownerYn eq 'Y'}">
						<a href="#" onclick="modify('${boardPost.postSeq}'); return false;" class="blue">수정하기</a>
					</c:when>
					<c:when test="${boardPost.regUser le 0}">
						<a href="#" onclick="openLayer('modify'); return false;" class="blue">수정하기</a>
					</c:when>
				</c:choose>
			</c:if>
			
		</p>

		<a href="#" onclick="list(); return false;" class="listBt">목록보기</a>
		
	</div>
	
	<!--팝업-->
	<div id="visitorLayer" class="layer_block layerPop">
		<p class="layerTit">
			<strong>비밀번호 입력</strong>
			<a href="#" class="layerClose"><img src="${siteImgPath}/common/layerClose.png" alt=""/></a>
		</p>
		<div class="layerCont">
			<p class="txt">등록 시에 입력한 비밀번호를 입력해주세요</p>
			<input type="password" class="it" id="tmpPw" placeholder="비밀번호 입력" style="width:99%; height:40px; margin:10px 0;">
			<p class="bt">
				<a href="#" class="cancel layerClose">취소</a>
				<a href="#" onclick="checkPassword(); return false;" class="ok"><span>확인</span></a>
			</p>
		</div>
		<input type="hidden" id="tmpSeq" value="${boardPost.postSeq}"/>
	</div>

	<jsp:include page="/WEB-INF/views/mobile/board/board-search-form.jsp" />
	
	<!-- footer -->
	<jsp:include page="/WEB-INF/views/mobile/common/footer.jsp"/>
	<!--// footer -->
	
</div>

</body>
</html>
