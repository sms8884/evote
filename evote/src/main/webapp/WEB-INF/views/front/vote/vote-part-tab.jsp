<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<script language="javascript" type="text/javascript">

//분야 눌렀을때 분야 검색하여 리스트 화면으로 이동
function goRealmVoteList(realm_cd){	
	$("#tab_menu").val(0);	
	$("#search_realm_cd").val(realm_cd);	
	$("#form").attr('action', "/vote/vote-list").submit();		
}

</script>
<div class="vote_loca">
	<ul class="">
	<c:if test="${!empty voteRealmList}">
		<c:forEach var="realm" items="${voteRealmList}" varStatus="status">		
		<li <c:if test ='${realm.realm_cd == params.search_realm_cd}'>class="active"</c:if>  > 
			<a href="#" onClick="javascript:goRealmVoteList('${realm.realm_cd}'); return false;">
			<span <c:if test ='${realm.sel_cnt == realm.choice_cnt}'> class="prev"</c:if> >
				${realm.realm_nm}<br/>( ${realm.sel_cnt}/${realm.choice_cnt} )
			</span>
			</a>
		</li>	
		</c:forEach>
	</c:if>
	</ul>
</div>
