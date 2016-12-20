//加载完毕
$(function() {

  $("li").click(function() {
    //跳转到相关页面  url  是否需要登录
    loadURL(wrapIosNativeCallback("gotoLocalWebPage", $(this).data("hidden").replace("file:///android_asset/", ""), $(this).data("login")));
  });

  //获取我的账户
  loadURL(wrapIosNativeCallback("getMyAccount"));

});



//获取我的账户
function getMyAccount(data){
     var obj = jQuery.parseJSON(data);
     //交易密码已设置
      var havePayPwd = obj.HAVE_PAY_PWD;
      if(havePayPwd){
         $('#payPwd').text("已设置");
      }else{
        $('#payPwd').text("未设置");
      }

}

document.getElementById("loginPwdLi").addEventListener("touchstart", touchStart, false);
document.getElementById("loginPwdLi").addEventListener("touchmove", touchMove, false);
document.getElementById("loginPwdLi").addEventListener("touchend", touchEnd, false);


document.getElementById("payPwdLi").addEventListener("touchstart", touchStart, false);
document.getElementById("payPwdLi").addEventListener("touchmove", touchMove, false);
document.getElementById("payPwdLi").addEventListener("touchend", touchEnd, false);


function touchStart(event) {
  this.style.background = "#e1e1e1";
}

function touchMove(event) {
  this.style.background = "#FFF";
}

function touchEnd(event) {
  this.style.background = "#FFF";
}