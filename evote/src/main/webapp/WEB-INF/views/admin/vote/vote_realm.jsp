<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>

<!-- meta -->
<jsp:include page="/WEB-INF/views/admin/common/meta.jsp" />
<!-- //meta -->
<style>  
.mytable { border-collapse:collapse; }  
.mytable th, .mytable td { border:1px solid black; }
</style>
<script langauge="javascript">

$(document).ready(function(){
	//숫자만 입력되게 수정
	$('.OnlyNumber').keypress(function(event) {
	    if(event.which && (event.which < 48 || event.which > 57) && event.which != 8) {
	        event.preventDefault();
	    }
	}).keyup(function(){
	    if( $(this).val() != null && $(this).val() != '' ) {
	        $(this).val( $(this).val().replace(/[^0-9]/g, '') );
	    }
	});

});


/**
 * textarea 글자 제한
 */
function checkmaxlength(obj, msg){	
	var mlength=obj.getAttribute? parseInt(obj.getAttribute("maxlength")) : "";
	if (obj.getAttribute && obj.value.length>=mlength) {		
		alert(msg);
		obj.value=obj.value.substring(0,mlength);		
	}
}


/*데이터 초기화*/
function clearData(){
	$("#realm_cd").val('');
	$("#realm_nm").val('');
	$("#choice_cnt").val('');
	$("#use_yn").val('Y');
	//$("input:radio[id='use_yn_y']").prop("checked", true);
	$("input:radio[id='dp_target1']").prop("checked", true);
	$("#youth_yn").prop("checked", true);
	$("#adult_yn").prop("checked", true);
	var vote_type = $("#vote_type").val();
	if(vote_type == 'PART'){
		$("#sava_mesage").text('※ 상단에서 분야 정보를 입력한 후 등록하기를 선택해주세요.');
	}
	$("#btn_save").text("등록하기");
}

/*수정 폼으로 옮기기*/
function modifyData(cd) {	
	var vote_type = $("#vote_type").val();
	if(vote_type == 'PART'){
		$("#sava_mesage").text('※ 상단에서 분야 정보를 수정한 후 저장하기를 선택해주세요.');
	}
	$("#btn_save").text("저장하기");
	
	$("#realm_cd").val(cd);
	var nm = $("#nm_"+cd).text();
	$("#realm_nm").val(nm);

	var cnt =$("#cnt_"+cd).text();
	$("#choice_cnt").val(cnt);
	
	var use = $("#use_"+cd).is(":checked");
	if(use){
		$("#use_yn").val('Y');
		//$("input:radio[id='use_yn_y']").prop("checked", true);
	}else{
		$("#use_yn").val('N');
		//$("input:radio[id='use_yn_n']").prop("checked", true);
	}
	
	var youth = $("#youth_yn_"+cd).is(":checked");
	if(youth){
		$("#youth_yn").prop("checked", true);
	}else{
		$("#youth_yn").prop("checked", false);
	}
	
	var adult = $("#adult_yn_"+cd).is(":checked");
	if(adult) {
		$("#adult_yn").prop("checked", true);
	}else{
		$("#adult_yn").prop("checked", false);
	}
	
	var dp_target = $("input[name=dp_target_"+cd+"]:checked").val(); 	
	$('input:radio[name=dp_target]:input[value='+dp_target+']').prop("checked", true);
	
}

