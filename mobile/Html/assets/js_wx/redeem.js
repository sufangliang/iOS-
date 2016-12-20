	document.write("<script language='javascript' src='/assets/js/util/common.js'></script>");
	document.write("<script language='javascript' src='/assets/js/util/md5.js'></script>");
	
//加载完毕
$(function(){
	
	history.replaceState({page: 4}, "title 4", "assets.html");
	
	/*
	 * ajax不异步执行.从上而下
	 */
	//获取最大的可提取金额
	$.ajax({  
        type:'GET',  
        url:'/getmywalletmaxredeem',  
        data:getRequestData(),  
        dataType:'json',  
        cache : false,
        async : false,  //异步执行为false
        success:function(data){  
           $('#amount').attr("placeholder", "可赎回金额" + formatMoney(data.amount) + "元");
		    //最大赎回金额
		    $('#maxRedeemAmount').val(data.amount);
        },error:function(){
    		requestError();
        }
    });  
	    
	//赎回
	$('#redeemButton').click(function() {
		if(Validate._redeem('amount','maxRedeemAmount')&&Validate._pwd('payPwd')){
			var payPwd=CryptoJS.MD5(getMobile() + " " + getpwd() + " " + CryptoJS.MD5($('#payPwd').val()).toString()).toString();
			$.post('/redeemwallet',$.extend(getRequestData(),{amount:$('#amount').val(),signature:payPwd,client:1}),function(data){
				if (0 == data.error_code) {
					localStorage.toast=3;
					localStorage.wallet_redeem_amount=$('#amount').val();
					window.location.href="assets.html";
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
     $('#amount').val($('#maxRedeemAmount').val());
   });

	    //眼睛
   $("#toggle_eye").click(function(){
        $("#toggle_eye").toggleClass("show_eye");
         if("password"==$("#payPwd").attr("type")){
           $("#payPwd").attr("type","text");
        }else if("text"==$("#payPwd").attr("type")){
           $("#payPwd").attr("type","password");
        }
         $("#payPwd").focus();
     });
});

