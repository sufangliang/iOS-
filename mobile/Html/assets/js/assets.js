
//滚动全局变量
var options = {
	  useEasing : true,
	  useGrouping : true,
	  separator : ',',
	  decimal : '.',
	  prefix : '',
	  suffix : ''
  };

//登录状态默认 未登录
var loginState=false;


//加载完毕
$(function(){
    //判断是否登录状态
     Callback.refresh();

    //菜单点击
    $("div[class='col-xs-4 quick-entry']").click(function() {
             //跳转到相关页面  url  是否需要登录
            Callback.gotoWebViewPage($(this).data("hidden"),$(this).data("login"));
        });


     //资金统计
     $("#myMoneyStatistics").click(function() {
                 //跳转到相关页面  url  是否需要登录
                Callback.gotoWebViewPage($(this).data("hidden"),$(this).data("login"));
            });

      //昨日收益
      $("#yesterday_sy_div").click(function(){
          //如果未登录则拦截
           if(!loginState){
              //跳转到相关页面  url  是否需要登录
              Callback.gotoWebViewPage($(this).data("hidden"),$(this).data("login"));
              return;
           }
           $(".bombbox-black").show();
           $(".yday_gain").show();
           $("#pop_title").text("昨日收益");
           $("#yesterday_ul").show();
           $("#sum_sy_ul").hide();
      });

      //累计收益
      $("#all_sy_div").click(function(){
             //如果未登录则拦截
             if(!loginState){
                   Callback.gotoWebViewPage($(this).data("hidden"),$(this).data("login"));
                   return;
               }
              $(".bombbox-black").show();
              $(".yday_gain").show();
              $("#pop_title").text("累计收益");
              $("#yesterday_ul").hide();
              $("#sum_sy_ul").show();
          });


      //影藏遮罩
      $(".bombbox-black,.define_btn").click(function(){
          $(".bombbox-black").hide();
          $(".yday_gain").hide();
      });


     
});


// 判断是否登录状态
//function onResumeRefresh(){
//   alert('a');
//   Callback.onResumeRefresh();
//
//}

// 判断是否登录状态
function onResumeRefresh(wallet_redeem_amount){
   //alert('onResumeRefresh2');
   Callback.onResumeRefresh();
  //如果赎回
   if(wallet_redeem_amount!=undefined && wallet_redeem_amount!=null && wallet_redeem_amount!=""){
            $('#redeem_amount_div').text("+"+wallet_redeem_amount);
            $('.assets_total .add_ac').show();
             setTimeout(function(){
                $('.assets_total .add_ac').hide();
            }, 3000 );

   }

}

//已登录
function refreshLoginOk(){
     //获取我的资金统计
     Callback.getMyMoneyStatistics();
     loginState=true;

}

//未登录
function refreshNotLogin(){
      $("#sumBalance").text("0.00");
      $("#useBalance").text("0.00");
      $("#walletYesterdaySy").text("0.00");
      $("#allSy").text("0.00");

      $("#walletYesterdayLx").text("0.00");
      $("#walletYesterdayTx").text("0.00");
      $("#walletYesterdayJx").text("0.00");

      $("#walletSumSy").text("0.00");
      $("#dingSumSy").text("0.00");

       loginState=false;
}



//获取我的资金
function getMyMoneyStatistics(data){

        var obj = jQuery.parseJSON(data);

    	var demo1 = new countUp("sumBalance", 0, obj.sumBalance, 2, 1, options);
    	demo1.start();

        var demo2 = new countUp("useBalance", 0, obj.useBalance, 2, 1, options);
        demo2.start();


        var demo3 = new countUp("walletYesterdaySy", 0, obj.walletYesterdaySy, 2, 1, options);
        demo3.start();

        var demo4 = new countUp("allSy", 0, obj.allSy, 2, 1, options);
        demo4.start();

        $("#walletYesterdayLx").text(formatMoney(obj.walletYesterdayLx));
        $("#walletYesterdayTx").text(formatMoney(obj.walletYesterdayTx));
        $("#walletYesterdayJx").text(formatMoney(obj.walletYesterdayJx));

        $("#walletSumSy").text(formatMoney(obj.walletSumSy));
        $("#dingSumSy").text(formatMoney(obj.dingSumSy));


}




document.getElementById("div_recharge").addEventListener("touchstart", touchStart, false);
document.getElementById("div_recharge").addEventListener("touchmove", touchMove, false);
document.getElementById("div_recharge").addEventListener("touchend", touchEnd, false);
document.getElementById("div_recharge").addEventListener("touchcancel", touchCancel, false);




document.getElementById("div_trade_log").addEventListener("touchstart", touchStart, false);
document.getElementById("div_trade_log").addEventListener("touchmove", touchMove, false);
document.getElementById("div_trade_log").addEventListener("touchend", touchEnd, false);
document.getElementById("div_trade_log").addEventListener("touchcancel", touchCancel, false);



document.getElementById("div_withdraw").addEventListener("touchstart", touchStart, false);
document.getElementById("div_withdraw").addEventListener("touchmove", touchMove, false);
document.getElementById("div_withdraw").addEventListener("touchend", touchEnd, false);
document.getElementById("div_withdraw").addEventListener("touchcancel", touchCancel, false);



document.getElementById("div_wallet").addEventListener("touchstart", touchStart, false);
document.getElementById("div_wallet").addEventListener("touchmove", touchMove, false);
document.getElementById("div_wallet").addEventListener("touchend", touchEnd, false);
document.getElementById("div_wallet").addEventListener("touchcancel", touchCancel, false);



document.getElementById("div_ydb").addEventListener("touchstart", touchStart, false);
document.getElementById("div_ydb").addEventListener("touchmove", touchMove, false);
document.getElementById("div_ydb").addEventListener("touchend", touchEnd, false);
document.getElementById("div_ydb").addEventListener("touchcancel", touchCancel, false);




document.getElementById("div_news").addEventListener("touchstart", touchStart, false);
document.getElementById("div_news").addEventListener("touchmove", touchMove, false);
document.getElementById("div_news").addEventListener("touchend", touchEnd, false);
document.getElementById("div_news").addEventListener("touchcancel", touchCancel, false);


document.getElementById("yesterday_sy_div").addEventListener("touchstart", touchStart, false);
document.getElementById("yesterday_sy_div").addEventListener("touchmove", touchMove, false);
document.getElementById("yesterday_sy_div").addEventListener("touchend", touchEnd, false);
document.getElementById("yesterday_sy_div").addEventListener("touchcancel", touchCancel, false);


document.getElementById("all_sy_div").addEventListener("touchstart", touchStart, false);
document.getElementById("all_sy_div").addEventListener("touchmove", touchMove, false);
document.getElementById("all_sy_div").addEventListener("touchend", touchEnd, false);
document.getElementById("all_sy_div").addEventListener("touchcancel", touchCancel, false);



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


document.getElementById("myMoneyStatistics").addEventListener("touchstart", function (event) {
                                                                              this.style.background = "#d9733e";
                                                                            }, false);

document.getElementById("myMoneyStatistics").addEventListener("touchmove", function (event) {
                                                                             this.style.background = "#fd7500";
                                                                           }, false);

document.getElementById("myMoneyStatistics").addEventListener("touchend", function (event) {
                                                                            this.style.background = "#fd7500";
                                                                          }, false);

document.getElementById("myMoneyStatistics").addEventListener("touchcancel", function (event) {
                                                                          this.style.background = "#fd7500";
                                                                }, false);









