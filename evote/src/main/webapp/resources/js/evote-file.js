;(function($) {

	'use strict';
	
	$.fn.evoteFile = function(options) {
		var defaults = {
			maxFileCount : 1,
			removeButton : "<button class='fileAdd'>삭제</button>",
			oldFileCount : 0,
			callbackDeleteFile: function(fileSeq) {}
		};
		
		var settings = $.extend({}, defaults, options);
		

		var fileCount = 1;
		var maxFileCount = parseInt(settings.maxFileCount) || 5;
		var oldFileCount = parseInt(settings.oldFileCount) || 0;
		var hideFileBox = false;
		
		if (maxFileCount == 1) {
			$(this).hide();
		} else if(maxFileCount == -1) {
			maxFileCount = 10;
		}
		
		var fileBoxHtml = $(this).prev()[0].outerHTML ;
		
		// file count check
		if(oldFileCount >= maxFileCount) {
			$(this).hide();
			$(this).prev().hide();
			fileCount = 0;
			hideFileBox = true;
		}

		// check attache button
		var checkAttachButton = function(objAttachButton) {
			
			//console.log("maxFileCount: [" + maxFileCount + "], " + "fileCount: [" + fileCount + "], " + "oldFileCount: [" + oldFileCount + "], " + "currentFileCount: [" + (fileCount + oldFileCount) + "]");
			
			if((fileCount + oldFileCount) < maxFileCount) {
				$(objAttachButton).show();
			} else {
				$(objAttachButton).hide();
			}
		}

		$(this).on('click', function(e) {
			e.preventDefault();
			var objAttachButton = $(this);
			var removeButton = $(settings.removeButton).click(function () {
				e.preventDefault();
				$(this).prev().remove(); 
				$(this).remove(); 
				fileCount--;
				checkAttachButton(objAttachButton);
			});
			$(this).after(removeButton).after("&nbsp;").after(fileBoxHtml);
			fileCount++;
			checkAttachButton(objAttachButton);
		});

		checkAttachButton($(this));
		
		this.deleteFile = function(fileSeq) {
			if(hideFileBox && (fileCount + oldFileCount) == maxFileCount) {
				$(this).prev().show();
				fileCount++;
				hideFileBox = false;
			}
			oldFileCount--;
			settings.callbackDeleteFile(fileSeq);
			checkAttachButton(this);
		}
		
		this.getFileCount = function() {
			return fileCount;
		}
		
		return this;
		
	}

})(jQuery);