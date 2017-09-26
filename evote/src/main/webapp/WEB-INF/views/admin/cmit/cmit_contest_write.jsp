<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page contentType="text/html; charset=utf-8" %>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>
<!-- meta -->
<jsp:include page="/WEB-INF/views/admin/common/meta.jsp"/>
<!-- //meta -->
<link href="${siteCssPath}/eh.css" type="text/css" rel="stylesheet"  />
<script language="javascript" type="text/javascript">
//<![CDATA[
			$(document).ready(function() {
           		gfnSetPeriodDatePicker("startDate", "endDate");
           		setSelectTime()
			});
			
			/* 24시간으로 시간 셀렉트박스 생성 */			
			function setSelectTime(){
				var tmp = "";
				for(var i = 0; i<24; i++){
					if(i < 10){
						i = "0"+i;
					}
					tmp +="<option value =" +i+" >"+i+"시</option>";
					$("#startTime").html(tmp);
					$("#endTime").html(tmp);
				}
			}
			/*//24시간으로 시간 셀렉트박스 생성 */
			
	 /*주민참여위원회 저장하기 */
 	function writeProc() {
 		

 		if($("#startDate").val() == "" ||$("#startTime").val() == ""||$("#endDate").val() == ""||$("#endTime").val() == ""||$("#title").val()=="") {
 			alert("<spring:message code='message.common.header.002' arguments='내용을 빠짐없이 입력해주세요'/>");
 			return;
 		}
 		if($("#attachVal").val()==""){
 			alert("첨부파일은 필수입니다")
 			return;
 		}
 		
 		if($("#startDate").val() == $("#endDate").val()){
 			
 			if($("#startTime").val() == $("#endTime").val() || $("#startTime").val() >$("#endTime").val() ){
				alert("종료시간을 확인해주세요");
				return;
 			}
 		}
 		
 		var fiileSizeCheck = true;
 	    
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
 		$("#cmitContestForm").attr("action", "/admin/cmit/cmit_contest_write");
 		$("#cmitContestForm").attr("method", "POST");
 		$("#cmitContestForm").submit();
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
				<li>주민참여위원 공모</li>
			</ul>
		</div>

		<div class="container">
			<div class="contentWrap">
				<!--leftmenu-->
					<jsp:include page="/WEB-INF/views/admin/common/lnb.jsp"/>
				<!--//leftmenu-->
				
				<div class="content">
					<h3 class="contentTit">주민참여위원 공모</h3>
					
					
					<div class="mainContent">	
						<form method="post" class="searchTb" id="cmitContestForm" name="cmitContestForm"  enctype="multipart/form-data">
							<fieldset id="" class="">
								<p class="pTit2">위원공모 등록</p>
								<table cellpadding="0" cellspacing="0" summary="" class="comitteeTable2">
									<caption>위원공모 등록</caption>
									<colgroup>
										<col width="105"/><col width="*"/>
										<col width="105"/><col width="151"/>
									</colgroup>
									<tbody>
										<tr>
											<th scope="row" class="bln">제목</th>
											<td><label><input type="text" class="it wid461"  id="title" name="title"/></label></td>
										</tr>
										<tr>
											<th scope="row" class="bln">모집기간</th>
											<td colspan="3">
												<label for="startDate" class="hidden">시작기간 입력하기</label><input type="text" class="it wid131" title="" value="" name="startDate" id="startDate" readonly="readonly"/><input type="image" src="${siteImgPath}/common/icon_cal.gif" alt="시작기간 선택" onclick="$('#startDate').focus(); return false;"/> 
													<select title="시작시간" id="startTime"  name="startTime"  style="width:65px;">
													<option value="" selected="selected"></option>
												</select>
												~
												<label for="endDate" class="hidden">종료기간 입력하기</label><input type="text" class="it wid131" title="" value="" name="endDate" id="endDate" readonly="readonly" /><input type="image" src="${siteImgPath}/common/icon_cal.gif" alt="종료기간 선택" onclick="$('#endDate').focus(); return false;"/>
												
												<select title="마감시간" id="endTime"  name="endTime" style="width:65px;" onclick="timeCheck()">
													<option value="" selected="selected"></option>
												</select>
											</td>
											
										</tr>
										<tr>
											<th scope="row" class="bln">신청서 양식</th>
											<td colspan="3">
												<div class="fileBox">
												   <input type="button" class="filebutton" value="첨부" name="" id=""/>
												   <input type="file" class="fileupload" id="attachFile"  name="attachFile" onchange="$(this).next().val($(this).val());"/>
												   <input type="text" class="textbox" readonly="readonly" id="attachVal"  name="attachVal"/>
												</div>

												<p class="upload" style="padding-top: 8px">
													<span class="red2" >※ 신청서 양식은 한글파일(hwp)만 첨부할 수 있습니다</span>
												</p>
											</td>
										</tr>
									</tbody>
								</table>
								<div class="btnbox_GL">
									<a href="#" class="btn_reset">목록</a>
									<a href="#" class="btn_gray" onclick="writeProc()">저장</a>
								</div>
							</fieldset>
						</form>
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
