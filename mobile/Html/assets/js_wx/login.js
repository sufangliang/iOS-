	document.write("<script language='javascript' src='/assets/js/util/common.js'></script>");
	document.write("<script language='javascript' src='/assets/js/util/md5.js'></script>");
	
	var return_url =queryString('return_url');
	
//加载完毕
$(function() {
	
	history.replaceState({page: 1}, "title 1", "assets.html");
	
	$('#loginButton').click(function() {
		//$('#frmLogin').submit();
		if(Validate._mobile('username')&&Validate._pwd('pwd')){
			var mobile = $('#username').val();
			var pwd = $('#pwd').val();
			var signature = CryptoJS.MD5(mobile + " " + CryptoJS.MD5(pwd).toString()).toString();
			$.post('/login', {
				mobile: mobile,
				signature: signature,
				client:1
			}, function(data) {
				if (0 == data.error_code) {
					localStorage.signature=signature;
					localStorage.mobile=mobile;
					localStorage.pwd=CryptoJS.MD5(pwd).toString();
					if(return_url!=null){
						window.location.href=return_url;
					}else{
						window.location.href="assets.html";
					}
				} else {
					Sys.showToast(remoteMessage(data.error_code));
				}
			}, 'json').error(function(){
    			requestError();
    		});
		};
	});

	$('#gotoRegister').click(function() {
		window.location.href = "register.html";
	});

	$('#gotoChangePassword').click(function() {
		window.location.href = "setting_login_pwd.html";
	});
	
	//安全
    $('#app_security').click(function() {
         window.location.href = $(this).data("hidden").replace("file:///android_asset/", "");
    });

});

	




      //监听 输入框文本改变  当用户名登录密码都填写后 登录按钮 可用 否则禁用
	 $("#username,#pwd").bind("input propertychange",function(){
            if( $("#username").val()!=""  &&  $("#pwd").val()!="" ){
                $("#loginButton").removeAttr("disabled");
                 $("#loginButton").css("color","#fff");
                 $("#loginButton").css("background-color","#3399ff");
            }else{
                $("#loginButton").attr("disabled","disabled");
                 $("#loginButton").css("color","#d0e6ff");
                $("#loginButton").css("background-color","#99ccff");
            }
		});
		
	
	//眼睛
	$("#toggle_eye").click(function() {
		$("#toggle_eye").toggleClass("show_eye");
		if ("password" == $("#pwd").attr("type")) {
			$("#pwd").attr("type", "text");
		} else if ("text" == $("#pwd").attr("type")) {
			$("#pwd").attr("type", "password");
		}
		$("#pwd").focus();
	});
         
//获取URL参数
function queryString(item) {
	var sValue = location.search.match(new RegExp("[\?\&]" + item + "=([^\&]*)(\&?)", "i"))
	return sValue ? sValue[1] : sValue
}