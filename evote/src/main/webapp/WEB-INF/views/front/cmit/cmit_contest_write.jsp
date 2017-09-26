<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page contentType="text/html; charset=utf-8" %>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>

<!-- meta -->
<jsp:include page="/WEB-INF/views/front/common/meta.jsp"/>
<!-- //meta -->

<style type="text/css">
/*파일*/
.addFile{padding:5px 0;}
.fileBox{	position: relative;  display: inline-block;}

.filebutton{background:url(${siteImgPath}/common/icon_up_off.png) 60px 50% no-repeat #343434; font-size:14px; color:#fff;
	width: 92px;  height: 36px;	border:none;   padding-right:20px; }
.fileupload{	font-size:20px; position:absolute; right:0px;	top:0px; width:380px; height:36px; opacity:0;	 .filter:alpha(opacity=0);-ms-filter:"alpha(opacity=0)";	-moz-opacity:0;}

.textbox{width:300px; height:31px;}
.fileLabel{display:none;}

.fileAdd{border:1px solid #A9A9A9; padding:7px 15px; font-weight:bold;}
</style>

<script language="javascript" type="text/javascript">
//<![CDATA[
	$(document).ready(function(){
		$('.gnb').topmenu({ d1: 2, d2: 3});
 		
		$("#btnImageFile").evoteFile({
 			maxFileCount : 1
 		});
	
 		$("#btnAttachFile").evoteFile({
 			maxFileCount : 1
 		});

 		var birthDateTmp = '${formInfo.memInfo.birthDate}';
		var birthMonth = birthDateTmp.substring(0,2);
		var birthDay = birthDateTmp.substring(2,4);
		var birthDate= '${formInfo.memInfo.birthYear}' + '.' + birthMonth +'.' + birthDay+'.' ;
		$("#birth").text(birthDate);
	});
/* 분과선택하기  */
		function selectCmit1(){
		
			if($("#subCmit1").val() == 'C01'){
				$("#subCmit2").text('');
				var list = new Array(); 
				var cmitStr = '';
				'<c:forEach var="item" items="${formInfo.subCmit2}" >'
					cmitStr +='<option value="'+"${item.cdId}"+'">'+"${item.cdNm}"+'</option>'
				'</c:forEach>'
				$("#subCmit2").append(cmitStr);
				}else{
					$("#subCmit2").text('');
					var cmitStr = '<option value="">분과선택없음</option>'
					$("#subCmit2").append(cmitStr);	
				}
					
		}
/*//분과선택하기  */
	
	/* 취소하기 */
	function cancel(){
		if(confirm("입력된 항목이 저장되지 않습니다. 계속하시곘습니까?")){
			history.back();
		}
	}
	/*// 취소하기 */
	
	/* 공모 신청서작성 */
 	function wrtieForm() {
		
		if( !$("#ck_terms").hasClass("on") ) {
			// 필수 항목에 동의해야 진행할 수 있습니다
			alert('<spring:message code="message.member.join.001" />');
			$("#ck_terms").focus();
			return;
		}
		
 		if($("#phone").val() == "") {
 			alert("<spring:message code='message.common.header.002' arguments='연락처를'/>");
 			$("#phone").focus();
 			return;
 		}

 		if($("#addr2").val() == "") {
 			alert("<spring:message code='message.common.header.002' arguments='주소를'/>");
 			$("#addr2").focus();
 			return;
 		}
 		
 		if($("#job").val() == "") {
 			alert("<spring:message code='message.common.header.002' arguments='직업을'/>");
 			$("#job").focus();
 			return;
 		}
 		
 		if($("#subCmit1").val() == "") {
 			alert("<spring:message code='message.common.header.002' arguments='위원회를'/>");
 			$("#subCmit1").focus();
 			return;
 		}
 		
 		if($("#subCmit1").val() == "C01" && $("#subCmit2").val()=="") {
 			alert("<spring:message code='message.common.header.002' arguments='분과를'/>");
 			$("#subCmit2").focus();
 			return;
 		}
 		
 		if($("#intro").val()=="") {
 			alert("<spring:message code='message.common.header.002' arguments='자기소개를'/>");
 			$("#intro").focus();
 			return;
 		}
 		
 		
 		var regNumber = /^[0-9]*$/;
 		if(!regNumber.test($("#phone").val())) {
 		    alert('연락처는 숫자만 입력해주세요.');
 		    return;
 		}
 		
 		if($("#attachVal").val()=="" ){
 			alert("첨부파일은 필수입니다")
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
  		$("#cmitContestForm").attr("action", "/cmit/cmit_contest_write");
  		$("#cmitContestForm").attr("method", "POST");
  		$("#cmitContestForm").submit();
 	}
	/*//공모 신청서작성 */

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
		<span>주민참여위원회</span>
		<span>주민참여위원공모</span>
	</p>
</div>

<div id="container" class="container">
	<div class="containerWrap">
		<!-- LNB -->
		<jsp:include page="/WEB-INF/views/front/common/lnb.jsp">
			<jsp:param name="menuName" value="cmit"/>
		</jsp:include>
		<!-- //LNB -->
		<div class="contentsWrap">
			<h3 class="contentTit">주민참여위원신청하기</h3>
			<div class="contents">
			
				<div class="step1">
					<p class="tit" style="padding: 30px 0 0 0;">은평구 개인정보수집ㆍ이용 동의서</p>
					<ul style="height: 210px;">
						<li style="font-size: 16px; font-weight: bold; line-height: 22px;">
							- 개인정보의 수집, 이용 목적 : 주민참여위원회 위원 선정 및 위원회 운영관련 사항<br/>
							- 개인정보 수집항목 : 성명, 생년월일, 성별, 주소, 연락처(자택,직장,휴대폰), 이메일<br/>
							- 개인정보 보유 및 이용기간 : 위원 모집 ~ 해촉시까지<br/>
							- 동의 거부 권리안내 : 신청자는 본 개인정보 수집, 이용에 대한 동의를 거부할 수 있으며<br/>&nbsp;&nbsp; 이 경우 주민참여위원회 위원 신청이 제한됩니다.<br/>
							- 개인정보 수집 담당자 : 은평구청 희망마을담당관 (☎ : 351-6473~5)<br/><br/>
							<a href="#;" class="chk" id="ck_terms">개인정보수집ㆍ이용 동의서에 동의합니다<span>(필수)</span></a>
						</li>
					</ul>

					<script language="javascript" type="text/javascript">
					//<![CDATA[
						$('#ck_terms').on('click',function(){
							if ($(this).hasClass('on')){
								$(this).removeClass('on');
							}else{
								$(this).addClass('on');
							}
						}); 
					//]]>
					</script>

				</div>
				
				<p class="pTit2" style="font-size:22px; padding:0 0 20px;">신청인 정보 입력</p>
				<form method="post" id="cmitContestForm" name="cmitContestForm"  enctype="multipart/form-data">
					<div class="boardWrite">
						<table cellpadding="0" cellspacing="0" class="tbL" summary="구분, 사업며으 소요사업비, 사업기간, 사업위치, 제안 취지, 내용, 기대효과, 비밀번호, 사진, 신청서 등록을 입력하는 폼입니다." >
							<caption>신청인 정보 입력하기</caption>
							<colgroup>
										<col width="15%"/>
										<col width="*"/>
										<col width="15%"/>
										<col width="*"/>
							</colgroup>
							<tbody>
								<tr>
									<th>신청인</th>
									<td><c:out value="${formInfo.memInfo.userNm.decValue}"/></td>
									<th>휴대폰번호</th>
									<td><c:out value="${formInfo.memInfo.phone.decValue}"/></td>
								</tr>
								<tr>
									<th>이메일</th>
									<td><c:out value="${formInfo.memInfo.email.decValue}"/></td>
									<th>연락처</th>
									<td><input id="phone" name="phone"  type="text" style="height: 20px;width: 150px;"/></td>
								</tr>
								<tr>
									<th>주소</th>
									<td colspan="3">
										
										<select name="addr1" id="addr1" class="wid100">
											<c:forEach var="list" items="${emdList}">
												<option value="<c:out value="${list.emdNm}"/>"><c:out value="${list.emdNm}"/></option>
											</c:forEach>
										</select>
										
										<%-- <input type="text" name="addr1" id="addr1" readonly="readonly" style="width:80px; height:30px;" value="${formInfo.memInfo.emdNm}"/> --%>
										
										<input type="text" name="addr2" id="addr2" style="width:300px; height:30px;"/>
									</td>
								</tr>
								<tr>
									<th>생년월일</th>
									<td id="birth">
									</td>
									<th>직업</th>
									<td>
										<input type="text" name="job" id="job" style="width:160px; height:30px;"/>
									</td>
								</tr>
								<tr>
									<th>성별</th>
									<td colspan="3">
									<c:if test="${formInfo.memInfo.gender eq 'M'}">
										남자
									</c:if>
									<c:if test="${formInfo.memInfo.gender eq 'F'}">
										여자
									</c:if>
										
									</td>
								</tr>
								<tr>
									<th scope="row">희망분과</th>
									<td colspan="3">
										<select  id="subCmit1" name="subCmit1" title="분과선택" class="wid100" onchange="selectCmit1()">
											<option value="" selected="selected">위원회 선택</option>
											<c:forEach var="item" items="${formInfo.subCmit1}"  end="3">
												<option value="${item.cdId}" >${item.cdNm}</option>
											</c:forEach>
										</select>
										<select  id="subCmit2" name="subCmit2" title="분과선택" class="wid100">
											<option value="" selected="selected">분과 선택</option>
										</select>
									</td>
								</tr>
								<tr>
									<th scope="row">자기소개서</th>
									<td colspan="3">
										<div class="writeW">
											<textarea name="intro" id="intro" cols="10" rows="10" title="제안취지 입력" style="width:570px;"></textarea>
										</div>
									</td>
								</tr>
	<%-- 
								<tr>
									<th scope="row">첨부파일</th>
									<td colspan="3">
										<div class="addFile">
											<div class="fileBox">
											   <input type="button" class="filebutton" value="첨부" name="" id=""/>
											   <input type="file" class="fileupload" name="attachFile" onchange="$(this).next().val($(this).val());"/>
											   <input type="text" class="textbox" readonly="readonly"/>
											</div>
											<button id="btnAttachFile" class="fileAdd">추가</button>
										</div>
										<p class="upload">
											<span class="red2">
												※ gif, jpg, jpeg, png형식의 이미지 파일과 한글파일(hwp)만 등록할 수 있습니다<br/>
												※ 3개 이하의 파일을 첨부할 수 있습니다(파일용량 제한:2MB)
											</span>
										</p>
									</td>
								</tr>
	--%>
	
								<tr>
									<th scope="row">신청서 등록</th>
									<td style="border-right-style: none;" colspan="3">
										<div class='fileBox'>
											<input type='button' class='filebutton' value='첨부'/> 
											<input type='file' class='fileupload' name='attachFile' onchange='$(this).next().val($(this).val());'/> 
											<input type='text' class='textbox' readonly='readonly'  id="attachVal" /> 
										</div> 
										<button id="btnAttachFile" class="fileAdd">추가</button>
										<p class="upload">
											<span class="red2">※ hwp 파일만 등록이 가능합니다 (용량제한 : 2MB).</span>
										</p>
									</td>
								</tr>
								<tr>
									<th scope="row">사진</th>
									<td style="border-right-style: none;" colspan="3">
										<div class='fileBox'>
											<input type='button' class='filebutton' value='첨부'/> 
											<input type='file' class='fileupload' name='imageFile' onchange='$(this).next().val($(this).val());'/> 
											<input type='text' class='textbox' readonly='readonly'/> 
										</div> 
										<button id="btnImageFile" class="fileAdd">추가</button>
										<p class="upload">
											<span class="red2">※ gif, jpg, jpeg, png형식의 이미지 파일만 첨부 가능합니다 (용량제한 : 2MB).</span>
										</p>
									</td>
								</tr>
							</tbody>
						</table>
					</div>
					<input type="hidden" value="${formInfo.ps_seq}" name="ps_seq"  id="ps_seq"/>
				</form>
				
				<div class="btnR">
					<a href="#" class="btn_blue" onclick="wrtieForm(); return false;">등록</a>
					<a href="#" class="btn_reset" onclick="cancel()">취소 </a>
				</div>
			</div>
		</div>
	</div>
</div>


<!-- footer -->
<jsp:include page="/WEB-INF/views/front/common/footer.jsp"/>
<!-- //footer -->

</body>
</html>
