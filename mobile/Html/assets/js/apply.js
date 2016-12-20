
//最小投资金额
var min_num = 10 ;

//加载完毕
$(function(){
    //获取益钱包详情
    Callback.getWalletDetail();
     //获取我的账户
    Callback.getMyAccount();
    //获取我的抽奖加息劵
    //Callback.getMyCjJxjResult();
    //转入
	$('#applyButton').click(function() {
       //转入益钱包  是否是刷新事件 false
	   Callback.doWalletApply($('#amount').val(), $('#payPwd').val(),$('#usebalance').val(),$('#have_pay_pwd').val(),$('#jxjListSelect').val(),min_num,"false");
	});

    //全部
	$('#allButton').click(function() {
    	  $('#amount').val($('#usebalance').val());
    	});

    //链接 去充值
    $('#toRecharge').click(function() {
          //跳转到充值页面  传入参数 充值金额
          Callback.gotoWebViewPage($(this).data("hidden")+"?page_from=apply", $(this).data("login"));
      });

    //取消
	$('#doCancel,#bombbox1').click(function() {
    	    $('#bombbox1').hide();
            $('#bombbox2').hide();
    	});



      //弹出框 去充值
    $('#gotoRecharge').click(function() {
             //跳转到相关页面  url  是否需要登录
            Callback.gotoWebViewPage($(this).data("hidden")+"?page_from=apply&recharge_amount="+restoreMoney($('#add_money').text()), $(this).data("login"));
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




//获取我的抽奖加息劵
function getMyCjJxjResult(data){
   var obj = jQuery.parseJSON(data);
   var myData = "<option value=''>不使用加息劵</option>";//拼html
    //遍历 json
    $.each(obj, function(index, item){
       myData +="<option value='"+item.id+"'>"+item.desp+item.stamp_end.substring(5,10)+"到期</option>";
    });
   $('#jxjListSelect').html(myData);
}




//获取益钱包详情
function getWalletDetail(data){
   var obj = jQuery.parseJSON(data);
   //最低转入金额
   min_num=obj.MIN_NUM;
}

//获取我的账户
function getMyAccount(data){

   var obj = jQuery.parseJSON(data);

   $('#amount').attr("placeholder","账户余额"+formatMoney(obj.USE_BALANCE)+"元 至少转入"+min_num+"元");
   $('#usebalance').val(obj.USE_BALANCE);
   $('#have_pay_pwd').val(obj.HAVE_PAY_PWD);

  //如果未设置交易密码
  if(!obj.HAVE_PAY_PWD){
      $('#payPwd_label').text("设置(6-20位数字+字母区分大小写)交易密码");
      $('#payPwd').attr("placeholder","密码将在每次交易时使用");
      $('#payPwd').css("background-color","#d6ebff");
  }

}






//显示提示框  填充补充金额
function showHideBox(addMoney){
  //alert(addMoney);
  $('#add_money').text(formatMoney(addMoney));
  $('#bombbox1').show();
  $('#bombbox2').show();
}





// 判断是否登录状态
function onResumeRefresh(){
   Callback.onResumeRefresh();
}

//已登录
function refreshLoginOk(){
    //获取我的账户
    Callback.getMyAccount();
    $('#bombbox1').hide();
    $('#bombbox2').hide();

    //刷新后掉用转入按钮  是否是刷新事件 true
    Callback.doWalletApply($('#amount').val(), $('#payPwd').val(),$('#usebalance').val(),$('#have_pay_pwd').val(),$('#jxjListSelect').val(),min_num,"true");

}

//未登录
function refreshNotLogin(){

}


