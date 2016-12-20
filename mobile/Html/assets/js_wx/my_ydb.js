	document.write("<script language='javascript' src='/assets/js/util/common.js'></script>");
	//滚动全局变量
	var options = {
		useEasing : true,
		useGrouping : true,
		separator : ',',
		decimal : '.',
		prefix : '',
		suffix : ''
	};

	//益定宝投资金额
	var ydb_apply_amount=queryString("ydb_apply_amount");
	
	//加载完毕
	$(function(){
		var toast=localStorage.toast;
		if(toast!=null){
			localStorage.removeItem('toast');
			switch (toast) {
			case "2":
				Sys.showToast("转入成功");
				break;
			default:
			    break; 
			}
		}
		
		//投资定期
	    $("a").click(function() {
	       //跳转到相关页面  url  是否需要登录
	    	if (refresh()) {
		        window.location.href = $(this).data("hidden").replace("file:///android_asset/", "");
		    }else{
		        window.location.href = "login.html?return_url=" + $(this).data("hidden").replace("file:///android_asset/", "");
		    }
	    });
	    
	    
	    //获取我的资金
		getMyMoneyStatistics();
		//持有中(新)
		getMyDqApplyList0(0, 1, 10);
		//已结清(新)
		getMyDqApplyList1(1, 1, 10);
		
		//持有中
		//getMyYdbList2();
		//申购中
		//getMyYdbList1();
		//已结清
		//getMyYdbList3();
		
		
		$('.me_regularly_ul').on('click','li',function(){
			$('.me_regularly_ul li').removeClass('current');
			$(this).addClass('current');
	
			$('.me_regularly_li').hide();
			$(".me_regularly_li:eq("+$('.me_regularly_ul li').index(this)+")").show();
		});
				
		//如果投资过
		if (ydb_apply_amount != undefined && ydb_apply_amount != null && ydb_apply_amount != "") {
			
			//申购中显示
	        $("ul li:eq(1)").click();
	        
			setTimeout(function() {
				//添加动画
				$('.wallet_total div').addClass('wallet_at');
				$('#apply_amount_div').text("+" + ydb_apply_amount);
		
				setTimeout(function() {
					$('.wallet_total div').hide();
				}, 900);
				
			}, 1500);
		}
	
	});

	//获取我的资金
	function getMyMoneyStatistics(){
		$.getJSON('/getmymoneystatistics',$.extend({},getRequestData()),function(data){
			if(0==data.error_code){
			    var obj = jQuery.parseJSON(data.detail);
			
				var demo1 = new countUp("memberDsbj", 0, obj.memberDsbj, 2, 1, options);
	    		demo1.start();
			
			    var demo2 = new countUp("memberDslx", 0, obj.memberDslx, 2, 1, options);
			    demo2.start();
			
			    var demo3 = new countUp("dingSumSy", 0, obj.dingSumSy, 2, 1, options);
			    demo3.start();
			}else{
		   		requestError();
		    }
		}).error(function(){
			requestError();
		});    
	}


	//持有中(新)
	function getMyDqApplyList0() {
		$.getJSON('/getmydqapplylist',$.extend(getRequestData(),{finish:0,page:1,pagesize:50}),function(data){
			if(0==data.error_code){
			  	var myData = "";
				if (data.list == null || data.list == '' || data.list == '[]') {
					myData = '<div style="text-align:center; font-size:18px; color:#999; padding-top:40%;"> 暂无记录 </div>';
					$('#chi_you').append(myData);
				}else{
					var obj = jQuery.parseJSON(data.list);
					$.each(obj, function(index, item){
			            myData += '<dl class="regularly_info">';
			            myData += '<dt><span><a onclick="showMyProtocol('+item.id+');">查看合同</a></span>'+item.title+'</dt>';
			            myData += '<dd class="regularly_img02">';
			            myData += '<div class="regularly_info_nun">';
			            myData += '<div class="regularly_info_nunl"> <em>'+formatMoney(item.apply_bj)+'</em>元</div>';
			            myData += '<div class="regularly_info_nunr">';
			            myData += ' <p>还款：<span class="gray">'
			                      + (item.last_time==undefined ? "已完成" : getDateDiff(getCurrentYearMonth(),item.last_time)<=0  ? "已完成" : (getDateDiff(getCurrentYearMonth(),item.last_time)+"天后"))
			                      + '</span></p>';
			            myData += ' <p>到期：<span class="gray">'+item.last_time+'</span></p>';
			            myData += ' <p>利率：<span class="gray">'+item.rate+'%(年)</span></p>';
			            myData += ' <p>收益：<span class="yellow">￥'+formatMoney(item.yj_sy)+'</span></p>';
			            myData += ' </div>';
			            myData += ' </div>';
			            myData += ' </dd>';
			            myData += ' </dl>';
			        });
			        $('#chi_you').append(myData);
				}
			}else{
		   		requestError();
		    }
   		}).error(function(){
			requestError();
		});
	}
	
	//已结清(新)
	function getMyDqApplyList1() {
		$.getJSON('/getmydqapplylist', $.extend(getRequestData(),{finish: 1,page: 1,pagesize: 50}), function(data) {
			if (0 == data.error_code) {
				var myData = "";
				if (data.list == null || data.list == '' || data.list == '[]') {
					myData = '<div style="text-align:center; font-size:18px; color:#999; padding-top:40%;"> 暂无记录 </div>';
					$('#clean_end').append(myData);
				} else {
					var obj = jQuery.parseJSON(data.list);
					 $.each(obj, function(index, item){
			            myData += '<dl class="regularly_info">';
			            myData += '<dt><span><a onclick="showMyProtocol('+item.id+');">查看合同</a></span>'+item.title+'</dt>';
			            myData += '<dd class="regularly_img03">';
			            myData += '<div class="regularly_info_nun">';
			            myData += '<div class="regularly_info_nunl"> <em>'+formatMoney(item.apply_bj)+'</em>元</div>';
			            myData += '<div class="regularly_info_nunr">';
			            myData += ' <p>到期：<span class="gray">'+item.last_time+'</span></p>';
			            myData += ' <p>利率：<span class="gray">'+item.rate+'%(年)</span></p>';
			            myData += ' <p>收益：<span class="yellow">￥'+formatMoney(item.yj_sy)+'</span></p>';
			            myData += ' </div>';
			            myData += ' </div>';
			            myData += ' </dd>';
			            myData += ' </dl>';
			        });
			        $('#clean_end').append(myData);
				}
			} else {
				requestError();
			}
		}).error(function() {
			requestError();
		});
	}
	
    //查看我的合同
	function showMyProtocol(applyId){
	    //跳转到合同
	   window.location.href = "protocol.html?id=" + applyId;
	}


