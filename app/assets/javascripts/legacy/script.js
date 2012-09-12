 $(function(){
		
	$("#account .tabs a").click(function () {			
		$("#account .tabs a.active").removeClass("active").parent().removeClass("active");			
		$(this).addClass("active").parent().addClass("active");			
		$("#account .tab-box").hide();
		var content_show = $(this).attr("rel");
		$("#"+content_show).fadeIn();	
		
		return false;
	});
	
	$("#activity .tabs a").click(function () {			
		$("#activity .tabs a.active").removeClass("active").parent().removeClass("active");			
		$(this).addClass("active").parent().addClass("active");			
		$("#activity .tab-box").hide();
		var content_show = $(this).attr("rel");
		$("#"+content_show).fadeIn();	
		
		return false;
	});
	
	$('#trail-list ul').jScrollPane();
});