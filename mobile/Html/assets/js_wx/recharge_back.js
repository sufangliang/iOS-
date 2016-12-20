document.write("<script language='javascript' src='/assets/js/util/common.js'></script>");

var timer=3;
var recharge_amount=queryString("recharge_amount");//充值金额
var return_url=sessionStorage.return_url || 'tradelog.html?a=1';
$(function(){
	history.replaceState({page: 3}, "title 3", "assets.html");
	
	$('.return_wz>p').empty().append('<span id="timeout">3&nbsp;</span>秒后自动返回到首页..');
	var type=sessionStorage.type;
	//益钱包
	if(type == urlJson.wallet){
		$.post('/walletapply', $.extend(getRequestData(), {amount: sessionStorage.amount,signature: sessionStorage.paySignature,payPwd: sessionStorage.payPwd,cjResultId: sessionStorage.cjResultId,client: 1}), function(data) {
			if (0 == data.error_code) {
				localStorage.toast = 2;
				return_url = "my_wallet.html?wallet_apply_amount="+sessionStorage.amount;
				sessionStorage.clear();
			}
		}, 'json').error(function() {
			requestError();
		});
	}else if(type == urlJson.ydb){
		//益定宝
		$.post('/dqapply',$.extend(getRequestData(),{amount:sessionStorage.amount,signature:sessionStorage.paySignature,payPwd:sessionStorage.payPwd,cjResultId:sessionStorage.cjResultId,client:1,flag:sessionStorage.flag}),function(data){
    		if (0 == data.error_code) {
    			localStorage.toast=2;
    			return_url = "my_ydb.html?ydb_apply_amount="+sessionStorage.amount;
    			sessionStorage.clear();
    		}
    	},'json').error(function(){
			requestError();
		});
	}else{
		sessionStorage.removeItem('return_url');
		return_url+="&recharge_amount="+recharge_amount;
	}
	
	setInterval("timeout()", 1000);
	
	
});

function timeout(){
	
	timer=--timer;
	if(timer==0){
		window.location.href = return_url;
	}else{
		document.getElementById('timeout').innerHTML=timer;
	}
}

//获取URL参数
function queryString(item) {
    var url = location.href;
	var sValue = url.match(new RegExp("[\?\&]" + item + "=([^\&]*)(\&?)", "i"))
	return sValue ? sValue[1] : sValue
}