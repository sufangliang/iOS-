
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
  
   //判断是否登录状态
   refreshLoginState();

   //获取益钱包统计
   loadURL(wrapIosNativeCallback("getAboutWallet"));

   //获取益钱包详情
   loadURL(wrapIosNativeCallback("getWalletDetail"));

    $("a").click(function() {
          	 //跳转到相关页面  url  是否需要登录
              loadURL(wrapIosNativeCallback("gotoLocalWebPage", $(this).data("hidden").replace("file:///android_asset/", ""), $(this).data("login")));
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

function refreshNotLogin() {
    $('#notlogin').show();
    $('#hadlogin').hide();
}

function refreshLogin(){
    $('#notlogin').hide();
    $('#hadlogin').show();
}