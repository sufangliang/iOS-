
//提现金额
var withdraw_amount=queryString("withdraw_amount");
//充值金额
var recharge_amount=queryString("recharge_amount");
//4个tab 的 下拉次数  默认0次
var loadMoreCount1=0;
var loadMoreCount2=0;
var loadMoreCount3=0;
var loadMoreCount4=0;

//加载完成
$(function(){
   //转入流水
   Callback.getMyTradeLog("apply" ,1,20);
   //赎回流水
   Callback.getMyTradeLog(11,1,20);
   //充值流水
   Callback.getMyTradeLog(1,1,20);
   //提现流水
   Callback.getMyTradeLog(2,1,20);

});




//转入流水
function getMyTradeLogApply(data){
   var myData = "";
   if(data==null || data==''||data=='[]'){
      if(loadMoreCount1==0){
         myData='<tr><td colspan="4" style="text-align:center; font-size:18px; color:#999; padding-top:40%; width:100%; background-color: #f0f0f0;">暂无记录</td></tr>';
      }else{
         Callback.showToast("亲~没有更多记录了");
      }
    }else{
        var obj = jQuery.parseJSON(data);
        $.each(obj, function(index, item){
            myData += "<tr>";
            myData += "<td>"+item.TRANSACTION_TIME.substring(0,10)+"</td>";
            myData += "<td>"+formatMoney(item.TRANSACTION_AMOUNT, 1)+"</td>";
            myData += "<td>"+formatMoney(item.CURRENT_AMOUNT, 1)+"</td>";
            myData += "<td>"+(item.NOTE==undefined?"":item.NOTE)+"</td>";
            myData +="</tr>";
        });
     }
   $('#applyList').append(myData);
}

//赎回流水
function getMyTradeLogRedeem(data){
     var myData = "";
     if(data==null || data==''||data=='[]'){
           if(loadMoreCount2==0){
                    myData='<tr><td colspan="4" style="text-align:center; font-size:18px; color:#999; padding-top:40%; width:100%; background-color: #f0f0f0;">暂无记录</td></tr>';
                 }else{
                     Callback.showToast("亲~没有更多记录了");
                 }
      }else{
        var obj = jQuery.parseJSON(data);
        $.each(obj, function(index, item){
            myData += "<tr>";
            myData += "<td>"+item.TRANSACTION_TIME.substring(0,10)+"</td>";
            myData += "<td>"+formatMoney(item.TRANSACTION_AMOUNT, 1)+"</td>";
            myData += "<td>"+formatMoney(item.CURRENT_AMOUNT, 1)+"</td>";
            myData += "<td>"+(item.NOTE==undefined?"":item.NOTE)+"</td>";
            myData +="</tr>";
        });
    }
   $('#redeemList').append(myData);
}

//充值流水
function getMyTradeLogRecharge(data){
  var myData = "";
  if(data==null || data==''||data=='[]'){
        if(loadMoreCount3==0){
                 myData='<tr><td colspan="4" style="text-align:center; font-size:18px; color:#999; padding-top:40%; width:100%; background-color: #f0f0f0;">暂无记录</td></tr>';
              }else{
                 Callback.showToast("亲~没有更多记录了");
              }
   }else{
        var obj = jQuery.parseJSON(data);
        $.each(obj, function(index, item){
            myData += "<tr>";
            myData += "<td>"+item.TRANSACTION_TIME.substring(0,10)+"</td>";
            myData += "<td>"+formatMoney(item.TRANSACTION_AMOUNT, 1)+"</td>";
            myData += "<td>"+formatMoney(item.CURRENT_AMOUNT, 1)+"</td>";
            myData += "<td>"+(item.NOTE==undefined?"":item.NOTE)+"</td>";
            myData +="</tr>";
        });
    }
   $('#rechargeList').append(myData);
     //如果 存在充值金额 则提现列表显示
   if(recharge_amount!=undefined && recharge_amount!=null && recharge_amount!=''){
        $("ul li a:eq(2)").click();
        $("ul li :eq(0)").css("background-color","#fff");
        $("#rechargeList").find("tr:eq(0)").css("background-color","#d6ebff");
   }
}

//提现流水
function getMyTradeLogWithdraw(data){
   var myData = "";
   if(data==null || data==''||data=='[]'){
         if(loadMoreCount4==0){
                  myData='<tr><td colspan="4" style="text-align:center; font-size:18px; color:#999; padding-top:40%; width:100%; background-color: #f0f0f0;">暂无记录</td></tr>';
               }else{
                  Callback.showToast("亲~没有更多记录了");
               }
    }else{
       var obj = jQuery.parseJSON(data);
        $.each(obj, function(index, item){
            myData += "<tr>";
            myData += "<td>"+item.TRANSACTION_TIME.substring(0,10)+"</td>";
            myData += "<td>"+formatMoney(item.TRANSACTION_AMOUNT, 1)+"</td>";
            myData += "<td>"+formatMoney(item.CURRENT_AMOUNT, 1)+"</td>";
            myData += "<td>"+(item.NOTE==undefined?"":item.NOTE)+"</td>";
            myData +="</tr>";
        });
    }
   $('#withdrawList').append(myData);
   //如果 存在提现金额 则提现列表显示
   if(withdraw_amount!=undefined && withdraw_amount!=null && withdraw_amount!=''){
         $("ul li a:eq(3)").click();
         $("ul li :eq(0)").css("background-color","#fff");
         $("#withdrawList").find("tr:eq(0)").css("background-color","#d6ebff");
   }
}

//加载更多
function loadMore(){

     //alert( $("ul li:eq(1)").hasClass("active"));

     if($("ul li:eq(0)").hasClass("active")){
            //下拉次数加一次
           loadMoreCount1++;
           //转入流水
           Callback.getMyTradeLog("apply" ,1+loadMoreCount1,20);
     }else if($("ul li:eq(1)").hasClass("active")){
            //下拉次数加一次
            loadMoreCount2++;
           //赎回流水
           Callback.getMyTradeLog(11,1+loadMoreCount2,20);
     }else if($("ul li:eq(2)").hasClass("active")){
            //下拉次数加一次
            loadMoreCount3++;
           //充值流水
           Callback.getMyTradeLog(1,1+loadMoreCount3,20);
     }else if($("ul li:eq(3)").hasClass("active")){
             //下拉次数加一次
            loadMoreCount4++;
           //提现流水
           Callback.getMyTradeLog(2,1+loadMoreCount4,20);
     }
}


