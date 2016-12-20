	document.write("<script language='javascript' src='/assets/js/util/common.js'></script>");
	document.write("<script language='javascript' src='/assets/js/util/md5.js'></script>");
//加载完毕
$(function() {
	
	history.replaceState({page: 5}, "title 5", "assets.html");
	
	getMyAccount();
	
   $('#withdrawButton').click(function() {
   		//$('#frmWithdraw').submit();
   		if(Validate._withdraw('amount','usebalance')&&Validate._pwd('payPwd')){
   			var payPwd=CryptoJS.MD5(getMobile() + " " + getpwd() + " " + CryptoJS.MD5($('#payPwd').val()).toString()).toString();
		   	$.post('/withdraw',$.extend(getRequestData(),{amount:$('#amount').val(),signature:payPwd}),function(data){
		   		if (0 == data.error_code) {
		   			//localStorage.toast=1;
		   			window.location.href = "tradelog.html?withdraw_amount="+$('#amount').val();
		   		} else {
		   			Sys.showToast(remoteMessage(data.error_code));
		   		}
		   	},'json').error(function(){
				requestError();
			});
   		}
   });

   //全部
   $('#allButton').click(function() {
   	$('#amount').val($('#usebalance').val());
   });

});

    //眼睛
	$("#toggle_eye").click(function() {
		$("#toggle_eye").toggleClass("show_eye");
		if ("password" == $("#payPwd").attr("type")) {
			$("#payPwd").attr("type", "text");
		} else if ("text" == $("#payPwd").attr("type")) {
			$("#payPwd").attr("type", "password");
		}
		$("#payPwd").focus();
	});
	
//获取我的账户
function getMyAccount() {
	$.ajax({  
        type:'GET',  
        url:'/getmyaccount',  
        data:getRequestData(),  
        dataType:'json',  
        cache : false,
        async : false,  //异步执行为false
        success:function(data){  
            var obj = jQuery.parseJSON(data.detail);
			$('#amount').attr("placeholder", "账户余额" + formatMoney(obj.USE_BALANCE) + "元");
			$('#usebalance').val(obj.USE_BALANCE);
        },error:function(){
    		requestError();
        }
    });  
}

