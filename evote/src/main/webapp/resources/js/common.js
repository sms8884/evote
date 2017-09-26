/*!
 * e-gov common javascript
 * http://ep.e-gov.co.kr/
 */

function gfnSetPeriodDatePicker(id1, id2, btnId1, btnId2){
    var dates = $("#"+id1+", #"+id2).datepicker({
        //changeMonth : true, 
        changeYear : true,
        //gotoCurrent : true,
        //minDate: '0d',
        hideIfNoPrevNext : true,
        //navigationAsDateFormat : true,
        //dayNames : ["일", "월", "화", "수", "목", "금", "토"],
        //dayNamesMin : ["일", "월", "화", "수", "목", "금", "토"],
        monthNames : ["1월", "2월", "3월", "4월", "5월", "6월", "7월", "8월", "9월", "10월", "11월", "12월"],
        monthNamesShort : ["1월", "2월", "3월", "4월", "5월", "6월", "7월", "8월", "9월", "10월", "11월", "12월"],
        dateFormat: 'yy-mm-dd',
        showMonthAfterYear: true,
        onSelect: function( selectedDate ) {
            var option = this.id == "startDate" ? "minDate" : "maxDate",
            instance = $( this ).data( "datepicker" ),
            date = $.datepicker.parseDate(instance.settings.dateFormat || $.datepicker._defaults.dateFormat,selectedDate, instance.settings );
            dates.not( this ).datepicker( "option", option, date );
        }
    });
    $(".ui-datepicker").css('font-size', 15);
    
    $("#"+id1+", #"+id2).css("cursor", "pointer");
    
    if(!gfnIsEmpty(btnId1)){
    	$("#"+btnId1).css("cursor", "pointer");
    	$("#"+btnId1).on("click", function(){
    		$("#"+id1).focus();
    	});
    }
    if(!gfnIsEmpty(btnId2)){
    	$("#"+btnId2).css("cursor", "pointer");
    	$("#"+btnId2).on("click", function(){
    		$("#"+id2).focus();
    	});
    }
}

function gfnSetSingleDatePicker(id1, btnId1){
	var dates = $("#"+id1).datepicker({
		//changeMonth : true, 
		changeYear : true,
		//gotoCurrent : true,
		//minDate: '0d',
		hideIfNoPrevNext : true,
		//navigationAsDateFormat : true,
		//dayNames : ["일", "월", "화", "수", "목", "금", "토"],
		//dayNamesMin : ["일", "월", "화", "수", "목", "금", "토"],
		monthNames : ["1월", "2월", "3월", "4월", "5월", "6월", "7월", "8월", "9월", "10월", "11월", "12월"],
		monthNamesShort : ["1월", "2월", "3월", "4월", "5월", "6월", "7월", "8월", "9월", "10월", "11월", "12월"],
		dateFormat: 'yy-mm-dd',
		showMonthAfterYear: true
	});
	$(".ui-datepicker").css('font-size', 15);
	
	$("#"+id1).css("cursor", "pointer");
	
	if(!gfnIsEmpty(btnId1)){
		$("#"+btnId1).css("cursor", "pointer");
    	$("#"+btnId1).on("click", function(){
    		$("#"+id1).focus();
    	});
    }
}

function gfnComma(num){
	return num.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
}

function gfnUnComma(num){
	return num.toString().replace(/[^\d]+/g, "");
}

function gfnIsEmpty(val){
	if( val == null || typeof val == "undefined" || val == "" ) {
		return true;
	}
	return false;
}

/**
 * ex : if( gfnValidation( $("#id"), "입력해주세요." ) == false )
 */
function gfnValidation(obj, msg){
	if(gfnIsEmpty($(obj).val().trim())){
	    alert(msg);
	    $(obj).focus();
	    return false;
	}
	return true;
}

/**
 * return null : 이메일문자없음, false : 이메일형식오류, true : 이메일형식적합
 */
function gfnEmailCheck(email){
	var _emailPattern = /([\w-\.]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([\w-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)$/;
	if( gfnIsEmpty(email) ) {
		return null;
	} else {
	    if(!_emailPattern.test(email)) {
	        return false;
	    }
	}
	return true;
}

/**
 * ex : if( gfnFileExtCheck( $("#id"), ['png','jpg'] ) == false )
 */
function gfnFileExtCheck(obj, arr){
	if( $(obj).val() != "" ){
        var ext = $(obj).val().split('.').pop().toLowerCase();
		if($.inArray(ext, arr) == -1) {
			alert(arr+' 파일만 업로드 할 수 있습니다.');
			return false;
		}
		return true;
	}
	return null;
}

function gfnIsIE(){
	var agent = navigator.userAgent.toLowerCase();
	if( (navigator.appName == "Netscape" && navigator.userAgent.search("Trident") != -1) || (agent.indexOf("msie") != -1) ){
		return true;
	} else {
		return false;
	}
}

/**
 * ex : var fileSize = gfnGetFileSize(document.form.imageFile);
 */
function gfnGetFileSize(obj){
	var fileSize = -1;
	if($(obj).prop("type").toLowerCase() == "file"){
	 /*   if(gfnIsIE() == true){
	        var ax = new ActiveXObject("Scripting.FileSystemObject");
	        var filePath = obj.value;
	        if(filePath != ""){
	        	var file = ax.getFile(filePath);
	            fileSize = file.size;
	        }
	    } else {*/
	    	if(obj.files[0] != undefined){
	    		fileSize = obj.files[0].size	    		
	    	}
	    //}
	}
	return fileSize;
}

/**
 * string byte 
 */
function gfnByte(str){
    var size = 0;
    if(str != null && str != undefined && str != "undefined" && str != ""){
        for(var i=0,len=str.length;i<len;i++) {
            size++;
            if(44032 <str.charCodeAt(i) && str.charCodeAt(i) <=  55203) {
                size++;
            }
            if(12593 <= str.charCodeAt(i) && str.charCodeAt(i) <= 12686 ) {
                size++;
            }
        }
    }
    return size;
}

/**
 * jquery 이용한 엔터시 해당 function 호출
 */
$.fn.setEnter = function(func){
	$(this).on('keyup', function(e) {
		if (e.which == 13) {
			func();
		}
	});	
}

/**
 * 숫자만입력 및 comma 처리.
 */
function gfnSetAmount(id) {
    $("#"+id).keypress(function(event) {
        if(event.which && (event.which < 48 || event.which > 57) ) {
            event.preventDefault();
        }
    }).keyup(function(){
        if( $(this).val() != null && $(this).val() != '' ) {
            $(this).val( $(this).val().replace(/[^0-9]/g, '') );
            $(this).val(gfnComma($(this).val() ) );
        }
    });
}

/**
 * 숫자만 입력 
 */
function gfnSetNumber(id) {
    $("#"+id).keypress(function(event) {
        if(event.which && (event.which < 48 || event.which > 57) ) {
            event.preventDefault();
        }
    }).keyup(function(){
        if( $(this).val() != null && $(this).val() != '' ) {
            $(this).val( $(this).val().replace(/[^0-9]/g, '') );
        }
    });
}