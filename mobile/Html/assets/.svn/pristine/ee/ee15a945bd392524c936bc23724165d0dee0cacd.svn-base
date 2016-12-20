//滚动全局变量
var options = {  
  useEasing: true,
    useGrouping: true,
    separator: ',',
    decimal: '.',
    prefix: '',
    suffix: ''
};

//益钱包投资金额
var wallet_apply_amount=queryString("wallet_apply_amount");

//加载完毕
$(function() {

  $("a").click(function() {
    //跳转到相关页面  url  是否需要登录
               jsLog("my_wallet:a click");
    loadURL(wrapIosNativeCallback("gotoLocalWebPage", $(this).data("hidden").replace("file:///android_asset/", ""), $(this).data("login")));
  });
  
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

  refresh();
});

function refresh() {
    //获取会员益钱包收益详情
    loadURL(wrapIosNativeCallback("getMyWalletDetail"));
    //获取益钱包详情
    loadURL(wrapIosNativeCallback("getWalletDetail"));
    
    //如果投资过
    if(wallet_apply_amount!=undefined && wallet_apply_amount!=null && wallet_apply_amount!=""){
        applyAnimation(wallet_apply_amount);
    }
}

//获取我的资金
function getMyWalletDetail(data){
    jsLog("my_wallet:getMyWalletDetail data = " + data);
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
    jsLog("my_wallet:getWalletDetail data = " + data);
 var obj = jQuery.parseJSON(data);
 //起投金额
 $('#min_num').text(obj.MIN_NUM);
}

function walletApply(amount){
    jsLog("my_wallet:walletApply amount = " + amount);
    wallet_apply_amount = amount;
    refresh();
}

function applyAnimation() {
    setTimeout(function(){
       //添加动画
       $('.wallet_total div').addClass('wallet_at');
               
       $('.wallet_total div').show();
       $('#apply_amount_div').text("+"+wallet_apply_amount);
       setTimeout(function(){
                  $('.wallet_total div').hide();
                  }, 900 );
       },1500 );
}

