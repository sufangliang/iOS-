var interval = 60;


//加载完毕
$(function() {

  //获取当前手机号
  loadURL(wrapIosNativeCallback("getCurrentMobile"));


  $('#sendMsgButton').click(function() {
    if (interval == 60) {
      //发送短信验证码
      loadURL(wrapIosNativeCallback("getChangeLoginPasswordRandomSms", $('#mobile').val(), $('#pwd').val()));
    }

  });

  $('#sureButton').click(function() {
    loadURL(wrapIosNativeCallback("changeLoginPassword", $('#mobile').val(), $('#pwd').val(), $('#code').val()));
  });


   //监听 提交按钮
	 $("#mobile,#pwd,#code").bind("input propertychange",function(){
			 if( $("#mobile").val()!="" &&  $("#mobile").val().length>=11  &&  $("#pwd").val()!=""  &&  $("#code").val()!="" ){
				 $("#sureButton").removeAttr("disabled");
				 $("#sureButton").css("color","#fff");
                 $("#sureButton").css("background-color","#3399ff");
			 }else{
				 $("#sureButton").attr("disabled","disabled");
				 $("#sureButton").css("color","#d0e6ff");
                 $("#sureButton").css("background-color","#99ccff");
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


//获取当前手机号
function getCurrentMobile(data) {

   //如果已登录   手机号存在   只读
   if( data != undefined  && data != null  &&  data != "" ){
            $('#mobile').attr("type","text");
            $('#mobile').val(data);
            $('#mobile').attr("disabled","disabled");
            $("#sendMsgButton").removeAttr("disabled");
            $("#sendMsgButton").css("color","#fff");
            $("#sendMsgButton").css("background-color","#3399ff");
     }else{
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
     }
}

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
        loadURL(wrapIosNativeCallback("getChangeLoginPasswordRandomSms", $('#mobile').val(),$('#pwd').val()));
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