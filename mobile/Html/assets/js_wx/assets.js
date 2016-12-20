document.write("<script language='javascript' src='/assets/js/util/common.js'></script>");
document.write("<script language='javascript' src='/assets/js/formatutil.js'></script>");
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
$(function() {
	$('.container').css('margin-bottom', '49px');

	$('body').append('<div class="footer">' +
		'<div class="footer_nav_list">' +
		'<span class="footer_nav">' +
		'<a href="javascript:void(window.location.href=(&quot;index.html?_='+Math.random()+'&quot;))" class="nav_index nav_index"><i></i><em>理财</em></a>' +
		'</span>' +
		'<span class="footer_nav">' +
		'<a href="javascript:void(window.location.href=(&quot;assets.html?_='+Math.random()+'&quot;))" class="nav_assets  nav_assets_current"><i></i><em>资产</em></a>' +
		'</span>' +
		'<span class="footer_nav">' +
		'<a href="javascript:void(window.location.href=(&quot;me.html?_='+Math.random()+'&quot;))" class="nav_me"><i></i><em>我</em></a>' +
		'</span>' +
		'</div>' +
		'</div>');
	
	var toast=localStorage.toast;
	if(toast!=null){
		localStorage.removeItem('toast')
		switch (toast) {
		case "3":
			Sys.showToast("赎回成功");
			break;
		default:
		    break; 
		}
	}
	
	// 判断是否登录状态
	if (refresh()) {
		refreshLoginOk();
	} else {
		refreshNotLogin();
	}

	//菜单点击
	$(".quick-entry").click(function() {
		var $this=$(this);
		if($this.index()==0){
			$.getJSON('/gorecharge', function(data) {
				if(refresh()){
					if("0"==data.type){
						window.location.href = "recharge.html";
						
					}else{
						window.location.href = "recharge_bf.html";
					}
				}else{
					if("0"==data.type){
						window.location.href = "login.html?return_url=recharge.html";
					}else{
						window.location.href = "login.html?return_url=recharge_bf.html";
					}
				}
			});
		}else if($this.index()==2){
			if(refresh()){
				var money=new Number(restoreMoney($('#useBalance').text()));
				if(money>0){
					//查询实名认证
					$.getJSON('/getuser', $.extend({}, getRequestData()), function(data) {
						if (0 == data.error_code) {
							var obj = jQuery.parseJSON(data.detail);
							//如果未实名认证跳到实名认证
							if (obj.ID_CARD_STATUS != 0 && obj.ID_CARD_STATUS != 1) {
								localStorage.toast=0;
								window.location.href = "verify.html";
							}else{
								//查询是否设置了交易密码
								$.getJSON('/getmyaccount', getRequestData(), function(data) {
									if (0 == data.error_code) {
										var obj = jQuery.parseJSON(data.detail);
										if(obj.HAVE_PAY_PWD){
											window.location.href =  $this.data("hidden").replace("file:///android_asset/", "");
										}else{
											localStorage.toast=0;
											window.location.href="setting_pay_pwd.html";
										}
									}
								}).error(function(){
									requestError();
								});
							}
						}
					}).error(function(){
						requestError();
					});
				}else{
					Sys.showToast("您暂无可提现金额");
				}
			}else{
				window.location.href = "login.html?return_url=" + $this.data("hidden").replace("file:///android_asset/", "");
			}
		}else if ($(this).data("login") && !refresh()) {
			window.location.href = "login.html?return_url=" + $this.data("hidden").replace("file:///android_asset/", "");
		} else {
			window.location.href =  $this.data("hidden").replace("file:///android_asset/", "");
		}
	});

	//昨日收益
	$("#yesterday_sy_div").click(function() {
		if (refresh()) {
			$(".bombbox-black").show();
			$(".yday_gain").show();
			$("#pop_title").text("昨日收益");
			$("#yesterday_ul").show();
			$("#sum_sy_ul").hide();
		} else {
			window.location.href = "login.html?return_url=assets.html" ;
		}
	});
	
	//累计收益
	$("#all_sy_div").click(function() {
		if (refresh()) {
			$(".bombbox-black").show();
			$(".yday_gain").show();
			$("#pop_title").text("累计收益");
			$("#yesterday_ul").hide();
			$("#sum_sy_ul").show();
		} else {
			window.location.href = "login.html?return_url=assets.html" ;
		}
	});
	
	//影藏遮罩
	$(".bombbox-black,.define_btn").click(function() {
		$(".bombbox-black").hide();
		$(".yday_gain").hide();
	});
      
	//资金统计
	$("#myMoneyStatistics").click(function() {
		if (refresh()) {
			window.location.href = $(this).data("hidden").replace("file:///android_asset/", "");
		} else {
			window.location.href = "login.html?return_url=" + $(this).data("hidden").replace("file:///android_asset/", "");
		}
	});


});







