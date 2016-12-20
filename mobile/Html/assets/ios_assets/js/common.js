var js2NativeSplit = ":@:";
var debug = true;

function wrapIosNativeCallback() {
	var callback = "js2native";

	for (var i = 0; i < arguments.length; i++) {
		callback = callback + js2NativeSplit + arguments[i];
	}

	// alert(callback);

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

// 登陆状态
function refreshLoginState() {
    loadURL(wrapIosNativeCallback("refreshLoginState"));
}

function onRefreshLoginState(state) {
    jsLog("onRefreshLoginState state = " + state);
    
    if(state == true || "true" == state || "1" == state) {
        refreshLogin();
    } else {
        refreshNotLogin();
    }
}

function jsLog(info) {
    if(!debug){
        return;
    }
    loadURL(wrapIosNativeCallback("jsLog", info));
}

//获取URL参数
function queryString(item) {
    var url = location.href;
    var sValue = url.match(new RegExp("[\?\&]" + item + "=([^\&]*)(\&?)", "i"))
    return sValue ? sValue[1] : sValue
}