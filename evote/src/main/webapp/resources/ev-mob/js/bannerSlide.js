(function($){
	jQuery.fn.efuTouchSliderCycle = function (){
		var startX, startY, endX, endY, moveX, moveY, angle;
		var target = $(this);
		var slideT = true;
		
		target.cycle({
	      	fx: 'scrollHorz',
	        speed: 300,
			timeout: 0,
	        before: onBefore,
			after : onAfter
		});
	
		target.parent().find(".bxControl ul li").click(function() {
		    var num = $(this).index();
		    target.cycle(num);
			init();
		});		
		
		target.get(0).addEventListener("touchstart", touchStart, false);
		target.get(0).addEventListener("touchmove", touchMove, false);
		target.get(0).addEventListener("touchend", touchEnd, false);
		
		target.find("li:first img").load(function(){
			init();
		});
			init();
	
		function onBefore() {
			var idx = parseInt($(this).index());
			target.parent().find(".bxControl ul li").removeClass("on");
			target.parent().find(".bxControl ul li:eq(" + idx + ")").addClass("on");
		};
	
		function onAfter() {
			slideT = true;
		}

		function touchStartDocument(e){
			startX2 = e.changedTouches[0].pageX;
			startY2 = e.changedTouches[0].pageY;
		}
		
		function touchStart(e) {
			startX = e.changedTouches[0].pageX;
			startY = e.changedTouches[0].pageY;
		}
		
		function touchMove(e) {
			endX = e.changedTouches[0].pageX;
			endY = e.changedTouches[0].pageY;
			moveX = endX - startX;
			moveY = endY - startY;
			angle = Math.atan2(moveY, moveX) * 180 / Math.PI;
			if((Math.abs(angle) < 45) || (Math.abs(angle) > 135)){ 
				e.preventDefault();
			}
		}
		
		function touchEnd(e) {
			endX = e.changedTouches[0].pageX;
			endY = e.changedTouches[0].pageY;
			moveX = endX - startX;
			moveY = endY - startY;
			angle = Math.atan2(moveY, moveX) * 180 / Math.PI;
			//alert(angle);
			
			if(slideT && Math.abs(angle) != 0){
				slideT = false;
				if(Math.abs(angle) < 45){ //prev
					move(-1);
				} else if(Math.abs(angle) > 135) { //next
					move(1);
				}
			}
		}
		
		function move(cnt) {
			
			var listSize = $(".bxControl ul li").length;
			var listIndex = 0;
			
			$(".bxControl ul li").each(function(idx) {
				if($(this).hasClass("on")) {
					listIndex = idx + cnt;
					return;
				}
			});
			
			if(listIndex < 0) {
				listIndex = (listSize-1);
			} else if(listIndex > (listSize-1)) {
				listIndex = 0;
			}
			
		    target.cycle(listIndex);
		    init();
		}
		
		function init(){
			target.find("li").css("width", target.width()+"px");
			target.find("li img").css("width", target.width()+"px");
			slideW = target.find("li:visible img").width();
			slideH = target.find("li:visible img").height()+ target.find("li:visible .bannerTxt").height();
			target.css("height",slideH+"px");
			target.find("li").css("height",slideH+"px");
			target.find("li:visible .bannerTxt").css("width", slideW);
			//console.log(slideH);
		}
		
		jQuery(window).resize(function(){ 
			init();
		});
			
	};
})(jQuery);