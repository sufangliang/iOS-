	document.write("<script language='javascript' src='/assets/js/util/common.js'></script>");
	document.write("<script language='javascript' src='/assets/js/util/base64.js'></script>");
	
	//加载完毕
	$(function() {
		$('.container').css('margin-bottom', '49px');
		$('body').append('<div class="footer">' +
			'<div class="footer_nav_list">' +
			'<span class="footer_nav">' +
			'<a href="javascript:void(window.location.href=(&quot;index.html?_='+Math.random()+'&quot;))" class="nav_index nav_index"><i></i><em>理财</em></a>' +
			'</span>' +
			'<span class="footer_nav">' +
			'<a href="javascript:void(window.location.href=(&quot;assets.html?_='+Math.random()+'&quot;))" class="nav_assets"><i></i><em>资产</em></a>' +
			'</span>' +
			'<span class="footer_nav">' +
			'<a href="javascript:void(window.location.href=(&quot;me.html?_='+Math.random()+'&quot;))" class="nav_me nav_me_current"><i></i><em>我</em></a>' +
			'</span>' +
			'</div>' +
			'</div>');
	
		/*把Android的在线客服 与 版本检查  去掉*/
		$('.user_ul:eq(2)').hide();

		// 判断是否登录状态
		if (refresh()) {
			refreshLoginOk();
		} else {
			refreshNotLogin();
		}
	
		//关于我们
		$("#aboutus").click(function() {
			window.location.href = $(this).data("hidden").replace("file:///android_asset/", "");
		});
	
	
		
	
		$("#qrcode").click(function() {
			if (refresh()) {
				window.location.href = "qrcode.html";
			} else {
				window.location.href = "login.html";
			}
		});
	
	
		/*弹出模态框*/
		$('#logoutButton').click(function() {
			$('#imgbox_overlay').fadeIn();
			$('.foot_tk').fadeIn();
	
		});
	
	
		/*关闭*/
		$('#btn-c').click(function() {
			$('.foot_tk').fadeOut();
			$('#imgbox_overlay').fadeOut();
	
		});
	
		/*关闭*/
		$('#imgbox_overlay').click(function() {
			$('.foot_tk').fadeOut();
			$('#imgbox_overlay').fadeOut();
	
		});
	
		//密码设置
		$("#setting_pwd").click(function() {
			if (refresh()) {
				window.location.href = $(this).data("hidden").replace("file:///android_asset/", "");
			} else {
				window.location.href = "login.html?return_url=" + $(this).data("hidden").replace("file:///android_asset/", "");
			}
		});
	
		//退出
		$("#logoutSure").click(function() {
			$('.foot_tk .btn_go #btn-c').click();
			logout();
			window.location.href = "login.html";
		});
	
	});
	
	//已登录
	function refreshLoginOk() {
		$('#notLogin').hide();
		$('#hadLogin').show();
		$('#logoutButton').show();
	
		$("#hadLogin").parent().bind('click',function() {
			window.location.href = "verify.html";
		});
	
		getUser();
	}
	
	//未登录
	function refreshNotLogin() {
		$('#hadLogin').hide();
		$('#notLogin').show();
		$('#logoutButton').hide();
		
		localStorage.clear();
		
		$("#notLogin").parent().click(function() {
			window.location.href = "login.html";
		});
	
	}
	
	//用户详情
	function getUser() {
		$.getJSON('/getuser', $.extend({}, getRequestData()), function(data) {
			if (0 == data.error_code) {
				var obj = jQuery.parseJSON(data.detail);
	
				var b = new Base64();
				var name = b.decode(obj.NAME);
		
				$('#name').text(name);
				$('#mobile').text(obj.MOBILE);
		
				//身份认证通过
				var idCardStatus = obj.ID_CARD_STATUS;
				if (idCardStatus == 0 || idCardStatus == 1) {
					$('#realNameVerify').text("已认证");
					$('#realNameVerify').attr("class", "user_rz");
				} else {
					$('#realNameVerify').text("未认证");
					$('#realNameVerify').attr("class", "user_rz user_rzno");
				}
				
			}else {
				refreshNotLogin();
				//Sys.showToast(remoteMessage(data.error_code));
			}
			
		}).error(function(){
			requestError();
		});
	}
	
	
	
	
	
	
	
	
	document.getElementById("touch_1").addEventListener("touchstart", touchStart, false);
	document.getElementById("touch_1").addEventListener("touchmove", touchMove, false);
	document.getElementById("touch_1").addEventListener("touchend", touchEnd, false);
	document.getElementById("touch_1").addEventListener("touchcancel", touchCancel, false);
	
	document.getElementById("setting_pwd").addEventListener("touchstart", touchStart, false);
	document.getElementById("setting_pwd").addEventListener("touchmove", touchMove, false);
	document.getElementById("setting_pwd").addEventListener("touchend", touchEnd, false);
	document.getElementById("setting_pwd").addEventListener("touchcancel", touchCancel, false);
	
	document.getElementById("aboutus").addEventListener("touchstart", touchStart, false);
	document.getElementById("aboutus").addEventListener("touchmove", touchMove, false);
	document.getElementById("aboutus").addEventListener("touchend", touchEnd, false);
	document.getElementById("aboutus").addEventListener("touchcancel", touchCancel, false);
	
	
	document.getElementById("callTel").addEventListener("touchstart", touchStart, false);
	document.getElementById("callTel").addEventListener("touchmove", touchMove, false);
	document.getElementById("callTel").addEventListener("touchend", touchEnd, false);
	document.getElementById("callTel").addEventListener("touchcancel", touchCancel, false);
	
	document.getElementById("custom").addEventListener("touchstart", touchStart, false);
	document.getElementById("custom").addEventListener("touchmove", touchMove, false);
	document.getElementById("custom").addEventListener("touchend", touchEnd, false);
	document.getElementById("custom").addEventListener("touchcancel", touchCancel, false);
	
	
	document.getElementById("checkVersion").addEventListener("touchstart", touchStart, false);
	document.getElementById("checkVersion").addEventListener("touchmove", touchMove, false);
	document.getElementById("checkVersion").addEventListener("touchend", touchEnd, false);
	document.getElementById("checkVersion").addEventListener("touchcancel", touchCancel, false);
	
	
	document.getElementById("qrcode").addEventListener("touchstart", touchStart, false);
	document.getElementById("qrcode").addEventListener("touchmove", touchMove, false);
	document.getElementById("qrcode").addEventListener("touchend", touchEnd, false);
	document.getElementById("qrcode").addEventListener("touchcancel", touchCancel, false);
	
	
	
	
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