
//滚动全局变量
var options = {
	  useEasing : true,
	  useGrouping : true,
	  separator : ',',
	  decimal : '.',
	  prefix : '',
	  suffix : ''
  };


//加载完毕
$(function(){

   //获取益钱包统计
   Callback.getAboutWallet();


   //获取益钱包详情
   Callback.getWalletDetail();


    //判断是否登录状态
   Callback.onResumeRefresh();


    $("a").click(function() {
          	 //跳转到相关页面  url  是否需要登录
              Callback.gotoWebViewPage($(this).data("hidden"),$(this).data("login"));
          });

   //投资方向
   $("#security_div,#tz_fx_div,#problem_div").click(function() {
             //跳转到相关页面
            Callback.gotoWebViewPage($(this).data("hidden"),$(this).data("login"));
        });

});

//获取益钱包统计
function getAboutWallet(data){

    var obj = jQuery.parseJSON(data);

  	var demo1 = new countUp("apply_count", 0, obj.APPLY_COUNT, 0, 1, options);
    demo1.start();

    var demo2 = new countUp("sum_lx", 0, obj.SUM_LX, 2, 1, options);
    demo2.start();

    var demo3 = new countUp("applyed_bj", 0, obj.APPLYED_BJ, 2, 1, options);
    demo3.start();
}


//获取益钱包详情
function getWalletDetail(data){
 var obj = jQuery.parseJSON(data);
 //起投金额
 $('#min_num').text(obj.MIN_NUM);
}


// 判断是否登录状态
function onResumeRefresh(){
   //alert(2222);
   Callback.onResumeRefresh();
   //获取益钱包统计
   //Callback.getAboutWallet();
}


//已登录
function refreshLoginOk(){
   //alert(222);
    $('#notlogin').hide();
    $('#hadlogin').show();

}

//未登录
function refreshNotLogin(){
    $('#notlogin').show();
    $('#hadlogin').hide();
}




document.getElementById("security_div").addEventListener("touchstart", touchStart, false);
document.getElementById("security_div").addEventListener("touchmove", touchMove, false);
document.getElementById("security_div").addEventListener("touchend", touchEnd, false);
document.getElementById("security_div").addEventListener("touchcancel", touchCancel, false);


document.getElementById("tz_fx_div").addEventListener("touchstart", touchStart, false);
document.getElementById("tz_fx_div").addEventListener("touchmove", touchMove, false);
document.getElementById("tz_fx_div").addEventListener("touchend", touchEnd, false);
document.getElementById("tz_fx_div").addEventListener("touchcancel", touchCancel, false);


document.getElementById("problem_div").addEventListener("touchstart", touchStart, false);
document.getElementById("problem_div").addEventListener("touchmove", touchMove, false);
document.getElementById("problem_div").addEventListener("touchend", touchEnd, false);
document.getElementById("problem_div").addEventListener("touchcancel", touchCancel, false);



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
