//加载完毕
$(function() {
  
  //益定宝类型 1个月 或者 3个月
  var flag = queryString("flag");
  
  if(flag==3){
    $("#lock_day").text("90");
    $("#yearRate").text("12");
  }
  
  //投资定期
  $("a").click(function() {
    //跳转到相关页面
    var realUrl = $(this).data("hidden").replace("file:///android_asset/", "");
    loadURL(wrapIosNativeCallback("gotoLocalWebPage", realUrl + "?flag="+flag, $(this).data("login")));
  });

  //查询定期信息
  loadURL(wrapIosNativeCallback("getDqByFlag", flag));
});

//定期信息
function getDqByFlag(data) {
    jsLog("getDqByFlag data:" + data);
    var obj = jQuery.parseJSON(data);
    //起投金额
    $("#min_num1").text(obj.min_num);
    $("#min_num2").text(obj.min_num);
    $("#lock_day").text(obj.step);
    $("#yearRate").text(obj.rate);
}






