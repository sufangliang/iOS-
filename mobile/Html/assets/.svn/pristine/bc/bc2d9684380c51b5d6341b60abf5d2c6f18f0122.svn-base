//加载完毕
$(function(){

    //获取最大的可提取金额
    Callback.getMyWalletMaxRedeem();

    //赎回
	$('#redeemButton').click(function() {
	   Callback.doWalletRedeem($('#amount').val(), $('#payPwd').val(), $('#maxRedeemAmount').val());
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

//获取我的最大赎回金额
function getMyWalletMaxRedeem(amount){
   $('#amount').attr("placeholder", "可赎回金额" + formatMoney(amount) + "元")
   //最大赎回金额
   $('#maxRedeemAmount').val(amount);
}