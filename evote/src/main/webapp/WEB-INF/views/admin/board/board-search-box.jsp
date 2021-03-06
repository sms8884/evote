<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page contentType="text/html; charset=utf-8" %>
<script language="javascript" type="text/javascript">
function initSearchParam() {
	$("#startDate").val("${searchParam.searchStartDate}");
	$("#endDate").val("${searchParam.searchEndDate}");
	$("#tmpText").val("${searchParam.searchText}");

	if("${searchParam.searchCategoryCd}" != "") {
		$("#tmpCategoryCd").val("${searchParam.searchCategoryCd}");
	}
	
	if("${searchParam.searchTarget}" != "") {
		$("#tmpTarget").val("${searchParam.searchTarget}");
	}	

	if("${searchParam.searchDpYn}" != "") {
		$("#tmpDpYn").val("${searchParam.searchDpYn}");
	}	
}
</script>
						<form method="post" action="" class="searchTb">
							<fieldset id="" class="">
								<table cellpadding="0" cellspacing="0" class="" summary="" >
									<caption></caption>
									<colgroup>
										<col width="105"/><col width="*"/>
										<col width="105"/><col width="151"/>
									</colgroup>
									<tbody>
									
<c:if test="${param.searchFormType eq 2}">
									<c:if test="${board.cateUseYn eq 'Y'}">
									<th scope="row" class="bln">구분</th>
									<td colspan="3">
										<select id="tmpCategoryCd" title="구분" style="width:127px;">
											<option value="">전체</option>
											<c:forEach items="${boardCategoryList}" var="list">
												<option value="${list.categoryCd}"><c:out value="${list.categoryNm}"/></option>
											</c:forEach>
										</select>
									</td>
									</c:if>
</c:if>
									
										<tr>
											<th scope="row" class="bln">기간</th>
											<td>
												<label for="startDate" class="hidden">시작기간 입력하기</label><input type="text" class="it wid131" title="" value="" name="startDate" id="startDate" readonly="readonly"/><input type="image" src="${siteImgPath}/common/icon_cal.gif" alt="시작기간 선택" onclick="$('#startDate').focus(); return false;"/> ~
												<label for="endDate" class="hidden">종료기간 입력하기</label><input type="text" class="it wid131" title="" value="" name="endDate" id="endDate" readonly="readonly"/><input type="image" src="${siteImgPath}/common/icon_cal.gif" alt="종료기간 선택" onclick="$('#endDate').focus(); return false;"/>
											</td>

<c:if test="${param.searchFormType eq 1}">
											<c:if test="${board.cateUseYn eq 'Y'}">
											<th scope="row">구분</th>
											<td>
												<select id="tmpCategoryCd" title="구분" class="wid100">
													<option value="">전체</option>
													<c:forEach items="${boardCategoryList}" var="list">
														<option value="${list.categoryCd}"><c:out value="${list.categoryNm}"/></option>
													</c:forEach>
												</select>
											</td>
											</c:if>
</c:if>
<c:if test="${param.searchFormType eq 2}">
											<th scope="row">게시상태</th>
											<td>
												<select id="tmpDpYn" name="tmpDpYn" title="게시상태" style="width:127px;">
													<option value="" selected="selected">전체</option>
													<option value="Y">게시</option>
													<option value="N">미게시</option>
												</select>
											</td>
</c:if>
										</tr>
										<tr>
											<th scope="row" class="bln">검색</th>
											<td colspan="3">
												<select id="tmpTarget" title="검색" style="width:127px;">
													<option value="TITLE">제목</option>
													<option value="CONT">내용</option>
												</select>										
												<label for="con" class="hidden">검색내용 입력하기</label><input type="text" class="it wid461" title="" value="" name="con" id="tmpText"/>
											</td>
										</tr>
									</tbody>
								</table>
								<div class="btnC">
									<a href="#" class="btn_blue" onclick="searchPost(); return false;">검색</a>
									<a href="#" class="btn_reset" onclick="searchReset(); return false;">초기화</a>
								</div>
							</fieldset>
						</form>