/*등록 및 수정*/
function writeData() {
	//입력하신 내용을 저장하시겠습니까?
	if(confirm('<spring:message code="message.admin.vote.011"/>')) {
		if( gfnValidation( $("#realm_nm"), '<spring:message code="message.admin.common.001" arguments="분야명을"/>' ) == false ){ return; }
		if( gfnValidation( $("#choice_cnt"), '<spring:message code="message.admin.common.001" arguments="선택가능개수를"/>' ) == false ){ return; }		
		
		/*
		var realm_cd =  $.trim($("#realm_cd").val());		
		if(!realm_cd){
			if($("input:radio[id='use_yn_n']").is(':checked')){
				alert("사용하지 않을 분야는 등록하실수 없습니다.");
				$("input:radio[id='use_yn_y']").prop("checked", true);
				return;
			}
		}
		*/
		$("#use_yn").val('Y');
		$('#form').attr('action', "/admin/vote/setVoteRealm").submit();

	}
}
//삭제
function deleteData(cd){
	var vote_type = $("#vote_type").val();
	if(vote_type == 'ALL'){
		//일괄 투표시 일괄 분야를 삭제 할 수 없습니다.
		alert('<spring:message code="message.admin.vote.014"/>');
		return ;
	}else{
		var item_cnt = $("#item_cnt_"+cd).val();
		if(item_cnt > 0){
			//사업이 등록된 분야는 삭제할 수 없습니다.
			alert('<spring:message code="message.admin.vote.015"/>');
			return ;
		}else{
			var nm = $("#nm_"+cd).text();
			//다음 분야가 삭제됩니다. 계속하시겠습니까? (분야명) 			
			if(confirm('<spring:message code="message.admin.vote.009" arguments="'+nm+'" />' )) {
				$("#realm_cd").val(cd);
				$('#form').attr('action', "/admin/vote/delVoteRealm").submit();
			}
		}
	}
}

//순서조정
function saveSort(sort, cd){
	$("#realm_cd").val(cd);
	var use = $("#use_"+cd).is(":checked");
	if(!use){
		//사용 중인 분야만 순서를 변경할수 있습니다.
		alert('<spring:message code="message.admin.vote.016"/>');
		return ;
	}else{
		var nm = $("#nm_"+cd).text();	
		if(confirm('<spring:message code="message.admin.vote.013" arguments="'+nm+'" />' )) {
			$("#sort").val(sort);		
			var ord = $("#dp_ord_"+cd).val();	
			$("#dp_ord").val(ord);			
			$('#form').attr('action', "/admin/vote/chOrderVoteRealm").submit();	
		}
	}
}

//사용여부 변경
function saveUse(cd){
	var use = $("#use_"+cd).is(":checked");
	var vote_type = $("#vote_type").val();
	if(vote_type =='ALL'){
		//일괄 투표시 일괄 분야 사용을 해제 할수 없습니다.
		alert('<spring:message code="message.admin.vote.010"/>');	
		if(use == true){
			$("#use_"+cd).prop("checked", false);	
		}else{
			$("#use_"+cd).prop("checked", true);
		}
	}else{
		var item_cnt = $("#item_cnt_"+cd).val();
		if(item_cnt > 0){			
			//사업이 등록된 분야는 사용 해제할수 없습니다.
			alert('<spring:message code="message.admin.vote.017"/>');	
			if(use == true){
				$("#use_"+cd).prop("checked", false);	
			}else{
				$("#use_"+cd).prop("checked", true);
			}
		}else{
			//사용 해제 시 투표에서 분야가 비 노출됩니다. 계속하시겠습니까?
			if(confirm("<spring:message code='message.admin.vote.018'/>")) {
				modifyData(cd);
				$('#form').attr('action', "/admin/vote/setVoteRealm").submit();
			}else{
				if(use == true){
					$("#use_"+cd).prop("checked", false);	
				}else{
					$("#use_"+cd).prop("checked", true);
				}
			}
		}
	}
}

//사업관리
function goVoteItem(){
	$('#form').attr('action', "/admin/vote/vote_item_list").submit();		
}

</script>

