	document.write("<script language='javascript' src='/assets/js/util/common.js'></script>");
	document.write("<script language='javascript' src='/assets/js/util/md5.js'></script>");
	document.write("<script language='javascript' src='/assets/static/js/idcardcheck.js'></script>");
	
var interval = 60;

//加载完毕
$(function() {
	
	var toast=localStorage.toast;
	if(toast!=null){
		localStorage.removeItem('toast');
		switch (toast) {
		//asset.js 资产tab页进行提现时还未设置交易密码
		case "0":
			Sys.showToast("请先设置交易密码");
			break;
		default:
		    break; 
		}
	}
		
	//获取我的信息
	getUser();
	//获取我的账户
	getMyAccount();
	
	$('#sendMsgButton').click(function() {
		if ( ($('#have_pay_pwd').data('notSed')||Validate._idCard('idCard')) && Validate._setpwd('pwd') && interval == 60) {
			$("#sendMsgButton").attr("disabled","disabled");
			//发送短信验证码
			$.getJSON('/getrandomsms', $.extend(getRequestData(),{reason:'changepaypassword'}), function(data) {
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

	//提交  修改交易密码
	$('#sureButton').click(function() {
		if( ($('#have_pay_pwd').data('notSed')||Validate._idCard('idCard')) && Validate._setpwd('pwd') && Validate._code('code')){
			var pwd=CryptoJS.MD5($('#pwd').val()).toString();
			var idcard=CryptoJS.MD5($('#idCard').val()).toString();
			$.post('/changepaypassword', $.extend(getRequestData(),{password:pwd,random:$('#code').val(),idcard:idcard}), function(data){
				if(data.error_code==0){
					localStorage.toast=4;
					window.location.href = "index.html";
				}else{
					Sys.showToast(remoteMessage(data.error_code));
				}
			},'json').error(function(){
    			requestError();
    		});
		}
	});

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



//获取我的信息
function getUser() {
	$.getJSON('/getuser', $.extend({}, getRequestData()), function(data) {
		var obj = jQuery.parseJSON(data.detail);
		$('#mobile').val(obj.MOBILE);
	}).error(function(){
		requestError();
	});
}

	//获取我的账户
	function getMyAccount(){
		$.ajax({  
	        type:'GET',  
	        url:'/getmyaccount',  
	        data:getRequestData(),  
	        dataType:'json',  
	        cache : false,
	        async : false,  //异步执行为false
	        success:function(data){  
	            var obj = jQuery.parseJSON(data.detail);
				//是否设置过交易密码
				$('#have_pay_pwd').val(obj.HAVE_PAY_PWD);
				
				//如果未设置交易密码
				if (!obj.HAVE_PAY_PWD) {
					$('#idCardDiv').hide();
				    $('#pwdLabel').text("交易密码");
				    $('#pwd').attr("placeholder","请输入6-20个数字+字母，区分大小写");
				    $('#have_pay_pwd').data('notSed',true);
				}
	        },error:function(){
	    		requestError();
	        }
	    });  
	}


// 设置倒计时button
function getMobileCheckCode() {
	//点击之后 不能再点击
	 $("#sendMsgButton").attr("disabled","disabled");
	$("#sendMsgButton").unbind("click");
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

		$('#sendMsgButton').click(function() {

			if ( ($('#have_pay_pwd').data('notSed')||Validate._idCard('idCard')) && Validate._setpwd('pwd') &&interval == 60) {
				$.getJSON('/getrandomsms', $.extend(getRequestData(),{reason:'changepaypassword'}), function(data) {
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

		if (isNaN(interval) || isNaN(interval - 1)) {
			$("#sendMsgButton").val("获取手机验证码");
		} else {
			interval = interval - 1;
			$("#sendMsgButton").val(interval + "秒后重发");
		}
	}
}