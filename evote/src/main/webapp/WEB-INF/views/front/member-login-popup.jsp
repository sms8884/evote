<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!doctype html>
<html lang="en">
<head>

<script type="text/javascript">

$(document).ready(function() {
	
});

function fnMoveJoin(){
	try{
		opener.location.href = "<c:url value="/member/join-step1" />";
	}catch(e){}
}

function fnMoveLogin(){
	try{
        opener.location.href = "<c:url value="/login" />";
    }catch(e){}
}

</script>

</head>
<body>
	<table>
		<tr>
		    <td>회원가입/로그인</td>
		</tr>
		<tr>
	        <td>이메일 아이디로 로그인 후 댓글/공감이 가능합니다.<br />이메일로 가입하시거나 로그인 후 댓글등록/공감해주세요.</td>
	    </tr>
	    <tr>
	        <td><input type="button" value="이메일로 가입" onclick="fnMoveJoin()"/><input type="button" value="로그인" onclick="fnMoveLogin()"/></td>
	    </tr>
	</table>
	  
</body>
</html>
