<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page contentType="text/html; charset=utf-8" %>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>

<!-- meta -->
<jsp:include page="/WEB-INF/views/mobile/common/meta.jsp"/>
<!-- //meta -->

<link href="${siteCssPath}/board.css" type="text/css" rel="stylesheet"  />

<style type="text/css">
<!--
.btn_cmt_modify {
    width: 79px;
    height: 23px;
    padding: 9px 0 0;
    text-align: center;
    background: #343434;
    font-size: 14px;
    color: #fff !important;
    display: inline-block;
    text-decoration: none;
}

.btn_cmt_cancel {
    width: 79px;
    height: 22px;
    padding: 8px 0 0;
    text-align: center;
    background: #fff;
    font-size: 14px;
    color: #343434 !important;
    display: inline-block;
    text-decoration: none;
    border: 1px solid #000;
}

//-->
</style>

<script language="javascript" type="text/javascript">

	function login() {
		location.href = "/login";
	}
	
	function joinEmail() {
		location.href = "/member/join-email";
	}
	
	function fnList() {
		
		// FIXME: 이전 조회 전체 목록 출력 or 첫 페이지만 출력
		$("#pageNo").val(1);
		
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
						$("#tmpSympathy").attr("style","width:122px; height:34px; border:3px solid #ec4849;");
						$("#sympathyCount").attr("style","height:32px; line-height:34px; background:url(${siteImgPath}/sub1/bla1_on.png) 0 50% no-repeat; background-size:14px 13.5px;");
					} else {
						$("#tmpSympathy").attr("style", "");
						$("#sympathyCount").attr("style", "");
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
		var div_cmt_btn = "div_cmt_btn_" + cmtSeq;
		
		var divCmtCont = $("#divCmtCont_" + cmtSeq);
		var textareaId = "cmtUpdTa_" + cmtSeq;
		
		if( $("#" + divId).length == 0 ) {

			var html = "<div id='" + divId + "'>"
					 + "<textarea id='" + textareaId + "' style='text-indent: 0px; width: 310px; border: 2px solid #343434;' placeholder='제안에 대한 의견을 등록해주세요.'>" + divCmtCont.find("p:first").text() + "</textarea>"
					 + "</div>";
					 
			var btn = "<div id='" + div_cmt_btn + "' style='text-align: right; margin-right: 17px;'>"
			 		+ "<a href='#' class='btn_cmt_cancel' onclick='fnCommentCancel(\"" + cmtSeq + "\"); return false;'>취소</a>"
			 		+ "<a href='#' class='btn_cmt_modify' onclick='fnSaveComment(" + cmtSeq + "); return false;'>댓글수정</a>"
			 		+ "</div>";
					
			divCmtCont.after(html);
			divCmtCont.parent().after(btn);
			divCmtCont.hide();
		}
		
	}
	
	function fnCommentCancel(cmtSeq) {

		var divId = "div_comment_" + cmtSeq;
		var div_cmt_btn = "div_cmt_btn_" + cmtSeq;
		var divCmtCont = $("#divCmtCont_" + cmtSeq);
		
		$("#" + divId).remove();
		$("#" + div_cmt_btn).remove();
		divCmtCont.show();
		
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
		layer.fadeIn().css({ 'width': 320 });
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
		$("body").on('click',function(){
			$('.more').find("ul").hide();
		});
	});
	
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
		<span>제안사업 상세보기</span>
	</div>

	<input type="hidden" name="propSeq" id="propSeq" value="<c:out value="${proposal.propSeq}" />" />
	<input type="hidden" name="bizNm" id="bizNm" value="<c:out value="${proposal.bizNm }" />" />
	        
	<div class="boardView">
		<p class="viewTop">
			<strong><c:out value="${proposal.bizNm}"/></strong>
			<span><c:out value="${proposal.realmNm }"/></span>
		</p>

		<p class="pageView">조회수 <c:out value="${proposal.readCnt }" /></p>
		<table cellpadding="0" cellspacing="0" class="tbL" summary="" >
			<colgroup>
				<col width="80"/><col width="*"/>
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
				</tr>
				<tr>
					<th scope="row">등록일</th>
					<td><c:out value="${proposal.regDateText }" /></td>
				</tr>
				<tr>
					<th scope="row">처리상태</th>
					<td><c:out value="${proposal.statusText }" /></td>
				</tr>
				<tr>
					<th scope="row">소요사업비</th>
					<td><c:out value="${proposal.budget }"/></td>
				</tr>
				<tr>
					<th scope="row">사업기간</th>
					<td><c:out value="${proposal.startDate }" /> ~ <c:out value="${proposal.endDate }" /></td>
				</tr>
				<tr>
					<th scope="row" colspan="2">사업위치</th>
				</tr>
				<tr>
					<td colspan="2" class="bln">
						<div class="tbCon">
							<c:out value="${proposal.location }" />
						</div>
					</td>
				</tr>
				<tr>
					<th scope="row" colspan="2">제안취지</th>
				</tr>
				<tr>
					<td colspan="2" class="bln">
						<div class="tbCon">
							<c:out value="${fn:replace(proposal.necessity, entermark, '<br/>')}" escapeXml="false"/>
						</div>
					</td>
				</tr>
				<tr>
					<th scope="row" colspan="2">내용</th>
				</tr>
				<tr>
					<td colspan="2" class="bln">
						<div class="tbCon">
							<c:out value="${fn:replace(proposal.bizCont, entermark, '<br/>')}" escapeXml="false"/>
						</div>
					</td>
				</tr>
				<tr>
					<th scope="row" colspan="2">기대효과</th>
				</tr>
				<tr>
					<td colspan="2" class="bln">
						<div class="tbCon">
							<c:out value="${fn:replace(proposal.effect, entermark, '<br/>')}" escapeXml="false"/>
						</div>
					</td>
				</tr>
				
				<c:if test="${proposal.ownerYn eq 'Y'}">
				<tr>
					<th scope="row" colspan="2">사진</th>
				</tr>
				<tr>
					<td colspan="2" class="bln">
						
						<c:forEach items="${imageFileList}" var="item">
							<dl class="photo1">
								<dt><c:out value="${item.fileSrcNm}" /></dt>
								<dd><img src="/file-download/${item.fileSeq}" alt="${item.fileSrcNm}"/></dd>
							</dl>
						</c:forEach>
						
					</td>
				</tr>
				<tr>
					<th scope="row">신청서 등록</th>
					<td>
						<c:forEach items="${attachFileList }" var="item">
							<p style="padding: 3px;"><a href="/file-download/${item.fileSeq}"><c:out value="${item.fileSrcNm}" /></a></p>
						</c:forEach>
					</td>
				</tr>
				</c:if>
				
			</tbody>
		</table>


