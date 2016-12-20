//定期flag
var flag= 1;


//最小投资金额
var min_num = 50;
//最大投资金额
var max_num = 10000000;
//年利率
var rate=11;
//投资天数
var step=30;

var toRecharge = false;
var toRechargeAndApply = false;

//加载完毕
$(function() {
  
  flag = queryString("flag");
  
  if(flag==3){
     $("title").html("90天益定宝投资");
  }else if(flag=="newbie"){
       $("title").html("新手标投资");
  }
  
  //查询定期信息
  loadURL(wrapIosNativeCallback("getDqByFlag", flag));
  
  // 查询登陆状态
  refreshLoginState();

  //获取我的账户
  loadURL(wrapIosNativeCallback("getMyAccount"));

  //获取我的抽奖加息劵
  //Callback.getMyCjJxjResult();

 //定期投资
  $('#applyButton').click(function() {
    loadURL(wrapIosNativeCallback("doDqApply",$('#amount').val(), $('#payPwd').val(), $('#usebalance').val(), $('#have_pay_pwd').val(), $('#jxjListSelect').val(), flag, min_num, max_num, "false"));
  });

  //链接 去充值
  $('#toRecharge').click(function() {
    //跳转到充值页面  传入参数 充值金额
    toRecharge = true;
    loadURL(wrapIosNativeCallback("gotoLocalWebPage", $(this).data("hidden").replace("file:///android_asset/", ""),  $(this).data("login")));
  });
  
  //取消
  $('#doCancel,#bombbox1').click(function() {
  	$('#bombbox1').hide();
  	$('#bombbox2').hide();
  });
  
   //弹出框 去充值
    $('#gotoRecharge').click(function() {
             //跳转到相关页面  url  是否需要登录
        toRecharge = true;
        toRechargeAndApply = true;
	     var url = $(this).data("hidden").replace("file:///android_asset/", "");
	     loadURL(wrapIosNativeCallback("gotoLocalWebPage", url+"?recharge_amount="+restoreMoney($('#add_money').text()) , $(this).data("login")));
    });
    //全部
    $('#allButton').click(function() {
    	 $('#amount').val($('#usebalance').val());
	if($('#usebalance').val()==0){
        $('#yj_sy').text("0.00元");
        return;
    }
    	   //计算预期收益
	   loadURL(wrapIosNativeCallback("getExpectedIncome", $('#amount').val(),rate,step));
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


       //计算预计收益
      $("#amount").bind("input propertychange",function(){
             if($('#amount').val()==""||$('#amount').val()==null){
                 $('#yj_sy').text("0.00元");
                 return;
             }
             //计算预期收益
	     loadURL(wrapIosNativeCallback("getExpectedIncome", $('#amount').val(),rate,step));
      });

});



//定期信息
function getDqByFlag(data) {
    var obj = jQuery.parseJSON(data);
    min_num = obj.min_num;
    max_num = obj.max_num;
    rate = obj.rate;
    step = obj.step;
}

//预期收益
function getExpectedIncome(data) {
     $('#yj_sy').text(formatMoney(data)+"元");
}





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


//获取我的账户
function getMyAccount(data){

    jsLog("getMyAccount data = " + data);
  var obj = jQuery.parseJSON(data);

    $('#amount').attr("placeholder","账户余额"+formatMoney(obj.USE_BALANCE)+"元 至少转入"+min_num+"元");
     $('#amount').focus();

  $('#usebalance').val(obj.USE_BALANCE);
  $('#have_pay_pwd').val(obj.HAVE_PAY_PWD);


  //如果未设置交易密码
  if(!obj.HAVE_PAY_PWD){
      $('#payPwd_label').text("设置(6-20位数字+字母区分大小写)交易密码");
      $('#payPwd').attr("placeholder","密码将在每次交易时使用");
      $('#payPwd').css("background-color","#d6ebff");
  }


}

function onRechargeSuccess() {
    // 如果没有跳转充值界面并且没有点击弹出框的充值并转入界面
    if(!toRecharge && !toRechargeAndApply) {
        return;
    }
    
    //获取我的账户
    loadURL(wrapIosNativeCallback("getMyAccount"));
    
    if(toRechargeAndApply) {
        $('#bombbox1').hide();
        $('#bombbox2').hide();
        //刷新后掉用投资益定宝按钮
        loadURL(wrapIosNativeCallback("doDqApply", $('#amount').val(), $('#payPwd').val(), $('#usebalance').val(), $('#have_pay_pwd').val(), $('#jxjListSelect').val(), flag, min_num, max_num, "true"));
    }
}


//显示提示框  填充补充金额
function showHideBox(addMoney){
  //alert(addMoney);
  $('#add_money').text(formatMoney(addMoney));
  $('#bombbox1').show();
  $('#bombbox2').show();
}

//已登录
function refreshLogin(){
    
}

//未登录
function refreshNotLogin(){

}
