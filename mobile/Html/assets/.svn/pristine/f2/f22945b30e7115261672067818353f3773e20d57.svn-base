	document.write("<script language='javascript' src='/assets/js/util/common.js'></script>");
	document.write("<script language='javascript' src='/assets/js/util/base64.js'></script>");
	document.write("<script language='javascript' src='/assets/static/js/idcardcheck.js'></script>");
	
	//充值金额
	var recharge_amount= queryString("recharge_amount");
	//加载完毕
	$(function() {

	    //如果从转入页面传来的充值金额大于0  则赋值
	    if(recharge_amount!=undefined && recharge_amount!=null  && recharge_amount>0){
	        $('#money').val(recharge_amount);
	        $('#money').attr("disabled","disabled");
	    }
	    
		$('#rechargeButton').click(function() {
			if(Validate._money('money')){
				$.post('/pay/baorecharge', $.extend({money:$('#money').val(),client:1,}, getRequestData()), function(data){
					$('#MemberID').val(data.MemberID);
				    $('#TerminalID').val(data.TerminalID);
				    $('#InterfaceVersion').val(data.InterfaceVersion);
				    $('#KeyType').val(data.KeyType);
				    $('#TradeDate').val(data.TradeDate);
				    $('#TransID').val(data.TransID);
				    $('#OrderMoney').val(data.OrderMoney);
				    $('#PageUrl').val(data.PageUrl);
				    $('#ReturnUrl').val(data.ReturnUrl);
				    $('#Signature').val(data.Signature);
				    $('#NoticeType').val(data.NoticeType);
				    
				    $('#Username').val(data.Username);
				    $('#AdditionalInfo').val(data.AdditionalInfo);
				    
				    $('#frmRecharge').submit();
				},'json').error(function(){
	    			requestError();
	    		});
			}
		});
	});
	
	
	//获取URL参数
	function queryString(item) {
	    var url = location.href;
		var sValue = url.match(new RegExp("[\?\&]" + item + "=([^\&]*)(\&?)", "i"))
		return sValue ? sValue[1] : sValue
	}