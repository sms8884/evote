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
		initSearchParam();
		$('#tmpText').on('keypress', function(e) {
			if(e.keyCode == 13){
				e.preventDefault();
				searchPost();
			}
		});
	});

	function writeForm() {
		$("#searchForm").attr("action", "/board/" + "<c:out value='${board.boardName}' />" + "/write");
		$("#searchForm").attr("method", "POST");
		$("#searchForm").submit();		
	}

	function initSearchParam() {
		$("#tmpText").val("${searchParam.searchText}");
		if("${searchParam.searchTarget}" != "") {
			$("#tmpTarget").val("${searchParam.searchTarget}");
		}
		if("${searchParam.searchMyPostYn}" == "Y") {
			$("#tmpMyPostYn").addClass("on");
		}
	}

	function searchPost() {
		$("#searchTarget").val($("#tmpTarget").val());
		$("#searchText").val($("#tmpText").val());
		if($("#tmpMyPostYn").hasClass("on")) {
			$("#searchMyPostYn").val("Y");
		} else {
			$("#searchMyPostYn").val("N");
		}
		gotoPage(1);
	}

	function searchReset() {
		$("#tmpTarget").val("TITLE");
		$("#tmpText").val("");
	}
	
	function detail(seq, vpw) {
		if(arguments.length >= 2) {
		    if($("#password", "#searchForm").length == 0) {
		    	$("#searchForm").append("<input type='hidden' id='password' name='password'/>");
		    }
		    $("#password").val(vpw);
		}
		
		$("#searchForm").attr("action", "/board/${board.boardName}/" + seq);
		$("#searchForm").attr("method", "POST");
		$("#searchForm").submit();		
	}

	function visitorLayer(postSeq) {
		$("#tmpSeq").val(postSeq);
		openLayer("visitorLayer");
	}

	function openLayer(layerId) {
		var layer = $("#" + layerId);
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
            		detail(seq, vpw);
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
				<div class="inquiry">
					<p class="inquiryTxt">
						-  내용은 반드시 <span>실명(성명, 전화번호, 주소 등)</span>으로 등록하여 주세요.<br/>
						-  답변이 등록된 문의는 수정할 수 없습니다.<br/>
						-  비공개로 등록된 문의는 제목은 표시되고 내용은 비공개됩니다.<br/>
						-  참여예산 정책제안과 무관한 내용(종교, 정치 등), 비실명, 저속한 표현, 타인의 실명을 거론하거나,<br/>
						    &nbsp; &nbsp;명예훼손, 반사회적인 글, 개인정보 포함 글 등은 <span>예고 없이 삭제 또는 비공개로 전환</span>될 수 있으며 답변을<br/>
						  &nbsp; &nbsp;해드리지 않습니다.<br/>
						-  만 14세 미만은 문의하기를 통해 등록할 수 없습니다.<br/>
					</p>
					<p class="inquiryTel">&nbsp; &nbsp;문의: 은평구 희망마을담당관 02-351-6475&nbsp; &nbsp;</p>
				</div>
				<form method="post" action="" class="searchTb">
					<fieldset id="" class="">
							<table cellpadding="0" cellspacing="0" class="" summary="" >
								<colgroup>
									<col width="100"/>
									<col width="100"/><col width="100"/>
									<col width="*"/>
								</colgroup>
								<tbody>
									<tr>
										
										<c:if test="${_accountInfo.hasRole('USER')}">
										<td colspan="2" class="bln">
											<a href="#" id="tmpMyPostYn" class="chk">내 문의 보기</a>
										</td>
										</c:if>
										
										<th scope="row">검색</th>
										<td colspan="3">
											<select id="tmpTarget" title="검색" style="width:127px;">
												<option value="TITLE">제목</option>
												<option value="CONT">내용</option>
											</select>
											<label for="con" class="hidden">검색내용 입력하기</label><input type="text" class="inquriyS" title="" value="" name="con" id="tmpText"/>
										</td>
									</tr>
								</tbody>
							</table>
							<script language="javascript" type="text/javascript">
					//<![CDATA[
				
						$('table').find('.chk').on('click',function(){
							if ($(this).hasClass('on')){
							$(this).removeClass('on');
							}else{
								$(this).addClass('on');
							}
							return false;
						});
					//]]>
					</script>

						<div class="btnC">
							<a href="#" class="btn_blue" onclick="searchPost(); return false;" style="color: #fff">검색</a>
							<a href="#" class="btn_reset" onclick="searchReset(); return false;">초기화</a>
						</div>
					</fieldset>
				</form>

				<c:if test="${not empty searchParam}">
				<p class="caption">총 <c:out value="${pagingHelper.totalCnt}"/>건이 검색되었습니다.</p>
				</c:if>
				
				<div class="boardList">
					<table cellpadding="0" cellspacing="0" class="tbC" summary="공지사항의 번호, 구분, 제목, 조회수, 등록일 정보를 제공합니다." >
						<caption>공지사항</caption>
						<colgroup>
							<col width="15%"/>
							
							<%-- 카테고리 사용여부
							<c:if test="${board.cateUseYn eq 'Y'}">
							<col width="15%"/>
							</c:if>
 							--%>
 							
							<col width="*"/>
							<col width="10%"/>
							<col width="20%"/>
						</colgroup>
						<thead>
							<tr>
								<th scope="col">번호</th>
								
								<%-- 카테고리 사용여부
								<c:if test="${board.cateUseYn eq 'Y'}">
								<th scope="col">구분</th>
								</c:if>
								--%>
								
								<th scope="col">제목</th>
								<th scope="col">조회수</th>
								<th scope="col">등록일</th>
							</tr>
						</thead>
						<tbody>
						
							<c:forEach items="${boardPostList}" var="list" varStatus="status">
							<tr>
								<td><strong><c:out value="${pagingHelper.startRowDesc - status.index}" /></strong></td>
								
								<%-- 카테고리 사용여부
								<c:if test="${board.cateUseYn eq 'Y'}">
								<td><c:out value="${list.categoryNm}"/></td>
								</c:if>
								--%>

								<td class="tL">
								
									<c:choose>
										<c:when test="${list.delYn eq 'Y'}">
											<P class="inquriyH">작성자가 삭제한 글입니다</P>
										</c:when>
										<c:when test="${list.hideYn eq 'Y'}">
											<p class="inquriyH">숨김 처리된 글입니다</p>
										</c:when>
										<c:otherwise>
											<c:if test="${list.append4 eq 'Y'}"><p class="inquiryE">완료</p></c:if>
											<c:if test="${list.append4 ne 'Y'}"><p class="inquiryI">처리중</p></c:if>											
											<c:choose>
												<c:when test="${list.secYn eq 'Y'}">
													<img src="${siteImgPath}/etc/writePw.png" alt=""/>
													
													<c:choose>
														<c:when test="${_accountInfo.hasRole('USER') and list.ownerYn eq 'Y'}">
															<a href="javascript:detail('${list.postSeq}');"><c:out value="${list.title}"/></a>
														</c:when>
														<c:when test="${_accountInfo.hasRole('USER') and list.ownerYn ne 'Y'}">
															<a href="javascript:alert('<spring:message code="message.notice.003" />');"><c:out value="${list.title}"/></a>
														</c:when>
														<c:otherwise>
															<a href="javascript:visitorLayer('${list.postSeq}');"><c:out value="${list.title}"/></a>
														</c:otherwise>
													</c:choose>
													
												</c:when>
												<c:otherwise>
													<a href="javascript:detail('${list.postSeq}');"><c:out value="${list.title}"/></a>
												</c:otherwise>												
											</c:choose>
										</c:otherwise>
									</c:choose>
									
								</td>
								
								
								<td><c:out value="${list.readCnt}"/></td>
								<td><fmt:formatDate pattern="yyyy-MM-dd" value="${list.regDate}" /></td>
							</tr>
							</c:forEach>
						
						</tbody>
					</table>
					<div class="inquiryBtn">
						<c:choose>
							<c:when test="${_accountInfo.hasRole('USER') or userType eq 'QNA'}"><a href="#" onclick="writeForm(); return false;" class="btn_blue">문의하기</a></c:when>
							<c:otherwise><a href="#" onclick="openLayer('loginLayer'); return false;" class="btn_blue">문의하기</a></c:otherwise>
						</c:choose>
					</div>
				</div>

				<div id="visitorLayer" class="loginMbtLayer1 layer_block">
					<p class="tit">비밀번호확인</p>
					<div class="loginMbtLayerCon">
						<p class="inptxt"><input type="password" class="it widinputxt" id="tmpPw" placeholder="비밀번호를 입력해주세요."/></p>
						<a href="#" class="btW1 layerClose2"><span>취소</span></a>
						<a href="#" class="btC1 " onclick="checkPassword(); return false;"><span>확인</span></a>
						<a href="#" class="layerClose"><img src="${siteImgPath}/common/layerClose.png" alt="닫기"/></a>
						<input type="hidden" id="tmpSeq" />
					</div>
				</div>
				
				<div id="loginLayer" class="loginMbtLayer layer_block">
					<p class="tit">로그인</p>
					<div class="loginMbtLayerCon">
						<p class="txt3"><spring:message code="message.notice.005"/></p>
						<a href="#" onclick="javascript:location.href='/board/${board.boardName}/auth-phone';" class="btC1 layerClose2"><span>휴대폰인증</span></a>
						<a href="#" onclick="javascript:location.href='/login'" class="btC1 layerClose2"><span>로그인</span></a>
						<a href="#" class="layerClose"><img src="${siteImgPath}/common/layerClose.png" alt="닫기"/></a>
					</div>
				</div>
				
				<jsp:include page="/WEB-INF/views/front/board/board-search-form.jsp" />

				<jsp:include page="/WEB-INF/views/front/board/board-paging.jsp">
					<jsp:param name="formId" value="searchForm"/>
					<jsp:param name="action" value="/board/${board.boardName}/list"/>
				</jsp:include>

			</div>
		</div>
	</div>
</div>

<!-- footer -->
<jsp:include page="/WEB-INF/views/front/common/footer.jsp"/>
<!-- //footer -->

</body>
</html>
