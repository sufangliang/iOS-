document.write("<script language='javascript' src='/assets/js/util/common.js'></script>");
document.write("<script language='javascript' src='/assets/js/util/base64.js'></script>");
document.write("<script language='javascript' src='/assets/static/js/idcardcheck.js'></script>");

	//加载完毕
	$(function() {
		
		var toast=localStorage.toast;
		if(toast!=null){
			localStorage.removeItem('toast');
			switch (toast) {
			//asset.js 资产tab页进行提现时还未实名认证
			case "0":
				Sys.showToast("请先实名认证");
				break;
			default:
			    break; 
			}
		}
		
		//获取银行列表
		//Callback.getBankList();
	
		
		//获取我的信息
		getUser();
	
		//获取我的银行卡账户
		getMyBankAccount();
	
		//获取用户认证信息  当实名认真 和 银行卡 都绑定 返回 true
		getUserVerify();
	
		var status=sessionStorage.status;
		if(status!=null){
			sessionStorage.status=null;
			switch (status) {
			case "0":
				Sys.showToast("请先实名认证");
				break;
			default:
			    break; 
			}
		}
		
		$('#verifyButton').click(function() {
			//$('#frmVerify').submit();
			if(Validate._realname('name')&&Validate._idCard('idCard')&&Validate._bankCard('bankCard')){
				$.post('/verify', $.extend(getRequestData(), {name: new Base64().encode($('#name').val()),idCard: $('#idCard').val(),bankCard: $('#bankCard').val()}), function(data) {
					if (0 == data.error_code) {
						localStorage.toast=4;
	    				window.location.href= "index.html";
	    			} else {
	    				Sys.showToast(remoteMessage(data.error_code));
	    			}
				},'json').error(function(){
	    			requestError();
	    		});
			}
		});
	
	
		//获取焦点第一次触发
		$('#idCard,#name').one("focus", function() {
			$(this).val("");
		});
	
		//获取焦点第一次触发
		$('#bankCard').one("focus", function() {
			$(this).val("");
			$('#bankCard').attr("type", "number");
		});
		
	});
	
	//银行卡bin查询  文本改变
    $("#bankCard").on('input',function(){
        //alert($(this).val().length);
        $('#bankCardMessage').hide();
        if($(this).val().length>=16){
          queryBankCardBinLimit($('#bankCard').val());
        }
    });
    
    //银行卡bin查询
	function queryBankCardBinLimit(data){
		$.getJSON('/querybankcardbinlimit', {bankCard:data} , function(data) {
			var obj = jQuery.parseJSON(data.detail);
	  		$('#bankCardMessage').text(obj.bank_name+"支付额度："+(obj.count_limit==undefined?"系统维护期间":obj.count_limit)+"，"+(obj.day_limit==undefined?"暂停交易":obj.day_limit)+"。");
	  		$('#bankCardMessage').show();
	 	});
	}
	
	//银行卡查询限额
	function queryBankLimit(data){
   		$.getJSON('/querybanklimit', {bankFullName:data} , function(data) {
			var obj = jQuery.parseJSON(data.detail);
			$('#bankFullName').val($('#bankFullName').val()+"  支付额度："+(obj.count_limit==undefined?"系统维护期间":obj.count_limit)+"，"+(obj.day_limit==undefined?"暂停交易":obj.day_limit)+"。");
		});
   	}

	//获取我的信息
	function getUser() {
		$.getJSON('/getuser', $.extend({}, getRequestData()), function(data) {
			var obj = jQuery.parseJSON(data.detail);
			//身份认证通过
			if (obj.NAME != "" && obj.NAME != undefined && obj.NAME != null) {
				$('#name').val(new Base64().decode(obj.NAME));
				$('#idCard').val(obj.ID_CARD);
			}
		}).error(function(){
			requestError();
		});
	}
	
	//获取我的银行卡账户
	function getMyBankAccount() {
		$.getJSON('/getmybankaccount', $.extend({}, getRequestData()), function(data) {
			if (data.error_code == 0) {
				var obj = jQuery.parseJSON(data.detail);
				if (obj.BANK_ACCOUNT != "" && obj.BANK_ACCOUNT != undefined && obj.BANK_ACCOUNT != null) {
					$('#bankCard').attr("type", "text");
					$('#bankFullName').val(new Base64().decode(obj.BANK_FULL_NAME));
					$('#bankCard').val(obj.BANK_ACCOUNT);
					
					queryBankLimit(obj.BANK_FULL_NAME);
				}
			}
		}).error(function(){
			requestError();
		});
	}
	
	//获取用户认证信息  当实名认真 和 银行卡 都绑定 返回 true
	function getUserVerify() {
		$.getJSON('/getuserverify', getRequestData(), function(data) {
			//如果已经充值过
			if (data.detail) {
				$('#verifyButton').hide();
				$('#name').attr("disabled", "disabled");
				$('#idCard').attr("disabled", "disabled");
				$('#bankFullName').attr("disabled", "disabled");
				$('#bankCard').attr("disabled", "disabled");
				$('#bankFullNameDiv').show();
				 $('#yellow_msg').hide();
			}
		}).error(function(){
			requestError();
		});
	}
	
	
	//获取银行列表
	function getBankList(data) {
		var obj = jQuery.parseJSON(data);
		var myData = "<option value=''>请选择</option>"; //拼html
	
		//遍历 json
		$.each(obj, function(index, item) {
			myData += "<option value='" + item.id + "'>" + item.bank_name + "</option>";
		});
	
		$('#bankListSelect').html(myData);
	}