<c:if test="${proposal.status ne 'PENDING' and not empty proposalAudit}">


		<p class="tableTit">검토의견</p>
		<table cellpadding="0" cellspacing="0" class="tbL" summary="" >
			<colgroup>
				<col width="80"/><col width="*"/>
			</colgroup>
			<tbody>
				<tr>
					<th scope="row">사업기간</th>
					<td><c:out value="${proposalAudit.startDate}"/> ~ <c:out value="${proposalAudit.endDate}"/></td>
				</tr>
				<tr>
					<th scope="row">소요예산</th>
					<td><c:out value="${proposalAudit.budget}"/></td>
				</tr>
				<tr>
					<th scope="row">사업위치</th>
					<td><c:out value="${proposalAudit.location}"/></td>
				</tr>
				<tr>
					<th scope="row">분과위원회</th>
					<td><c:out value="${proposalAudit.subcmit}"/></td>
				</tr>
				<tr>
					<th scope="row">구분</th>
					<td><c:out value="${proposalAudit.realmNm}"/></td>
				</tr>
				<tr>
					<th scope="row" colspan="2">내용</th>
				</tr>
				<tr>
					<td colspan="2" class="bln">
						<div class="tbCon">
							<c:out value="${fn:replace(proposalAudit.bizCont, entermark, '<br/>')}" escapeXml="false"/>
						</div>
					</td>
				</tr>
				<tr>
					<th scope="row" colspan="2" class="thBg c">검토의견</th>
				</tr>
				<tr>
					<th scope="row" rowspan="2">법률ㆍ조례 기준</th>
					<td><c:out value="${proposalAudit.lawResult}"/></td>
				</tr>
				<tr>
					<td><c:out value="${proposalAudit.lawDetail}"/></td>
				</tr>
				<tr>
					<th scope="row" colspan="2">검토의견(타당성, 시급성, 사업효과, 수혜범위 등)</th>
				</tr>
				<tr>
					<td colspan="2" class="bln">
						<div class="tbCon">
							<c:out value="${fn:replace(proposalAudit.reviewDetail, entermark, '<br/>')}" escapeXml="false"/>
						</div>
					</td>
				</tr>
				<tr>
					<th scope="row">검토결과</th>
					<td><c:out value="${proposalAudit.reviewResult}"/></td>
				</tr>
				<tr>
					<th scope="row">검토부서</th>
					<td><c:out value="${proposalAudit.reviewDept}"/></td>
				</tr>
				<tr>
					<th scope="row">검토자</th>
					<td><c:out value="${proposalAudit.reviewer}"/></td>
				</tr>
				<tr>
					<th scope="row">사진</th>
					<td>
						<c:forEach items="${auditImageFileList}" var="item">
							<p style="padding-bottom: 5px;"><a href="/file-download/${item.fileSeq}"><c:out value="${item.fileSrcNm}"/></a></p>
						</c:forEach>
					</td>
				</tr>
				<tr>
					<th scope="row">첨부파일</th>
					<td>
						<c:forEach items="${auditAttachFileList}" var="item">
							<p style="padding-bottom: 5px;"><a href="/file-download/${item.fileSeq}"><c:out value="${item.fileSrcNm}"/></a></p>
						</c:forEach>
					</td>
				</tr>
				<tr>
					<th scope="row" colspan="2" class="thBg c">참여예산(분과)위원회 검토 의견</th>
				</tr>
				<tr>
					<th scope="row" rowspan="2">검토의견</th>
					<td><c:out value="${proposalAudit.cmitResult}"/></td>
				</tr>
				<tr>
					<td><c:out value="${proposalAudit.cmitDetail}"/></td>
				</tr>
			</tbody>
		</table>

		<p class="tableTit">심사결과</p>
		<table cellpadding="0" cellspacing="0" class="tbL" summary="" >
			<colgroup>
				<col width="80"/>
				<col width=""/>
				<col width=""/>
			</colgroup>
			<thead>
				<tr>
					<th scope="col" class="thBg c"></th>
					<th scope="col" class="thBg c">참여예산위원회</th>
					<th scope="col" class="thBg c">주민총회</th>
				</tr>
			</thead>
			<tbody>
				<tr>
					<th scope="row">심사결과</th>
					<td><c:out value="${proposalAudit.auditCmitResult}"/></td>
					<td><c:out value="${proposalAudit.auditGnrResult}"/></td>
				</tr>
				<tr>
					<th scope="row">조정사업비</th>
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


	<ul class="viewBtArea">
		<c:if test="${proposal.status eq 'PENDING'}">
			<c:choose>
				<c:when test="${proposal.ownerYn eq 'Y'}">
					<li><a href="#" class="del" onclick="fnRemove(); return false;">삭제하기</a></li>
					<li><a href="#" onclick="fnModify(); return false;">수정하기</a></li>
				</c:when>
				<c:when test="${proposal.memberYn eq 'N'}">
					<li><a href="#" onclick="propLayer('propLayer3'); return false;" class="del">삭제하기</a></li>
					<li><a href="#" onclick="propLayer('propLayer4'); return false;">수정하기</a></li>
				</c:when>
			</c:choose>
		</c:if>
		<li><a href="#" onclick="fnList(); return false;">목록보기</a></li>
	</ul>

	<c:set var="symStyle"><c:if test="${proposal.symYn eq 'Y' or proposal.status ne 'PENDING'}">width: 122px; height: 34px; border: 3px solid #ec4849;</c:if></c:set>
	<c:set var="symSpanStyle"><c:if test="${proposal.symYn eq 'Y' or proposal.status ne 'PENDING'}">height:32px; line-height:34px; background:url(${siteImgPath}/sub1/bla1_on.png) 0 50% no-repeat; background-size:14px 13.5px;</c:if></c:set>
	<c:choose>
		<c:when test="${proposal.status ne 'PENDING'}">
			<a href="#" onclick="return false;" class="heart" style="${symStyle}"><span id="sympathyCount" style="${symSpanStyle}"><fmt:formatNumber value="${proposal.symCnt}" pattern="#,###" /></span></a>
		</c:when>
		<c:when test="${userType eq 'EMAIL' or userType eq 'CMIT'}">
			<a href="#" id="tmpSympathy" class="heart " style="${symStyle}" onclick="fnSympathy(); return false;"><span id="sympathyCount" style="${symSpanStyle}"><fmt:formatNumber value="${proposal.symCnt}" pattern="#,###" /></span></a>
		</c:when>
