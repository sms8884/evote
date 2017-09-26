



//메뉴
	window.onload = function(){
		
	

		 $(".btn_headerMenu").click(function () {
			$(".menu,.page_cover,.page_cover2").addClass("open"); 
			$('.btn_headerMenu').hide();
			$('.close').show();
			
			//window.location.hash = "#open";
			});
	

			 $(".close").click(function ()  {
				$(".menu,.page_cover,.page_cover2").removeClass("open");
				$('.close').hide();
				$('.btn_headerMenu').show();
				$('.menulist1Box').hide();
			});

		


		//은평정책제안이란
		//리스트1누를때
			$(".menuli1").click(function () {
				$('.btn_headerMenu').hide();
				$('.close').show();
				$(".menu,.list1_tabs,.listPage_cover,.page_cover2").addClass("open"); /*20160622추가*/
				$('.menulist1Box').show();
				$('.list_close').show();
				$('.list1_tabwrap').show();
				
				return false; 	
			});

				$('.list_close').click(function () {
						$('.menulist1Box').hide();
						$('.listPage_cover,.page_cover2').removeClass("open"); /*20160622추가*/
				})



		
				//리스트2누를때 20160621추가
			$(".menuli2").click(function () {
				$('.btn_headerMenu').hide();
				$('.close').show();
				$(".menu,.list1_tabs,.listPage_cover,.page_cover2").addClass("open"); /*20160622추가*/
				$('.menulist2Box').show();
				$('.list1_tabwrap').show();
				
				return false; 	
			});

				$('.list2_close').click(function () {
						$('.menulist2Box').hide();
						$('.listPage_cover,.page_cover2').removeClass("open"); /*20160622추가*/
				})
				


	//리스트2누를때 20160621추가
			$(".menuli2").click(function () {
				$('.btn_headerMenu').hide();
				$('.close').show();
				$(".menu,.list1_tabs,.listPage_cover,.page_cover2").addClass("open"); /*20160622추가*/
				$('.menulist2Box').show();
				$('.list1_tabwrap').show();
				
				return false; 	
			});

			$('.list2_close').click(function () {
					$('.menulist2Box').hide();
					$('.listPage_cover,.page_cover2').removeClass("open"); /*20160622추가*/
			})


	//리스트3누를때 20160623추가
			$(".menuli3").click(function () {
				$('.btn_headerMenu').hide();
				$('.close').show();
				$(".menu,.list1_tabs,.listPage_cover,.page_cover2").addClass("open"); 
				$('.popup_voteshare').show();
				$('.list1_tabwrap').show();
				
				return false; 	
			});

			$('.list2_close').click(function () {
					$('.popup_voteshare').hide();
					$('.listPage_cover,.page_cover2').removeClass("open"); 
			})

			



	$(".menuli4").click(function () {	
		$('.btn_headerMenu').hide();
			$('.close').show();
			$(".menu,.list1_tabs,.listPage_cover,.page_cover2").addClass("open"); 
			$('.tutorialBoxWrap').show();
			$('.list1_tabwrap').show();
			$('.tutorialNomore').show();
			
			return false; 	
			});
		
		//튜토리얼 20160623추가

		 $(function(){
			 var num=0;
			 $('.btnBox2 a').click(function(){
				$('.btnBox2 a').removeClass('on');
				$(this).addClass('on');
				var num=$(this).parent().index();
				$('.tutorialImg').animate({left:-360*num},300);
			 })
			  
			 $('.btn_next').click(function(){
				num++;
				if(num==5)num=0;{
				$('.btnBox2 a').removeClass('on');
				$('.btnBox2 li:eq('+num+')').children('a').addClass('on');
				$('.tutorialImg').animate({left:-360*num},300);
				}
			}); 
			
			$('.btn_prev').click(function(){
				num--;
				if(num<0)num=4; 
				$('.btnBox2 a').removeClass('on');
				$('.btnBox2 li:eq('+num+')').children('a').addClass('on');
				$('.tutorialImg').animate({left:-360*num},300);
			})


		 });

		$('.list_closetuto').click(function () {
			$('.tutorialBoxWrap').hide();
			$('.listPage_cover,.page_cover2').removeClass("open"); 
		})

			

	
/*
			window.onhashchange = function () {
			if (location.hash != "#open" && $('.menulist1Box').attr('display','block')) {
				$(".menu,.page_cover").removeClass("open");
				$('.close').hide();
				$('.btn_headerMenu').show();
			}
		};
*/
	};

	
		//리스트탭
		function list1_tab1(num){	
			var f = $('.list1_tabs').find('li');
			
			for ( var i = 0; i < f.length; i++ ) {			
				if ( i == num) {	
					
					f.eq(i).addClass('activeTab');	
					$('.list_tab0' + i ).show();
					
				} else {
					f.eq(i).removeClass('activeTab');					
					$('.list_tab0' + i ).hide();							
				}
			}
		};

		//메뉴버튼..

		function menushow(){
			$(".menu,.page_cover,.page_cover2").addClass("open"); /*20160622추가*/
			$('.btn_headerMenu').hide();
			$('.close').show();
		};	

		 $(".close").click(function ()  {
			$(".menu,.page_cover,.page_cover2").removeClass("open");
			$('.close').hide();
			$('.btn_headerMenu').show();
			$('.menulist1Box').hide();
		});
			

	//정책제안투표 박스
 	function dropbox(){
		if($('.dropBoximg_down').attr("src")=="/resources/img/dropdown.png"){
				$('.dropBoximg_down').attr("src","/resources/img/dropup.png");	
				$('.header_dropDownBoxSub').show();
				$(".page_cover,.page_cover2").addClass("open");
		}else{
			$('.dropBoximg_down').attr("src","/resources/img/dropdown.png");
			$('.header_dropDownBoxSub').hide();
			$(".page_cover,.page_cover2").removeClass("open");
		}
	
	}

	//탭
	
	function tab_menu(num){	
		var f = $('.menu_tabHide').find('li');
		var f2 = $('.menu_tab').find('li');
		
		for ( var i = 0; i < f.length; i++ ) {			
			if ( i == num) {	
				f.eq(i).addClass('tabactive');	
				f2.eq(i).addClass('tabactive');	
				$('.menu_tab0' + i ).show();
				$('.tabactive').find('img').attr('src','/resources/img/tap'+i+'_on.png');
			} else {
				f.eq(i).removeClass('tabactive');					
				f2.eq(i).removeClass('tabactive');					
				$('.menu_tab0' + i ).hide();
				f.eq(i).find('img').attr('src','/resources/img/tap'+i+'_off.png');	
				f2.eq(i).find('img').attr('src','/resources/img/tap'+i+'_off.png');	
			}
	
		}
	};


