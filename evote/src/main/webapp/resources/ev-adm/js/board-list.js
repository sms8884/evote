function searchPost() {
	$("#searchStartDate").val($("#startDate").val());
	$("#searchEndDate").val($("#endDate").val());
	$("#searchCategoryCd").val($("#tmpCategoryCd").val());
	$("#searchTarget").val($("#tmpTarget").val());
	$("#searchText").val($("#tmpText").val());
	$("#searchDpYn").val($("#tmpDpYn").val());
	$("#searchReplyYn").val($("#tmpReplyYn").val());
	gotoPage(1);
}

function searchReset() {
	$("#startDate").val("");
	$("#endDate").val("");
	$("#tmpCategoryCd").val("");
	$("#tmpTarget").val("TITLE");
	$("#tmpText").val("");
	$("#tmpDpYn").val("");
}

function detail(seq) {
	$("#searchForm").attr("action", "/admin/board/" + __BOARD_NAME + "/" + seq);
	$("#searchForm").attr("method", "POST");
	$("#searchForm").submit();		
}

function writeForm() {
	$("#searchForm").attr("action", "/admin/board/" + __BOARD_NAME + "/write");
	$("#searchForm").attr("method", "POST");
	$("#searchForm").submit();		
}