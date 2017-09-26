$(document).ready(function(){
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

	$('.ellipsisAr').find('.elli').each(function(){
		$(this).dotdotdot({
			watch: "window"
		});
	})
	$('.elli2').dotdotdot({
		watch: "window"
	})

	$('.topFixBt').on('click',function(){
		$('body, html').animate({ scrollTop:0}, 500);
		return false;
	})
})