var menu_tab_obj;
$(function(){
    menu_tab_obj = $('.menu_tab').html();
})

	//슬라이드시 박스보였다 안보이기
	var prevPosition = 0;
	$(document).on('scroll',function(event){
		var initPosition = $(this).scrollTop();
		if(initPosition>prevPosition){
			
		}
		

		prevPosition = initPosition;

		if($(document).scrollTop() > 130){
			$('.menu_tabHide').show();

			$('.header_dropDownBoxSub').hide();
			$('.menulist1Box').hide();
		/*	$('.showResultListBox').hide();*/
			$(".page_cover,.page_cover2").removeClass("open");
			$('.dropBoximg_down').attr("src","/resources/img/dropdown.png");
			$(".menu,.page_cover,.page_cover2").removeClass("open");
			$('.close').hide();
			$('.btn_headerMenu').show();
			$('.menulist2Box').hide();
			
		//	if($('.menu_tab')){
		//		$('.menu_tab').remove();
		//	}
		}else{
			$('.menu_tabHide').hide();
			//$('.menu_tab').removeClass('noshow');
		
		//	if(!$('.menu_tab')){
        //        $(".container").html( menu_tab_obj + $(".container").html() );
		//	}
		}
		
	});




	//투표완료하기
	
			function govoteResult2(){
				$('.page_cover,.page_cover2').addClass('open');
				$('.popup_voteEnd').show();
			};

			function btn_puCancle(){
				$('.popup_voteEnd').hide();
				$('.page_cover,.page_cover2').removeClass('open');
			}


			function puOk(){
				$('.popup_voteEndConfirm').show();
				$('.popup_voteEnd').hide();
				$('.page_cover,.page_cover2').addClass('open');
			}

			function puCancle2(){
				$('.popup_voteEndConfirm').hide();
				$('.page_cover,.page_cover2').removeClass('open');
			}

			function puCancle3(){
				$('.popup_voteshare').hide();
				$('.page_cover,.page_cover2').removeClass('open');
			}






	//투표결과보기

	function showResult(){
		$('.showResultListBox').show();
		$('.page_cover,.page_cover2').css('top','52px');
		$('.page_cover,.page_cover2').addClass('open');
		
	};
	
	function closeResultbox(){
		$('.showResultListBox').hide();
		$('.page_cover,.page_cover2').removeClass('open');
	};



	//join 성별선택
	function manOrwoman(){
			$('.btn_man,.btn_woman').toggleClass('selectActive');
	
	}
	


	
		//이용약관보기

	function terms1(){
		$('.popup_terms1').show();
		$('.page_cover,.page_cover2').addClass('open');
	};

	function terms2(){
		$('.popup_terms2').show();
		$('.page_cover,.page_cover2').addClass('open');
	};
	
	function terms3(){
		$('.popup_terms3').show();
		$('.page_cover,.page_cover2').addClass('open');
	};


	function termsClose1(){
		$('.popup_terms1').hide();
		$('.page_cover,.page_cover2').removeClass('open');
	};

	function termsClose2(){
		$('.popup_terms2').hide();
		$('.page_cover,.page_cover2').removeClass('open');
	};

	function termsClose3(){
		$('.popup_terms3').hide();
		$('.page_cover,.page_cover2').removeClass('open');
	};


//셀렉트 전체 선택
	function allSelect(){
		var checkedAll = document.getElementById('ck_step1All');
		var allCheck = document.getElementsByName('ck_step1Select');
		if(checkedAll.checked == true){
			for(var c = 0; c < allCheck.length; c++){
				allCheck[c].checked = true;
			}							
		}else{
			for(var c = 0; c < allCheck.length; c++){
				allCheck[c].checked = false;
			}						
		}
	}

	//회원투표참여방법 20160621추가
	function joinmethod(){
		$('.login2_box1Slide').slideToggle();
	};
	



	//회원투표참여방법 20160621추가
	function nojoinmethod(){
		$('.login2_box2Slide').slideToggle();
	};
	





	function termsClose(){
		$('this').parent().parent().hide();
	}


	function myinfoClose(){
		$('.menulist2Box').hide();
			$('.listPage_cover,.page_cover2').removeClass("open"); /*20160628추가*/
	}