<%-- 		
		<c:when test="${userType eq 'PHONE'}">
			<a href="#" id="tmpSympathy" onclick="propLayer('propLayer2'); return false;" class="heart"><span id="sympathyCount"><fmt:formatNumber value="${proposal.symCnt}" pattern="#,###" /></span></a>
		</c:when>
--%>		
		<c:otherwise>
			<a href="#" id="tmpSympathy" onclick="propLayer('propLayer1'); return false;" class="heart"><span id="sympathyCount"><fmt:formatNumber value="${proposal.symCnt}" pattern="#,###" /></span></a>
		</c:otherwise>
	</c:choose>
		<!-- sns -->
		<div class="sns_wrap">
			<script type="text/javascript">
				var sh_title = $("#bizNm").val();
		   		var sh_url = location.href;			
			</script>
			<jsp:include page="/WEB-INF/views/common/sns.jsp"/>
		</div>
		<!-- //sns -->	
		<!-- 
	<ul class="viewSns">
		<li><a href="#" onclick="fnShareSns(5); return false;"><img src="${siteImgPath}/sub1/sns1.gif" alt="카카오톡" width="34px"/></a></li>
		<li><a href="#" onclick="fnShareSns(1); return false;"><img src="${siteImgPath}/sub1/sns2.gif" alt="페이스북" width="34px"/></a></li>
		<li><a href="#" onclick="fnShareSns(2); return false;"><img src="${siteImgPath}/sub1/sns3.gif" alt="트위터" width="34px"/></a></li>
		<li><a href="#" onclick="fnShareSns(3); return false;"><img src="${siteImgPath}/sub1/sns4.gif" alt="밴드" width="34px"/></a></li>
		<li><a href="#" onclick="fnShareSns(4); return false;"><img src="${siteImgPath}/sub1/sns5.gif" alt="카카오스토리" width="34px"/></a></li>
	</ul>
 -->
	<div class="reTxtArea">
		<p class="tit">
			<strong>댓글</strong>
			<span><c:out value="${commentListCount}" /></span>
		</p>

		<c:forEach items="${commentList}" var="item" varStatus="idx">
			<div class="reTxt" style="min-height:69px; height: auto;">
				<p class="tit">
					<strong><c:out value="${item.nickname }" /></strong>
					<span><c:out value="${item.regDateText }" /></span>
					<strong style="margin-left: 6px; color: red;"><c:if test="${item.reportCnt gt 0}">신고 <c:out value="${item.reportCnt}"/></c:if></strong>
				</p>
				
				<c:choose>
					<c:when test="${item.hideYn eq 'Y' and item.ownerYn eq 'N'}">
						<div class="txt red">
							숨김 처리된 댓글입니다.
						</div>
					</c:when>
					<c:when test="${item.hideYn eq 'Y' and item.ownerYn eq 'Y'}">
						<div class="txt red">
							숨김 처리된 댓글입니다.
						</div>
						<div id="divCmtCont_${item.cmtSeq}" class="txt">
							<p><c:out value="${item.cont}" /></p>
						</div>
						<div class="more">
							<a href="#"><img src="${siteImgPath}/sub1/eTxtMore.png" alt=""/></a>
							<ul class="">
								<li class="fir"><a href="#" onclick="fnCommentUpdate(this, '${item.cmtSeq}'); return false;">수정</a></li>
								<li><a href="#" onclick="fnCommentDelete('${item.cmtSeq}'); return false;">삭제</a></li>
							</ul>
						</div>
					</c:when>
					<c:when test="${item.hideYn ne 'Y' and item.ownerYn eq 'N'}">
						<div id="divCmtCont_${item.cmtSeq}" class="txt">
							<p><c:out value="${item.cont}" /></p>
						</div>
						<div class="more">
							<a href="#"><img src="${siteImgPath}/sub1/eTxtMore.png" alt=""/></a>
							<ul class="">
								<li class="fir"><a href="#" onclick="fnCommentReport('${item.cmtSeq}'); return false;">신고하기</a></li>
							</ul>
						</div>
						<p class="yesorno">
							<a href="#" class="yes on" onclick="fnCommentAgree('${item.cmtSeq}','Y'); return false;"><c:out value="${item.agreeCntY}" /></a>
							<a href="#" class="no on" onclick="fnCommentAgree('${item.cmtSeq}','N'); return false;"><c:out value="${item.agreeCntN}" /></a>
						</p>
					</c:when>
					<c:when test="${item.hideYn ne 'Y' and item.ownerYn eq 'Y'}">
						<div id="divCmtCont_${item.cmtSeq}" class="txt">
							<p><c:out value="${item.cont}" /></p>
						</div>
						<div class="more">
							<a href="#"><img src="${siteImgPath}/sub1/eTxtMore.png" alt=""/></a>
							<ul class="">
								<li class="fir"><a href="#" onclick="fnCommentUpdate(this, '${item.cmtSeq}'); return false;">수정</a></li>
								<li><a href="#" onclick="fnCommentDelete('${item.cmtSeq}'); return false;">삭제</a></li>
							</ul>
						</div>
					</c:when>
				</c:choose>
				
				<c:if test="${proposal.status ne 'PENDING'}">
				<script>$(".more").remove();$(".moreBox").remove();$(".yesorno").remove();</script>
				</c:if>
				
	 		</div>
		</c:forEach>

		<c:if test="${proposal.status eq 'PENDING'}">
		
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
					<div class="reTxtWrite">
						<div class="">
							<spring:message code="message.proposal.017"/>
						</div>
					</div>
				</c:when>
				
				<c:when test="${_accountInfo.hasRole('USER')}">
					<div class="reTxtWrite">
						<div class="">
							<p style="padding-left: 10px; height: 25px; line-height: 25px; font-size: 13px; font-weight: bold; color: #343434;"><c:out value="${_accountInfo.nickname}"/></p>
							<textarea id="comment" style="text-indent: 0px;" placeholder=" 제안에 대한 의견을 등록해주세요."></textarea>
						</div>
					</div>
				</c:when>
				
				<c:otherwise>
					<div class="reTxtWrite">
						<div class="">
							<textarea id="comment" placeholder=" 제안에 대한 의견을 등록해주세요." onfocus="checkAuthCode('${tmpValue}');"></textarea>
						</div>
					</div>
				</c:otherwise>
			</c:choose>
			
			
			<p class="reTxtPoint">개인정보유출, 권리 침해, 욕설 등의 내용을 게시할 경우 이용약관 및 관련 법률에 의해 제재를 받을 수 있습니다</p>
			
			<c:if test="${_accountInfo.hasRole('USER') and cmtYn ne 'N'}">
			<p class="reTxtBt">
				<a href="#" onclick="fnSaveComment(); return false;">댓글등록</a>
			</p>
			</c:if>
			
		</c:if>
		
	</div>
	<script language="javascript" type="text/javascript">
	//<![CDATA[
		$('.more').each(function(){
			$(this).find('>a').on('click',function(){
				if ($(this).hasClass('on')){
					$(this).removeClass('on').next('ul').hide();
				}else{
					$(this).addClass('on').next('ul').show();
				}
				return false;
			})
		})
	//]]>
	</script>

	<div id="propLayer1" class="layer_block layerPop">
		<p class="layerTit">
			<strong>로그인</strong>
			<a href="#" class="layerClose"><img src="${siteImgPath}/common/layerClose.png" alt=""/></a>
		</p>
		<div class="layerCont">
			<p class="txt"><spring:message code="message.proposal.013"/></p>
			<p class="txt"><spring:message code="message.proposal.014"/></p>
			<p class="bt">
				<a href="#" class="cancel layerClose">취소</a>
				<a href="#" class="ok" onclick="login(); return false;"><span>확인</span></a>
			</p>
		</div>
	</div>
	<div id="propLayer2" class="layer_block layerPop">
		<p class="layerTit">
			<strong>이메일로 가입</strong>
			<a href="#" class="layerClose"><img src="${siteImgPath}/common/layerClose.png" alt=""/></a>
		</p>
		<div class="layerCont">
			<p class="txt"><spring:message code="message.proposal.015"/></p>
			<p class="txt"><spring:message code="message.proposal.016"/></p>
			<p class="bt">
				<a href="#" class="cancel layerClose">취소</a>
				<a href="#" class="ok" onclick="joinEmail(); return false;"><span>이메일로 가입</span></a>
			</p>
		</div>
	</div>
	<div id="propLayer3" class="layer_block layerPop">
		<p class="layerTit">
			<strong>비밀번호확인</strong>
			<a href="#" class="layerClose"><img src="${siteImgPath}/common/layerClose.png" alt=""/></a>
		</p>
		<div class="layerCont">
			<input type="password" class="it" id="removePw" placeholder="비밀번호를 입력해주세요" style="width:99%; height:40px; margin:10px 0; "/>
			<p class="bt">
				<a href="#" class="cancel layerClose">취소</a>
				<a href="#" class="ok" onclick="visitorRemove(); return false;"><span>확인</span></a>
			</p>
		</div>
	</div>
	<div id="propLayer4" class="layer_block layerPop">
		<p class="layerTit">
			<strong>비밀번호확인</strong>
			<a href="#" class="layerClose"><img src="${siteImgPath}/common/layerClose.png" alt=""/></a>
		</p>
		<div class="layerCont">
			<input type="password" class="it" id="modifyPw" placeholder="비밀번호를 입력해주세요" style="width:99%; height:40px; margin:10px 0; "/>
			<p class="bt">
				<a href="#" class="cancel layerClose">취소</a>
				<a href="#" class="ok" onclick="visitorModify(); return false;"><span>확인</span></a>
			</p>
		</div>
	</div>
			
	<jsp:include page="/WEB-INF/views/mobile/proposal/proposal-search-form.jsp" />

	<c:set var="req" value="${pageContext.request}" />
	<c:set var="baseURL" value="${fn:replace(req.requestURL, req.requestURI, '')}" />
	<c:set var="params" value="${requestScope['javax.servlet.forward.query_string']}"/>
	<c:set var="requestPath" value="${requestScope['javax.servlet.forward.request_uri']}"/>
	<c:set var="requestURL" value="${baseURL}${requestPath}${not empty params ? '?' += params : ''}" scope="session"/>

	
	
</div>
<!-- footer -->
<jsp:include page="/WEB-INF/views/mobile/common/footer.jsp"/>
<!-- //footer -->
</body>
</html>
