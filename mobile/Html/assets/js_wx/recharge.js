	document.write("<script language='javascript' src='/assets/js/util/common.js'></script>");
	document.write("<script language='javascript' src='/assets/js/util/base64.js'></script>");
	document.write("<script language='javascript' src='/assets/static/js/idcardcheck.js'></script>");
	
	//充值金额
	var recharge_amount= queryString("recharge_amount");
	//加载完毕
	$(function() {
		//获取我的信息
		getUser();
		//获取我的银行卡账户
		getMyBankAccount();
		//获取用户认证信息  当实名认真 和 银行卡 都绑定 返回 true
	    getUserVerify();
	    
	    //如果从转入页面传来的充值金额大于0  则赋值
	    if(recharge_amount!=undefined && recharge_amount!=null  && recharge_amount>0){
	        $('#money_order').val(recharge_amount);
	        $('#money_order').attr("disabled","disabled");
	    }
	    
		$('#rechargeButton').click(function() {
			if(($('#have_id_card').val()=='true'|| (Validate._realname('name') && Validate._idCard('idCard')) ) && ($('#have_bank_card').val()=='true'||Validate._bankCard('bankCard'))){
				if(Validate._money('money_order')){
					$.post('/pay/lianlianrecharge', $.extend({money_order:$('#money_order').val(),client:1,idCard:$('#idCard').val(),bankCard:$('#bankCard').val(),name:new Base64().encode($('#name').val()),have_id_card:$('#have_id_card').val(),have_bank_card:$('#have_bank_card').val()}, getRequestData()), function(data){
						data.risk_item=jQuery.parseJSON(data.risk_item);
						$('#req_data').val(JSON.stringify(data));
						$('#charge').submit();
					},'json').error(function(){
		    			requestError();
		    		});
				}
			}
		});
	
		//银行卡bin查询  文本改变
	    $("#bankCard").on('input',function(){
	        //alert($(this).val().length);
	        $('#bankCardMessage').hide();
	        if($(this).val().length>=16){
	          queryBankCardBinLimit($('#bankCard').val());
	        }
	    });
	    
	    //编辑
	    $('#edit_verify').click(function() {
			$(this).hide();
			$('#name').attr("disabled", false);
			$('#idCard').attr("disabled", false);
			$('#bankCard').attr("disabled", false);
			$('#bankFullNameDiv').hide();
			
			//获取焦点第一次触发
	        $('#name,#idCard').one("focus",function() {
		          $(this).val("");
		          //是否绑定过身份证
		          $('#have_id_card').val("false");
	        });
	                    
			//获取焦点第一次触发
			$('#bankCard').one("focus", function() {
				$(this).val("");
				$('#bankCard').attr("type", "number");
		
				//是否绑定过银行卡
				$('#have_bank_card').val("false");
			});
		});

	});

	
	//获取我的信息
	function getUser() {
		$.getJSON('/getuser', $.extend({}, getRequestData()), function(data) {
			var obj = jQuery.parseJSON(data.detail);
			$('#name').val(new Base64().decode(obj.NAME));
			$('#idCard').val(obj.ID_CARD);
			
			
			//如果实名认证过
			if (obj.ID_CARD_STATUS == 0 || obj.ID_CARD_STATUS == 1) {
				$('#name').attr("disabled", "disabled");
				$('#idCard').attr("disabled", "disabled");
			
				//是否绑定过身份证
				$('#have_id_card').val("true");
			}else{
				$('#name').attr("disabled", false);
				$('#idCard').attr("disabled", false);
			
				//是否绑定过身份证
				$('#have_id_card').val("false");
				
				$('#edit_verify').hide();
			}
		});
		
	}
	
	//获取我的银行卡账户
	function getMyBankAccount() {
		$.getJSON('/getmybankaccount', $.extend({}, getRequestData()), function(data) {
			if (0 == data.error_code) {
				var obj = jQuery.parseJSON(data.detail);
				if (obj.BANK_FULL_NAME != undefined && obj.BANK_FULL_NAME != null && obj.BANK_FULL_NAME != '') {
					$('#bankFullName').val(new Base64().decode(obj.BANK_FULL_NAME));
					$('#bankFullNameDiv').show();
			
					//查询限额
					queryBankLimit(obj.BANK_FULL_NAME);
				}
				//如果绑定过银行卡
				if (obj.BANK_ACCOUNT != undefined && obj.BANK_ACCOUNT != null && obj.BANK_ACCOUNT != '') {
					$('#bankCard').attr("disabled", "disabled");
					$('#bankCard').attr("type", "text");
					$('#bankCard').val(obj.BANK_ACCOUNT);
			
					//是否绑定过银行卡
					$('#have_bank_card').val("true");
					$('#yellow_msg').hide();
				}
			}else{
				//没银行卡
				$('#have_bank_card').val("false");
				$('#bankCard').attr("disabled", false);
				
				$('#edit_verify').hide();
			}
		});
	}
	
	//银行卡查询限额
	function queryBankLimit(data) {
		$.getJSON('/querybanklimit', {bankFullName:data} , function(data) {
			var obj = jQuery.parseJSON(data.detail);
			$('#bankFullName').val($('#bankFullName').val()+"  支付额度："+(obj.count_limit==undefined?"系统维护期间":obj.count_limit)+"，"+(obj.day_limit==undefined?"暂停交易":obj.day_limit)+"。");
		});
	}
	
	//银行卡bin查询
	function queryBankCardBinLimit(data){
		$.getJSON('/querybankcardbinlimit', {bankCard:data} , function(data) {
			var obj = jQuery.parseJSON(data.detail);
	  		$('#bankCardMessage').text(obj.bank_name+"支付额度："+(obj.count_limit==undefined?"系统维护期间":obj.count_limit)+"，"+(obj.day_limit==undefined?"暂停交易":obj.day_limit)+"。");
	  		$('#bankCardMessage').show();
	 	});
	}
	
	//获取用户认证信息  当实名认真 和 银行卡 都绑定 返回 true
	function getUserVerify(){
		$.getJSON('/getuserverify', $.extend({}, getRequestData()), function(data) {
		    //如果已经充值过
		    if(data.detail==true){
		        $('#edit_verify').hide();
		    }
		});
	}
	
	//获取URL参数
	function queryString(item) {
	    var url = location.href;
		var sValue = url.match(new RegExp("[\?\&]" + item + "=([^\&]*)(\&?)", "i"))
		return sValue ? sValue[1] : sValue
	}