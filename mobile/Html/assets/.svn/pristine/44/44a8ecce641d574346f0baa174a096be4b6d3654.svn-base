//加载完毕
$(function(){

    //登录
	$('#loginButton').click(function() {
	   Callback.doLogin($('#username').val(), $('#pwd').val());
	});

   //注册
	$('#gotoRegister').click(function() {
    	 Callback.gotoWebViewPage("file:///android_asset/register.html", "false");
    });

    //忘记密码
    $('#gotoChangePassword').click(function() {
        	 Callback.gotoWebViewPage("file:///android_asset/setting_login_pwd.html", "false");
        });


     //安全
    $('#app_security').click(function() {
             Callback.gotoWebViewPage($(this).data("hidden"),$(this).data("login"));
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
