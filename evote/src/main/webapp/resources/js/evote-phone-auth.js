;(function($) {

	'use strict';

	$.phoneAuth = function(options) {

		var __IS_TIME_OUT = false;
		var __TIMER;
		
		var defaults = {
			authLimitTime : 180,
			authRequestUrl : '',
			authCheckUrl : '',
			
			phoneNumberId : 'phoneNumber',
			phoneCodeId : 'phone-code',
			phoneKeyId : 'phone-key',
			limitTimeTextId : 'limit_time_txt',

			authCodeAreaId : 'tmp-phone-code',
			
			btnRequestId : 'btn_request',
			btnAuthId : 'btn_auth',
			appendBirthdate : false,
			appendData : [],
			validAuthRequestEvent : function() {
				return true;
			},
			validAuthCheckEvent : function() {
				return true;
			},
			callbackEvent : function(data) {}
		};
		
		var settings = $.extend({}, defaults, options);

		if(settings.authRequestUrl == '' || settings.authCheckUrl == '') {
			alert('Parameters [authRequestUrl, authCheckUrl] is required.');
			return;
		}
		
		// 생년월일 항목 초기화
		if(settings.appendBirthdate == true) {
			var date = new Date();
			var year = date.getFullYear();
			var tmpVal;
			
			for(var cnt=(year-14); cnt>(year-100); cnt--) {
				$("#birthYear").append($("<option></option>").attr("value", cnt).text(cnt)); 
			}
			
			$("#birthMonth").append($("<option></option>").attr("value", "").text("월"));
			for(var cnt=0; cnt<12; cnt++) {
				tmpVal = (cnt < 9) ? "0" + (cnt+1) : (cnt+1);
				$("#birthMonth").append($("<option></option>").attr("value", tmpVal).text(tmpVal)); 
			}
			
			$("#birthDate").append($("<option></option>").attr("value", "").text("일"));
			for(var cnt=0; cnt<31; cnt++) {
				tmpVal = (cnt < 9) ? "0" + (cnt+1) : (cnt+1);
				$("#birthDate").append($("<option></option>").attr("value", tmpVal).text(tmpVal)); 
			}
			
			$("#birthYear").val("1970");
		}
		
		// 만 14세 미만 체크
		var checkAge = function() {
		    var todayYear = parseInt(new Date().getFullYear()); 
		    var todayMonth = parseInt(new Date().getMonth() + 1);
		    var todayDate = parseInt(new Date().getDate());

		    var birthYear = parseInt($("#birthYear").val());
			var birthMonth = parseInt($("#birthMonth").val());
			var birthDate = parseInt($("#birthDate").val());
			
		    var age;
		    
		    if((todayMonth > birthMonth) || (todayMonth == birthMonth & todayDate >= birthDate)) {
		    	age = todayYear - birthYear + 1;
		    } else{ 
				age = todayYear - birthYear; 
		    }
		    
		    if((age-1) < 14) {
				return false;
		    } else {
				return true;
		    }
		}
		
		var timerStart = function() {
			clearInterval(__TIMER);
			var counter = settings.authLimitTime;
			var dpTime = '';
			$('#' + settings.limitTimeTextId).html(getTimeString(counter));
			__TIMER = setInterval(function () {
				$('#' + settings.limitTimeTextId).html(getTimeString(counter-1));
				if(counter <= 0) {
					clearInterval(__TIMER);
					$('#' + settings.limitTimeTextId).html('시간초과');
					__IS_TIME_OUT = true;
				}
				counter--;
			}, 1000);
		}
		
		var getTimeString = function(seconds) {
			var timeString = Math.floor(seconds/60);
			timeString = timeString + '분 ';
			if ( (seconds%60) < 10 ) { 
				timeString = timeString + '0';
			}
			timeString = timeString + (seconds%60);
			timeString = timeString + '초';
			return '남은시간: ' + timeString;
		}
		
		var checkAppendData = function() {
			var result = true;
			$(settings.appendData).each(function() {
				var appendFieldId = $(this).attr('appendFieldId');
				var validationMsg = $(this).attr('validationMsg');
				if($('#' + appendFieldId).val() == '') {
					alert(validationMsg);
					$('#' + appendFieldId).focus();
					result = false;
					return false;
				}
			});
			return result;
		}
		
		var getSendData = function() {
			var data = {'phoneNumber':$('#' + settings.phoneNumberId).val()};
			$(settings.appendData).each(function() {
				var appendFieldId = $(this).attr('appendFieldId');
				var validationMsg = $(this).attr('validationMsg');
				var appendObject = $('#' + appendFieldId);
				if(appendObject.length > 0 && appendObject.val() != '') {
					data[appendFieldId] = $('#' + appendFieldId).val();
				}
			});
			return data;
		}

		var getCheckData = function() {
			var data = {};
			data['phone'] = $('#' + settings.phoneNumberId).val();
			data['code'] = $('#' + settings.phoneCodeId).val();
			data['key'] = $('#' + settings.phoneKeyId).val();
			return data;
		}

		var disabledDataField = function() {
    		$('#' + settings.phoneNumberId).attr('disabled', true);
    		$(settings.appendData).each(function() {
				var appendFieldId = $(this).attr('appendFieldId');
				$('#' + appendFieldId).attr('disabled', true);
				
    		});
		}
		
		// 인증번호 요청
		$('#' + settings.btnRequestId).on('click', function(e) {
			e.preventDefault();
			
			if(!settings.validAuthRequestEvent()) {
				return;
			}
			
			if(settings.appendBirthdate == true && !checkAge()) {
				alert('만 14세 미만은 이용이 제한됩니다');
				return;
			}
			
			var phoneNumber = $('#' + settings.phoneNumberId).val();
			var numCheck = /^[0-9]*$/;
			
			if(!checkAppendData()) {
				return;
			} else if(phoneNumber == ''){
		        alert('휴대전화번호를 입력해주세요');
		        $('#' + settings.phoneNumberId).focus();
		    }else if(!numCheck.test(phoneNumber)){
		        alert('숫자만 입력해주세요');
		        $('#' + settings.phoneNumberId).val('');
		        $('#' + settings.phoneNumberId).focus();
		    }else {
		        $.ajax({
		            type: 'POST',
		            url: settings.authRequestUrl,
		            dataType: 'json',
		            data: getSendData(),
		            success: function (data) {
		            	if(data != undefined) {
		                	if(data.result == 'Y') {
		                		timerStart();
		                		__IS_TIME_OUT = false;
		                		alert('인증번호가 발송되었습니다.');
		                		$('#' + settings.phoneCodeId).val('');
								$('#' + settings.authCodeAreaId).show();
		                		$('#' + settings.limitTimeTextId).show();
		                		$('#' + settings.btnRequestId).text('인증번호 재요청');
		                		$('#' + settings.phoneKeyId).val(data.key);
		                		disabledDataField();
		                	} else if(data.result == 'N') {
		                		alert(data.message);
		                	}
		            	}
		            },
		            error: function (jqXHR, textStatus, errorThrown) {
		                console.log(errorThrown);
		                console.log(textStatus);
		            }
		        });
		    }
		    
		});

		// 인증번호 검증
		$('#' + settings.btnAuthId).on('click', function(e) {
			e.preventDefault();

			if(!settings.validAuthCheckEvent()) {
				return;
			}
			
			if(__IS_TIME_OUT) {
				alert('인증 시간이 초과되었습니다.\n인증 번호를 다시 요청해주세요.');
				clearInterval(__TIMER);
				return;
			}
			
			if($('#' + settings.phoneCodeId).val() == '') {
				alert('인증을 받지 않았습니다. 인증번호를 입력하고 인증확인을 선택해주세요.');
				return;
			}
			
		    $.ajax({
		    	type: 'POST',
		        url: settings.authCheckUrl,
		        dataType: 'json',
		        data: getCheckData(),  
		        success: function (data) {
		        	if(data.result == true) {
		        		alert('인증되었습니다');
		        		clearInterval(__TIMER);
		        		settings.callbackEvent(data);
		        	} else {
		        		alert('잘못된 인증번호입니다. 인증번호를 확인한 다음 다시 입력해주세요.');
		        		$('#' + settings.phoneCodeId).val('');
		        	}
		        },
		        error: function (jqXHR, textStatus, errorThrown) {
		            console.log(errorThrown);
		            console.log(textStatus);
		        }
		    });
		    
		});

		$('#' + settings.phoneNumberId).on('keypress', function(e) {
			if (e.which == 13) {
				$('#' + settings.btnRequestId).click();
			}
		});
		
		$('#' + settings.phoneCodeId).on('keypress', function(e) {
			if (e.which == 13) {
				$('#' + settings.btnAuthId).click();
			}
		});
		
	};

})(jQuery);