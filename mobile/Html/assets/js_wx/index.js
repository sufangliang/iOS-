	document.write("<script language='javascript' src='/assets/js/util/common.js'></script>");
//加载完毕
$(function(){
	var toast=localStorage.toast;
	if(toast!=null){
		localStorage.removeItem('toast');
		switch (toast) {
		case "0":
			Sys.showToast("充值成功");
			break;
		/*case "1":
			Sys.showToast("提现申请成功");--已变成跳到资金流水页
			break;*/
		case "2":
			Sys.showToast("转入成功");
			break;
		case "3":
			Sys.showToast("赎回成功");
			break;
		case "4":
			//修改支付.登陆密码.实名认证成功
			Sys.showToast("设置成功");
			break;
		default:
		    break; 
		}
	}
	
	$('.container').css('margin-bottom','49px');
	$('body').append('<div class="footer">'+
				  '<div class="footer_nav_list">'+
				    '<span class="footer_nav">'+
				    '<a href="javascript:void(window.location.href=(&quot;index.html?_='+Math.random()+'&quot;))" class="nav_index nav_index_current"><i></i><em>理财</em></a>'+
				    '</span>'+
				    '<span class="footer_nav">'+
				    '<a href="javascript:void(window.location.href=(&quot;assets.html?_='+Math.random()+'&quot;))" id="nav_assets" class="nav_assets"><i></i><em>资产</em></a>'+
				    '</span>'+
				    '<span class="footer_nav">'+
				    '<a href="javascript:void(window.location.href=(&quot;me.html?_='+Math.random()+'&quot;))" class="nav_me"><i></i><em>我</em></a>'+
				    '</span>'+
				  '</div>'+
				'</div>');
				
    $(".index_list_c").click(function() {
         window.location.href = $(this).data("hidden").replace("file:///android_asset/","");
    });

    //banner手势滑动
    $('#carousel-example-generic').hammer().on('swipeleft', function(){
      $(this).carousel('next');
     });

    $('#carousel-example-generic').hammer().on('swiperight', function(){
      $(this).carousel('prev');
    });
    
    //获取益钱包详情
    getWalletDetail();
    //定期30天
    getDqByFlag(1);
    //定期90天
    getDqByFlag(3);
     //新手标
    getDqByFlag("newbie");
    //判断用户是否为新手
    getMemberIsNewbie();
});
	
	function getWalletDetail(){
		$.getJSON('/getwalletdetail',getRequestData(),function(data) {
			if (0 == data.error_code) {
				var obj = jQuery.parseJSON(data.detail);
				//起投金额
 				$('#min_num_wallet').text("￥"+obj.MIN_NUM);
			}
		}).error(function(){
			requestError();
		});
	}
	
	//获取定期详情
	function getDqByFlag(flag) {
		$.getJSON('/getdqbyflag', {flag:flag}, function(data) {
			if (0 == data.error_code) {
				var obj = jQuery.parseJSON(data.detail);
				if(obj.id==1){
				    //30天定期起投金额
				    $('#min_num_dq1').text("￥"+obj.min_num);
				}else if(obj.id==2){
				    //90天定期起投金额
				    $('#min_num_dq3').text("￥"+obj.min_num);
				}else if(obj.id==3){
				    //新手标利息
				    $('#rate_newbie').html(obj.rate+"<i>%</i>");
				    //新手标天数
				    $('#step_newbie').text(obj.step+"天");
				    //新手标起投金额
				    $('#min_num_newbie').text("￥"+obj.min_num);
				}
			}else{
				Sys.showToast(remoteMessage(data.error_code));
			}
		}).error(function(){
	    	requestError();
	    });
	}
	
	//判断用户是否为新手
	function getMemberIsNewbie(){
		$.getJSON('/getmemberisnewbie', getRequestData(), function(data) {
			if (0 == data.error_code) {
				if(!data.detail){
			      $('#newbie_div').hide();
			    }
			}else if(1 != data.error_code){
				Sys.showToast(remoteMessage(data.error_code));
			}
		}).error(function(){
	    	requestError();
	    });
	}

document.getElementById("touch_0").addEventListener("touchstart", touchStart, false);
document.getElementById("touch_0").addEventListener("touchmove", touchMove, false);
document.getElementById("touch_0").addEventListener("touchend", touchEnd, false);
document.getElementById("touch_0").addEventListener("touchcancel", touchCancel, false);

document.getElementById("touch_1").addEventListener("touchstart", touchStart, false);
document.getElementById("touch_1").addEventListener("touchmove", touchMove, false);
document.getElementById("touch_1").addEventListener("touchend", touchEnd, false);
document.getElementById("touch_1").addEventListener("touchcancel", touchCancel, false);

document.getElementById("touch_2").addEventListener("touchstart", touchStart, false);
document.getElementById("touch_2").addEventListener("touchmove", touchMove, false);
document.getElementById("touch_2").addEventListener("touchend", touchEnd, false);
document.getElementById("touch_2").addEventListener("touchcancel", touchCancel, false);

document.getElementById("touch_3").addEventListener("touchstart", touchStart, false);
document.getElementById("touch_3").addEventListener("touchmove", touchMove, false);
document.getElementById("touch_3").addEventListener("touchend", touchEnd, false);
document.getElementById("touch_3").addEventListener("touchcancel", touchCancel, false);

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