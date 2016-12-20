var interval = 60;

//加载完毕
$(function() {

  //发送短信
  $('#sendMsgButton').click(function() {
    if (interval == 60) {
      //发送短信验证码
      loadURL(wrapIosNativeCallback("getRandomSms", $("#mobile").val(), $("#pwd").val()));
    }

  });

  //注册
  $('#registerButton').click(function() {
    //alert($("#regBox").attr('checked'));
    //如果未选中同意框
    if (!$('#regBox').is(':checked')) {
      //alert($("#regBox").attr('checked'));
      loadURL(wrapIosNativeCallback("tips", "请同意《益大家注册协议》及《益大家服务条款》"));
      return;
    }
    loadURL(wrapIosNativeCallback("register", $('#mobile').val(), $('#pwd').val(), $('#code').val()));

  });


  //注册协议
  $('#registerProtocol').click(function() {
    loadURL(wrapIosNativeCallback("gotoLocalWebPage", "registerprotocol.html", "false"));
  });

  //服务条款
  $('#serviceProtocol').click(function() {
    loadURL(wrapIosNativeCallback("gotoLocalWebPage", "serviceprotocol.html", "false"));
  });


       //监听 发送短信按钮
	 $("#mobile").bind("input propertychange",function(){
			 if( $("#mobile").val()!=""  &&  $("#mobile").val().length>=11 ){
				 $("#sendMsgButton").removeAttr("disabled");
				 $("#sendMsgButton").css("color","#fff");
                 $("#sendMsgButton").css("background-color","#3399ff");
			 }else{
				 $("#sendMsgButton").attr("disabled","disabled");
				 $("#sendMsgButton").css("color","#d0e6ff");
                 $("#sendMsgButton").css("background-color","#99ccff");
			 }
		});

	  //监听 注册按钮
	 $("#mobile,#pwd,#code").bind("input propertychange",function(){
			 if( $("#mobile").val()!="" &&  $("#mobile").val().length>=11  &&  $("#pwd").val()!=""  &&  $("#code").val()!="" ){
				 $("#registerButton").removeAttr("disabled");
				 $("#registerButton").css("color","#fff");
                 $("#registerButton").css("background-color","#3399ff");
			 }else{
				 $("#registerButton").attr("disabled","disabled");
				 $("#registerButton").css("color","#d0e6ff");
                 $("#registerButton").css("background-color","#99ccff");
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



// 设置倒计时button
function getMobileCheckCode() {
    //点击之后 不能再点击
	$("#sendMsgButton").attr("disabled","disabled");
	$("#sendMsgButton").unbind("click");
	$("#sendMsgButton").css("color","#d0e6ff");
    $("#sendMsgButton").css("background-color","#99ccff");
	$("#sendMsgButton").val(interval+"秒后重发");
	timer = window.setInterval("msgInterval();", 1000);

}



// 倒计时
function msgInterval() {

  // 倒计时结束
  if (interval == 0) {

    interval = 60;
    $("#sendMsgButton").removeAttr("disabled");
    $("#sendMsgButton").val("获取手机验证码");
    $("#sendMsgButton").css("color","#fff");
    $("#sendMsgButton").css("background-color","#3399ff");
    $('#sendMsgButton').click(function() {
      if (interval == 60) {
        //发送短信验证码
        loadURL(wrapIosNativeCallback("getRandomSms", $("#mobile").val(), $("#pwd").val()));
      }

    });

    window.clearInterval(timer);

  } else {
    $("#sendMsgButton").attr("disabled","disabled");
    $("#sendMsgButton").unbind("click");
    $("#sendMsgButton").css("color","#d0e6ff");
    $("#sendMsgButton").css("background-color","#99ccff");
    if (isNaN(interval) || isNaN(interval - 1)) {
      $("#sendMsgButton").val("获取手机验证码");
    } else {
      interval = interval - 1;
      $("#sendMsgButton").val(interval + "秒后重发");
    }
  }
}