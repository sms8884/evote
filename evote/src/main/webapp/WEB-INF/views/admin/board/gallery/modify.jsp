<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page contentType="text/html; charset=utf-8" %>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>

<!-- meta -->
<jsp:include page="/WEB-INF/views/admin/common/meta.jsp"/>
<!-- //meta -->

<script language="javascript" type="text/javascript">

function modifyProc() {

	if($("#title").val() == "") {
		alert("<spring:message code='message.common.header.002' arguments='제목을'/>");
		$("#title").focus();
		return;
	}

	if($("#cont").val() == "") {
		alert("<spring:message code='message.common.header.002' arguments='내용을'/>");
		$("#cont").focus();
		return;
	}
	
	var fiileSizeCheck = true;
	
    $("input[name=imageFile]").each(function(){
        if(gfnFileExtCheck($(this), ['jpg','jpeg','gif','png']) == false){
        	fiileSizeCheck = false;
            return false;
        }
        
        //파일이 선택된 항목만 체크
        var fileSize = gfnGetFileSize(this);
        if(fileSize != -1){
            //MAX파일용량 2MB
            if(fileSize > 2097152){
                alert("파일용량을 초과하였습니다.");
                this.focus();
                fiileSizeCheck = false;
                return false;  
            }
        }
            
    });
    if(fiileSizeCheck == false){
        return;
    }
	
    fiileSizeCheck = true;
    
    $("input[name=attachFile]").each(function(){
        if(gfnFileExtCheck($(this), ['hwp']) == false){
        	fiileSizeCheck = false;
            return false;
        }
        
        //파일이 선택된 항목만 체크
        var fileSize = gfnGetFileSize(this);
        if(fileSize != -1){
            //MAX파일용량 2MB
            if(fileSize > 2097152){
                alert("파일용량을 초과하였습니다.");
                this.focus();
                fiileSizeCheck = false;
                return false;  
            }
        }
            
    });
    if(fiileSizeCheck == false){
        return;
    }
    
	$("#boardForm").attr("action", "/admin/board/${board.boardName}/modify-proc");
	$("#boardForm").attr("method", "POST");
	$("#boardForm").submit();
}

function list() {
	$("#searchForm").attr("action", "/admin/board/${board.boardName}/list");
	$("#searchForm").attr("method", "POST");
	$("#searchForm").submit();		
}

var imageFile;

$(function() {
	<c:if test="${board.imageUseYn eq 'Y'}">
	imageFile = $("#btnImageFile").evoteFile({
				maxFileCount : "<c:out value='${board.maxImageCount}'/>",
			    oldFileCount : "<c:out value='${fn:length(boardPost.imageList)}'/>",
				callbackDeleteFile : addDeleteFileSeq
	});
	</c:if>
	
	<c:if test="${board.cateUseYn eq 'Y'}">
	$("#categoryCd").val("${boardPost.categoryCd}");
	</c:if>
	
	if("Y" == "${boardPost.dpYn}") {
		$("#dpY").attr("checked", "checked");
	} else {
		$("#dpN").attr("checked", "checked");
	}
});

function deleteImageFile(fileSeq) {
	imageFile.deleteFile(fileSeq);
}

