
//加载完毕
$(function(){

  // 查询登陆状态
  refreshLoginState();
  
   //投资定期
  $("a").click(function() {
             //跳转到相关页面
	    loadURL(wrapIosNativeCallback("gotoLocalWebPage", $(this).data("hidden").replace("file:///android_asset/", "")+"?flag=newbie",$(this).data("login")));
        });

  //投资方向
  $("#security_div,#tz_fx_div,#problem_div").click(function() {
             //跳转到相关页面
	    loadURL(wrapIosNativeCallback("gotoLocalWebPage", $(this).data("hidden").replace("file:///android_asset/", ""),$(this).data("login")));
        });


  //查询定期信息
  loadURL(wrapIosNativeCallback("getDqByFlag", "newbie"));
});

//定期信息
function getDqByFlag(data) {
    jsLog("getDqByFlag data = " + data);
    var obj = jQuery.parseJSON(data);
    //起投金额
    $("#min_num").text(obj.min_num);
    $("#max_num").text(obj.max_num);
    $("#lock_day_1").text(obj.step);
    $("#lock_day_2").text(obj.step);
    $("#year_rate_1").text(obj.rate);
    $("#year_rate_2").text(obj.rate);
}


//已登录
function refreshLogin(){
    loadURL(wrapIosNativeCallback("getMemberIsNewbie"));
}

//未登录
function refreshNotLogin(){

}



//判断用户是否为新手
function getMemberIsNewbie(data){
    if("false"==data){
        $('#goto_apply').hide();
        $('#goto_newbie').show();
    }else{
       $('#goto_apply').show();
       $('#goto_newbie').hide();
    }
}

