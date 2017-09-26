<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>

<!-- meta -->
<jsp:include page="/WEB-INF/views/admin/common/meta.jsp"/>
<!-- //meta -->

<!-- ckeditor -->
<script src="${ckeditorPath}/ckeditor.js" language="javascript" type="text/javascript" charset="utf-8"></script>
<!-- //ckeditor -->

<script type="text/javascript">

function writeProc() {
	
	if($("#title").val() == "") {
		alert("<spring:message code='message.common.header.002' arguments='제목을'/>");
		$("#title").focus();
		return;
	}

	<c:if test="${board.editorUseYn ne 'Y'}">
	if($("#cont").val() == "") {
		alert("<spring:message code='message.common.header.002' arguments='내용을'/>");
		$("#cont").focus();
		return;
	}
	</c:if>
	
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
    
	$("#boardForm").attr("action", "/admin/board/${board.boardName}/write-proc");
	$("#boardForm").attr("method", "POST");
	$("#boardForm").submit();
}

function list() {
	$("#searchForm").attr("action", "/admin/board/${board.boardName}/list");
	$("#searchForm").attr("method", "POST");
	$("#searchForm").submit();		
}

$(function() {
	<c:if test="${board.editorUseYn ne 'Y' and board.imageUseYn eq 'Y'}">
	$("#btnImageFile").evoteFile({
		maxFileCount : "<c:out value='${board.maxImageCount}'/>"
	});
	</c:if>
	<c:if test="${board.attachUseYn eq 'Y'}">
	$("#btnAttachFile").evoteFile({
		maxFileCount : "<c:out value='${board.maxAttachCount}'/>"
	});
	</c:if>
	
	<c:if test="${board.editorUseYn eq 'Y'}">
	CKEDITOR.replace('cont', {
		
		extraPlugins: 'uploadimage,image2',

        removePlugins: 'save,newpage,preview,print,templates,find,selectall,forms,div,justify,bidi,indentblock,flash,smiley,pagebreak,iframe,colorbutton,font,image',
        
        removeButtons: 'Underline,Subscript,Superscript,Copy,Cut,Paste,PasteText,PasteFromWord',
        
        height: 400,
        
		uploadUrl: '/editor/image-upload',

		//filebrowserImageUploadUrl: '/editor/dialog-upload',
		
		stylesSet: [
			{ name: 'Narrow image', type: 'widget', widget: 'image', attributes: { 'class': 'image-narrow' } },
			{ name: 'Wide image', type: 'widget', widget: 'image', attributes: { 'class': 'image-wide' } }
		],

		removeDialogTabs: 'link:advanced',
		
		// Load the default contents.css file plus customizations for this sample.
		//contentsCss: [ CKEDITOR.basePath + 'contents.css', 'http://sdk.ckeditor.com/samples/assets/css/widgetstyles.css' ],
		contentsCss: [ CKEDITOR.basePath + 'contents.css', '${ckeditorPath}/contents.css' ],

		// Configure the Enhanced Image plugin to use classes instead of styles and to disable the
		// resizer (because image size is controlled by widget styles or the image takes maximum
		// 100% of the editor width).
		image2_alignClasses: [ 'image-align-left', 'image-align-center', 'image-align-right' ],
		image2_disableResizer: true
				
	});
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
				<li>공지사항</li>
			</ul>
		</div>

		<div class="container">
			<div class="contentWrap">

				<!--leftmenu-->
				<jsp:include page="/WEB-INF/views/admin/common/lnb.jsp"/>
				<!--leftmenu-->

				<div class="content">
					<h3 class="contentTit"><c:out value="${board.boardTitle}"/></h3>
					<div class="mainContent">
						<div class="boardWrite">
							
							<form name="boardForm" id="boardForm" enctype="multipart/form-data">
							
							<table cellpadding="0" cellspacing="0" class="tbL" summary="공지사항 상세보기 - 구분, 조회수, 제목, 등록일, 내용, 첨부파일의 정보를 제공합니다." >
								<caption>공지사항 상세보기</caption>
								<colgroup>
									<col width="15%"/>
									<col width="*"/>
									<col width="15%"/>
									<col width="15%"/>
								</colgroup>
								<tbody>
									
									<c:if test="${board.pushUseYn eq 'Y'}">
									<tr>
										<th scope="row">푸시 알림</th>
										<td colspan="3">
											<label class="chkboxLb"><input type="checkbox" class="chkbox" id="pushYn" name="pushYn" value="Y"/> 즉시발송</label>
										</td>
									</tr>
									</c:if>
									
									<c:if test="${board.cateUseYn eq 'Y'}">
									<tr>
										<th scope="row">구분</th>
										<td colspan="2">
											<select id="categoryCd" name="categoryCd">
												<c:forEach items="${boardCategoryList}" var="list">
													<option value="${list.categoryCd}"><c:out value="${list.categoryNm}"/></option>
												</c:forEach>
											</select>
										</td>
										<td class="pdn c">
											<label class="chkboxLb"><input type="checkbox" class="chkbox" id="topYn" name="topYn" value="Y"/> 상단고정</label>
										</td>
									</tr>
									</c:if>
									
									<tr>
										<th scope="row">제목</th>
										<td colspan="3">
											<input type="text" class="it wid498" id="title" name="title" maxlength="50"/>
											<span class="red">50자 입력제한</span>
										</td>
									</tr>
									<tr>
										<th scope="row">내용</th>
										<td style="border-right-style: none;" colspan="3">
											<div class="writeW">
												
												<c:choose>
													<c:when test="${board.editorUseYn eq 'Y'}">
														<textarea class="ckeditor" id="cont" name="cont"></textarea>
													</c:when>
													<c:otherwise>
														<textarea id="cont" name="cont" cols="10" rows="10" title="내용" class="wid100"></textarea>
													</c:otherwise>
												</c:choose>
												
											</div>

										</td>
									</tr>
									
									<c:if test="${board.editorUseYn ne 'Y' and board.imageUseYn eq 'Y'}">
									<tr>
										<th scope="row">사진</th>
										<td style="border-right-style: none;" colspan="3">
										
											<!-- file box -->
											<div class='fileBox'>
												<input type='button' class='filebutton' value='첨부'/> 
												<input type='file' class='fileupload' name='imageFile' onchange='$(this).next().val($(this).val());'/> 
												<input type='text' class='textbox' readonly='readonly'/> 
											</div> 
											<button id="btnImageFile" class="fileAdd">추가</button>
											<!-- //file box -->

											<p class="upload">
												<span class="red2">※ gif, jpg, jpeg, png형식의 이미지 파일만 첨부 가능합니다.</span>
												<span class="red2">※ <c:out value='${board.maxImageCount}'/>개의 파일을 첨부할 수 있습니다.(파일 용량제한: 2MB)</span>
											</p>
										</td>
									</tr>
									</c:if>
									
									<c:if test="${board.attachUseYn eq 'Y'}">
									<tr>
										<th scope="row">첨부파일</th>
										<td style="border-right-style: none;" colspan="3">

											<!-- file box -->
											<div class='fileBox'>
												<input type='button' class='filebutton' value='첨부'/> 
												<input type='file' class='fileupload' name='attachFile' onchange='$(this).next().val($(this).val());'/> 
												<input type='text' class='textbox' readonly='readonly'/> 
											</div> 
											<button id="btnAttachFile" class="fileAdd">추가</button><!--20160804추가-->
											<!-- //file box -->
											
											<p class="upload">
												<span class="red2">※ 한글파일(hwp 파일)만 등록이 가능합니다.</span>
												<span class="red2">※ 최대 <c:out value="${board.maxAttachCount}"/>개의 파일을 첨부할 수 있습니다.(파일 용량제한: 2MB)</span>
											</p>
										</td>
									</tr>
									</c:if>
									
									<tr>
										<th scope="row">게시</th>
										<td colspan="3" class="radChk">
											<input type="radio" class="noticeR1" id="dpY" name="dpYn" value="Y" checked="checked"/><label for="dpY">게시</label>
											<input type="radio" class="noticeR2" id="dpN" name="dpYn" value="N"/><label for="dpN">미게시</label>
										</td>
									</tr>
								</tbody>
							</table>
							
							</form>
							
						</div>
						<div class="btnR">
							<a href="#" class="btn_blue" onclick="writeProc(); return false;">등록하기</a>
							<a href="#" class="btn_reset" onclick="list(); return false;">취소</a>
						</div>
						
						<jsp:include page="/WEB-INF/views/admin/board/board-search-form.jsp" />
						
					</div>
				</div><!--content-->
			</div><!--contentWrap-->

		</div><!--container-->
	</div><!--containerWrap-->
	
	<!-- footer -->
	<jsp:include page="/WEB-INF/views/admin/common/footer.jsp"/>
	<!-- //footer -->
	
</body>
</html>