</head>
<body>
	<!-- header -->
	<jsp:include page="/WEB-INF/views/admin/common/header.jsp" />
	<!-- //header -->
		
		
		<div class="containerWrap">
		<div class="subNav">
			<ul class="subNavUl">
				<li class="subNavHome"><img src="${siteImgPath}/common/home.png" alt="home"/></li>
				<li><a href="/admin/vote/vote_list">투표</a></li>				
				<li>분야관리</li>
			</ul>
		</div>

		<div class="container">
			<div class="contentWrap">
			<jsp:include page="/WEB-INF/views/admin/common/lnb.jsp" />					
				<div class="content">
					<h3 class="contentTit">${voteInfo.title} : 분야설정</h3>					
					<div class="mainContent">	
						<form id="form" name="form" method="post" action= "/admin/vote/setVoteRealm" class="searchTb partTable">
						<input type="hidden" id="vote_seq" name="vote_seq" value="${voteInfo.vote_seq}"/>
						<input type="hidden" id="vote_type" name="vote_type" value="${voteInfo.vote_type}"/>
						<input type="hidden" id="realm_cd" name="realm_cd"/>
						<input type="hidden" id="sort" name="sort"/>
						<input type="hidden" id="dp_ord" name="dp_ord"/>
						<input type="hidden" id="use_yn" name="use_yn"/>
						
						<fieldset id="" class="">
							<div class="infoRed" id="sava_mesage">
							<c:if test ="${voteInfo.vote_type eq 'PART'}">							
								※ 상단에서 분야 정보를 입력한 후 등록하기를 선택해주세요.
							</c:if>
							<c:if test ="${voteInfo.vote_type eq 'ALL'}">
								※ 일괄 투표시 신규로 분야 등록 및 사용해제 할 수 없습니다.</br> 아래 리스트에서 수정하기 버튼을 클릭후 해당 정보를 변경해주세요.
							</c:if>
							</div>
								<table cellpadding="0" cellspacing="0" class="" summary="" >
									<caption></caption>
									<colgroup>									
										<col width="20%"/>
										<col width="20%"/>
										<col width="20%"/>
										<col width="20%"/>
									</colgroup>
									<thead>
										<tr>											
											<th>분야명</th>
											<th>필수투표대상</th>
											<th>분야표시대상</th>
											<th>선택가능개수</th>
										</tr>
									</thead>
									<tbody>
										<tr>											
											<td>
												<input type="text" id="realm_nm" name="realm_nm" class="it wid125" maxlength="11"<c:if test="${voteInfo.vote_type eq 'ALL'}"> readOnly</c:if>/>
											</td>
											<td>
												<ul>
													<li><input type="checkbox" id="youth_yn" name="youth_yn" value="Y" checked/> <label for="youth_yn"> 청소년</label></li>
													<li><input type="checkbox" id="adult_yn" name="adult_yn" value="Y" checked/> <label for="adult_yn"> 성인</label></li>
												</ul>
											</td>
											<td>
												<ul>
													<li><input type="radio" class="noticeR1" id="dp_target1" name="dp_target" value="ALL" checked/><label for="target1"> 전체</label></li>
													<li><input type="radio" class="noticeR1" id="dp_target2" name="dp_target" value="YOUNG" /><label for="target2"> 청소년</label></li>
		 											<li><input type="radio" class="noticeR1" id="dp_target3" name="dp_target" value="ADULT"/><label for="target3"> 성인</label></li> 
												</ul>
											</td>
											<td>
												<input type="text" id="choice_cnt" name="choice_cnt" class="OnlyNumber it wid125" maxlength="6"/>
											</td>
										</tr>
									</tbody>
								</table>
								<div class="btnC">
									<a href="javascript:writeData();" class="btn_blue"><span id="btn_save">등록하기</span></a>
									<c:if test ="${voteInfo.vote_type eq 'PART'}">	
									<a href="javascript:clearData();" class="btn_reset">신규등록</a>
									</c:if>
								</div>
							</fieldset>
						</form>
					
						<div class="boardView voteBoard partTable">
							<table cellpadding="0" cellspacing="0" class="tbL" summary="공모관리의 선택, 번호, 제목, 공모기간, 등록일을 알 수 있는 표입니다." >
								<caption>투표관리</caption>
								<colgroup>
									<col width="7%"/>
									<col width="7%"/>
									<col width="20%"/>
									<col width="12%"/>
									<col width="12%"/>
									<col width="10%"/>
									<col width="15%"/>
									<col width="*%"/>
								</colgroup>
								<thead>
									<th scope="col">번호</th>
									<th scope="col">사용여부</th>
									<th scope="col">분야명</br>(사업개수)</th>
									<th scope="col">필수투표대상</th>
									<th scope="col">분야표시대상</th>
									<th scope="col">선택가능개수</th>
									<th scope="col">관리</th>
									<th scope="col">순서변경</th>
								</thead>
								<tbody>
						<c:if test="${!empty voteRealmList}">
						<c:forEach var="item" items="${voteRealmList}" varStatus="status" >
							<tr>
								<td><input type="hidden" id="cd_${item.realm_cd}" value="${item.realm_cd}"/>${status.index+1}</td>
								<td>
									 <input type="hidden" id="item_cnt_${item.realm_cd}" value="${item.item_cnt}"/>
									<input type="checkbox" id="use_${item.realm_cd}" <c:if test="${item.use_yn eq 'Y'}">checked</c:if> Onclick="javascript:saveUse('${item.realm_cd}');" />										
								</td>
								<td><span id="nm_${item.realm_cd}">${item.realm_nm}</span>
										<input type="hidden" id="item_cnt_${item.realm_cd}" value='${item.item_cnt}'/>(${item.item_cnt})
								</td>
								<td>
									<ul>
										<li>
											<input type="checkbox" id="youth_yn_${item.realm_cd}" <c:if test="${item.youth_yn eq 'Y'}">checked</c:if> onClick="return false;"/> 청소년
										</li>
										<li>
											<input type="checkbox" id="adult_yn_${item.realm_cd}" <c:if test="${item.adult_yn eq 'Y'}">checked</c:if> onClick="return false;"/> 성인
										</li>
									</ul>
								</td>
								<td>
									<ul>
										<li><input type="radio" value="ALL" name="dp_target_${item.realm_cd}" <c:if test="${item.dp_target eq 'ALL'}"> checked </c:if> onClick="return false;"/> 전체</li>
										<li><input type="radio" value="YOUNG" name="dp_target_${item.realm_cd}"  <c:if test="${item.dp_target eq 'YOUNG'}"> checked </c:if>  onClick="return false;"/> 청소년</li>
								 		<li><input type="radio" value="ADULT" name="dp_target_${item.realm_cd}" <c:if test="${item.dp_target eq 'ADULT'}">checked</c:if> onClick="return false;"/> 성인 </li>
									</ul>
								</td>
								<td><span id="cnt_${item.realm_cd}">${item.choice_cnt}</span></td>
								<td>								
									<div class="btn_reset2box">
										<input class="btn_reset2" type="button" value="수정" onclick="javascript:modifyData('${item.realm_cd}')"  />
									</div>									
									<div class="btn_gray2box">
										<input class="btn_gray2" type="button" value="삭제" onclick="javascript:deleteData('${item.realm_cd}')" />
									</div>														
								</td>
								<td class="moveButton">
									<input type="hidden" id="dp_ord_${item.realm_cd}" value='${item.dp_ord}'/>	
									<a href="javascript:saveSort('firstup','${item.realm_cd}');" ><img src="${siteImgPath}/content/totop.png" alt=""/></a>
									<a href="javascript:saveSort('up','${item.realm_cd}');"  ><img src="${siteImgPath}/content/up.png" alt=""/></a>
									<a href="javascript:saveSort('down','${item.realm_cd}');" ><img src="${siteImgPath}/content/down.png" alt=""/></a>
									<a href="javascript:saveSort('lastdown','${item.realm_cd}');" ><img src="${siteImgPath}/content/tobottom.png" alt=""/></a>
								</td>
							</tr>
						</c:forEach>
						</c:if>	
						<c:if test="${empty voteRealmList}">
						<tr>
							<td colspan="8" align="center">목록이 없습니다.</td>
						</tr>
						</c:if>										
					</tbody>
				</table>
			</div>		
			<div class="infoRed">※ 사업이 등록된 분야는 삭제 및 사용 해제할 수 없습니다</div>	
			<div class="btnR">
				<a href="/admin/vote/vote_list" class="btn_reset">투표목록보기</a>
				<a href="javascript:goVoteItem();" class="btn_blue">사업관리</a>
			</div>		
		</div>
		</div>
	</div><!--contentWrap-->
	</div><!--container-->
</div><!--containerWrap-->

<!-- footer -->
<jsp:include page="/WEB-INF/views/admin/common/footer.jsp" />
<!-- //footer -->

</body>
</html>