	document.write("<script language='javascript' src='/assets/js/util/common.js'></script>");
	
	//充值金额
	var recharge_amount=queryString("recharge_amount");
	//提现金额
	var withdraw_amount=queryString("withdraw_amount");
	
	//加载完成
	$(function() {
		//转入流水
		getMyTradeLogApply();
		//赎回流水
		getMyTradeLogRedeem();
		//充值流水
		getMyTradeLogRecharge();
		//提现流水
		getMyTradeLogWithdraw();
	
	});
	
	//转入流水
	function getMyTradeLogApply() {
		$.getJSON('/getmytradelog', $.extend({
			tradetype: 'apply',
			page: 1,
			pagesize: 500
		}, getRequestData()), function(data) {
			var myData = "";
			if(data.list==null || data.list==''||data.list=='[]'){
		       myData='<tr><td colspan="4" style="text-align:center; font-size:18px; color:#999; padding-top:40%; width:100%; background-color: #f0f0f0;">暂无记录</td></tr>';
		    }else{
				var obj = jQuery.parseJSON(data.list);
				// json
				$.each(obj, function(index, item) {
					myData += "<tr>";
					myData += "<td>" + item.TRANSACTION_TIME.substring(0, 10) + "</td>";
					myData += "<td>" + formatMoney(item.TRANSACTION_AMOUNT, 1) + "</td>";
					myData += "<td>" + formatMoney(item.CURRENT_AMOUNT, 1) + "</td>";
					myData += "<td>" + (item.NOTE == undefined ? "" : item.NOTE) + "</td>";
					myData += "</tr>";
				});
			}
			$('#applyList').html(myData);
		}).error(function(){
			requestError();
		});
	}
	
	//赎回流水
	function getMyTradeLogRedeem() {
	
		$.getJSON('/getmytradelog', $.extend({
			tradetype: 11,
			page: 1,
			pagesize: 500
		}, getRequestData()), function(data) {
			var myData = "";
			if(data.list==null || data.list==''||data.list=='[]'){
		       myData='<tr><td colspan="4" style="text-align:center; font-size:18px; color:#999; padding-top:40%; width:100%; background-color: #f0f0f0;">暂无记录</td></tr>';
		    }else{
				var obj = jQuery.parseJSON(data.list);
				// json
				$.each(obj, function(index, item) {
					myData += "<tr>";
					myData += "<td>" + item.TRANSACTION_TIME.substring(0, 10) + "</td>";
					myData += "<td>" + formatMoney(item.TRANSACTION_AMOUNT, 1) + "</td>";
					myData += "<td>" + formatMoney(item.CURRENT_AMOUNT, 1) + "</td>";
					myData += "<td>" + (item.NOTE == undefined ? "" : item.NOTE) + "</td>";
					myData += "</tr>";
				});
			}
			$('#redeemList').html(myData);
		}).error(function(){
			requestError();
		});
	}
	
	//充值流水
	function getMyTradeLogRecharge(data) {
		$.getJSON('/getmytradelog', $.extend({
			tradetype: 1,
			page: 1,
			pagesize: 500
		}, getRequestData()), function(data) {
			var myData = ""; //ƴhtml
			if(data.list==null || data.list==''||data.list=='[]'){
		       myData='<tr><td colspan="4" style="text-align:center; font-size:18px; color:#999; padding-top:40%; width:100%; background-color: #f0f0f0;">暂无记录</td></tr>';
		    }else{
				var obj = jQuery.parseJSON(data.list);
				// json
				$.each(obj, function(index, item) {
					myData += "<tr>";
					myData += "<td>" + item.TRANSACTION_TIME.substring(0, 10) + "</td>";
					myData += "<td>" + formatMoney(item.TRANSACTION_AMOUNT, 1) + "</td>";
					myData += "<td>" + formatMoney(item.CURRENT_AMOUNT, 1) + "</td>";
					myData += "<td>" + (item.NOTE == undefined ? "" : item.NOTE) + "</td>";
					myData += "</tr>";
				});
			}
			$('#rechargeList').html(myData);
			
			//如果 存在充值金额 则提现列表显示
		   if(recharge_amount!=undefined && recharge_amount!=null && recharge_amount!=''){
		        $("ul li a:eq(2)").click();
		        $("ul li :eq(0)").css("background-color","#fff");
		        $("#rechargeList").find("tr:eq(0)").css("background-color","#d6ebff");
		   }
		}).error(function(){
			requestError();
		});
	}
	
	//提现流水
	function getMyTradeLogWithdraw(data) {
		$.getJSON('/getmytradelog', $.extend({
			tradetype: 2,
			page: 1,
			pagesize: 500
		}, getRequestData()), function(data) {
			var myData = "";
			if(data.list==null || data.list==''||data.list=='[]'){
		       myData='<tr><td colspan="4" style="text-align:center; font-size:18px; color:#999; padding-top:40%; width:100%; background-color: #f0f0f0;">暂无记录</td></tr>';
		    }else{
				var obj = jQuery.parseJSON(data.list);
				// json
				$.each(obj, function(index, item) {
					myData += "<tr>";
					myData += "<td>" + item.TRANSACTION_TIME.substring(0, 10) + "</td>";
					myData += "<td>" + formatMoney(item.TRANSACTION_AMOUNT, 1) + "</td>";
					myData += "<td>" + formatMoney(item.CURRENT_AMOUNT, 1) + "</td>";
					myData += "<td>" + (item.NOTE==null?"":item.NOTE) + "</td>";
					myData += "</tr>";
				});
			}
			$('#withdrawList').html(myData);
			 //如果 存在提现金额 则提现列表显示
		   	if(withdraw_amount!=undefined && withdraw_amount!=null && withdraw_amount!=''){
		         $("ul li a:eq(3)").click();
		         $("ul li :eq(0)").css("background-color","#fff");
		         $("#withdrawList").find("tr:eq(0)").css("background-color","#d6ebff");
		   	}
		}).error(function(){
			requestError();
		});
	}
	
	//获取URL参数
	function queryString(item) {
	    var url = location.href;
		var sValue = url.match(new RegExp("[\?\&]" + item + "=([^\&]*)(\&?)", "i"))
		return sValue ? sValue[1] : sValue
	}