//持有中
function getMyYdbList2(data){
	$.getJSON('/getmyydblist',$.extend({apply_status:2},getRequestData()),function(data){
		if(0==data.error_code){
		  	var myData = "";
		  	if(data.list==null || data.list==''||data.list=='[]'){
		       myData='<div style="text-align:center; font-size:18px; color:#999; padding-top:40%;"> 暂无记录 </div>';
		  	}else{
		        var obj = jQuery.parseJSON(data.list);
			    $.each(obj, function(index, item){
		            myData += '<dl class="regularly_info" data-id="'+item.apply_id+'">';
		            myData += '<dt>'+item.project_title+'</dt>';
		            myData += '<dd class="regularly_img02">';
		            myData += '<div class="regularly_info_nun">';
		            myData += '<div class="regularly_info_nunl"> <em>'+formatMoney(item.apply_amount)+'</em>元</div>';
		            myData += '<div class="regularly_info_nunr">';
		           // myData += ' <p>还款：<span class="gray">'+(item.next_income_time==undefined?"已完成":getDateDiff(getCurrentYearMonth(),item.next_income_time)+"天后")+'</span></p>';
		            myData += ' <p>还款：<span class="gray">'
		                      + (item.next_income_time==undefined ? "已完成" : getDateDiff(getCurrentYearMonth(),item.next_income_time)<=0  ? "已完成" : (getDateDiff(getCurrentYearMonth(),item.next_income_time)+"天后"))
		                      + '</span></p>';
		            myData += ' <p>期限：<span class="gray">'+item.period+'个月</span></p>';
		            myData += ' <p>利率：<span class="gray">'+item.appreciation_rate+'%(年)</span></p>';
		            myData += ' <p>收益：<span class="yellow">￥'+formatMoney(item.income_ratesum)+'</span></p>';
		            myData += ' </div>';
		            myData += ' </div>';
		            myData += ' </dd>';
		            myData += ' </dl>';
		        });
		    }
		  	$('#chi_you').html(myData).append('<div class="version">点击投资记录可查看合同</div>');
		  	
		}else{
	   		requestError();
	    }
   	}).error(function(){
		requestError();
	}); 
  
}



 //申购中
