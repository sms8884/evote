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
        /* 날짜를 비교할데이터 생성  */
		        var tmpDay= new Date();
		       	var startDate = 	'<fmt:formatDate pattern="yyyy-MM-dd hh" value="${cmitItem.start_date}"/>';
		       	var endDate = 	'<fmt:formatDate pattern="yyyy-MM-dd hh" value="${cmitItem.end_date}"/>';
		       	var today = tmpDay.getFullYear() + '-';
		       	
		       	today+= (tmpDay.getMonth()+1) >= 10 ?  (tmpDay.getMonth()+1)+'-' : '0'+(tmpDay.getMonth()+1)+'-';
		       	today+= tmpDay.getDate() >= 10 ?  tmpDay.getDate()+' ' : '0'+tmpDay.getDate()+' ';
		       	today+= tmpDay.getHours() >= 10 ?  tmpDay.getHours() : '0'+tmpDay.getHours();
        /*//날짜를 비교할데이터 생성  */
           
	           	$(document).ready(function() {
	           		gfnSetPeriodDatePicker("startDate", "endDate");
	           		setDate();
	           		setSelectTime();
	           		dateCheck();
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
		/* 기존시간 설정  */
						var startTime1 = 	'<fmt:formatDate pattern="HH" value="${cmitItem.start_date}"/>';
						var endTime1 = 	'<fmt:formatDate pattern="HH" value="${cmitItem.end_date}"/>';
						$("#startTime > option[value="+startTime1+"]").attr("selected", "true");
						$("#endTime > option[value="+endTime1+"]").attr("selected", "true");
			/*// 기존시간 설정  */
			}
        	
        /* 기존 날짜 설정 */
	        	function setDate(){
	        		var startDate1 = 	'<fmt:formatDate pattern="yyyy-MM-dd" value="${cmitItem.start_date}"/>';
	    			var endDate1 = 	'<fmt:formatDate pattern="yyyy-MM-dd" value="${cmitItem.end_date}"/>';
	    			$("#startDate").val(startDate1);
	    			$("#endDate").val(endDate1);
	        	}
        /*//기존 날짜 설정 */
        
        /* 첨부파일 삭제 */	
		        function removeAttach(psSeq){
		        	
		               	if(today >= startDate && today <= endDate){
		               		alert("진행중인 공모에서는 첨부파일을 삭제할수없습니다");
		               		return ;
		               	}
		               	
		        		if(confirm("파일을 삭제하시겠습니까?")){
		        	 		$.ajax({
		        	 			url:"/admin/cmit/cmitFileInfo_delete/" + psSeq
		        	 			,type:'POST'
		        	 			,dataType:"json"
		        	 			,success: function(data){
		        	 				if(data==true){
		        	 	 			location.reload(true);
		        	 				}
		        	 			}
		        	 			 , error: function(xhr, status, error) {
		        	 				 alert();
		        	 	        	if (console && console.log) console.log("error : " + error.message);
		        	 	        }
		        	 		});
		        			}
		        	}
        /*//첨부파일 삭제 */	
        
        /*주민참여위원회 수정하기 */
				 	function modifyProc() {
				 		
		
				 		if($("#startDate").val() == "" ||$("#startTime").val() == ""||$("#endDate").val() == ""||$("#endTime").val() == ""||$("#title").val()=="") {
				 			alert("<spring:message code='message.common.header.002' arguments='내용을 빠짐없이 입력해주세요'/>");
				 			return;
				 		}
				 		if($("#attachVal").val()=="" && $("#fileBox").css("display") == "block" ){
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
				 		$("#cmitContestForm").attr("action", "/admin/cmit/cmit_contest_modify");
				 		$("#cmitContestForm").attr("method", "POST");
				 		$("#cmitContestForm").submit();
				 	}
        /*//주민참여위원회 수정하기 */
		        
        
     /*오늘날짜기준 진행중인지 체크  */   
	        function dateCheck(){
	       	if(today >= startDate && today <= endDate){
		         	$("#startDate").datepicker('disable');
		         	$("#endDate").datepicker('disable');
		         	$("#startTime").attr('disabled',true);
		         	$("#endTime").attr('disabled',true);
		         	$("#save").css("display","none");
		         	$("#stop").css("display","inline-block");
				}
	        }
     /* //오늘날짜기준 진행중인지 체크  */   
        
	        function stopContest(psSeq){
	           	
	    	 if(confirm("공모를 강제종료 하시겠습니까?")){
	    	 		$.ajax({
	    	 			url:"/admin/cmit/cmit_contest_stop/" + psSeq
	    	 			,type:'POST'
	    	 			,dataType:"json"	
	    	 			,success: function(data){
	    	 				if(data === true){
	    	 					window.location.reload(true)
	    	 				}
	    	 			}
	    	 			 , error: function(xhr, status, error) {
	    	 				 alert("실패하였습니다");
	    	 	        	if (console && console.log) console.log("error : " + error.message);
	    	 	        }
	    	 		});
	    			}
	        }
	/* 공모삭제 */		
			  function removeCmitContest(psSeq){
			     	if(today >= startDate && today <= endDate){
			     		alert("진행중인 공모는 삭제할 수 없습니다 공모 삭제를 원하시면 \n강제종료후 삭제해주세요");
			     		return ;
			     	}
				
			     	if(confirm("공모를 삭제 하시겠습니까?")){
					$.ajax({
						url:"/admin/cmit/cmit_contest_remove/" + psSeq
						,type:'POST'
						,dataType:"json"
						,success: function(data){
							if(data === true){
							location.href="/admin/cmit/cmit_contest_list"
							}
						}
						 , error: function(xhr, status, error) {
							 alert("실패하였습니다");
				        	if (console && console.log) console.log("error : " + error.message);
				        }
					});
				}
			  }
	/*//공모삭제 */		
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
								<p class="pTit2">위원공모 수정</p>
								<table cellpadding="0" cellspacing="0" summary="" class="comitteeTable2">
									<caption>위원공모 등록</caption>
									<colgroup>
										<col width="105"/><col width="*"/>
										<col width="105"/><col width="151"/>
									</colgroup>
									<tbody>
										<tr>
											<th scope="row" class="bln">제목</th>
											<td><label><input type="text" class="it wid461" id="title" value="${cmitItem.title}" name="title" /></label></td>
										</tr>
											<tr>
											<th scope="row" class="bln">모집기간</th>
											<td colspan="3">
												<label for="startDate" class="hidden">시작기간 입력하기</label><input type="text" class="it wid131" title="" value="" name="startDate" id="startDate" readonly="readonly" onclick="test()"/><input type="image" src="${siteImgPath}/common/icon_cal.gif" alt="시작기간 선택" onclick="$('#startDate').focus(); return false;"/> 
													<select title="시작시간" id="startTime"  name="startTime"  style="width:65px;">
													<option value="" selected="selected" ></option>
												</select>
												~
												<label for="endDate" class="hidden">종료기간 입력하기</label><input type="text" class="it wid131" title="" value="" name="endDate" id="endDate" readonly="readonly" /><input type="image" src="${siteImgPath}/common/icon_cal.gif" alt="종료기간 선택" onclick="$('#endDate').focus(); return false;"/>
												
												<select title="마감시간" id="endTime"  name="endTime" style="width:65px;" onclick="timeCheck()">
													<option value="" selected="selected"></option>
												</select>
											</td>
											
										</tr>
										<tr>
											<th scope="row" class="bln">신청서양식</th>
												<c:if test="${not empty cmitItem.attachList}">
										<c:forEach items = "${cmitItem.attachList}" var="list">
											<td colspan="5"><a href="/file-download/${list.fileSeq}"><c:out value="${list.fileSrcNm}"/></a><a href="#" class="btn_cm" onclick="removeAttach(${cmitItem.ps_seq})" >삭제</a></td>
										</c:forEach>
										</c:if>
										<c:if test="${empty cmitItem.attachList}">
											<td>
												<!-- file box -->
											<div class='fileBox'   id="fileBox">
												<input type='button' class='filebutton' value='첨부'/> 
												<input type='file' style="width: 600px" class='fileupload' id="attachFile" name='attachFile' onchange='$(this).next().val($(this).val());'/> 
												<input type='text' class='textbox' readonly='readonly'  id="attachVal"  name="attachVal"/> 
											</div> 
											<!-- //file box -->
												<span class="red3">※ 신청서 양식은 한글파일(hwp)만 첨부할 수 있습니다</span>
											</td>
										</c:if>
										
										
										</tr>
									</tbody>
								</table>
								<div class="cmBtnBox">
									<a href="#" onclick="removeCmitContest(${cmitItem.ps_seq})" class="btn_gray" >삭제</a>
									<div class="flR">
										<a href="#" onclick="modifyProc()" class="btn_blue" id="save">저장</a>
										<a href="#" onclick="stopContest(${cmitItem.ps_seq})" class="btn_blue"  id="stop" style="display: none;">강제종료</a>
										<a href="/admin/cmit/cmit_contest_list" class="btn_reset">목록</a>
									</div>
								</div>
								
							</fieldset>
							<input type="hidden" id="ps_seq" name="ps_seq" value="${cmitItem.ps_seq}" />
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
