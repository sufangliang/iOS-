document.write("<script language='javascript' src='/assets/js/util/common.js'></script>");
//加载完毕
$(function() {
	
	
	//登录密码
    $("#loginPwdLi").click(function() {
    	if (refresh()) {
    		window.location.href =  $(this).data("hidden").replace("file:///android_asset/", "");
    	} else {
    		window.location.href =  "login.html?return_url=" + $(this).data("hidden").replace("file:///android_asset/", "");
    	}
    });
    
    //交易密码
    $("#payPwdLi").click(function() {
    	if (refresh()) {
    		if( $('#payPwd').text() == "未设置" || $('#payPwdLi').data('status') ){
    			window.location.href = $(this).data("hidden").replace("file:///android_asset/", "");
    		}else{
    			sessionStorage.status=0;
    			window.location.href = 'verify.html';
    		}
    	} else {
    		window.location.href = "login.html?return_url=" + $(this).data("hidden").replace("file:///android_asset/", "");
    	}
    });
	//获取我的账户
	getMyAccount();

	//获取我的信息
	getUser();
});



//获取我的账户
function getMyAccount() {
	$.getJSON('/getmyaccount', $.extend({}, getRequestData()), function(data) {
		var obj = jQuery.parseJSON(data.detail);
		//身份认证通过
		var havePayPwd = obj.HAVE_PAY_PWD;
		if (havePayPwd) {
			$('#payPwd').text("已设置");
		}else{
	        $('#payPwd').text("未设置");
	    }
	}).error(function(){
		requestError();
	});
}

//获取我的信息
function getUser() {
	$.getJSON('/getuser', getRequestData() , function(data) {
		var obj = jQuery.parseJSON(data.detail);
		//如果实名认证过
		if (obj.ID_CARD_STATUS == 0 || obj.ID_CARD_STATUS == 1) {
			$('#payPwdLi').data('status',true);
		}else{
			$('#payPwdLi').data('status',false);
		}
	}).error(function(){
		requestError();
	});
}


document.getElementById("loginPwdLi").addEventListener("touchstart", touchStart, false);
document.getElementById("loginPwdLi").addEventListener("touchmove", touchMove, false);
document.getElementById("loginPwdLi").addEventListener("touchend", touchEnd, false);


document.getElementById("payPwdLi").addEventListener("touchstart", touchStart, false);
document.getElementById("payPwdLi").addEventListener("touchmove", touchMove, false);
document.getElementById("payPwdLi").addEventListener("touchend", touchEnd, false);


function touchStart(event) {
  this.style.background = "#e1e1e1";
}

function touchMove(event) {
  this.style.background = "#FFF";
}

function touchEnd(event) {
  this.style.background = "#FFF";
}