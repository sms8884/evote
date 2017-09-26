<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page contentType="text/html; charset=utf-8" %>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>

<!-- meta -->
<jsp:include page="/WEB-INF/views/front/common/meta.jsp"/>
<!-- //meta -->

<link href="${siteCssPath}/etc.css" type="text/css" rel="stylesheet"  />

<script language="javascript" type="text/javascript">
//<![CDATA[
	$(document).ready(function(){
		$('.gnb').topmenu({ d1: 3, d2: 4});
	});

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
		layer.fadeIn().css({ 'width': 460 });
		layer.css({
			'margin-top' : -(layer.height() / 2),
			'margin-left' : -(layer.width() / 2)
		});
		$('body').append('<div class="fade"></div>');
		$('.fade').css({'filter' : 'alpha(opacity=80)'}).fadeIn();
		return false;		
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
	
//]]>
</script>
</head>
<body>

<!-- header -->
<jsp:include page="/WEB-INF/views/front/common/header.jsp"/>
<!-- //header -->

<!-- board-breadcrumb -->
<jsp:include page="/WEB-INF/views/front/board/board-breadcrumb.jsp"/>
<!-- //board-breadcrumb -->

<div id="container" class="container">
	<div class="containerWrap">
		
		<!-- LNB -->
		<jsp:include page="/WEB-INF/views/front/common/lnb.jsp">
			<jsp:param name="menuName" value="notice"/>
		</jsp:include>
		<!-- //LNB -->
			
		<div class="contentsWrap">
			<h3 class="contentTit">문의하기</h3>
			<div class="contents">
				<div class="boardWrite"  style="padding-top:30px;">
					<table cellpadding="0" cellspacing="0" class="tbL" summary="">
						<caption>신청인 정보 입력하기</caption>
						<colgroup>
							<col width="100px"/>
							<col width="300px"/>
							<col width="100px"/>
							<col width="*"/>
						</colgroup>
						<tbody>
							<tr>
								<th>작성자</th>
								<td>
									<c:out value="${fn:substring(boardPost.append1, 0, 1)}OO"/>
								</td>
								<th>등록일</th>
								<td><fmt:formatDate pattern="yyyy-MM-dd" value="${boardPost.regDate}" /></td>
							</tr>
							
							<c:if test="${board.cateUseYn eq 'Y'}">
							<tr>
								<th>구분</th>
								<td colspan="3"><c:out value="${boardPost.categoryNm}"/></td>
							</tr>
							</c:if>
							
							<tr>
								<th>제목</th>
								<td colspan="3"><c:out value="${boardPost.title}"/></td>
							</tr>
							<tr>
								<th>문의내용</th>
								<td colspan="3"><c:out value="${fn:replace(boardPost.cont, crcn, br)}" escapeXml="false"/></td>
							</tr>
						</tbody>
					</table>
					
					<div class="btnR">
						<c:choose>
							<c:when test="${boardPost.ownerYn eq 'Y'}">
								<a href="#" onclick="remove('${boardPost.postSeq}'); return false;" class="btn_blue" style="float:left; color: #fff">삭제하기</a>
							</c:when>
							<c:when test="${boardPost.regUser le 0}">
								<a href="#" onclick="openLayer('remove'); return false;" class="btn_blue" style="float:left; color: #fff">삭제하기</a>
							</c:when>
						</c:choose>
						
						<c:if test="${boardPost.append4 ne 'Y'}">
							<c:choose>
								<c:when test="${boardPost.ownerYn eq 'Y'}">
									<a href="#" onclick="modify('${boardPost.postSeq}'); return false;" class="btn_blue" style="color: #fff">수정하기</a>
								</c:when>
								<c:when test="${boardPost.regUser le 0}">
									<a href="#" onclick="openLayer('modify'); return false;" class="btn_blue" style="color: #fff">수정하기</a>
								</c:when>
							</c:choose>
						</c:if>

						<a href="#" onclick="list(); return false;" class="btn_reset">목록보기</a>
					</div>
					
				</div>
				
				<c:if test="${boardPost.append4 eq 'Y'}">
				<div class="boardWrite">
					<table cellpadding="0" cellspacing="0" class="tbL" summary="" >
						<caption>신청인 정보 입력하기</caption>
						<colgroup>
							<col width="15%"/>
							<col width="*"/>
						</colgroup>
						<tbody>
							<tr>
								<th>답변일</th>
								<td><fmt:formatDate pattern="yyyy-MM-dd" value="${boardPost.modDate}" /></td>
							</tr>
							<tr>
								<th>답변내용</th>
								<td><c:out value="${fn:replace(boardPost.append5, crcn, br)}" escapeXml="false"/></td>
							</tr>
						</tbody>
					</table>

				</div>
				</c:if>
				
				<div id="visitorLayer" class="loginMbtLayer1 layer_block">
					<p class="tit">비밀번호확인</p>
					<div class="loginMbtLayerCon">
						<p class="inptxt"><input type="password" class="it widinputxt" id="tmpPw" placeholder="비밀번호를 입력해주세요."/></p>
						<a href="#" class="btW1 layerClose2"><span>취소</span></a>
						<a href="#" class="btC1 " onclick="checkPassword(); return false;"><span>확인</span></a>
						<a href="#" class="layerClose"><img src="${siteImgPath}/common/layerClose.png" alt="닫기"/></a>
						<input type="hidden" id="tmpSeq" value="${boardPost.postSeq}"/>
					</div>
				</div>
				
				<jsp:include page="/WEB-INF/views/front/board/board-search-form.jsp" />
				
			</div>
		</div>
	</div>
</div>

<!-- footer -->
<jsp:include page="/WEB-INF/views/front/common/footer.jsp"/>
<!-- //footer -->

</body>
</html>
