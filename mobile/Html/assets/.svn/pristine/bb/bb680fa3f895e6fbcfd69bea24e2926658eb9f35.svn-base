	document.write("<script language='javascript' src='/assets/js/util/common.js'></script>");
$(function() {
	$.getJSON('/getinvitecode', $.extend({}, getRequestData()), function(data) {
		var obj = jQuery.parseJSON(data.detail);
		new QRCode(document.getElementById("qrcode"), "http://"+window.location.host+urlJson.base+"/register.html?inviteCode=" + obj.INVITE_CODE);
	}).error(function(){
		requestError();
	});

})