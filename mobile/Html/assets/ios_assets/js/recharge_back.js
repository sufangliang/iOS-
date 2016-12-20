var js2NativeSplit = ":@:";
var timer=5;
var callbackparam = queryString("callbackparam");

//加载完毕
$(function(){
	$('.return_wz>p').empty().append('<span id="timeout">5&nbsp;</span>秒后自动返回..');
  //定时任务
  myInterval = window.setInterval("timeout()", 1000);
});

function timeout(){

	--timer;
	if(0 == timer){
        if(callbackparam == "1") {
            loadURL(wrapIosNativeCallback("onRechargeSuccess"));
        } else {
            loadURL(wrapIosNativeCallback("backAndDestroy"));
            loadURL(wrapIosNativeCallback("onRechargeSuccess"));
        }
        
        //清除定时任务
        window.clearInterval(myInterval);
	}else{
		document.getElementById('timeout').innerHTML=timer;
	}
}

function wrapIosNativeCallback() {
    var callback = "js2native";
    
    for (var i = 0; i < arguments.length; i++) {
        callback = callback + js2NativeSplit + arguments[i];
    }
    
    return callback;
}

function loadURL(url) {
    var iFrame;
    iFrame = document.createElement("iframe");
    iFrame.setAttribute("src", url);
    iFrame.setAttribute("style", "display:none;");
    iFrame.setAttribute("height", "0px");
    iFrame.setAttribute("width", "0px");
    iFrame.setAttribute("frameborder", "0");
    document.body.appendChild(iFrame);
    // 发起请求后这个 iFrame 就没用了，所以把它从 dom 上移除掉
    iFrame.parentNode.removeChild(iFrame);
    iFrame = null;
}

//获取URL参数
function queryString(item) {
    var url = location.href;
    var sValue = url.match(new RegExp("[\?\&]" + item + "=([^\&]*)(\&?)", "i"))
    return sValue ? sValue[1] : sValue
}