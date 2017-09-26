<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page contentType="text/html; charset=utf-8" %>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>

<!-- meta -->
<jsp:include page="/WEB-INF/views/mobile/common/meta.jsp"/>
<!-- //meta -->
<link href="${siteCssPath}/board.css" type="text/css" rel="stylesheet"  />

<script language="javascript" type="text/javascript">

	function writeForm() {
		$("#searchForm").attr("action", "/board/" + "<c:out value='${board.boardName}' />" + "/write");
		$("#searchForm").attr("method", "POST");
		$("#searchForm").submit();		
	}

	function initSearchParam() {
		$("#pageNo").val(0);
		if("${searchParam.searchMyPostYn}" == "Y") {
			$("#tmpSearchMyPostYn").addClass("on");
			$("#searchMyPostYn").val("Y");
		}
	}
	
	function searchPost() {
		$("#pageNo").val(0);
		$("#searchText").val($("#tmpSearchText").val());
		if($("#tmpSearchMyPostYn").hasClass("on")) {
			$("#searchMyPostYn").val("Y");
		} else {
			$("#searchMyPostYn").val("N");
		}
		$('#ulPostList').html('');
		morePage();
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
		layer.fadeIn().css({ 'width': 300 });
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
	
    function morePage() {
    	
        $('#pageNo').val( Number($('#pageNo').val()) + 1 );
	    
        $.ajax({
            type: 'POST',
            url: '/board/${board.boardName}/list/more',
            dataType: 'json',
            data: {
            	'pageNo':$('#pageNo').val(),
            	'searchTarget':'TITLE',
            	'searchText':$('#searchText').val(),
            	'searchMyPostYn':$('#searchMyPostYn').val()
            },
            success: function (data) {
            	if(data.boardPostList.length > 0) {
            		$(data.boardPostList).each(function() {
       		 			var appendData = getAppendData(this);
       		 			$("#ulPostList").append(appendData);
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
	
    function getAppendData(data) {

    	var appendData = $('<a/>').on('click', function(e) {
    		e.preventDefault();
    		if(data.delYn == 'Y' || data.hideYn == 'Y') {
    			return;
    		} else {
    			if(data.secYn == 'Y') {
   				<c:choose>
    				<c:when test="${_accountInfo.hasRole('USER')}">
    					if(data.ownerYn == 'Y') {
    						detail(data.postSeq);
    					} else {
    						alert('<spring:message code="message.notice.003" />');
    					}
    				</c:when>
    				<c:otherwise>
    					visitorLayer(data.postSeq);
    				</c:otherwise>
    			</c:choose>
    			} else {
    				detail(data.postSeq);
    			}
    		}
    		
    	})
    	.append('<span class="tit">문의하기</span>');
    	
     	if(data.delYn == 'Y') {
    		appendData.append('<strong class="hideReply">작성자가 삭제한 글입니다</strong>');
    	} else if(data.hideYn == 'Y') {
    		appendData.append('<strong class="hideReply">숨김 처리된 글입니다</strong>');
    	} else {
	     	if(data.secYn == 'Y') {
	     		appendData.append('<strong class=""><span class="keyImg"></span>' + data.title + '</strong>');
	     	} else {
	     		appendData.append('<strong class="">' + data.title + '</strong>');
	     	}
    	}
		
		if(data.replyYn == 'Y') {
			appendData.append('<span>' + data.strRegDate + ' | 조회수 ' + data.readCnt + '  | <span class="endGray">완료</span></span>');	
		} else {
			appendData.append('<span>' + data.strRegDate + ' | 조회수 ' + data.readCnt + '  | <span class="ingBlue">처리중</span></span>');
		}
     	
    	return $('<li/>').append(appendData);
    }
    
    $(function() {
    	initSearchParam();
    });
    
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
 
 	<!-- search box -->
	<jsp:include page="/WEB-INF/views/mobile/board/board-search.jsp" />
	<!-- //search box -->
	
	<div class="boardList">
		<div class="boardInfoBox">
			<p>- 내용은 반드시 <span class="bluetxt">실명(성명, 전화번호, 주소 등)</span>으로 등록하여 주세요.</p>
			<p>- 답변이 등록된 문의는 수정할 수 없습니다.</p>
			<p>- 비공개로 등록된 문의는 제목은 표시되고 내용은 비공개됩니다.</p>
			<p>- 참여예산 정채제안과 무관한 내용(종교, 정치 등), 비실명, 저속한 표현, 타인의 실명을 거론하거나, 명예훼손, 반사회적인 글, 개인정보 포함 글 등은 <span class="bluetxt">예고 없이 삭제 또는 비공개로 전환</span>될 수 있으며 답변을 해드리지 않습니다.</p>
			<p>- 만 14세 미만은 문의하기를 통해 등록할 수 없습니다.</p>		
			<p class="grayCercle">문의: 은평구청 희망마을담당관 02-351-6475</p>
		</div>
		<div class="infoChk1" style="height: 44px; margin-top: 10px;">
			<p>
				<c:if test="${_accountInfo.hasRole('USER')}">
					<a href="#" class="chk" id="tmpSearchMyPostYn" style="float: left; margin-left: 10px;">내 문의 보기</a>
				</c:if>
				
				<c:choose>
					<c:when test="${_accountInfo.hasRole('USER') or userType eq 'QNA'}">
						<a href="#" class="btn_blue" style="margin-right: 10px;" onclick="writeForm(); return false;">문의하기</a>
					</c:when>
					<c:otherwise>
						<a href="#" class="btn_blue" style="margin-right: 10px;" onclick="openLayer('loginLayer'); return false;">문의하기</a>
					</c:otherwise>
				</c:choose>
						
				
			</p>
			<script language="javascript" type="text/javascript">
			//<![CDATA[
				$('.infoChk1').find('.chk').on('click',function(){
					if ($(this).hasClass('on')){
						$(this).removeClass('on');
					}else{
						$(this).addClass('on');
					}
					return false;
				})
			//]]>
			</script>
		</div>

		<!--등록문의없을때
		<div class="listNoneBox2">
			<p class="listnone">등록된 내용이 없습니다.</p>
		</div>
		-->
		
		<ul class="" id="ulPostList">
			<c:forEach items="${boardPostList}" var="list" varStatus="status">
			
				<li class="">
					<a href="#;">
						<span class="tit">문의하기</span>
						
						<c:choose>
							<c:when test="${list.delYn eq 'Y'}">
								<strong class="hideReply">작성자가 삭제한 글입니다</strong>
							</c:when>
							<c:when test="${list.hideYn eq 'Y'}">
								<strong class="hideReply">숨김 처리된 글입니다</strong>
							</c:when>
							<c:otherwise>
								<c:choose>
									<c:when test="${list.secYn eq 'Y'}">
										<c:choose>
											<c:when test="${_accountInfo.hasRole('USER') and list.ownerYn eq 'Y'}">
												<strong class="" onclick="detail('${list.postSeq}');"><span class="keyImg"></span><c:out value="${list.title}"/></strong>
											</c:when>
											<c:when test="${_accountInfo.hasRole('USER') and list.ownerYn ne 'Y'}">
												<strong class="" onclick="alert('<spring:message code="message.notice.003" />');"><span class="keyImg"></span><c:out value="${list.title}"/></strong>
											</c:when>
											<c:otherwise>
												<strong class="" onclick="visitorLayer('${list.postSeq}'); return false;"><span class="keyImg"></span><c:out value="${list.title}"/></strong>
											</c:otherwise>
										</c:choose>
									</c:when>
									<c:otherwise>
										<strong class="" onclick="detail('${list.postSeq}');"><c:out value="${list.title}"/></strong>
									</c:otherwise>												
								</c:choose>
							</c:otherwise>
						</c:choose>
									
						<span>
							<fmt:formatDate value="${list.regDate}" pattern="yyyy-MM-dd"/> | 
							조회수 <c:out value="${list.readCnt}"/> | 
							<c:if test="${list.append4 eq 'Y'}"><span class="endGray">완료</span></c:if>
							<c:if test="${list.append4 ne 'Y'}"><span class="ingBlue">처리중</span></c:if>
						</span>
						
					</a>
				</li>
			
			</c:forEach>
		</ul>
	
		<p class="boardMore"><a href="#" onclick="morePage(); return false;"><span>더보기(10)</span></a></p>
		
	</div>

	<div id="loginLayer" class="layer_block layerPop">
		<p class="layerTit">
			<strong>로그인</strong>
			<a href="#" class="layerClose"><img src="${siteImgPath}/common/layerClose.png" alt=""/></a>
		</p>
		<div class="layerCont">
			<p style="margin: 10px 0 10px 0; text-align: center;"><strong><spring:message code="message.notice.005"/></strong></p>
			<p class="bt">
				<a href="/board/${board.boardName}/auth-phone" class="ok" style="float:none;"><span>휴대폰인증</span></a>
				<a href="/login" class="ok" style="float:none;"><span>로그인</span></a>
			</p>
		</div>
	</div>

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
