	document.write("<script language='javascript' src='/assets/js/util/common.js'></script>");
	
	//滚动全局变量
	var options = {
		useEasing: true,
		useGrouping: true,
		separator: ',',
		decimal: '.',
		prefix: '',
		suffix: ''
	};


	//加载完毕
	$(function(){



	    $("a").click(function() {
	    	var $this=$(this);
			//跳转到相关页面  url  是否需要登录
			if (refresh()) {
				if ($this.text() == "赎回") {
					$.getJSON('/getmywalletmaxredeem', getRequestData(), function(data) {
						if (0 == data.error_code) {
							var amount=new Number(data.amount);
							if(amount>0){
								window.location.href = $this.data("hidden").replace("file:///android_asset/", "");
							}else{
								Sys.showToast("您的益钱包无可赎回金额");
							}
						}else{
							requestError();
						}
					}).error(function() {
						requestError();
					});
				} else {
					window.location.href = $(this).data("hidden").replace("file:///android_asset/", "");
				}
			} else {
				if (($this.text() != "赎回") && ($this.text() != "转入") && ($this.text() != "立即投资")) {
					window.location.href = $this.data("hidden").replace("file:///android_asset/", "");
				}else{
					window.location.href = "login.html?return_url=about_wallet.html";
				}
			}
		});

 		//投资方向
	    $("#security_div,#tz_fx_div,#problem_div").click(function() {
             //跳转到相关页面
	        window.location.href = $(this).data("hidden").replace("file:///android_asset/", "");
        });

		//获取益钱包统计
		$.getJSON('/getwalletstatistics',$.extend({},getRequestData()),function(data){
			if (0 == data.error_code) {
				var obj = jQuery.parseJSON(data.detail);
				
		   		var demo1 = new countUp("apply_count", 0, obj.APPLY_COUNT, 0, 1, options);
			    demo1.start();
			
			    var demo2 = new countUp("sum_lx", 0, obj.SUM_LX, 2, 1, options);
			    demo2.start();
			
			    var demo3 = new countUp("applyed_bj", 0, obj.APPLYED_BJ, 2, 1, options);
			    demo3.start();
			}else{
				requestError();
			}
		}).error(function(){
			requestError();
		});


		//判断是否登录状态
		if(refresh()){
			refreshLoginOk();
		};


		//获取益钱包详情
    	getWalletDetail();
	});


	function getWalletDetail(){
		$.getJSON('/getwalletdetail', getRequestData() ,function(data) {
			if (0 == data.error_code) {
				var obj = jQuery.parseJSON(data.detail);
				$('#min_num').text(obj.MIN_NUM);
			}
		}).error(function(){
			requestError();
		});
	}
	//已登录
	function refreshLoginOk(){
	    $('#notlogin').hide();
	    $('#hadlogin').show();
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