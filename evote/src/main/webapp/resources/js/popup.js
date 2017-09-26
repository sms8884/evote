//<![CDATA[
	$(document).ready(
		function(){
			$("#popupBtn").click(
				function(){
					
					$("body").css(
						{
							"overflow":"auto",
							"margin-right":"18px"
						}
					);
					$("body").append("<div id='shadow'></div>");
					
					$("#shadow").click(
						function(){
							$("#layerPop").hide();
							$("#shadow").remove();
							$("body").css(
								{
									"overflow":"visible",
									"margin-right":"0px"
								}
							);
						}
					);
					$(".closeBtn").click(
						function(){
							$("#shadow").trigger("click");
						}
					);
					$("#layerPop").css(
						{
							position:"absolute",
							top:"50px",
							left:"50%",
							marginLeft:-parseInt($("#layerPop").css("width"))/2
						}
					);
					$("#layerPop").show();

				}
			);
			$("#popupBtn").trigger('click');


		}	
	);
  //]]>