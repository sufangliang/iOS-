//加载完毕
$(function() {

   // 查询登陆状态
  refreshLoginState();

  // 跳转到详细投资页面
  $("div[class='index_list_c']").click(function() {
    //跳转到相关页面  url  是否需要登录

    loadURL(wrapIosNativeCallback("gotoLocalWebPage", $(this).data("hidden").replace("file:///android_asset/", ""), $(this).data("login")));
  });


  //banner手势滑动
  $('#carousel-example-generic').hammer().on('swipeleft', function() {
    $(this).carousel('next');
  });

  $('#carousel-example-generic').hammer().on('swiperight', function() {
    $(this).carousel('prev');
  });

  //获取益钱包详情
  loadURL(wrapIosNativeCallback("getWalletDetail"));
  //定期30天
  loadURL(wrapIosNativeCallback("getDqByFlag", 1));
    //定期90天
    loadURL(wrapIosNativeCallback("getDqByFlag", 3));
    //新手标
    loadURL(wrapIosNativeCallback("getDqByFlag", "newbie"));
    //判断用户是否为新手
    loadURL(wrapIosNativeCallback("getMemberIsNewbie"));
});
//获取益钱包详情
function getWalletDetail(data){
 var obj = jQuery.parseJSON(data);
 //起投金额
 $('#min_num_wallet').text("￥"+obj.MIN_NUM);
}


//获取定期详情
function getDqByFlag(data){
    jsLog("getDqByFlag data = " + data);
 var obj = jQuery.parseJSON(data);
 if(obj.id==1){
     //30天定期起投金额
    $('#min_num_dq1').text("￥"+obj.min_num);
 }else if(obj.id==2){
     //90天定期起投金额
    $('#min_num_dq3').text("￥"+obj.min_num);
 }else if(obj.id==3){
      //新手标利息
      $('#rate_newbie').html(obj.rate+"<i>%</i>");
      //新手标天数
      $('#step_newbie').text(obj.step+"天");
       //新手标起投金额
      $('#min_num_newbie').text("￥"+obj.min_num);
   }

}


//判断用户是否为新手
function getMemberIsNewbie(data){
    jsLog("getMemberIsNewbie data = " + data);
    if("false"==data || "0" == data || data == 0){
      $('#newbie_div').hide();
    }else{
      $('#newbie_div').show();
    }
}

//已登录
function refreshLogin(){
    //判断用户是否为新手
    loadURL(wrapIosNativeCallback("getMemberIsNewbie"));
}

//未登录
function refreshNotLogin(){
    $('#newbie_div').show();
}

document.getElementById("touch_0").addEventListener("touchstart", touchStart, false);
document.getElementById("touch_0").addEventListener("touchmove", touchMove, false);
document.getElementById("touch_0").addEventListener("touchend", touchEnd, false);
document.getElementById("touch_0").addEventListener("touchcancel", touchCancel, false);

document.getElementById("touch_1").addEventListener("touchstart", touchStart, false);
document.getElementById("touch_1").addEventListener("touchmove", touchMove, false);
document.getElementById("touch_1").addEventListener("touchend", touchEnd, false);
document.getElementById("touch_1").addEventListener("touchcancel", touchCancel, false);

document.getElementById("touch_2").addEventListener("touchstart", touchStart, false);
document.getElementById("touch_2").addEventListener("touchmove", touchMove, false);
document.getElementById("touch_2").addEventListener("touchend", touchEnd, false);
document.getElementById("touch_2").addEventListener("touchcancel", touchCancel, false);

document.getElementById("touch_3").addEventListener("touchstart", touchStart, false);
document.getElementById("touch_3").addEventListener("touchmove", touchMove, false);
document.getElementById("touch_3").addEventListener("touchend", touchEnd, false);
document.getElementById("touch_3").addEventListener("touchcancel", touchCancel, false);


function touchStart(event) {
  this.style.background = "#e1e1e1";
}

function touchMove(event) {
  this.style.background = "#FFF";
}

function touchEnd(event) {
  this.style.background = "#FFF";
}

function touchCancel(event){
  this.style.background = "#FFF";
}
