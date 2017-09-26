$(document).ready(function(){
	$('.lnbmenuDl dt').on('click',function(){
			if($(this).hasClass('dton')){
				$(this).removeClass("dton");
				$(this).next().hide();
			}else{
				$('.lnbmenuDl dt.dton').next().hide();
				$('.lnbmenuDl dt.dton').removeClass('dton');
				$(this).addClass("dton");
				$(this).next().show();
			}	
		});


	$('.lnbmenuDl dd ul li a').mouseenter(function(){
			$(this).parent().addClass('ddon');
	});
	$('.lnbmenuDl dd ul li a').mouseleave(function(){
			$(this).parent().removeClass('ddon');
	});

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

	



});
	
	
	
	function moveUp(el){
		var $tr = $(el).parent().parent(); // 클릭한 버튼이 속한 tr 요소
		$tr.prev().before($tr); // 현재 tr 의 이전 tr 앞에 선택한 tr 넣기
	}

	function moveDown(el){
		var $tr = $(el).parent().parent(); // 클릭한 버튼이 속한 tr 요소
		$tr.next().after($tr); // 현재 tr 의 다음 tr 뒤에 선택한 tr 넣기
	}

	function moveTop(el){
		var $tr = $(el).parent().parent();
		$('.voteBoard tbody').prepend($tr); 
	}

	function moveBottom(el){
		var $tr = $(el).parent().parent();
		$('.voteBoard tbody').append($tr); 
	}


	num=0;
	function addFile(){
		num++;
		var addBox = $('.addFile').clone();
		$(addBox).appendTo('.newFile').removeClass('addFile').addClass('addFile'+num).css('padding','3px 0');
	}



