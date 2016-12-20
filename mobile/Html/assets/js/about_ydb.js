
//加载完毕
$(function(){
  //益定宝类型 1个月 或者 3个月
  var flag = queryString("flag");

  if(flag==3){
        $("#lock_day").text("90");
        $("#yearRate").text("12");
  }
   //投资定期
  $("a").click(function() {
             //跳转到相关页面
            Callback.gotoWebViewPage($(this).data("hidden")+"?flag="+flag,$(this).data("login"));
        });


   //投资方向
   $("#security_div,#tz_fx_div,#problem_div").click(function() {
             //跳转到相关页面
            Callback.gotoWebViewPage($(this).data("hidden"),$(this).data("login"));
        });

  //查询定期信息
  Callback.getDqByFlag(flag);
});

//定期信息
function getDqByFlag(data) {
    var obj = jQuery.parseJSON(data);
    //起投金额
    $("#min_num1").text(obj.min_num);
    //$("#min_num2").text(obj.min_num);
    $("#lock_day").text(obj.step);
    $("#yearRate").text(obj.rate);
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



