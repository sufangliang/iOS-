	document.write("<script language='javascript' src='/assets/js/util/common.js'></script>");
	document.write("<script language='javascript' src='/assets/js/util/md5.js'></script>");
	
	var interval = 60;
	
	$(function(){
		getUser();
		
		//获取当前手机号
	    var data = getMobile();
	
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
     
		$('#sendMsgButton').click(function() {
			if (Validate._setpwd('pwd')&&interval == 60) {
				$("#sendMsgButton").attr("disabled","disabled");
				$.getJSON('/getrandomsms', $.extend({reason:'changepassword',mobile:$('#mobile').val()},getRequestData()), function(data) {
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
		
		
		$('#sureButton').click(function() {
			//$('#frmSetpwd').submit();
			if (Validate._setpwd('pwd')&&Validate._code('code')) {
				var pwd=CryptoJS.MD5($('#pwd').val()).toString();
				$.post('/changeloginpassword', $.extend({password:pwd,random:$('#code').val(),mobile:$('#mobile').val()},getRequestData()), function(data){
					if(data.error_code==0){
						if(localStorage.mobile==null){
							localStorage.mobile=$('#mobile').val();
						}
						localStorage.signature=CryptoJS.MD5(localStorage.mobile + " " + pwd).toString();
						localStorage.pwd=pwd;
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
 	
	
	//获取我的信息
	function getUser() {
		$.getJSON('/getuser', $.extend({}, getRequestData()), function(data) {
			if (0 == data.error_code) {
				var obj = jQuery.parseJSON(data.detail);
				$('#mobile').attr("type","text");
	            $('#mobile').attr("disabled","disabled");
				$('#mobile').val(obj.MOBILE);
			}
		});
	}
	
	
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
    
	// 设置倒计时button
	function getMobileCheckCode() {
		//点击之后 不能再点击
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
			$("#sendMsgButton").css("color","#fff");
			$("#sendMsgButton").css("background-color","#3399ff");
			
			$('#sendMsgButton').click(function() {
				
				if (Validate._setpwd('pwd')&&interval == 60) {
					$.getJSON('/getrandomsms', $.extend({reason:'changepassword',mobile:$('#mobile').val()},getRequestData()), function(data) {
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