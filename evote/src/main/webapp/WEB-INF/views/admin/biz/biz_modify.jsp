<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page contentType="text/html; charset=utf-8" %>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>
<!-- meta -->
<jsp:include page="/WEB-INF/views/admin/common/meta.jsp"/>
<!-- //meta -->
<script language="javascript" type="text/javascript">
//<![CDATA[
           var imgCount = '${bizItem.imageList.size()}';
 	$(document).ready(function(){
 		
 		/* 내용 setting  */
/*  		
		$("#summary").val("${bizItem.summary}"); 		//사업개요
		$("#plan").val("${bizItem.plan}"); 					    // 추진계획
		$("#result").val("${bizItem.result}"); 					//추진실적
		$("#schedule").val("${bizItem.schedule}"); 			//향후일정
		$("#dept").val("${bizItem.dept}"); 						//추진부서
 */		
 		/*///내용 setting  */
 		
 		$('#bussiness_I').addClass('bussiness_Icheck');
 		setSelectDate();
 		setImageFile(imgCount);
 		if('${bizItem.attachList.size()}' >0){
 			attachFileBox('ready');
 		}
 		stateCheck("${bizItem.state}");
	});
 	
 	
 	/*파일 첨부 추가삭제 숫자설정  */
 	// 최대 파일점부 - 현재 파일수
 	/*//// */
 	function setImageFile(count){
 		
 		var imageSize = count;
 		var evoteImageCount = 2-imageSize; // 첨부가능한 숫자 - 기존 파일수
 		
 		if(evoteImageCount == 0){
 			$("#imageBox1").css("display","none");
 			$("#imageBox2").css("display","none");
 		}else if(evoteImageCount == 1){
 			$("#imageBox1").css("display","block");
 			$("#imageBox2").css("display","none");
 		}else if(evoteImageCount == 2){
 			$("#imageBox2").css("display","block");
 		} 
 	}
 	
 	function attachFileBox(state,id){
           if(state =='ready'){
 			$("#attachBox").css("display","none");
           }else{
        		if(confirm("파일을 삭제하시겠습니까?")){
        	 		$.ajax({
        	 			url:"/admin/biz/bizFileInfo_delete/" + id
        	 			,type:'POST'
        	 			,dataType:"json"
        	 			,success: function(data){
        	 				if(data==true){
        	 	        	$("#attachFileId").remove();	
        	 	 			$("#attachBox").css("display","block");
        	 				}
        	 			}
        	 			 , error: function(xhr, status, error) {
        	 				 alert();
        	 	        	if (console && console.log) console.log("error : " + error.message);
        	 	        }
        	 		});
        		}
           }
 	}
 	
 	
 	/* 2012 년부터 현재 년도 +1년까지 셀렉트박스 생성 */
 	function setSelectDate(){
 		var today = new Date();
 		var year = today.getFullYear();
		var standard  = year - 2012;
 		for(var i = 0 ; i<=standard ; i++){
			if( i==0 ){
				var tmp2 =	"<option value='"+(year+1)+"'>"+(year+1)+"</option>";				
				$("#biz_year").append(tmp2);
			}
			var tmp = "<option value='"+(year-i)+"'>"+(year-i)+"</option>";
			$("#biz_year").append(tmp);
 		}
 		$("#biz_year> option[value="+"${bizItem.biz_year}"+"]").attr("selected", "true");
 	}
 	/*/// 셀렉트 박스생성 END */
 	
	
 	
 	/*사업현황 저장하기 */
 	function writeProc() {
 		
 		if($("#biz_name").val() == "") {
 			alert("<spring:message code='message.common.header.002' arguments='제목을'/>");
 			$("#biz_name").focus();
 			return;
 		}

 		if($("#budget").val() == "") {
 			alert("<spring:message code='message.common.header.002' arguments='소요예산을'/>");
 			$("#budget").focus();
 			return;
 		}

 		var regNumber = /^[0-9]*$/;
 		if(!regNumber.test($("#budget").val())) {
 		    alert('소요예산은 숫자만 입력해주세요.');
 		   $("#budget").focus();
 		    return;
 		}
 		
 		if($("#progressHide").css("display") == "inline-block"){
 			if( $("#progress").val() == "" ){
	 			alert("<spring:message code='message.common.header.002' arguments='진행률을'/>");
	 			$("#progress").focus();
	 			return; 
 			}
 			var temp =$("#progress").val();
 			if(isNaN(temp) == true || temp > 100) {
 				alert("100이하 정수만 입력해주세요");
 				$("#progress").focus();
 				return; 
 			} 
 		}
 		
 		if($("#summary").val() == "") {
 			alert("<spring:message code='message.common.header.002' arguments='사업개요를'/>");
 			$("#summary").focus();
 			return;
 		} 
		
 		if($("#plan").val() == "") {
 			alert("<spring:message code='message.common.header.002' arguments='추진계획을'/>");
 			$("#plan").focus();
 			return;
 		}
 		
		if($("#result").val() == "") {
 			alert("<spring:message code='message.common.header.002' arguments='추진실적을'/>");
 			$("#result").focus();
 			return;
		}
		
		if($("#schedule").val() == "") {
 			alert("<spring:message code='message.common.header.002' arguments='향후일정'/>");
 			$("#schedule").focus();
 			return;
		}
		
		if($("#dept").val() == "") {
 			alert("<spring:message code='message.common.header.002' arguments='추진부서'/>");
 			$("#dept").focus();
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
 	        if(gfnFileExtCheck($(this), ['hwp','pdf']) == false){
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
 		$("#bizForm").attr("action", "/admin/biz/biz_modify");
 		$("#bizForm").attr("method", "POST");
 		$("#bizForm").submit();
 	}
 	
 	function stateCheck(state){
 		if(state == "실행중"){
 		$('#bussiness_I').addClass('bussiness_Icheck');
 		$('#bussiness_E').removeClass('bussiness_Echeck');
 		$("#progressHide").css("display","inline-block");
 		
 		if("${bizItem.progress != null}"){
 		$("#progress").val("${bizItem.progress}")
 		$("#state").val("실행중");
 		}else{
 		$("#progress").val("")
 		}
 		 }else if(state=="완료"){
 		$('#bussiness_E').addClass('bussiness_Echeck');
 		$('#bussiness_I').removeClass('bussiness_Icheck');
 		$("#progressHide").css("display","none");
 		$("#state").val("완료");
 		$("#progress").val("100")
 		 }
 	}
 	
 	function preview(fileSeq){
		var moveUrl = "/admin/biz/biz_pop/" + fileSeq
 		popupWindow =  window.open(moveUrl, 'biz_popup', 'width=350, height=450, menubar=no, status=no, toolbar=no');
 		
 	}
 	
 	
 	function removeData(id){
		if(confirm("파일을 삭제하시겠습니까?")){
 		$.ajax({
 			url:"/admin/biz/bizFileInfo_delete/" + id
 			,type:'POST'
 			,dataType:"json"
 			,success: function(data){
 				if(data==true){
 		 			imgCount = imgCount-1;
					setImageFile(imgCount);
					$("#image"+id).remove();	
 				}
 			}
 			 , error: function(xhr, status, error) {
 	        	if (console && console.log) console.log("error : " + error.message);
 	        }
 		});
		}
 					
 	}
 	
 	
//]]>
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
				<li>사업현황</li>
				<li>사업등록</li>
			</ul>
		</div>

		<div class="container">
			<div class="contentWrap">	
			<!--leftmenu-->
				<jsp:include page="/WEB-INF/views/admin/common/lnb.jsp"/>
				<!--//leftmenu-->
				<div class="content">
					<h3 class="contentTit">사업현황 등록하기</h3>	
					<div class="mainContent">
					<form name="bizForm" id="bizForm" enctype="multipart/form-data">
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
											<th scope="row">해당년도</th>
											<td>
												<select name="biz_year" id="biz_year"  title="선택하기" class="wid125">
													<option value="">선택</option>
												</select>
											</td>
										</tr>
										<tr>
											<th scope="row">제목</th>
											<td>
												<input type="text" class="it wid461" title="biz_name" value="${bizItem.biz_name}" name="biz_name" id="biz_name"/>
											</td>
										</tr>
										<tr>
											<th scope="row">소요예산</th>
											<td>
												<input type="text" class="it wid141" title="" value="${bizItem.budget}" name="budget" id="budget"/> <span class="textAfter"> 천원</span>
											</td>
										</tr>
										<tr>
											<th scope="row">진행상황</th>
											<td>
												<button type="button" class="bussiness_I" id="bussiness_I" onclick="stateCheck('실행중')" >실행중</button>
												<button type="button" class="bussiness_E" id="bussiness_E" onclick="stateCheck('완료')">완료</button>
												<input type="hidden" id="state" name="state" value="실행중" />
												<p class="BI_per" id="progressHide" style="display: inline-block;"><label>진행률(%)</label><input type="text" class="it wid70" id="progress" name="progress" /></p>
											</td>
										</tr>
									<tr>
										<th scope="row">사진</th>
										<td style="border-right-style: none;" colspan="3">
									<!-- 사진미리보기  -->
												<c:if test="${not empty bizItem.imageList}">
												<c:forEach items="${bizItem.imageList}" var="list"  >
												<div id="image${list.fileSeq}">
													<a href="#" onclick="preview(${list.fileSeq})">${list.fileSrcNm} </a>
													<button type="button" id="deleteImage" onclick="removeData(${list.fileSeq})"  style="height: 30px; border-color: black; ">삭제</button>
												</div>
												</c:forEach>
											</c:if>
									<!-- //사진미리보기  -->
										
											<!-- file box -->
											<div class='fileBox'  id="imageBox1">
												<input type='button' class='filebutton' value='첨부'/> 
												<input type='file' class='fileupload' name='imageFile' onchange='$(this).next().val($(this).val());'style="width: 550px"/> 
												<input type='text' class='textbox' readonly='readonly'/> 
											</div> 
											<div class='fileBox'  id="imageBox2">
												<input type='button' class='filebutton' value='첨부'/> 
												<input type='file' class='fileupload' name='imageFile' onchange='$(this).next().val($(this).val());' style="width: 550px"/> 
												<input type='text' class='textbox' readonly='readonly'/> 
											</div> 
											
											<!-- //file box -->
											<p class="upload">
												<span class="red2">※ gif, jpg, jpeg, png형식의 이미지 파일만 첨부 가능합니다.</span>
												<span class="red2">※ 2개의 파일을 첨부할 수 있습니다.(파일 용량제한: 2MB)</span>
											</p>
										</td>
									</tr>
									<tr>
										<th scope="row">첨부파일</th>
										<td style="border-right-style: none;" colspan="3">
												<!-- 파일이름  -->
												<c:if test="${not empty bizItem.attachList}">
												<c:forEach items="${bizItem.attachList}" var="list" varStatus="s" >
												<div id="attachFileId">
													<a href="/file-download/${list.fileSeq}"><c:out value="${list.fileSrcNm}"/></a>
													<button type="button" id='deleteAttach' onclick="attachFileBox(state,${list.fileSeq})" style="height: 30px; border-color: black;">삭제</button>
												</div>
												</c:forEach>
											</c:if>
									<!-- //파일이름 -->
											<!-- file box -->
											<div class='fileBox' id = "attachBox">
												<input type='button' class='filebutton' value='첨부'/> 
												<input type='file' class='fileupload' name='attachFile' onchange='$(this).next().val($(this).val());'/> 
												<input type='text' class='textbox' readonly='readonly'/> 
											</div> 
											<!-- //file box -->
											
											<p class="upload">
												<span class="red2">※ hwp,pdf 파일만 등록이 가능합니다.</span>
											</p>
										</td>
									</tr>
										<tr>
											<th scope="row">사업개요</th>
											<td>
												<div class="writeW">
													<textarea name="summary" id="summary" cols="10" rows="10" title="내용 입력" class="wid100_hei50" maxlength = "2000" ><c:out value="${bizItem.summary}"/></textarea>
												</div>
												<span class="red2">최대 2000자까지 입력가능</span>
											</td>
										</tr>
										<tr>
											<th scope="row">추진계획</th>
											<td>
												<div class="writeW">
													<textarea name="plan" id="plan" cols="10" rows="10" title="내용 입력" class="wid100" maxlength = "2000"><c:out value="${bizItem.plan}"/><c:out value="${bizItem.plan}"/></textarea>
												</div>
												<span class="red2">최대 2000자까지 입력가능</span>
											</td>
										</tr>
										<tr>
											<th scope="row">추진실적</th>
											<td>
												<div class="writeW">
													<textarea name="result" id="result" cols="10" rows="10" title="내용 입력" class="wid100_hei50" maxlength = "2000"><c:out value="${bizItem.result}"/></textarea>
												</div>
												<span class="red2">최대 2000자까지 입력가능</span>
											</td>
										</tr>
										<tr>
											<th scope="row">향후일정</th>
											<td>
												<div class="writeW">
													<textarea maxlength = "2000" name="schedule" id="schedule" cols="10" rows="10" title="내용 입력" class="wid100_hei50" ><c:out value="${bizItem.schedule}"></c:out> </textarea>
												</div>
												<span class="red2">최대 2000자까지 입력가능</span>
											</td>
										</tr>
										<tr>
											<th scope="row">추진부서</th>
											<td><input type="text" class="it wid141" title="" value="${bizItem.dept}" name="dept" id="dept" /></td>
										</tr>
									</tbody>
								</table>
							</div>
							<input type="hidden" id="biz_seq" name="biz_seq" value="${bizItem.biz_seq}" />
							</form>
						<div class="btnbox_BL3">
							<a href="/admin/biz/biz_list" class="btn_blue">목록보기</a>
					 <a href="#" class="btn_reset" onclick="writeProc(); return false;">수정하기</a>
						</div>
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