//已登录
function refreshLoginOk() {
	//获取我的资金统计
	$.getJSON('/getmymoneystatistics',getRequestData(), function(data) {
		if (0 == data.error_code) {
			var obj = jQuery.parseJSON(data.detail);
	
			var demo1 = new countUp("sumBalance", 0, obj.sumBalance, 2, 1, options);
			demo1.start();
	
			var demo2 = new countUp("useBalance", 0, obj.useBalance, 2, 1, options);
			demo2.start();
	
			var demo3 = new countUp("walletYesterdaySy", 0, obj.walletYesterdaySy, 2, 1, options);
			demo3.start();
	
			var demo4 = new countUp("allSy", 0, obj.allSy, 2, 1, options);
			demo4.start();
			
			$("#walletYesterdayLx").text(formatMoney(obj.walletYesterdayLx));
	        $("#walletYesterdayTx").text(formatMoney(obj.walletYesterdayTx));
	        $("#walletYesterdayJx").text(formatMoney(obj.walletYesterdayJx));
	
	        $("#walletSumSy").text(formatMoney(obj.walletSumSy));
	        $("#dingSumSy").text(formatMoney(obj.dingSumSy));
	        
		}else{
			Sys.showToast("会话已失效,请重新登录");
			//localStorage.clear();
			refreshNotLogin();
		}
	}).error(function(){
		requestError();
	});
	
	var wallet_redeem_amount=localStorage.wallet_redeem_amount;
	 //如果赎回
	if (wallet_redeem_amount != undefined && wallet_redeem_amount != null && wallet_redeem_amount != "") {
		localStorage.removeItem('wallet_redeem_amount');
		$('#redeem_amount_div').text("+"+wallet_redeem_amount);
      	$('.assets_total .add_ac').show();
        setTimeout(function(){
      	 	 $('.assets_total .add_ac').hide();
        }, 3000 );
	}
	
}

//未登录
function refreshNotLogin() {
	$("#useBalance").text("0.00");
	$("#walletYesterdaySy").text("0.00");
	$("#allSy").text("0.00");
	localStorage.clear();
	
	$("#walletYesterdayLx").text("0.00");
	$("#walletYesterdayTx").text("0.00");
	$("#walletYesterdayJx").text("0.00");
	
	$("#walletSumSy").text("0.00");
	$("#dingSumSy").text("0.00");
	
	$('.assets_total').empty().append('<span class="white_arrow"></span><span id="sumBalance" style="line-height:115px;font-size:28px;">点击登陆</span>');
	
}






document.getElementById("div_recharge").addEventListener("touchstart", touchStart, false);
document.getElementById("div_recharge").addEventListener("touchmove", touchMove, false);
document.getElementById("div_recharge").addEventListener("touchend", touchEnd, false);


document.getElementById("div_trade_log").addEventListener("touchstart", touchStart, false);
document.getElementById("div_trade_log").addEventListener("touchmove", touchMove, false);
document.getElementById("div_trade_log").addEventListener("touchend", touchEnd, false);


document.getElementById("div_withdraw").addEventListener("touchstart", touchStart, false);
document.getElementById("div_withdraw").addEventListener("touchmove", touchMove, false);
document.getElementById("div_withdraw").addEventListener("touchend", touchEnd, false);


document.getElementById("div_wallet").addEventListener("touchstart", touchStart, false);
document.getElementById("div_wallet").addEventListener("touchmove", touchMove, false);
document.getElementById("div_wallet").addEventListener("touchend", touchEnd, false);

document.getElementById("div_ydb").addEventListener("touchstart", touchStart, false);
document.getElementById("div_ydb").addEventListener("touchmove", touchMove, false);
document.getElementById("div_ydb").addEventListener("touchend", touchEnd, false);

document.getElementById("div_news").addEventListener("touchstart", touchStart, false);
document.getElementById("div_news").addEventListener("touchmove", touchMove, false);
document.getElementById("div_news").addEventListener("touchend", touchEnd, false);



document.getElementById("yesterday_sy_div").addEventListener("touchstart", touchStart, false);
document.getElementById("yesterday_sy_div").addEventListener("touchmove", touchMove, false);
document.getElementById("yesterday_sy_div").addEventListener("touchend", touchEnd, false);
document.getElementById("yesterday_sy_div").addEventListener("touchcancel", touchCancel, false);


document.getElementById("all_sy_div").addEventListener("touchstart", touchStart, false);
document.getElementById("all_sy_div").addEventListener("touchmove", touchMove, false);
document.getElementById("all_sy_div").addEventListener("touchend", touchEnd, false);
document.getElementById("all_sy_div").addEventListener("touchcancel", touchCancel, false);

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


document.getElementById("myMoneyStatistics").addEventListener("touchstart", function (event) {
                                                                              this.style.background = "#d9733e";
                                                                            }, false);

document.getElementById("myMoneyStatistics").addEventListener("touchmove", function (event) {
                                                                             this.style.background = "#fd7500";
                                                                           }, false);

document.getElementById("myMoneyStatistics").addEventListener("touchend", function (event) {
                                                                            this.style.background = "#fd7500";
                                                                          }, false);

document.getElementById("myMoneyStatistics").addEventListener("touchcancel", function (event) {
                                                                          this.style.background = "#fd7500";
                                                                }, false);