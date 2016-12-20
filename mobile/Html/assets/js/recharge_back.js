var timer=5;

var page_from=queryString("page_from");//页面点击入口
var recharge_amount=queryString("recharge_amount");//充值金额
//加载完毕
$(function() {
//     alert(page_from);
//     alert(recharge_amount);
	//发送广播 刷新
	//Callback.sendBroadcastRefresh();
	$('.return_wz>p').empty().append('<span id="timeout">5&nbsp;</span>秒后自动返回..');
	//定时任务
	myInterval = window.setInterval("timeout()", 1000);
});


//定时函数
function timeout() {
	--timer;
	if (0 == timer) {
	    //如果是从资产页面点击进入
	    if("assets"==page_from){
	          //销毁栈顶的充值页面 并且跳转到资金流水页面
              Callback.gotoTradeLogPage(recharge_amount);
	    }else{
	         //销毁栈顶的充值页面
          	 Callback.destroyPage("page_recharge");
	    }
		//清除定时任务
		window.clearInterval(myInterval);
	} else {
		document.getElementById('timeout').innerHTML = timer;
	}
}



//获取URL参数
function queryString(item) {
    var url = location.href;
	var sValue = url.match(new RegExp("[\?\&]" + item + "=([^\&]*)(\&?)", "i"))
	return sValue ? sValue[1] : sValue
}
