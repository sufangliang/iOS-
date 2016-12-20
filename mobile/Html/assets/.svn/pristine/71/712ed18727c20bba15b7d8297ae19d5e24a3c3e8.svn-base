	document.write("<script language='javascript' src='/assets/js/util/common.js'></script>");
	document.write("<script language='javascript' src='/assets/js/util/base64.js'></script>");
	
	$(function(){
		//获取我的信息
		protocol();
	});
	
	//获取我的信息
	function protocol() {
		$.getJSON('/protocol', $.extend({id:queryString("id")}, getRequestData()), function(data) {
			var obj = jQuery.parseJSON(data.detail);
			
			$('#name').text(obj.name);
	        $('#loginname').text(obj.loginName);
	        $('#idCard').text(obj.idCard);
	
	        $('#ydbname').text(obj.ydjName);
	        $('#protocol').text(obj.protocol);
	
	        $('#amount').text(formatMoney(obj.amount,0));
	        $('#amountup').text(obj.amountUp);
	        $('#peroid').text(obj.peroid+"天");
	        $('#rate').text(obj.rate+"%");
	
	        $('#now').text(obj.fulfilTime);
		}).error(function(){
			requestError();
		});
	}