function getMyYdbList1(data){
	$.getJSON('/getmyydblist',$.extend({apply_status:1},getRequestData()),function(data){
		if(0==data.error_code){
		  	var myData = "";
		  	if(data.list==null || data.list==''||data.list=='[]'){
		      	myData='<div style="text-align:center; font-size:18px; color:#999; padding-top:40%;"> 暂无记录 </div>';
		   	}else{
		       	var obj = jQuery.parseJSON(data.list);
		        $.each(obj, function(index, item){
		            myData += '<dl class="regularly_info">';
		            myData += '<dt>'+item.project_title+'</dt>';
		            myData += '<dd class="regularly_img01">';
		            myData += '<div class="regularly_info_nun">';
		            myData += '<div class="regularly_info_nunl"> <em>'+formatMoney(item.apply_amount)+'</em>元</div>';
		            myData += '<div class="regularly_info_nunr">';
		            myData += ' <p>已售：<span class="gray">'+Math.floor(item.applyed_count/item.market_value*100)+'%</span></p>';
		            myData += ' <p>期限：<span class="gray">'+item.period+'个月</span></p>';
		            myData += ' <p>利率：<span class="gray">'+item.appreciation_rate+'%(年)</span></p>';
		            myData += ' </div>';
		            myData += ' </div>';
		            myData += ' </dd>';
		            myData += ' </dl>';
		        });
		        $('.me_regularly_ul>li:eq(1)').click();
		    }
		   	$('#applying').html(myData);
	   	}else{
	   		requestError();
	    }
   	}).error(function(){
		requestError();
	}); 
}



//已结清
function getMyYdbList3(data){
	$.getJSON('/getmyydblist',$.extend({apply_status:3},getRequestData()),function(data){
		if(0==data.error_code){
		  	var myData = "";
		  	if(data.list==null || data.list==''||data.list=='[]'){
		      	myData='<div style="text-align:center; font-size:18px; color:#999; padding-top:40%;"> 暂无记录 </div>';
		   	}else{
		        var obj = jQuery.parseJSON(data.list);
		        $.each(obj, function(index, item){
		            myData += '<dl class="regularly_info" data-id="'+item.apply_id+'">';
		            myData += '<dt>'+item.project_title+'</dt>';
		            myData += '<dd class="regularly_img03">';
		            myData += '<div class="regularly_info_nun">';
		            myData += '<div class="regularly_info_nunl"> <em>'+formatMoney(item.apply_amount)+'</em>元</div>';
		            myData += '<div class="regularly_info_nunr">';
		            myData += ' <p>期限：<span class="gray">'+item.period+'个月</span></p>';
		            myData += ' <p>利率：<span class="gray">'+item.appreciation_rate+'%(年)</span></p>';
		            myData += ' <p>收益：<span class="yellow">￥'+formatMoney(item.income_ratesum)+'</span></p>';
		            myData += ' </div>';
		            myData += ' </div>';
		            myData += ' </dd>';
		            myData += ' </dl>';
		
		        });
		    }
		   	$('#clean_end').html(myData).append('<div class="version">点击投资记录可查看合同</div>');
		}else{
	   		requestError();
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