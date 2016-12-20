//加载完毕
$(function() {
  //获取我的账户
  loadURL(wrapIosNativeCallback("getMyAccount"));

  $('#withdrawButton').click(function() {
    loadURL(wrapIosNativeCallback("withdraw", $('#amount').val(), $('#payPwd').val(), $('#usebalance').val()));
  });

  //全部
  $('#allButton').click(function() {
    $('#amount').val($('#usebalance').val());
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

//获取我的账户
function getMyAccount(data) {

  var obj = jQuery.parseJSON(data);

  $('#amount').attr("placeholder", "账户余额" + formatMoney(obj.USE_BALANCE) + "元");

  $('#usebalance').val(obj.USE_BALANCE);
}