function addDeleteFileSeq(fileSeq) {
	if ($("#deleteFile").val() == "") {
		$("#deleteFile").val(fileSeq);
	} else {
		$("#deleteFile").val($("#deleteFile").val() + "|" + fileSeq);
	}
}


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
				<li>갤러리</li>
			</ul>
		</div>

		<div class="container">
			<div class="contentWrap">

				<!--leftmenu-->
				<jsp:include page="/WEB-INF/views/admin/common/lnb.jsp"/>
				<!--//leftmenu-->
				
				<div class="content">
					<h3 class="contentTit"><c:out value="${board.boardTitle}"/></h3>	
					<div class="mainContent">
					
						<form name="boardForm" id="boardForm" enctype="multipart/form-data">
							
							<input type="hidden" name="postSeq" value="${boardPost.postSeq}"/>
							<input type="hidden" name="deleteFile" id="deleteFile"/>

							<!-- search param -->
							<input type="hidden" id="pageNo" name="pageNo" value="${searchParam.pageNo}"/>
							<input type="hidden" id="searchStartDate" name="searchStartDate" value="${searchParam.searchStartDate}"/>
							<input type="hidden" id="searchEndDate" name="searchEndDate" value="${searchParam.searchEndDate}"/>
							<input type="hidden" id="searchCategoryCd" name="searchCategoryCd" value="${searchParam.searchCategoryCd}"/>
							<input type="hidden" id="searchTarget" name="searchTarget" value="${searchParam.searchTarget}"/>
							<input type="hidden" id="searchText" name="searchText" value="${searchParam.searchText}"/>
							<!-- //search param -->
							
							<table cellpadding="0" cellspacing="0" class="tbG" summary="" >
								<caption><c:out value="${board.boardTitle}"/></caption>
								<colgroup>
									<col width="15%"/>
									<col width="*"/>
								</colgroup>
								<tbody>
								
									<c:if test="${board.pushUseYn eq 'Y'}">
									<tr>
										<th scope="row">푸시알림</th>
										<td>
										<c:choose>
											<c:when test="${boardPost.pushSendYn eq 'Y'}">
												푸시발송일시: <fmt:formatDate pattern="yyyy-MM-dd HH:mm:ss" value="${boardPost.pushSendDate}" />
											</c:when>
											<c:otherwise>
												<label class="chkboxLb"><input type="checkbox" class="chkbox" id="pushYn" name="pushYn" value="Y"/> 즉시발송</label>
											</c:otherwise>
										</c:choose>
										</td>
									</tr>
									</c:if>

									<c:if test="${board.cateUseYn eq 'Y'}">
									<tr>
										<th scope="row">구분</th>
										<td colspan="2">
											<select id="categoryCd" name="categoryCd" style="width:127px; height: 32px;">
												<c:forEach items="${boardCategoryList}" var="list">
													<option value="${list.categoryCd}"><c:out value="${list.categoryNm}"/></option>
												</c:forEach>
											</select>
										</td>
									</tr>
									</c:if>
									
									<tr>
										<th scope="row"><label for="title">제목</label></th>
										<td>
											<input type="text" class="gl_title" id="title" name="title" maxlength="50" value="${boardPost.title}"/>
										</td>
									</tr>
									<tr>
										<th scope="row">사진</th>
										<td>
											
											<!-- file box -->
											<div class="fileBox">
												<input type="button" class="filebutton" value="첨부" name="" id=""/>
												<input type="file" class="fileupload" name="imageFile" onchange="$(this).next().val($(this).val());"/>
												<input type="text" class="textbox" readonly="readonly"/>
											</div>
											<button id="btnImageFile" class="fileAdd">추가</button><!--20160804추가-->
											<!-- //file box -->
											
											<div class="gallery_img">
											
												<c:if test="${not empty boardPost.imageList}">
													<c:forEach items="${boardPost.imageList}" var="list">
														<p>
															<c:out value="${list.fileSrcNm}"/>
															<img src="/file-download/${list.fileSeq}" style="width: 142px; height: 100px;"/>
															<a href="#" class="delete" onclick="deleteImageFile('${list.fileSeq}'); $(this).parent().remove(); return false;"><img src="${siteImgPath}/common/btn_delete.gif" alt="삭제하기"></a>
														</p>
													</c:forEach>
												</c:if>
												
											</div>
										</td>
									</tr>
									<tr>
										<th scope="row">내용</th>
										<td>
											<div class="writeW">
												<textarea name="cont" id="cont" cols="10" rows="10" title="내용 입력" style="width:570px;"><c:out value="${boardPost.cont}"/></textarea>
											</div>
									</tr>
									<tr class="G_post" >
											<th>게시</th>
											<td colspan="4" >
												<input type="radio" class="" title="" id="dpY" name="dpYn" value="Y"><label for="dpY">게시</label>
												<input type="radio" class="" title="" id="dpN" name="dpYn" value="N"><label for="dpN">미게시</label>
											</td>
										</tr>
								</tbody>
							</table>
						
						</form>
						
						<div class="btnbox_GL2">
							<a href="#" class="btn_reset" style="float:right;" onclick="list(); return false;">취소</a>
							<a href="#" class="btn_blue" style="float:right;" onclick="modifyProc(); return false;">수정</a>
						</div>
					</div>
					
					<jsp:include page="/WEB-INF/views/admin/board/board-search-form.jsp" />
					
				</div>	
			</div><!--contentWrap-->
		</div><!--container-->
	</div><!--containerWrap-->

	<!-- footer -->
	<jsp:include page="/WEB-INF/views/admin/common/footer.jsp"/>
	<!-- //footer -->
	
</body>
</html>
