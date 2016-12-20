	document.write("<script language='javascript' src='/assets/js/util/common.js'></script>");
//滚动全局变量
var options = {
	  useEasing : true,
	  useGrouping : true,
	  separator : ',',
	  decimal : '.',
	  prefix : '',
	  suffix : ''
  };
	
	//益钱包投资金额
	var wallet_apply_amount=queryString("wallet_apply_amount");

//加载完毕
$(function(){
	
	var toast=localStorage.toast;
	if(toast!=null){
		localStorage.removeItem('toast');
		switch (toast) {
		case "2":
			Sys.showToast("转入成功");
			break;
		default:
		    break; 
		}
	}
	
     //获取会员益钱包收益详情
     getMyWalletDetail();
	//获取益钱包详情
    getWalletDetail();
	
	
     //投资方向
     $("#security_div,#tz_fx_div,#problem_div").click(function() {
          //跳转到相关页面
          window.location.href = $(this).data("hidden").replace("file:///android_asset/", "");
     });
             
	//如果投资过
    if (wallet_apply_amount != undefined && wallet_apply_amount != null && wallet_apply_amount != "") {
		setTimeout(function() {
			//添加动画
			$('.wallet_total div').addClass('wallet_at');
	
			$('#apply_amount_div').text("+" + wallet_apply_amount);
	
			setTimeout(function() {
	
				$('.wallet_total div').hide();
	
			}, 900);
		}, 1500);
	}
         
    //昨日收益
	$("#yesterday_sy_div").click(function() {
		$(".bombbox-black").show();
		$(".yday_gain").show();
	});
	
	//隐藏遮罩
	$(".bombbox-black,.define_btn").click(function() {
		$(".bombbox-black").hide();
		$(".yday_gain").hide();
	});
	
    $("a").click(function() {
	   //跳转到相关页面  url  是否需要登录
       if (refresh()) {
       	 	var $this=$(this);
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
       }else{
       		window.location.href = "login.html?return_url=" + $(this).data("hidden").replace("file:///android_asset/", "");
       }
   	});



});

//获取我的资金
function getMyWalletDetail(){

	$.getJSON('/getmywalletdetail',$.extend({},getRequestData()),function(data){
		if(0==data.error_code){
		    var obj = jQuery.parseJSON(data.detail);
		
		  	var demo1 = new countUp("memberWalletBx", 0, obj.SUM_BX, 2, 1, options);
		    demo1.start();
		
		    var demo2 = new countUp("walletYesterdaySy", 0, obj.YESTERDAY_SY, 2, 1, options);
		    demo2.start();
		
		    var demo3 = new countUp("walletSumSy", 0, obj.SUM_SY, 2, 1, options);
		    demo3.start();
		    
		    $("#walletYesterdayLx").text(formatMoney(obj.YESTERDAY_LX));
     		$("#walletYesterdayTx").text(formatMoney(obj.YESTERDAY_TX));
     		$("#walletYesterdayJx").text(formatMoney(obj.YESTERDAY_JX));
	   }else{
	   		requestError();
	   }
	}).error(function(){
		requestError();
	});
}

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

	//获取URL参数
	function queryString(item) {
	    var url = location.href;
		var sValue = url.match(new RegExp("[\?\&]" + item + "=([^\&]*)(\&?)", "i"))
		return sValue ? sValue[1] : sValue
	}
	
	document.getElementById("yesterday_sy_div").addEventListener("touchstart", touchStart, false);
	document.getElementById("yesterday_sy_div").addEventListener("touchmove", touchMove, false);
	document.getElementById("yesterday_sy_div").addEventListener("touchend", touchEnd, false);
	document.getElementById("yesterday_sy_div").addEventListener("touchcancel", touchCancel, false);
	
	
	
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