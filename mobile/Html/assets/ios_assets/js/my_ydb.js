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

var currentPage1=0;  // 持有中
var currentPage2=0;  // 已结清
var pageCount = 10;  // 1页个数

//加载完毕
$(function() {
   //投资定期
    $("a").click(function() {
                   //跳转到相关页面  url  是否需要登录
		     loadURL(wrapIosNativeCallback("gotoLocalWebPage", $(this).data("hidden").replace("file:///android_asset/", ""), $(this).data("login")));
    });

  $('.me_regularly_ul').on('click','li',function(){
    $('.me_regularly_ul li').removeClass('current');
    $(this).addClass('current');

    $('.me_regularly_li').hide();
    $('.me_regularly_li:eq('+$('.me_regularly_ul li').index(this)+')').show();
  });

  refresh();
});

function refresh() {
    currentPage1 = 0;
    currentPage2 = 0;
    
    //获取我的资金
    loadURL(wrapIosNativeCallback("getMyMoneyStatistics"));
    
    //持有中(新)
    loadURL(wrapIosNativeCallback("getMyDqApplyList", 0, 1, pageCount));
    
    //已结清(新)
    loadURL(wrapIosNativeCallback("getMyDqApplyList", 1, 1, pageCount));
    
    //如果投资过
    if(ydb_apply_amount!=undefined && ydb_apply_amount!=null && ydb_apply_amount!=""){
        
        applyAnimation();
    }
}

function ydbApply(amount) {
    jsLog("my_ydb:ydbApply amount = " + amount);
    ydb_apply_amount = amount;

    refresh();
}

function applyAnimation() {
    setTimeout(function(){
       //添加动画
       $('.wallet_total div').addClass('wallet_at');
       $('.wallet_total div').show();
       $('#apply_amount_div').text("+"+ydb_apply_amount);
       setTimeout(function(){$('.wallet_total div').hide();}, 900);}, 1500);
}

//获取我的资金
function getMyMoneyStatistics(data){

    var obj = jQuery.parseJSON(data);

  	var demo1 = new countUp("memberDsbj", 0, obj.memberDsbj, 2, 1, options);
    demo1.start();

    var demo2 = new countUp("memberDslx", 0, obj.memberDslx, 2, 1, options);
    demo2.start();

    var demo3 = new countUp("dingSumSy", 0, obj.dingSumSy, 2, 1, options);
    demo3.start();
}






//持有中(新)
function getMyDqApplyList0(data){
    jsLog("my_ydb:getMyDqApplyList0 data = " + data);
    
    loadURL(wrapIosNativeCallback("finishLoadMore"));
    
    var myData = "";
    if(data==null || data==''||data=='[]'){
        if(currentPage1==0){
            myData='<div style="text-align:center; font-size:18px; color:#999; padding-top:40%;"> 暂无记录 </div>';
            $('#chi_you').append(myData);
        }else{
            loadURL(wrapIosNativeCallback("tips", "亲~没有更多记录了"));
        }
    }else{
        var obj = jQuery.parseJSON(data);
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
        if(currentPage1 == 0) {
            $('#chi_you').html(myData);
        } else {
             $('#chi_you').append(myData);
        }
       

    }


}

//已结清(新)
function getMyDqApplyList1(data){
    jsLog("my_ydb:getMyDqApplyList1 data = " + data);
    
    loadURL(wrapIosNativeCallback("finishLoadMore"));
    
    var myData = "";
    if(data==null || data==''||data=='[]'){
        if(currentPage2==0){
            myData='<div style="text-align:center; font-size:18px; color:#999; padding-top:40%;"> 暂无记录 </div>';
            $('#clean_end').append(myData);
        }else{
            loadURL(wrapIosNativeCallback("tips", "亲~没有更多记录了"));
        }
    }else{
        var obj = jQuery.parseJSON(data);
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
        if(currentPage1 == 0) {
            $('#clean_end').html(myData);
        } else {
            $('#clean_end').append(myData);
        }
    }
}


//加载更多
function loadMore(){
    jsLog("loadMore");
    if($("ul li:eq(0)").hasClass("current")){
        currentPage1++;
        //持有中(新)
        loadURL(wrapIosNativeCallback("getMyDqApplyList", 0, currentPage1 + 1, pageCount));
    }else if($("ul li:eq(1)").hasClass("current")){
        currentPage2++;
        //已结清(新)
        loadURL(wrapIosNativeCallback("getMyDqApplyList", 1, currentPage2 + 1, pageCount));
    }
}

//查看我的合同
function showMyProtocol(applyId){
    //跳转到合同
    loadURL(wrapIosNativeCallback("gotoLocalWebPage", "protocol.html?applyId=" + applyId, "true"));
}
