
//加载完毕
$(function(){

 $("#aboutus").click(function() {
         //跳转到相关页面  url  是否需要登录
        Callback.gotoWebViewPage($(this).data("hidden"),$(this).data("login"));
    });

  $("#mode").click(function() {
             //跳转到相关页面  url  是否需要登录
            Callback.gotoWebViewPage($(this).data("hidden"),$(this).data("login"));
        });


 $("#aqbz").click(function() {
             //跳转到相关页面  url  是否需要登录
            Callback.gotoWebViewPage($(this).data("hidden"),$(this).data("login"));
        });

 $("#contactus").click(function() {
             //跳转到相关页面  url  是否需要登录
            Callback.gotoWebViewPage($(this).data("hidden"),$(this).data("login"));
        });

  $("#problem").click(function() {
               //跳转到相关页面  url  是否需要登录
              Callback.gotoWebViewPage($(this).data("hidden"),$(this).data("login"));
          });

 $("#welcome").click(function() {
             //跳转到相关页面  url  是否需要登录
            Callback.toWelcomePage();
        });



});




document.getElementById("aboutus").addEventListener("touchstart", touchStart, false);
document.getElementById("aboutus").addEventListener("touchmove", touchMove, false);
document.getElementById("aboutus").addEventListener("touchend", touchEnd, false);


document.getElementById("mode").addEventListener("touchstart", touchStart, false);
document.getElementById("mode").addEventListener("touchmove", touchMove, false);
document.getElementById("mode").addEventListener("touchend", touchEnd, false);


document.getElementById("aqbz").addEventListener("touchstart", touchStart, false);
document.getElementById("aqbz").addEventListener("touchmove", touchMove, false);
document.getElementById("aqbz").addEventListener("touchend", touchEnd, false);


document.getElementById("contactus").addEventListener("touchstart", touchStart, false);
document.getElementById("contactus").addEventListener("touchmove", touchMove, false);
document.getElementById("contactus").addEventListener("touchend", touchEnd, false);


document.getElementById("problem").addEventListener("touchstart", touchStart, false);
document.getElementById("problem").addEventListener("touchmove", touchMove, false);
document.getElementById("problem").addEventListener("touchend", touchEnd, false);


document.getElementById("welcome").addEventListener("touchstart", touchStart, false);
document.getElementById("welcome").addEventListener("touchmove", touchMove, false);
document.getElementById("welcome").addEventListener("touchend", touchEnd, false);


function touchStart(event) {
  this.style.background = "#e1e1e1";
}

function touchMove(event) {
  this.style.background = "#FFF";
}

function touchEnd(event) {
  this.style.background = "#FFF";
}











