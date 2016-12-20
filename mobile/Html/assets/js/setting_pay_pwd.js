

var interval = 60;

//加载完毕
$(function(){

  //获取我的信息
  Callback.getUser();

  //获取我的账户
  Callback.getMyAccount();


 $('#sendMsgButton').click(function() {
        if(interval==60){
				//发送短信验证码
				Callback.getChangePayPasswordRandomSms($('#idCard').val(),$('#pwd').val(),$('#have_pay_pwd').val());
        	}

  	});


  //提交  修改交易密码
  $('#sureButton').click(function() {
  	   Callback.doChangePayPassword($('#idCard').val(),$('#pwd').val(), $('#code').val(),$('#have_pay_pwd').val());
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





//获取我的信息
function getUser(data){

   var obj = jQuery.parseJSON(data);

   $('#mobile').val(obj.MOBILE);

}



//获取我的账户
function getMyAccount(data){

   var obj = jQuery.parseJSON(data);

   //是否设置过交易密码
   $('#have_pay_pwd').val(obj.HAVE_PAY_PWD);


  //如果未设置交易密码
  if(!obj.HAVE_PAY_PWD){
      $('#idCardDiv').hide();
      $('#pwdLabel').text("交易密码");
      $('#pwd').attr("placeholder","请输入6-20个数字+字母，区分大小写");
      // $('#pwd').css("background-color","#d6ebff");
      //$('#paw_pwd_message').show();
  }

}


// 设置倒计时button
function getMobileCheckCode() {
    //点击之后 不能再点击
    $("#sendMsgButton").attr("disabled","disabled");
	$("#sendMsgButton").unbind("click");
	$("#sendMsgButton").val(interval+"秒后重发");
	timer = window.setInterval("msgInterval();", 1000);

}



// 倒计时
function msgInterval() {
    // 倒计时结束
	if (interval == 0) {
	     interval=60;
         $("#sendMsgButton").removeAttr("disabled");
		 $("#sendMsgButton").val("获取手机验证码");
		 $('#sendMsgButton').click(function() {
				if(interval==60){
					//发送短信验证码
                     Callback.getChangePayPasswordRandomSms($('#idCard').val(),$('#pwd').val(),$('#have_pay_pwd').val());
					}

			});
		 window.clearInterval(timer);
	}else{
	    $("#sendMsgButton").attr("disabled","disabled");
		$("#sendMsgButton").unbind("click");
		if (isNaN(interval) || isNaN(interval - 1)  ){
        		$("#sendMsgButton").val("获取手机验证码");
        }else{
        		interval = interval - 1;
        		$("#sendMsgButton").val(interval+"秒后重发");
        	}
	}
}
