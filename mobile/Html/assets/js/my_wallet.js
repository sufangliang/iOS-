
//滚动全局变量
var options = {
	  useEasing : true,
	  useGrouping : true,
	  separator : ',',
	  decimal : '.',
	  prefix : '',
	  suffix : ''
  };

//益钱包投资金额
var wallet_apply_amount=queryString("wallet_apply_amount");

//加载完毕
$(function(){


     //获取会员益钱包收益详情
     Callback.getMyWalletDetail();

     //获取益钱包详情
     Callback.getWalletDetail();


     $("a").click(function() {
             //跳转到相关页面  url  是否需要登录
               Callback.gotoWebViewPage($(this).data("hidden"),$(this).data("login"));
          });


     //投资方向
      $("#security_div,#tz_fx_div,#problem_div").click(function() {
                  //跳转到相关页面
                 Callback.gotoWebViewPage($(this).data("hidden"),$(this).data("login"));
             });

     //如果投资过
     if(wallet_apply_amount!=undefined && wallet_apply_amount!=null && wallet_apply_amount!=""){

             setTimeout(function(){
                            //添加动画
                           $('.wallet_total div').addClass('wallet_at');

                            $('#apply_amount_div').text("+"+wallet_apply_amount);

                            setTimeout(function(){

                               $('.wallet_total div').hide();

                           }, 900 );
            },1500 );
     }

       //昨日收益
       $("#yesterday_sy_div").click(function(){
     	  $(".bombbox-black").show();
     	  $(".yday_gain").show();
       });

       //隐藏遮罩
       $(".bombbox-black,.define_btn").click(function(){
     	  $(".bombbox-black").hide();
     	  $(".yday_gain").hide();
       });




});

//获取我的资金
function getMyWalletDetail(data){

    var obj = jQuery.parseJSON(data);

  	var demo1 = new countUp("memberWalletBx", 0, obj.SUM_BX, 2, 1, options);
    demo1.start();

    var demo2 = new countUp("walletYesterdaySy", 0, obj.YESTERDAY_SY, 2, 1, options);
    demo2.start();

    var demo3 = new countUp("walletSumSy", 0, obj.SUM_SY, 2, 1, options);
    demo3.start();


     $("#walletYesterdayLx").text(formatMoney(obj.YESTERDAY_LX));
     $("#walletYesterdayTx").text(formatMoney(obj.YESTERDAY_TX));
     $("#walletYesterdayJx").text(formatMoney(obj.YESTERDAY_JX));
}

//获取益钱包详情
function getWalletDetail(data){
 var obj = jQuery.parseJSON(data);
 //起投金额
 $('#min_num').text(obj.MIN_NUM);
}




document.getElementById("yesterday_sy_div").addEventListener("touchstart", touchStart, false);
document.getElementById("yesterday_sy_div").addEventListener("touchmove", touchMove, false);
document.getElementById("yesterday_sy_div").addEventListener("touchend", touchEnd, false);
document.getElementById("yesterday_sy_div").addEventListener("touchcancel", touchCancel, false);



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


