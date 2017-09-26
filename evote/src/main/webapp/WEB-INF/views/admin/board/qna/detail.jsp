<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page contentType="text/html; charset=utf-8" %>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>

<!-- meta -->
<jsp:include page="/WEB-INF/views/admin/common/meta.jsp"/>
<!-- //meta -->

<script language="javascript" type="text/javascript">

<c:if test="${boardPost.append4 ne 'Y'}">
function modifyProc() {

	if($("#append5").val() == "") {
		alert("<spring:message code='message.common.header.002' arguments='답변을'/>");
		$("#append5").focus();
		return;
	}

	$("#boardForm").attr("action", "/admin/board/${board.boardName}/modify-proc");
	$("#boardForm").attr("method", "POST");
	$("#boardForm").submit();
}
</c:if>

function list() {
	$("#searchForm").attr("action", "/admin/board/${board.boardName}/list");
	$("#searchForm").attr("method", "POST");
	$("#searchForm").submit();		
}

function modifyHidden(postSeq, hideYn) {
    $.ajax({
        type: 'POST',
        url: '/admin/board/${board.boardName}/hidden/' + postSeq,
        dataType: 'json',
        data: {"hideYn":hideYn},
        success: function (data) {
        	if(data != undefined) {
            	if(data.result == 'Y') {
            		if(hideYn == "Y") {
            			$("#tmpHideY").hide();
            			$("#tmpHideN").show();
            			$("#tmpHideText").show();
            		} else if(hideYn == "N") {
            			$("#tmpHideY").show();
            			$("#tmpHideN").hide();
            			$("#tmpHideText").hide();
            		}
            	}
        	}
        },
        error: function (jqXHR, textStatus, errorThrown) {
            console.log(errorThrown);
            console.log(textStatus);
        }
    });
}

$(function() {
<c:if test="${boardPost.hideYn eq 'Y'}">
	$("#tmpHideText").show();
	$("#tmpHideY").hide();
	$("#tmpHideN").show();
</c:if>
});

</script>

</head>
<body>
	
	<!-- header -->
	<jsp:include page="/WEB-INF/views/admin/common/header.jsp"/>
	<!-- //header -->
		
	<div class="containerWrap">
		<div class="subNav">
			<ul class="subNavUl">
				<li class="subNavHome"><img src="${siteImgPath}/common/home.png" alt="home"/></li>
				<li>주민알림</li>
				<li>문의하기</li>
			</ul>
		</div>

		<div class="container">
			<div class="contentWrap">

				<!--leftmenu-->
				<jsp:include page="/WEB-INF/views/admin/common/lnb.jsp"/>
				<!--leftmenu-->
				
				<div class="content">
					<h3 class="contentTit">문의 답변하기</h3>	
					<div class="mainContent">
						<p class="inquery_hidden">
							<a href="#" id="tmpHideY" onclick="modifyHidden('${boardPost.postSeq}', 'Y');" class="btn_gray">숨김처리</a>
							<a href="#" id="tmpHideN" onclick="modifyHidden('${boardPost.postSeq}', 'N');" class="btn_gray" style="padding:9px 10px 0px 10px; display:none;">숨김처리 해제</a>
						</p>
						<div class="boardView boardView2">
						
							<form name="boardForm" id="boardForm" enctype="multipart/form-data">
						
								<input type="hidden" name="postSeq" value="${boardPost.postSeq}"/>
								
								<!-- search param -->
								<input type="hidden" id="pageNo" name="pageNo" value="${searchParam.pageNo}"/>
								<input type="hidden" id="searchCategoryCd" name="searchCategoryCd" value="${searchParam.searchCategoryCd}"/>
								<input type="hidden" id="searchTarget" name="searchTarget" value="${searchParam.searchTarget}"/>
								<input type="hidden" id="searchText" name="searchText" value="${searchParam.searchText}"/>
								<input type="hidden" id="searchReplyYn" name="searchReplyYn" value="${searchParam.searchReplyYn}"/>
								<!-- //search param -->
							
								<table cellpadding="0" cellspacing="0" class="tbL" summary="" >
									<caption>검토의견</caption>
									<colgroup>
										<col width="15%"/>
										<col width="35%"/>
										<col width="15%"/>
										<col width="35%"/>
									</colgroup>
									<tbody>
										<tr>
											<th scope="row">문의자</th>
											<td><c:out value="${boardPost.append1}"/></td>
											<th scope="row">등록일</th>
											<td><fmt:formatDate pattern="yyyy-MM-dd" value="${boardPost.regDate}" /></td>
										</tr>
										<tr>
											<th scope="row">연락처</th>
											<td><c:out value="${boardPost.append2}"/></td>
											<th scope="row">이메일</th>
											<td><c:out value="${boardPost.append3}"/></td>
										</tr>
										<tr>
											<th scope="row">구분</th>
											<td><c:out value="${boardPost.categoryNm}"/></td>
											<th scope="row">답변일</th>
											<td>
												<c:if test="${boardPost.append4 eq 'Y'}"><fmt:formatDate pattern="yyyy-MM-dd" value="${boardPost.replyDate}" /></c:if>
											</td>
										</tr>
										<tr>
											<th scope="row">제목</th>
											<td colspan="3">
												<p id="tmpHideText" style="font-size: 13px; color:#aaa; display: none;">숨김 처리된 글입니다.</p>
												<c:if test="${boardPost.secYn eq 'Y'}"><img src="${siteImgPath}/common/writePw.png" />&nbsp;</c:if>
												<c:out value="${boardPost.title}"/>
											</td>
										</tr>
										<tr>
											<th scope="row">문의내용</th>
											<td colspan="3">
												<c:out value="${fn:replace(boardPost.cont, entermark, '<br/>')}" escapeXml="false"/>
											</td>
										</tr>
 
										<tr>
											<th scope="row">답변</th>
											<td colspan="3">

												<c:choose>
													<c:when test="${boardPost.append4 eq 'Y'}">
														<c:out value="${fn:replace(boardPost.append5, entermark, '<br/>')}" escapeXml="false"/>
													</c:when>
													<c:otherwise>
														<div class="writeW">
															<textarea name="append5" id="append5" cols="10" rows="10" title="내용 입력" class="wid100_hei50"></textarea>
														</div>
														<span class="red2">※ 답변 저장 시 문의에 대한 답변이 문의자의 이메일로 발송됩니다.</span>
													</c:otherwise>
												</c:choose>
											</td>
										</tr>
										
										
									</tbody>
								</table>
								
							</form>
							
						</div>
							
						<div class="btnbox_BL3">
							<a href="#" class="btn_blue" onclick="list(); return false;">목록</a>
							<c:if test="${boardPost.append4 ne 'Y'}">
								<a href="#" class="btn_reset" onclick="modifyProc(); return false;">답변저장</a>
							</c:if>
						</div>
						
						<jsp:include page="/WEB-INF/views/admin/board/board-search-form.jsp" />
						
					</div>
				</div>
			</div><!--contentWrap-->

		</div><!--container-->
	</div><!--containerWrap-->

	<!-- footer -->
	<jsp:include page="/WEB-INF/views/admin/common/footer.jsp"/>
	<!-- //footer -->
	
</body>
</html>
