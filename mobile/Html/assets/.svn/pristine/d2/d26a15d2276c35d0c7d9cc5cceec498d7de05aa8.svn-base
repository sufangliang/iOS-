	document.write("<script language='javascript' src='/assets/js/util/common.js'></script>");
	//加载完毕
	$(function() {
	
		//投资定期
		$("a").click(function() {
			//跳转到相关页面
			if ($(this).data("login") && !refresh()) {
				window.location.href = "login.html?return_url=" + $(this).data("hidden").replace("file:///android_asset/", "") + "?flag=newbie";
			} else {
				window.location.href = $(this).data("hidden").replace("file:///android_asset/", "") + "?flag=newbie";
			}
	
		});
	
		//投资方向
		$("#security_div,#tz_fx_div,#problem_div").click(function() {
			//跳转到相关页面
			window.location.href = $(this).data("hidden").replace("file:///android_asset/", "") + "?flag=newbie";
		});
	
	
		//查询定期信息
		getDqByFlag("newbie");
	
		//判断用户是否为新手
		getMemberIsNewbie();
	});


	//定期信息
	function getDqByFlag(flag) {
		$.getJSON('/getdqbyflag', {flag: flag}, function(data) {
			if (0 == data.error_code) {
				var obj = jQuery.parseJSON(data.detail);
				$("#min_num").text(obj.min_num);
				$("#max_num").text(obj.max_num);
				$("#lock_day_1").text(obj.step);
				$("#lock_day_2").text(obj.step);
				$("#year_rate_1").text(obj.rate);
				$("#year_rate_2").text(obj.rate);
			} else {
				Sys.showToast(remoteMessage(data.error_code));
			}
		}).error(function() {
			requestError();
		});
	}

	//判断用户是否为新手
	function getMemberIsNewbie(){
		$.getJSON('/getmemberisnewbie', getRequestData(), function(data) {
			if (0 == data.error_code) {
				if(data.detail){
			        $('#goto_apply').show();
       				$('#goto_newbie').hide()
			    }else{
			    	$('#goto_apply').hide();
        			$('#goto_newbie').show();
			    }
			}else if(1 != data.error_code){
				Sys.showToast(remoteMessage(data.error_code));
			}
		}).error(function(){
	    	requestError();
	    });
	}
	document.getElementById("security_div").addEventListener("touchstart", touchStart, false);
	document.getElementById("security_div").addEventListener("touchmove", touchMove, false);
	document.getElementById("security_div").addEventListener("touchend", touchEnd, false);
	document.getElementById("security_div").addEventListener("touchcancel", touchCancel, false);
	
	
	document.getElementById("tz_fx_div").addEventListener("touchstart", touchStart, false);
	document.getElementById("tz_fx_div").addEventListener("touchmove", touchMove, false);
	document.getElementById("tz_fx_div").addEventListener("touchend", touchEnd, false);
	document.getElementById("tz_fx_div").addEventListener("touchcancel", touchCancel, false);
	
	
	document.getElementById("problem_div").addEventListener("touchstart", touchStart, false);
	document.getElementById("problem_div").addEventListener("touchmove", touchMove, false);
	document.getElementById("problem_div").addEventListener("touchend", touchEnd, false);
	document.getElementById("problem_div").addEventListener("touchcancel", touchCancel, false);
	
	
	
	function touchStart(event) {
	  this.style.background = "#e1e1e1";
	}
	
	function touchMove(event) {
	  this.style.background = "#FFF";
	}
	
	function touchEnd(event) {
	  this.style.background = "#FFF";
	}
	
	function touchCancel(event){
	  this.style.background = "#FFF";
	}



