//加载完毕
$(function() {

	$('#loginButton').click(function() {
		loadURL(wrapIosNativeCallback("login", $('#username').val(), $('#pwd').val()));
	});

	$('#gotoRegister').click(function() {
		loadURL(wrapIosNativeCallback("gotoLocalWebPage", "register.html", "false"));
	});

	$('#gotoChangePassword').click(function() {
		loadURL(wrapIosNativeCallback("gotoLocalWebPage", "setting_login_pwd.html", "false"));
	});

  	//安全
    $('#app_security').click(function() {
        loadURL(wrapIosNativeCallback("gotoLocalWebPage", $(this).data("hidden").replace("file:///android_asset/", ""), $(this).data("login")));
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
      $("#toggle_eye").click(function(){
            $("#toggle_eye").toggleClass("show_eye");
            if("password"==$("#pwd").attr("type")){
               $("#pwd").attr("type","text");
            }else if("text"==$("#pwd").attr("type")){
               $("#pwd").attr("type","password");
            }
             $("#pwd").focus();
         });

});