//<![CDATA[
	function changeItem(idx,mode){
		$("#pagingList a.active").removeClass("active");
		$("#pagingList a:eq("+idx+")").addClass("active");		
		$(".bannerList").stop();
		if(mode == "left"){
			var menuWidth = parseInt($(".bxContainer").css("width"));
			$(".bannerList").animate(
				{
					"left":"-"+(idx*menuWidth)+"px"
				},
				600,
				"easeOutQuart"
			);
		}
	}
	function bannerMake(mode){
		if(mode = "left"){	
			$(".bannerList li:hidden").show();
			$(".bannerList").css(
				{
					"position":"absolute",
					"left":"0px",
					"top":"0px",
					"width":$(".bxContainer").css("width"),
				}
			);
			var menuWidth = parseInt($(".bxContainer").css("width"));
			$(".bannerList").css("width",(menuWidth*$(".bannerList li").length)+"px");
			$(".bannerList li").css(
				{
					"float":"left",
					"width":$(".bxContainer").css("width")
				}
			);
		}
		$("#pagingList a").each(
			function(index,obj){
				$(obj).data("idx",index);
				$(obj).click(
					function(e){
						e.preventDefault(); 
						changeItem($(this).data("idx"),mode);
					}
				);
			}
		);
		$(".bx_next").click(
			function(e){
				e.preventDefault(); 
				var temp = $("#pagingList a.active").data("idx")+1;
				if(temp>$("#pagingList a").length-1){ 
					temp = 0;
				}
				changeItem(temp,mode);
			}
		);	
		$(".bx_prev").click(
			function(e){
				e.preventDefault(); 
				var temp = $("#pagingList a.active").data("idx")-1;
				if(temp<0){
					temp = $("#pagingList a").length-1;
				}
				changeItem(temp,mode);
			}
		);
		$(".bx_next,.bx_prev").mouseenter(
			function(){
				$('.bx_next,.bx_prev').addClass("show");
			}
		);
		$(".bx_next,.bx_prev").mouseleave(
			function(){
				$('.bx_next,.bx_prev').removeClass("show");
			}
		);
	}
	
  //]]>