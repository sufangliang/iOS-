	document.write("<script language='javascript' src='/assets/js/util/common.js'></script>");
	document.write("<script language='javascript' src='/assets/js/util/md5.js'></script>");
	
	
	//最小投资金额
	var min_num = 0 ;
	//加载完毕
	$(function(){
    	//获取益钱包详情
    	getWalletDetail();
    	
		//获取我的账户
	    getMyAccount();
	    
	    $('#applyButton').click(function() {
	    	
	    	history.replaceState({page: 2}, "title 2", "assets.html");
	    	
	    	if(Validate._apply('amount','usebalance',min_num)){
	    		if( Validate._pwd('payPwd') && ($('#have_pay_pwd').val()=="true" || Validate._setpwd('payPwd')) ){
		    		var signature=CryptoJS.MD5(getMobile() + " " + getpwd() + " " + CryptoJS.MD5($('#payPwd').val()).toString()).toString();
		    		var payPwd = CryptoJS.MD5($('#payPwd').val()).toString();
		    		//可用余额小于 投资金额的时候弹出提示框
		    		var usebalance=$('#usebalance').val();
		    		var amount=$('#amount').val();
				    /*if ( usebalance < amount) {
						showHideBox(amount - usebalance);
						return;
					} else {*/
						$.post('/walletapply', $.extend(getRequestData(), {amount: $('#amount').val(),signature: signature,payPwd: payPwd,cjResultId: $('#jxjListSelect').val(),client: 1}), function(data) {
							if (0 == data.error_code) {
								localStorage.toast = 2;
								window.location.href = urlJson.base + "/my_wallet.html?wallet_apply_amount="+$('#amount').val();
							} else if(23 == data.error_code) {
								//交易密码正确后余额不足弹出充值并转入
								sessionStorage.amount=amount;
								sessionStorage.payPwd=payPwd;
								sessionStorage.paySignature=signature;
								sessionStorage.type=urlJson.wallet; //益钱包转入
								sessionStorage.cjResultId=$('#jxjListSelect').val();
								showHideBox(Subtr(amount,usebalance));
							}else{
								Sys.showToast(remoteMessage(data.error_code));
							}
						}, 'json').error(function() {
							requestError();
						});
					//}
					
		    	}
	    	}
	    	//$('#frmApple').submit();
    	});

        //全部
    	$('#allButton').click(function() {
        	  $('#amount').val($('#usebalance').val());
        });

        //充值
        $('#toRecharge').click(function() {
        	if (refresh()) {
        		sessionStorage.return_url="apply.html?a=1";
    			window.location.href = $(this).data("hidden").replace("file:///android_asset/", "");
    		} else {
    			window.location.href = "login.html?return_url=apply.html";
    		}
         });
	
	    //获取我的抽奖加息劵
	    //Callback.getMyCjJxjResult();
	     //取消
		$('#doCancel,#bombbox1').click(function() {
    	    $('#bombbox1').hide();
            $('#bombbox2').hide();
            sessionStorage.clear();
    	});
		
		//眼睛
		$("#toggle_eye").click(function() {
			$("#toggle_eye").toggleClass("show_eye");
			if ("password" == $("#payPwd").attr("type")) {
				$("#payPwd").attr("type", "text");
			} else if ("text" == $("#payPwd").attr("type")) {
				$("#payPwd").attr("type", "password");
			}
			$("#payPwd").focus();
		});
         
      	//弹出框 去充值
    	$('#gotoRecharge').click(function() {
    		var $this=$(this);
    		$.getJSON('/getuserverify', $.extend({}, getRequestData()), function(data) {
    			//data.type - 0:连连 需要再判断实名认证信息 1：直接宝付充值
    			if("0"==data.type){
    				 //如果已经充值过
    				if(data.detail==true){
				    	lianlianRecharge();
				    }else{
				    	sessionStorage.return_url="apply.html";
				    	window.location.href = $this.data("hidden").replace("file:///android_asset/", "")+"?recharge_amount="+restoreMoney($('#add_money').text());
				    }
		    	}else{
		    		baofuRecharge();
		    	}
			   
			});
           
        });
	
	});

	//直接到连连充值
	function lianlianRecharge(){
		$('body').append('<form id="charge" action="https://yintong.com.cn/llpayh5/authpay.htm" method="post" hidden>'+
					        '<input type="text" id="req_data" name="req_data"/>'+
					    '</form>');
					    
	    $.post('/pay/lianlianrecharge', $.extend({money_order:$('#add_money').text(),client:1,have_id_card:true,have_bank_card:true}, getRequestData()), function(data){
			data.risk_item=jQuery.parseJSON(data.risk_item);
			$('#req_data').val(JSON.stringify(data));
			$('#charge').submit();
		},'json').error(function(){
			requestError();
		});
	}
	 
	//直接到宝付充值
	function baofuRecharge(){
		$('body').append('<form action="https://gw.baofoo.com/wapmobile" id="frmRecharge" method="post" hidden>'+
							'<input name="PayID" type="hidden" value="all"/>'+
							'<input name="OrderMoney" type="hidden" id="OrderMoney"/>'+
							'<input name="MemberID" type="hidden" id="MemberID"/>'+
							'<input name="TerminalID" type="hidden" id="TerminalID"/>'+
							'<input name="InterfaceVersion" type="hidden" id="InterfaceVersion"/>'+
							'<input name="KeyType" type="hidden" id="KeyType"/>'+
							'<input name="TransID" type="hidden" id="TransID"/>'+	
							'<input name="TradeDate" type="hidden" id="TradeDate" />'+
							'<input name="PageUrl" type="hidden" id="PageUrl"/>'+
							'<input name="ReturnUrl" type="hidden" id="ReturnUrl"/>	'+
							'<input name="Signature" type="hidden" id="Signature"/>'+
							'<input name="NoticeType" type="hidden" id="NoticeType"/>'+
							'<input name="ProductName" type="hidden" id="ProductName"/>'+
							'<input name="Amount" type="hidden" id="Amount"/>'+
							'<input name="UserName" type="hidden" id="UserName"/>'+
							'<input name="AdditionalInfo" type="hidden" id="AdditionalInfo"/>'+
					    '</form>');
    
		$.post('/pay/baorecharge', $.extend({money:$('#add_money').text(),client:1,}, getRequestData()), function(data){
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
	    
         
	//获取我的抽奖加息劵
	function getMyCjJxjResult(data){
	   var obj = jQuery.parseJSON(data);
	   var myData = "<option value=''>不使用加息劵</option>";//拼html
	    //遍历 json
	    $.each(obj, function(index, item){
	       myData +="<option value='"+item.id+"'>"+item.desp+item.stamp_end.substring(5,10)+"到期</option>";
	    });
	   $('#jxjListSelect').html(myData);
	}
	
	//获取我的账户
	function getMyAccount(){
		$.ajax({  
	        type:'GET',  
	        url:'/getmyaccount',  
	        data:getRequestData(),  
	        dataType:'json',  
	        cache : false,
	        async : false,  //异步执行为false
	        success:function(data){  
	           var obj = jQuery.parseJSON(data.detail);
		
			   $('#amount').attr("placeholder","账户余额"+formatMoney(obj.USE_BALANCE)+"元，至少转入"+min_num+"元");

			   $('#usebalance').val(obj.USE_BALANCE);
			   $('#have_pay_pwd').val(obj.HAVE_PAY_PWD);
			
			  //如果未设置交易密码
			  if(!obj.HAVE_PAY_PWD){
		     	$('#payPwd_label').text("设置(6-20位数字+字母区分大小写)交易密码");
			     $('#payPwd').attr("placeholder","密码将在每次交易时使用");
			    $('#payPwd').css("background-color","#d6ebff");
			  }
	        },error:function(){
	    		requestError();
	        }
	    });  
	}
	
	function getWalletDetail(){
		$.ajax({  
	        type:'GET',  
	        url:'/getwalletdetail',  
	        data:getRequestData(),
	        dataType:'json',  
	        cache : false,
	        async : false,  //异步执行为false
	        success:function(data){  
	            if (0 == data.error_code) {
					var obj = jQuery.parseJSON(data.detail);
					min_num=obj.MIN_NUM;
				}else {
					refreshNotLogin();
					//Sys.showToast(remoteMessage(data.error_code));
				}
	        },error:function(){
	    		requestError();
	        }
	    });  
	}
	
	//显示提示框  填充补充金额
	function showHideBox(addMoney){
	  $('#add_money').text(formatMoney(addMoney));
	  $('#bombbox1').show();
	  $('#bombbox2').show();
	}
