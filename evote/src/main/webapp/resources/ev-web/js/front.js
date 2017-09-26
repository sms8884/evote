// gnb, lnb - menu
jQuery(function($){
	$.fn.topmenu = function(options) {
		var opts = $.extend(options);
		var topmenu = $(this);
		var topmenuList = topmenu.find('>li');
		var submenu = topmenu.find('.gnbSub');
		var submenuList = submenu.find('>li');
		submenu.hide();
		function showMenu() {
			t = $(this).parent('li');
			if(!t.hasClass('active')){
				submenu.show();
			}else{
				submenu.show();
			}
			$('.gnbSubBg').show();
		}

		function hideMenu() {
			submenu.hide();
			activeMenu();
			$('.gnbSubBg').hide();
		}

		function activeMenu() {
			if(opts.d1 == 0){
				if(opts.d2 == 0) {
					return;
				}else{
					$('.lnb>ul>li').eq(opts.d2-1).find('>a').addClass('on').next('ul').show();
				}
			}else{
				t = topmenuList.eq(opts.d1-1);
				topmenuList.removeClass('active');
				t.addClass('active');
				if(opts.d2 == 0) {
					return false;
				}else{
					t.find('.gnbSub>li').eq(opts.d2-1).find('a').addClass('on');
					$('.lnb>ul>li').eq(opts.d2-1).find('>a').addClass('on').next('ul').show();
					if(opts.d3 == 0) {
						return false;
					}else{
						$('.lnb>ul>li>ul>li').eq(opts.d3-1).find('>a').addClass('on');
					}
				}
			}
		}

		return this.each(function() {
			activeMenu();
			$('.gnbSubBg').hide();
			topmenuList.find('>a').mouseover(showMenu).focus(showMenu);
			topmenuList.on('mouseover focus',function(){
				$('.gnbSubBg').show();
			})
			topmenuList.on('mouseout blur',function(){
				$('.gnbSubBg').hide();
			})
			topmenu.mouseleave(hideMenu);
			$('#container').mouseover(hideMenu);
			$('#container').find('a').eq(0).focus(hideMenu);
			$('.top').find('a').focus(hideMenu);
		});

	}
});



$(document).ready(function(){
	// tab
	var btn = $("#tab .tabBt");
	var list = $("#tab .tabBt .tab_cont");
	btn.on('click',function(){
		list.hide().eq($(this).index()).show();
		btn.removeClass("on").eq($(this).index()).addClass("on");
	});
	btn.eq(0).addClass("on");
	list.hide();
	list.eq(0).show();

	$('.toggleCon').hide();
	$('.toggleBt>input').on('click',function(){
		if ($(this).is(':checked')){
			$(this).parent().addClass('toggleOn');
			$(this).parent().next('.toggleCon').show();
		}else{
			$(this).parent().removeClass('toggleOn');
			$(this).parent().next('.toggleCon').hide();
		}
	})


	$(".ellipsis").ellipsis();
	$(".voteBox").each(function(){
		$(this).find('.chk').ellipsis();
	})

	$('.rList').each(function(){
		$(this).find('.more').each(function(){
			$(this).on('click',function(){
				if ($(this).hasClass('on')){
					$(this).removeClass('on').next('.moreBox').hide();
				}else{
					$(this).addClass('on').next('.moreBox').show();
				}
				return false;
			})
		})
	})
	
	$(function(){
			$('.member_leave').hide();
			$('.memberLbtn[href^="#"]').on('click',function(){
				var popmemberL = $(this).attr('rel');
				var popmemberURL = $(this).attr('href');
						
				var query1= popmemberURL.split('?');
				var dim1= query1[1].split('&');
				var popWidth1 = dim1[0].split('=')[1];

				$('.' + popmemberL).fadeIn().css({ 'width': Number( popWidth1 ) });
				
				var popTop = $('.' + popmemberL).height() / 1;
				var popLeft = $('.' + popmemberL).width() /	-10;
				
				$('.' + popmemberL).css({
					'margin-top' : -popTop,
					'margin-left' : -popLeft
				});
				$('body').append('<div class="fade"></div>');
					$('.fade').css({'filter' : 'alpha(opacity=80)'}).fadeIn();
					return false;
			});

			$('a.layerClose3, a.layerClose').click(function(){
			$('.fade, .member_leave').fadeOut(function(){
				$('.fade').remove();
			});
			return false;
		});
	});

	$('a.layer[href^="#"]').on('click',function(){
		var popID = $(this).attr('rel');
		var popURL = $(this).attr('href');
				
		var query= popURL.split('?');
		var dim= query[1].split('&');
		var popWidth = dim[0].split('=')[1];

		$('.' + popID).fadeIn().css({ 'width': Number( popWidth ) });
		
		var popMargTop = $('.' + popID).height() / 2;
		var popMargLeft = $('.' + popID).width() / 2;
		
		$('.' + popID).css({
			'margin-top' : -popMargTop,
			'margin-left' : -popMargLeft
		});
		$('body').append('<div class="fade"></div>');
		$('.fade').css({'filter' : 'alpha(opacity=80)'}).fadeIn();
		return false;
	});

	$('a.layerClose, a.layerClose2').click(function(){
		$('.fade, .layer_block').fadeOut(function(){
			$('.fade').remove();
		});
		return false;
	});


	/*테이블 마지막 보더값 없애기*/
	$('.boardList').find('table tr th:last-child').css("border-right","none");
	$('.boardList').find('table tr td:last-child').css("border-right","none");
	$('.boardView').find('table tr td:last-child').css("border-right","none");
	$('.boardWrite').find('table tr td:last-child').css("border-right","none");


	$('.btAgree').click(function(e){
		e.preventDefault;
		if($('.btAgree > span').hasClass('agree') == false){
			$('.btAgree > span').addClass('agree');
		}else{
			$('.btAgree > span').removeClass('agree');
		}	
	});
	$('.btNotAgree').click(function(e){
		e.preventDefault;
		if($('.btNotAgree > span').hasClass('agree') == false){
			$('.btNotAgree > span').addClass('agree');
		}else{
			$('.btNotAgree > span').removeClass('agree');
		}	
	});


})


	