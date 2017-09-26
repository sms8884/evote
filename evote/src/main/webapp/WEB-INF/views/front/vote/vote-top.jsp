<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<script language="javascript" type="text/javascript">

$(document).ready(function(){	
	$('.gnb').topmenu({ d1: 0, d2: 1, d3: 0});
});


//상단탭[제안목록] 눌럿을때 화면으로 이동
function goVoteList(){	
	$("#tab_menu").val(0);	
	$("#form").attr('action', "/vote/vote-list").submit();		
}

//상단탭[선택항목] 눌럿을때 화면으로 이동
function goVoteChoiceList(){	
	$("#tab_menu").val(1);	
	$('#form').attr('action', "/vote/vote-choice-list").submit();		
}

</script>

<!-- 투표정보 -->
<div class="voteInfo <c:if test="${params.finish_yn eq 'Y'}">active</c:if>">
	<c:if test="${params.finish_yn eq 'Y'}">
		<!-- 투표참여 완료 -->
		<div class="sel_top"><span>투표 참여 완료</span></div>
	</c:if>
	<p class="tit" style="height: auto; margin-bottom: 10px;" id="tmpTitle"><c:out value="${fn:replace(voteInfo.title, crcn, br)}" escapeXml="false"/></p>
	<c:if test="${params.finish_yn ne 'Y'}">
		<!-- 투표참여 미완료 -->
		<p class="s_txt">선호하는 제안사업에 투표해주세요</p>
	</c:if>
	<strong class="day_txt">		
		<fmt:parseDate value="${voteInfo.start_date}" var="dateFmt" pattern="yyyyMMddHH"/>
		<fmt:formatDate value="${dateFmt}"  pattern="yyyy.MM.dd HH시"/> ~
		<fmt:parseDate value="${voteInfo.end_date}" var="dateFmt" pattern="yyyyMMddHH"/>
		<fmt:formatDate value="${dateFmt}"  pattern="yyyy.MM.dd HH시"/>	
	</strong>
	<div class="snsW">
		<!-- sns -->
		<script type="text/javascript">
			var sh_title = $('#tmpTitle').text().replace('\n',' ') + '에 참여해주세요';
	   		var sh_url = location.href + "?vote_seq="+$("#vote_seq").val();
	   		var loUrl = window.location.pathname;
			if(loUrl == '/vote/vote-detail'){		
				sh_url = location.protocol+'//'+location.hostname+(location.port ? ':'+location.port: '') +"/vote/vote-list?vote_seq="+$("#vote_seq").val();
			}else if(loUrl =='/vote/vote-result-detail'){
				sh_url = location.protocol+'//'+location.hostname+(location.port ? ':'+location.port: '') +"/vote/vote-result-list?vote_seq="+$("#vote_seq").val();
			}
			//sh_url = location.protocol+'//'+location.hostname+(location.port ? ':'+location.port: '') +"/vote/vote-main";
		</script>
		<jsp:include page="/WEB-INF/views/common/sns.jsp"/>
		<!-- //sns -->		
	</div>
</div>


<c:if test="${voteInfo.status eq 'START'}">
<!-- 진행중인 투표만 제안목록, 선택항목 보여줌 --> 
<ul class="conTab two">
	<li><a href="#" <c:if test ="${tab_menu == 0}"> class="on"</c:if> onClick='javascript:goVoteList(); return false;' >제안목록(${voteTabCnt.total_cnt})</a></li>
	<li><a href="#" <c:if test ="${tab_menu == 1}"> class="on"</c:if> onClick='javascript:goVoteChoiceList(); return false;' >선택항목( ${voteTabCnt.user_choice_cnt} / ${voteTabCnt.vital_cnt} )</a></li>
</ul>
</c:if>

