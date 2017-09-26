<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>

<!-- meta -->
<jsp:include page="/WEB-INF/views/front/common/meta.jsp"/>
<!-- //meta -->

<link href="${siteCssPath}/etc.css" type="text/css" rel="stylesheet"  />

<script language="javascript" type="text/javascript">
//<![CDATA[
	$(document).ready(function(){
		$('.gnb').topmenu({ d1: 1, d2: 3, d3:1});
	});
	
	function login() {
		location.href = "/login";
	}
	
	function joinEmail() {
		location.href = "/member/join-email";
	}
	
	function fnList() {
		$("#_tempFrm").attr("action", "/proposal/list");
		$("#_tempFrm").attr("method", "POST");
		$("#_tempFrm").submit();
	}
	
	function fnModify() {
		$("#_tempFrm").attr("action", "/proposal/modify/${proposal.propSeq}");
		$("#_tempFrm").attr("method", "POST");
		$("#_tempFrm").submit();
	}
	
	function fnRemove() {
		if(confirm("<spring:message code='message.proposal.019' />")) {
			$("#_tempFrm").attr("action", "/proposal/remove/${proposal.propSeq}");
			$("#_tempFrm").attr("method", "POST");
			$("#_tempFrm").submit();
		}
	}
	
	function fnShareSns(sns){
		var title = $("#bizNm").val();
	    var url = location.href;
		switch(sns){
		   case 1 : gfnShareFacebook(title, url); break;
		   case 2 : gfnShareTwitter(title, url); break;
		   case 3 : gfnShareBand(title, url); break;
		   case 4 : gfnShareStory(title, url); break;
		   case 5 : gfnShareKakao(title, url); break;
		}
	}

	function fnSympathy() {
        //공감처리.
		$.ajax({
			url: '<c:url value="/proposal/detail/sympathy" />',
			type: 'post',
			dataType: "json",
			data: {
				"propSeq": $("#propSeq").val()
			},
			success: function(data) {
				if(!checkAuthCode(data)) {
					return;
				}
				if(data == -99){
					alert('<spring:message code="message.proposal.info.001" />'); // 해당 제안이 존재하지않습니다.
					fnList();
				} else {
					$("#sympathyCount").text(gfnComma(data));
					if ($("#tmpSympathy").attr("style") == "") {
						$("#tmpSympathy").attr("style","padding:17px 83px; border:3px solid #ec4849; background:url(${siteImgPath}/sub1/ok_on.gif) 54px 50% no-repeat;");
					} else {
						$("#tmpSympathy").attr("style", "");
					}
				}
			},
			error: function(xhr, status, error) {
				alert("error : ajax fail!! [ fnSympathy ]");
			}
		});
	}
	
	function fnSaveComment(cmtSeq){
		var commentValue = "";
		var param = {};

	    if(cmtSeq == null){
	    	commentValue = $("#comment").val();
	    } else {
	    	commentValue = $("#cmtUpdTa_"+cmtSeq).val();
	    	param.cmtSeq = cmtSeq;
	    }
	    
	    param.propSeq = $("#propSeq").val();
	    param.cont = commentValue;
		
		var commentByte = gfnByte(commentValue);
		if(commentByte == 0 || commentByte > 1000){
			return;
		}
		
		$.cookie('_proposalDetailCurrentScrollTop', $(document).scrollTop());// 스크롤 위치고정목적 쿠키
        $.ajax({
            url: '<c:url value="/proposal/detail/comment/save" />',
            type: 'post',
            async : false,
            dataType: "html",
            data: param,
            success: function(data) {
            	
            	if(!checkAuthCode(data)) {
            		return;
            	} else if(data > 0){
                	location.reload();
                } else if (data == -99){
                	alert('<spring:message code="message.proposal.info.001" />'); // 해당 제안이 존재하지않습니다.
                	fnList();
                }
            },
            error: function(xhr, status, error) {
                alert("error : ajax fail!! [ fnSaveComment ]");
            }
        });

	}
	
	function fnCommentAgree(cmtSeq, agreeYn){
		$.ajax({
	        url: '<c:url value="/proposal/detail/comment/agree" />',
	        type: 'post',
	        dataType: "json",
	        data: {
	        	"propSeq" : $("#propSeq").val(),
	            "cmtSeq" : cmtSeq,
	            "agreeYn" : agreeYn
	        },
	        success: function(data) {
				if(!checkAuthCode(data)) {
					return;
				} else if(data > 0){
	            	location.reload();
	            } else if (data == -99){
	                alert('<spring:message code="message.proposal.info.001" />'); // 해당 제안이 존재하지않습니다.
	                fnList();
	            }
	        },
	        error: function(xhr, status, error) {
	            alert("error : ajax fail!! [ fnCommentAgree ]");
	        }
	    });
	}
	
	function fnCommentReport(cmtSeq){
		if(!confirm("신고하시겠습니까?")){
			return;
		}
	    
	    $.ajax({
	        url: '<c:url value="/proposal/detail/comment/report" />',
	        type: 'post',
	        dataType: "json",
	        data: {
	            "propSeq" : $("#propSeq").val(),
	            "cmtSeq" : cmtSeq
	        },
	        success: function(data) {
				if(!checkAuthCode(data)) {
					return;
				} else if(data > 0){
	                alert("신고하였습니다.");
	                location.reload();
	            } else if (data == -99){
	            	alert('<spring:message code="message.proposal.info.001" />'); // 해당 제안이 존재하지않습니다.
	                fnList();
	            } else {
	            	alert("이미 신고한 댓글입니다.");
	            }
	        },
	        error: function(xhr, status, error) {
	            alert("error : ajax fail!! [ fnCommentReport ]");
	        }
	    });
	}

	function fnCommentUpdate(obj, cmtSeq){
		
		var divId = "div_comment_" + cmtSeq;
		var textareaId = "cmtUpdTa_" + cmtSeq;
		
		if( $("#" + divId).length == 0 ) {
			var html = "<div id='" + divId + "' class='addR' style='width: 600px; margin-top:10px;'>"
					 + "<textarea class='Rcon' id='" + textareaId + "' placeholder='제안에 대한 의견을 등록해주세요.'>" + $(obj).parent().parent().find("p:first").text() + "</textarea>"
					 + "<p class='add' style='margin-top: -40px;'>"
					 + "<a href='#' class='btn_gray2' style='' onclick='fnSaveComment(" + cmtSeq + "); return false;'>댓글 수정</a><br/>"
					 + "<a href='#' class='btn_gray2' style='margin-top:5px;' onclick='fnCommentCancel(\"" + divId + "\"); return false;'>취소</a>"
					 + "</p>"
					 + "</div>";
			$(obj).parent().after(html);
			$(obj).parent().parent().find("p:first").hide();
		}
		
	}
	
	function fnCommentCancel(divId) {
		$("#" + divId).parent().find("p:first").show();
		$("#" + divId).remove();
	}
	
	function fnCommentDelete(cmtSeq){
		if(!confirm("댓글을 삭제하시겠습니까?")){
	        return;
	    }
	    
	    $.ajax({
	        url: '<c:url value="/proposal/detail/comment/delete" />',
	        type: 'post',
	        async : false,
	        dataType: "html",
	        data: {
	        	"propSeq" : $("#propSeq").val(),
	            "cmtSeq" : cmtSeq
	        },
	        success: function(data) {
	        	if(!checkAuthCode(data)) {
					return;
	        	} else if(data > 0){
	                alert("삭제되었습니다.");
	                location.reload();
	            } else if (data == -99){
	            	alert('<spring:message code="message.proposal.info.001" />'); // 해당 제안이 존재하지않습니다.
	                fnList();
	            }
	        },
	        error: function(xhr, status, error) {
	            alert("error : ajax fail!! [ fnCommentDelete ]");
	        }
	    });
	}
	
	function propLayer(layerId) {
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
	
	function checkAuthCode(data) {
		if(data == -10 || data == -15){
			// 비로그인
			propLayer("propLayer1");
			return false;
		} else if(data == -20){
			// 핸드폰회원
			propLayer("propLayer2");
			return false;
		} else if(data == -30) {
			// 댓글쓰기 권한이 차단 되었습니다. 관리자에게 문의해 주시기 바랍니다.
			alert('<spring:message code="message.proposal.017"/>');
			location.reload();
			return false;
		}
		return true;
	}
	
	function visitorModify() {
		
		if($("#modifyPw").val() == "") {
			alert('<spring:message code="message.common.header.002" arguments="비밀번호를"/>');
			$("#modifyPw").focus();
			return;
		}
		$("#visitorPw").val($("#modifyPw").val());
		
		$("#modifyPw").val("");
		
		$("#_tempFrm").attr("action", "/proposal/visitor/modify/${proposal.propSeq}");
		$("#_tempFrm").attr("method", "POST");
		$("#_tempFrm").submit();
	}
	
	function visitorRemove() {

		if($("#removePw").val() == "") {
			alert('<spring:message code="message.common.header.002" arguments="비밀번호를"/>');
			$("#removePw").focus();
			return;
		}
		
		// 삭제 시 등록된 제안이 삭제되어 복구할 수 없습니다.삭제하시겠습니까?
		if(confirm('<spring:message code="message.proposal.019"/>')) {
			$("#visitorPw").val($("#removePw").val());
			$("#removePw").val("");
			$("#_tempFrm").attr("action", "/proposal/visitor/remove/${proposal.propSeq}");
			$("#_tempFrm").attr("method", "POST");
			$("#_tempFrm").submit();
		}
	}
	
	$(document).ready(function() {
		$("#container").on('click',function(){
			$('.more').removeClass('on').next('.moreBox').hide();
		});
	});
	
//]]>
</script>
</head>
<body>

<!-- header -->
<jsp:include page="/WEB-INF/views/front/common/header.jsp"/>
<!-- //header -->

<div class="location">
	<p>
		<a href="#"><img src="${siteImgPath}/common/locationHome.png" alt="홈"/></a>
		<span>주민참여예산제</span>
		<span>정책제안</span>
		<span>제안사업</span>
	</p>
</div>

<div id="container" class="container">
	<div class="containerWrap">

		<!-- LNB -->
		<jsp:include page="/WEB-INF/views/front/common/lnb.jsp">
			<jsp:param name="menuName" value="proposal"/>
		</jsp:include>
		<!-- //LNB -->
		
		<div class="contentsWrap">
			<h3 class="contentTit">제안사업 상세보기</h3>

	        <input type="hidden" name="propSeq" id="propSeq" value="<c:out value="${proposal.propSeq}" />" />
	        <input type="hidden" name="bizNm" id="bizNm" value="<c:out value="${proposal.bizNm }" />" />
	        
			<div class="contents">
				<div class="offerTit">
					<c:out value="${proposal.bizNm}"/>
					<div><p class="point"><c:out value="${proposal.realmNm }"/></p></div>
				</div>

				<div class="boardView boardView2">
					<table cellpadding="0" cellspacing="0" class="tbL" summary="제안사업 상세보기 - 등록자, 등록일, 조회수, 처리상태, 소요사업비, 사업기간, 사업위치, 제안취지, 내용, 기대효과, 사진, 신청서 등록 정보를 보는 화면입니다." >
						<caption>제안사업 상세보기</caption>
						<colgroup>
							<col width="15%"/>
							<col width="18%"/>
							<col width="15%"/>
							<col width="*"/>
							<col width="15%"/>
							<col width="18%"/>
						</colgroup>
						<tbody>
							<tr>
								<th scope="row">등록자</th>
								<td>
									<c:choose>
				                        <c:when test="${not empty proposal.regName.value}">
				                        	<c:out value="${proposal.regName.decValue}" />
				                        </c:when>
				                        <c:otherwise>
				                        	<c:out value="${proposal.reqNm.decValue}" />
				                        </c:otherwise>
									</c:choose>
								</td>
								<th scope="row">등록일</th>
								<td><c:out value="${proposal.regDateText }" /></td>
								<th scope="row">조회수</th>
								<td><c:out value="${proposal.readCnt }" /></td>
							</tr>
							<tr>
								<th scope="row">처리상태</th>
								<td colspan="5"><c:out value="${proposal.statusText }" /></td>
							</tr>
							<tr>
								<th scope="row">소요사업비</th>
								<td colspan="5"><c:out value="${proposal.budget }"/></td>
							</tr>
							<tr>
								<th scope="row">사업기간</th>
								<td colspan="5"><c:out value="${proposal.startDate }" /> ~ <c:out value="${proposal.endDate }" /></td>
							</tr>
							<tr>
								<th scope="row">사업위치</th>
								<td colspan="5"><c:out value="${proposal.location }" /></td>
							</tr>
							<tr>
								<th scope="row">제안취지</th>
								<td colspan="5"><c:out value="${fn:replace(proposal.necessity, entermark, '<br/>')}" escapeXml="false"/></td>
							</tr>
							<tr>
								<th scope="row">내용</th>
								<td colspan="5"><c:out value="${fn:replace(proposal.bizCont, entermark, '<br/>')}" escapeXml="false"/></td>
							</tr>
							<tr>
								<th scope="row">기대효과</th>
								<td colspan="5"><c:out value="${fn:replace(proposal.effect, entermark, '<br/>')}" escapeXml="false"/></td>
							</tr>
							
							<c:if test="${proposal.ownerYn eq 'Y'}">
							
							<tr>
								<th scope="row">사진</th>
								<td colspan="5">
		                            <c:forEach items="${imageFileList}" var="item">
										<dl class="photo1">
											<dt><c:out value="${item.fileSrcNm }" /></dt>
											<dd><img src="/file-download/${item.fileSeq}" alt="사례이미지1"/></dd>
										</dl>
		                            </c:forEach>
								</td>
							</tr>
							<tr>
								<th scope="row">신청서 등록</th>
								<td colspan="5">
		                            <c:forEach items="${attachFileList }" var="item">
		                                <p style="padding: 3px;"><a href="/file-download/${item.fileSeq }"><c:out value="${item.fileSrcNm }" /></a></p>
		                            </c:forEach>
								</td>
							</tr>
							
							</c:if>
							
						</tbody>
					</table>
				</div>


<c:if test="${proposal.status ne 'PENDING' and not empty proposalAudit}">


				<p class="pTit2">검토의견</p>
				<div class="boardView boardView2">
					<table cellpadding="0" cellspacing="0" class="tbL" summary="사업기간, 소요예산, 사업위치, 분과위원회, 구분, 내용에 대한 검토의견- 법률 조례기준, 검토의견(타당성, 시급성, 사업효과, 수혜범위 등), 검토결과, 검토부서, 사진, 첨부파일과 참여예산(분과)위원회 검토의견을 볼 수 있는 표입니다." >
						<caption>검토의견</caption>
						<colgroup>
							<col width="15%"/>
							<col width="35%"/>
							<col width="15%"/>
							<col width="35%"/>
						</colgroup>
						<tbody>
							<tr>
								<th scope="row">사업기간</th>
								<td><c:out value="${proposalAudit.startDate}"/> ~ <c:out value="${proposalAudit.endDate}"/></td>
								<th scope="row">소요예산</th>
								<td><c:out value="${proposalAudit.budget}"/></td>
							</tr>
							<tr>
								<th scope="row">사업위치</th>
								<td><c:out value="${proposalAudit.location}"/></td>
								<th scope="row">분과위원회</th>
								<td><c:out value="${proposalAudit.subcmit}"/></td>
							</tr>
							<tr>
								<th scope="row">구분</th>
								<td colspan="3"><c:out value="${proposalAudit.realmNm}"/></td>
							</tr>
							<tr>
								<th scope="row">내용</th>
								<td colspan="3"><c:out value="${fn:replace(proposalAudit.bizCont, entermark, '<br/>')}" escapeXml="false"/></td>
							</tr>
							<tr>
								<th scope="col" colspan="4" class="thBg">검토의견</th>
							</tr>
							<tr>
								<th scope="row">법률 &middot; 조례 기준</th>
								<td>
									<c:if test="${proposalAudit.lawResult eq 'Y' }">적격</c:if>
									<c:if test="${proposalAudit.lawResult eq 'N' }">부적격</c:if>
								</td>
										
								<td colspan="2"><c:out value="${proposalAudit.lawDetail}"/></td>
							</tr>
							<tr>
								<th scope="row">검토의견 (타당성, 시급성, 사업효과, 수헤범위 등)</th>
								<td colspan="3"><c:out value="${fn:replace(proposalAudit.reviewDetail, entermark, '<br/>')}" escapeXml="false"/></td>
							</tr>
							<tr>
								<th scope="row">검토 결과</th>
								<td colspan="3">
									<c:if test="${proposalAudit.reviewResult eq 'Y'}">적합</c:if>
									<c:if test="${proposalAudit.reviewResult eq 'N'}">부적합</c:if>
								</td>
							</tr>
							<tr>
								<th scope="row">검토 부서</th>
								<td><c:out value="${proposalAudit.reviewDept}"/></td>
								<th scope="row">검토자</th>
								<td><c:out value="${proposalAudit.reviewer}"/></td>
							</tr>
							<tr>
								<th scope="row">사진</th>
								<td colspan="3">
            						<c:forEach items="${auditImageFileList}" var="item">
            							<p style="padding-bottom: 5px;"><a href="/file-download/${item.fileSeq}"><c:out value="${item.fileSrcNm}"/></a></p>
            						</c:forEach>
								</td>
							</tr>
							<tr>
								<th scope="row">첨부파일</th>
								<td colspan="3">
            						<c:forEach items="${auditAttachFileList}" var="item">
            							<p style="padding-bottom: 5px;"><a href="/file-download/${item.fileSeq}"><c:out value="${item.fileSrcNm}"/></a></p>
            						</c:forEach>
								</td>
							</tr>
							<tr>
								<th scope="col" colspan="4" class="thBg">참여예산(분과)위원회 검토 의견</th>
							</tr>
							<tr>
								<th scope="row">검토의견</th>
								<td>
									<c:if test="${proposalAudit.cmitResult eq 'Y'}">적격</c:if>
									<c:if test="${proposalAudit.cmitResult eq 'N'}">부적격</c:if>
								</td>
								<td colspan="2"><c:out value="${proposalAudit.cmitDetail}"/></td>
							</tr>
						</tbody>
					</table>
				</div>

				<p class="pTit2">심사결과</p>
				<div class="boardView">
					<table cellpadding="0" cellspacing="0" class="tbL" summary="참여예산위원회와 주민총회의 심사결과, 조정사업비, 순위를 보여주는 표입니다." >
						<caption>심사결과</caption>
						<colgroup>
							<col width="15%"/>
							<col width="43%%"/>
							<col width="*"/>
						</colgroup>
						<thead>
							<th scope="col" class="thBg">&nbsp;	</th>
							<th scope="col" class="thBg">참여예산위원회</th>
							<th scope="col" class="thBg">주민총회</th>
						</thead>
						<tbody>
							<tr>
								<th scope="row">심사결과</th>
								<td>
									<c:if test="${proposalAudit.auditCmitResult eq 'Y'}">선정</c:if>
									<c:if test="${proposalAudit.auditCmitResult eq 'N'}">미선정</c:if>
								</td>
								<td>
									<c:if test="${proposalAudit.auditGnrResult eq 'Y'}">선정</c:if>
									<c:if test="${proposalAudit.auditGnrResult eq 'N'}">미선정</c:if>
								</td>
							</tr>
							<tr>
								<th scope="row">조정 사업비</th>
								<td><c:out value="${proposalAudit.auditCmitBudget}"/></td>
								<td><c:out value="${proposalAudit.auditGnrBudget}"/></td>
							</tr>
							<tr>
								<th scope="row">순위</th>
								<td>-</td>
								<td><c:out value="${proposalAudit.auditRank}"/></td>
							</tr>
						</tbody>
					</table>
				</div>


</c:if>


				<div class="tbBot">
					<div class="sns">
						<span>공유하기</span>
						<ul class="">
							<li><a href="#" onclick="fnShareSns(5); return false;"><img src="${siteImgPath}/sub1/sns1.gif" alt="카카오톡"/></a></li>
							<li><a href="#" onclick="fnShareSns(1); return false;"><img src="${siteImgPath}/sub1/sns2.gif" alt="페이스북"/></a></li>
							<li><a href="#" onclick="fnShareSns(2); return false;"><img src="${siteImgPath}/sub1/sns3.gif" alt="트위터"/></a></li>
							<li><a href="#" onclick="fnShareSns(3); return false;"><img src="${siteImgPath}/sub1/sns4.gif" alt="밴드"/></a></li>
							<li><a href="#" onclick="fnShareSns(4); return false;"><img src="${siteImgPath}/sub1/sns5.gif" alt="카카오스토리"/></a></li>
						</ul>
					</div>
					<div class="btnFr">
						<c:if test="${proposal.status eq 'PENDING'}">
							<c:choose>
								<c:when test="${proposal.ownerYn eq 'Y'}">
									<a href="#" class="btn_gray loginMbt1 " onclick="fnRemove(); return false;">삭제하기</a>
									<a href="#" class="btn_reset" onclick="fnModify(); return false;">수정하기</a>
								</c:when>
								<c:when test="${proposal.memberYn eq 'N'}">
									<a href="#" onclick="propLayer('propLayer3'); return false;" class="btn_gray loginMbt1 layer" rel="loginMbtLayer1">삭제하기</a>
									<a href="#" onclick="propLayer('propLayer4'); return false;" class="btn_reset" rel="loginMbtLayer1">수정하기</a>
								</c:when>
							</c:choose>
						</c:if>
						<a href="#" class="btn_reset" onclick="fnList(); return false;">목록보기</a>
					</div>
				</div>
				
				<div class="btnC bNone">
					<c:set var="symStyle"><c:if test="${proposal.symYn eq 'Y' or proposal.status ne 'PENDING'}">padding:17px 83px; border:3px solid #ec4849; background:url(${siteImgPath}/sub1/ok_on.gif) 54px 50% no-repeat;</c:if></c:set>
					<c:choose>
						<c:when test="${proposal.status ne 'PENDING'}">
							<a href="#" onclick="return false;" class="heart loginMbt1" style="${symStyle} cursor: context-menu; text-decoration: none;"><span id="sympathyCount"><fmt:formatNumber value="${proposal.symCnt}" pattern="#,###" /></span></a>
						</c:when>
						<c:when test="${_accountInfo.hasRole('USER')}">
							<a href="#" id="tmpSympathy" class="heart " style="${symStyle}" onclick="fnSympathy(); return false;"><span id="sympathyCount"><fmt:formatNumber value="${proposal.symCnt}" pattern="#,###" /></span></a>
						</c:when>
<%-- 						
						<c:when test="${userType eq 'PHONE'}">
							<a href="#" id="tmpSympathy" onclick="propLayer('propLayer2'); return false;" class="heart loginMbt1"><span id="sympathyCount"><fmt:formatNumber value="${proposal.symCnt}" pattern="#,###" /></span></a>
						</c:when>
--%>						
						<c:otherwise>
							<a href="#" id="tmpSympathy" onclick="propLayer('propLayer1'); return false;" class="heart loginMbt1"><span id="sympathyCount"><fmt:formatNumber value="${proposal.symCnt}" pattern="#,###" /></span></a>
						</c:otherwise>
					</c:choose>
				</div>

				<div class="replyBox">
					<p class="rCaption">댓글 <span><c:out value="${commentListCount}" /></span></p>
					<ul class="rList">
					
					<c:forEach items="${commentList}" var="item" varStatus="idx">
					
						<li class="addAgree">
							<span class="nick"><c:out value="${item.nickname }" /></span>
							<span><c:out value="${item.regDateText }" /></span>
							<span class="ShowNoti"><c:if test="${item.reportCnt gt 0}">신고 <c:out value="${item.reportCnt}"/></c:if></span>
									
							<c:choose>
								<c:when test="${item.hideYn eq 'Y' and item.ownerYn eq 'N'}">
									<p class="red">숨김 처리된 댓글입니다.</p>
								</c:when>
								<c:when test="${item.hideYn eq 'Y' and item.ownerYn eq 'Y'}">
									<p class="red">숨김 처리된 댓글입니다.</p>
									<p><c:out value="${item.cont}" /></p>
									<a href="#" class="more">더보기</a>
									<div class="moreBox">
										<a href="#" onclick="fnCommentUpdate(this, '${item.cmtSeq}'); return false;">수정</a>
										<a href="#" onclick="fnCommentDelete('${item.cmtSeq}'); return false;">삭제</a>
									</div>
								</c:when>
								<c:when test="${item.hideYn ne 'Y' and item.ownerYn eq 'N'}">
									<p><c:out value="${item.cont}" /></p>
									<a href="#" class="more">더보기</a>
									<div class="moreBox">
										<a href="#" onclick="fnCommentReport('${item.cmtSeq}'); return false;">신고하기</a>
									</div>
									
									<div class="btnFr pdt10">
										<button class="bt_agree" onclick="fnCommentAgree('${item.cmtSeq}','Y'); return false;" >동의합니다 <span><c:out value="${item.agreeCntY}" /></span></button>
										<button class="bt_Nagree" onclick="fnCommentAgree('${item.cmtSeq}','N'); return false;" >동의하지 않습니다 <span style="color:white;"><c:out value="${item.agreeCntN}" /></span></button>
									</div>

								</c:when>
								<c:when test="${item.hideYn ne 'Y' and item.ownerYn eq 'Y'}">
 									<p><c:out value="${item.cont}" /></p>
									<a href="#" class="more">더보기</a>
									<div class="moreBox" style="z-index: 999">
										<a href="#" onclick="fnCommentUpdate(this, '${item.cmtSeq}'); return false;">수정</a>
										<a href="#" onclick="fnCommentDelete('${item.cmtSeq}'); return false;">삭제</a>
									</div>
								</c:when>
							</c:choose>
							
							<c:if test="${proposal.status ne 'PENDING'}">
							<script>$(".more").remove();$(".moreBox").remove();$(".pdt10").remove();</script>
							</c:if>
							
						</li>
					
					</c:forEach>
						
					</ul>
					
					<c:if test="${proposal.status eq 'PENDING'}">
					<div class="addR">
						<c:set var="tmpValue">
							<c:choose>
								<c:when test="${empty userType}">-10</c:when>
								<c:when test="${userType eq 'PROPOSAL'}">-15</c:when>
								<c:when test="${userType eq 'PHONE'}">-20</c:when>
								<c:otherwise>0</c:otherwise>
							</c:choose>
						</c:set>
						
						<c:choose>
							<c:when test="${cmtYn eq 'N'}">
								<div class="inputR">
									<p><spring:message code="message.proposal.017"/></p>
								</div>
							</c:when>
							<c:when test="${_accountInfo.hasRole('USER')}">
								<div class="inputR">
									<p class="name"><c:out value="${_accountInfo.nickname}"/></p>
									<textarea class="Rcon" id="comment" placeholder="제안에 대한 의견을 등록해주세요."></textarea>
								</div>
								<p class="add"><a href="#" class="btn_gray2" onclick="fnSaveComment(); return false;">댓글 등록</a></p>
							</c:when>
							<c:otherwise>
								<div class="inputR">
									<textarea class="Rcon" id="comment" placeholder="제안에 대한 의견을 등록해주세요." onfocus="checkAuthCode('${tmpValue}');"></textarea>
								</div>
								<p class="add"><a href="#" class="btn_gray2" onclick="checkAuthCode('${tmpValue}'); return false;">댓글 등록</a></p>
							</c:otherwise>
						</c:choose>
						

					</div>
					<p class="ps">개인정보유출, 권리 침해, 욕설 등의 내용을 게시할 경우 이용약관 및 관련 법률에 의해 제재를 받을 수 있습니다.</p>
					</c:if>
				</div>

				<div id="propLayer1" class="loginMbtLayer layer_block">
					<p class="tit">로그인</p>
					<div class="loginMbtLayerCon">
						<p class="txt1"><spring:message code="message.proposal.013"/><br/></p>
						<p class="txt3"><spring:message code="message.proposal.014"/></p>
						<a href="#" class="btW1 layerClose2"><span>취소</span></a>
						<a href="#" class="btC1 layerClose2" onclick="login(); return false;"><span>확인</span></a>
						<a href="#" class="layerClose"><img src="${siteImgPath}/common/layerClose.png" alt="닫기"/></a>
					</div>
				</div>

				<div id="propLayer2" class="loginMbtLayer layer_block">
					<p class="tit">이메일로 가입</p>
					<div class="loginMbtLayerCon">
						<p class="txt1"><spring:message code="message.proposal.015"/><br/></p>
						<p class="txt3"><spring:message code="message.proposal.016"/></p>
						<a href="#" class="btW1 layerClose2"><span>취소</span></a>
						<a href="#" class="btC1 layerClose2" onclick="joinEmail(); return false;"><span>이메일로 가입</span></a>
						<a href="#" class="layerClose"><img src="${siteImgPath}/common/layerClose.png" alt="닫기"/></a>
					</div>
				</div>

				<div id="propLayer3" class="loginMbtLayer1 layer_block">
					<p class="tit">비밀번호확인</p>
					<div class="loginMbtLayerCon">
						<p class="inptxt"><input type="password" class="it widinputxt" id="removePw" placeholder="비밀번호를 입력해주세요."/></p>
						<a href="#" class="btW1 layerClose2"><span>취소</span></a>
						<a href="#" class="btC1 " onclick="visitorRemove(); return false;"><span>확인</span></a>
						<a href="#" class="layerClose"><img src="${siteImgPath}/common/layerClose.png" alt="닫기"/></a>
					</div>
				</div>

				<div id="propLayer4" class="loginMbtLayer1 layer_block">
					<p class="tit">비밀번호확인</p>
					<div class="loginMbtLayerCon">
						<p class="inptxt"><input type="password" class="it widinputxt" id="modifyPw" placeholder="비밀번호를 입력해주세요."/></p>
						<a href="#" class="btW1 layerClose2"><span>취소</span></a>
						<a href="#" class="btC1 " onclick="visitorModify(); return false;"><span>확인</span></a>
						<a href="#" class="layerClose"><img src="${siteImgPath}/common/layerClose.png" alt="닫기"/></a>
					</div>
				</div>

				<jsp:include page="/WEB-INF/views/front/proposal/proposal-search-form.jsp" />

				<c:set var="req" value="${pageContext.request}" />
				<c:set var="baseURL" value="${fn:replace(req.requestURL, req.requestURI, '')}" />
				<c:set var="params" value="${requestScope['javax.servlet.forward.query_string']}"/>
				<c:set var="requestPath" value="${requestScope['javax.servlet.forward.request_uri']}"/>
				<c:set var="requestURL" value="${baseURL}${requestPath}${not empty params ? '?' += params : ''}" scope="session"/>

			</div>

		</div>
	</div>
</div>

<!-- footer -->
<jsp:include page="/WEB-INF/views/front/common/footer.jsp"/>
<!-- //footer -->

</body>
</html>
