<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

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
		$('.gnb').topmenu({ d1: 1, d2: 3, d3:1});
		
		gfnSetPeriodDatePicker("startDate", "endDate");
	});
	
	function fnList() {
		$("#_tempFrm").attr("action", "/proposal/list");
		$("#_tempFrm").attr("method", "POST");
		$("#_tempFrm").submit();
	}
	
	function fnSave(){
		
		<c:if test="${userType eq 'PROPOSAL'}">
			if(gfnValidation($("#reqNm"),"<spring:message code='message.common.header.002' arguments='신청인을'/>") == false){
		        return;
		    }
		    if(gfnValidation($("#reqAddr"),"<spring:message code='message.common.header.003' arguments='주소를'/>") == false){
		        return;
		    }
		    if(gfnValidation($("#reqEmail"),"<spring:message code='message.common.header.002' arguments='이메일을'/>") == false){
		        return;
		    }
		    if(gfnEmailCheck($("#reqEmail").val()) == false){
		    	// 잘못된 이메일 주소입니다. 이메일 주소를 확인한 다음 다시 입력해주세요.
		        alert("<spring:message code='message.member.join.007'/>");
		        $("#reqEmail").focus();
		        return;
		    }
		</c:if>
		
		if($("input[name=realmCd]:checked").length == 0){
			alert("<spring:message code='message.common.header.003' arguments='구분을'/>");
			return;
		}
		
		if(gfnValidation($("#bizNm"),"<spring:message code='message.common.header.002' arguments='사업명을'/>") == false){
	        return;
	    }
		if(gfnValidation($("#budget"),"<spring:message code='message.common.header.002' arguments='사업비를'/>") == false){
	        return;
	    }
		if(gfnValidation($("#startDate"),"<spring:message code='message.common.header.003' arguments='사업기간 시작일을'/>") == false){
	        return;
	    }
		if(gfnValidation($("#endDate"),"<spring:message code='message.common.header.003' arguments='사업기간 종료일을'/>") == false){
	        return;
	    }
		if(gfnValidation($("#location"),"<spring:message code='message.common.header.002' arguments='사업위치를'/>") == false){
	        return;
	    }
		if(gfnValidation($("#necessity"),"<spring:message code='message.common.header.002' arguments='제안취지를'/>") == false){
	        return;
	    }
		if(gfnValidation($("#bizCont"),"<spring:message code='message.common.header.002' arguments='내용을'/>") == false){
	        return;
	    }
		if(gfnValidation($("#effect"),"<spring:message code='message.common.header.002' arguments='기대효과를'/>") == false){
	        return;
	    }
		
		<c:if test="${userType eq 'PROPOSAL'}">
		if(gfnValidation($("#reqPw"),"<spring:message code='message.common.header.002' arguments='비밀번호를'/>") == false){
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
	    
	    if(confirm("저장하시겠습니까?")){
	    	$("#dataFrm").prop("action", "<c:url value="/proposal/save" />").submit();    	
	    }
		
	}
	
	$(function() {
		$("#imageBtnPlus").evoteFile({
			maxFileCount : 3
		});
		$("#attachBtnPlus").evoteFile({
			maxFileCount : 3
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
		<span>내 정책 제안하기</span>
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
			<h3 class="contentTit">정책제안 등록하기</h3>

			<div class="contents">
				<p class="pTit2">신청인 정보 입력</p>
				<form name="dataFrm" id="dataFrm" method="post" enctype="multipart/form-data">
					<fieldset id="" class="">
						<legend>정책제안 등록폼</legend>
						<div class="boardWrite">
							<table cellpadding="0" cellspacing="0" class="tbL" summary="신청인 이름, 연락처, 주소, 이메일을 입력하는 폼입니다." >
								<caption>신청인 정보 입력하기</caption>
								<colgroup>
									<col width="15%"/>
									<col width="35%"/>
									<col width="15%"/>
									<col width="35%"/>
								</colgroup>
								<tbody>
								
									<c:choose>
										<c:when test="${_accountInfo.hasRole('USER')}">
											<tr>
												<th scope="row">신청인</th>
												<td><c:out value="${userInfo.userNm.decValue}" /></td>
												<th scope="row">연락처</th>
												<td><c:out value="${userInfo.phone.decValue}"/></td>
											</tr>
											<tr>
												<th scope="row">주소</th>
												<td><c:out value="${userInfo.emdNm}"/></td>
												<th scope="row">이메일</th>
												<td><c:out value="${userInfo.email.decValue}" /></td>
											</tr>
										</c:when>
<%-- 										
										<c:when test="${userType eq 'PHONE'}">
											<tr>
												<th scope="row">신청인</th>
												<td><input type="text" class="it " name="reqNm" id="reqNm" /></td>
												<th scope="row">연락처</th>
												<td><c:out value="${userInfo.phone.decValue}"/></td>
											</tr>
											<tr>
												<th scope="row">주소</th>
												<td><c:out value="${userInfo.emdNm}"/></td>
												<th scope="row">이메일</th>
												<td><input type="text" class="it wid248" name="reqEmail" id="reqEmail" /></td>
											</tr>
										</c:when>
--%>										
										<c:otherwise>
											<tr>
												<th scope="row">신청인</th>
												<td><input type="text" class="it " name="reqNm" id="reqNm" /></td>
												<th scope="row">연락처</th>
												<td>${userInfo.phone.decValue}</td>
											</tr>
											<tr>
												<th scope="row">주소</th>
												<td>
						                            <select name="reqAddr" id="reqAddr" title="주소 선택하기" class="wid100">
						                                <c:forEach items="${emdList}" var="item">
						                                    <option value="${item.regionCd}">${item.emdNm}</option>
						                                </c:forEach>
						                            </select>
												</td>
												<th scope="row">이메일</th>
												<td><input type="text" class="it wid248" name="reqEmail" id="reqEmail" /></td>
											</tr>
										</c:otherwise>
									</c:choose>

									
									
								</tbody>
							</table>
						</div>
					</fieldset> 
					
					<p class="pTit2">사업 정보 입력</p>
					<div class="boardWrite">
						<table cellpadding="0" cellspacing="0" class="tbL" summary="구분, 사업며으 소요사업비, 사업기간, 사업위치, 제안 취지, 내용, 기대효과, 비밀번호, 사진, 신청서 등록을 입력하는 폼입니다." >
							<caption>신청인 정보 입력하기</caption>
							<colgroup>
								<col width="15%"/>
								<col width="*"/>
							</colgroup>
							<tbody>
							
								<c:forEach items="${realmList}" var="item" varStatus="status">
								<tr>
									<c:if test="${status.first}">
									<th scope="row" rowspan="${fn:length(realmList)}">구분</th>
									</c:if>
									<td>
										<input type="radio" class="" title="" value="${item.realmCd}" name="realmCd" id="select_${status.index}"/>
										<label for="select_${status.index}"><c:out value="${item.realmNm}"/></label>
									</td>
								</tr>
								</c:forEach>
							
								<tr>
									<th scope="row"><label for="title">공모선택</label></th>
									<td>
										<select name="psSeq" class="wid100">
											<option value="">상시공모</option>
											<c:if test="${not empty pssrp}">
											<option value="${pssrp.psSeq}"><c:out value="${pssrp.title}"/></option>
											</c:if>
										</select>
									</td>
								</tr>
								
								<tr>
									<th scope="row"><label for="title">사업명</label></th>
									<td>
										<input type="text" class="it wid498" name="bizNm" id="bizNm" maxlength="50" />
										<span class="red">50자 입력제한</span>
									</td>
								</tr>
								<tr>
									<th scope="row"><label for="expen">소요사업비</label></th>
									<td><input type="text" class="it wid248" name="budget" id="budget"/></td>
								</tr>
								<tr>
									<th scope="row">사업기간</th>
									<td>
										<label for="startT" class="hidden">시작날짜입력</label><input type="text" class="it " title="" name="startDate" id="startDate" readonly="readonly"/><input type="image" alt="시작날짜선택" src="${siteImgPath}/common/icon_cal.gif" onclick="$('#startDate').focus(); return false;"/>
										<span> ~ </span>
										<label for="endT" class="hidden">끝나는날짜입력</label><input type="text" class="it " title="" name="endDate" id="endDate" readonly="readonly"/><input type="image" alt="끝나는날짜선택" src="${siteImgPath}/common/icon_cal.gif" onclick="$('#endDate').focus(); return false;"/>
									</td>
								</tr>
								<tr>
									<th scope="row"><label for="loca">사업위치</label></th>
									<td><input type="text" class="it wid498" name="location" id="location" maxlength="50"/>
									<span class="red">50자 입력제한</span></td>
								</tr>
								<tr>
									<th scope="row">제안취지</th>
									<td>
										<div class="writeW">
											<textarea name="necessity" id="necessity" cols="10" rows="10" title="제안취지 입력" style="width:570px;"></textarea>
										</div>
									<span class="red2">최대 2000자까지 입력가능</span></td>
								</tr>
								<tr>
									<th scope="row">내용</th>
									<td>
										<div class="writeW">
											<textarea name="bizCont" id="bizCont" cols="10" rows="10" title="내용 입력" style="width:570px;"></textarea>
										</div>
									<span class="red2">최대 2000자까지 입력가능</span></td>
								</tr>
								<tr>
									<th scope="row">기대효과</th>
									<td>
										<div class="writeW">
											<textarea name="effect" id="effect" cols="10" rows="10" title="기대효과 입력" style="width:570px;"></textarea>
										</div>
									<span class="red2">최대 2000자까지 입력가능</span></td>
								</tr>
								
								<c:if test="${userType eq 'PROPOSAL'}">
								<tr>
									<th scope="row"><label for="">비밀번호</label></th>
									<td><input type="password" class="it " name="reqPw" id="reqPw"/><span class="red">※ 비밀번호 입력</span></td>
								</tr>
								</c:if>
								
								<tr>
									<th scope="row">사진</th>
									<td>
										<div id="fileBox" class="fileBox">
											<input type="button" class="filebutton" value="첨부" name="" id=""/>
											<input type="file" class="fileupload" name="imageFile" onchange="$(this).next().val($(this).val());"/>
											<input type="text" class="textbox" readonly="readonly"/>
										</div>
										
										<button id="imageBtnPlus" class="fileAdd">추가</button>
										
										<p class="upload" style="margin-top: 10px;">
											<span class="red2">※ gif, jpg, jpeg, png형식의 이미지 파일만 첨부 가능합니다.</span>
											<span class="red2">※ 최대 3개의 파일을 첨부할 수 있습니다.(파일 용량제한: 2MB)</span>
										</p>
									</td>
								</tr>
								<tr>
									<th scope="row">신청서 등록</th>
									<td>
										<div id="fileBox" class="fileBox">
											<input type="button" class="filebutton" value="첨부" name="" id=""/>
											<input type="file" class="fileupload" name="attachFile" onchange="$(this).next().val($(this).val());"/>
											<input type="text" class="textbox" readonly="readonly"/>
										</div>
										
										<button id="attachBtnPlus" class="fileAdd">추가</button>
										
										<p class="upload" style="margin-top: 10px;">
											<span class="red2">※ 한글파일(hwp)만 첨부할 수 있습니다.</span>
											<span class="red2">※ 최대 3개의 파일을 첨부할 수 있습니다.(파일 용량제한: 2MB)</span>
										</p>
									</td>
								</tr>
							</tbody>
						</table>
					</div>
					
				</form>
				
				<div class="btnR">
					<a href="#" class="btn_blue" onclick="fnSave(); return false;">등록하기</a>
					<a href="#" class="btn_reset" onclick="fnList(); return false;">목록보기</a>
				</div>

				<jsp:include page="/WEB-INF/views/front/proposal/proposal-search-form.jsp" />

			</div>

		</div>
	</div>
</div>

<!-- footer -->
<jsp:include page="/WEB-INF/views/front/common/footer.jsp"/>
<!-- //footer -->

</body>
</html>
