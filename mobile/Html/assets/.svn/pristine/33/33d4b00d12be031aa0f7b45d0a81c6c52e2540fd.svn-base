
//加载完毕
$(function(){

   //投资定期
  $("a").click(function() {
             //跳转到相关页面
            Callback.gotoWebViewPage($(this).data("hidden")+"?flag=newbie",$(this).data("login"));
        });

  //投资方向
  $("#security_div,#tz_fx_div,#problem_div").click(function() {
             //跳转到相关页面
            Callback.gotoWebViewPage($(this).data("hidden"),$(this).data("login"));
        });


  //查询定期信息
  Callback.getDqByFlag("newbie");

   //判断用户是否为新手
   Callback.getMemberIsNewbie();

});

//定期信息
function getDqByFlag(data) {
    var obj = jQuery.parseJSON(data);
    //起投金额
    $("#min_num").text(obj.min_num);
    $("#max_num").text(obj.max_num);
    $("#lock_day_1").text(obj.step);
    $("#lock_day_2").text(obj.step);
    $("#year_rate_1").text(obj.rate);
    $("#year_rate_2").text(obj.rate);
}


// 判断是否登录状态
function onResumeRefresh(){
    //判断用户是否为新手
    Callback.getMemberIsNewbie();
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
