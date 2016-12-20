	document.write("<script language='javascript' src='/assets/js/util/common.js'></script>");
	document.write("<script language='javascript' src='/assets/js/util/md5.js'></script>");
	
var interval = 60;

var inviteCode=queryString('inviteCode');

//从哪个入口进来的 订阅号菜单：1  微信扫一扫：0
var from=queryString('from')||"0";
	
	
//加载完毕
$(function() {
	history.replaceState({page: 1}, "title 1", "assets.html");
	
	//发送短信
	$('#sendMsgButton').click(function() {
 		var mobile = $("#mobile").val();
		if (Validate._mobile('mobile') && Validate._setpwd('pwd') && interval == 60) {
			$("#sendMsgButton").attr("disabled","disabled");
			//发送短信验证码
			$.getJSON('/getrandomsms',{mobile:mobile,reason:'register',_:Math.random()}, function(data) {
				if(data.error_code==0){
					getMobileCheckCode();
				}else{
					$("#sendMsgButton").removeAttr("disabled");
					Sys.showToast(remoteMessage(data.error_code));
				}
			}).error(function(){
    			requestError();
    		});
		}
	 });

	

	//注册
	$('#registerButton').click(function() {
		if ( Validate._mobile('mobile') && Validate._setpwd('pwd') && Validate._code('code')) {
			var pwd=CryptoJS.MD5($('#pwd').val()).toString();
			var mobile=$('#mobile').val()
			$.post('/register',{password:pwd,random:$('#code').val(),mobile:mobile,client:1,inviteCode:inviteCode,_:Math.random()},function(data){
				if(data.error_code==0){
					localStorage.signature=CryptoJS.MD5(mobile + " " + pwd).toString();
					localStorage.mobile=mobile;
					localStorage.pwd=pwd;
					if("1"==from){
						//订阅号菜单注册的直接到 Tab-理财页
						window.location.href = "index.html";
					}else{
						//微信扫一扫注册的跳到订阅号二维码页面让其关注
						window.location.href = "dyQrcode.html";
					}
				}else{
					Sys.showToast(remoteMessage(data.error_code));
				}
			}).error(function(){
    			requestError();
    		});
		}
	});


	//注册协议
	$('#registerProtocol').click(function() {
		window.location.href = "registerprotocol.html";
	});

	//服务条款
	$('#serviceProtocol').click(function() {
		window.location.href = "serviceprotocol.html";
	});

});

  	//监听 发送短信按钮
	$("#mobile").bind("input propertychange", function() {
		if ($("#mobile").val() != "" && $("#mobile").val().length >= 11) {
			$("#sendMsgButton").removeAttr("disabled");
			 $("#sendMsgButton").css("color","#fff");
			 $("#sendMsgButton").css("background-color","#3399ff");
		} else {
			$("#sendMsgButton").attr("disabled", "disabled");
			$("#sendMsgButton").css("color","#d0e6ff");
            $("#sendMsgButton").css("background-color","#99ccff");
		}
	});
	
	//监听 注册按钮
	$("#mobile,#pwd,#code").bind("input propertychange", function() {
		if ($("#mobile").val() != "" && $("#mobile").val().length >= 11 && $("#pwd").val() != "" && $("#code").val() != "") {
			$("#registerButton").removeAttr("disabled");
			$("#sendMsgButton").removeAttr("disabled");
			$("#registerButton").css("background-color","#3399ff");
		} else {
			$("#registerButton").attr("disabled", "disabled");
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
	
	// 设置倒计时button
	function getMobileCheckCode() {
		$("#sendMsgButton").attr("disabled","disabled");
		$("#sendMsgButton").unbind("click");
		$("#sendMsgButton").css("color","#d0e6ff");
	    $("#sendMsgButton").css("background-color","#99ccff");
		$("#sendMsgButton").val(interval + "秒后重发");
		timer = window.setInterval("msgInterval();", 1000);
	}


// 倒计时
function msgInterval() {

	// 倒计时结束
	if (interval == 0) {

		interval = 60;
		$("#sendMsgButton").removeAttr("disabled");
		$("#sendMsgButton").val("获取手机验证码");
 		$("#sendMsgButton").css("background-color","#3399ff");
 		
		$('#sendMsgButton').click(function() {
			var mobile = $("#mobile").val();
			var pwd = $("#pwd").val();
			 $("#sendMsgButton").css("color","#fff");
			if (Validate._setpwd('pwd') && Validate._mobile('mobile') && interval == 60) {
				//发送短信验证码
				$.getJSON('/getrandomsms',{mobile:mobile,reason:'register',_:Math.random()}, function(data) {
					if(data.error_code==0){
						getMobileCheckCode();
					}else{
						Sys.showToast(remoteMessage(data.error_code));
					}
				}).error(function(){
	    			requestError();
	    		});
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

	//获取URL参数
	function queryString(item) {
	    var url = location.href;
		var sValue = url.match(new RegExp("[\?\&]" + item + "=([^\&]*)(\&?)", "i"))
		return sValue ? sValue[1] : sValue
	}