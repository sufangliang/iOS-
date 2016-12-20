	document.write("<script language='javascript' src='/assets/js/util/common.js'></script>");
	
	//加载完毕
	$(function(){
		//益定宝类型 1个月 或者 3个月
		var flag = queryString("flag");
		
		if(flag==3){
		    $("#lock_day").text("90");
		    $("#yearRate").text("12");
		}
		
		//投资定期
		$("a").click(function() {
			//跳转到相关页面  url  是否需要登录
			if (refresh()) {
				window.location.href = $(this).data("hidden").replace("file:///android_asset/", "") + "?flag=" + flag;
			} else {
				window.location.href = "login.html?return_url=" + $(this).data("hidden").replace("file:///android_asset/", "") + "?flag=" + flag;
			}
		});
		
	    //投资方向
	    $("#security_div,#tz_fx_div,#problem_div").click(function() {
             //跳转到相关页面
	        window.location.href = $(this).data("hidden").replace("file:///android_asset/", "");
        });
        
		//查询定期信息
		getDqByFlag(flag);
	});

	function getDqByFlag(flag){
		$.getJSON('/getdqbyflag', {flag:flag}, function(data) {
			if (0 == data.error_code) {
				var obj = jQuery.parseJSON(data.detail);
			    //起投金额
			    $("#min_num1").text(obj.min_num);
			    //$("#min_num2").text(obj.min_num);
			    $("#lock_day").text(obj.step);
			    $("#yearRate").text(obj.rate);
			}else{
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

