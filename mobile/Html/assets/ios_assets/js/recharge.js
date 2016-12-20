//充值金额
var recharge_amount= queryString("recharge_amount");

//加载完毕
$(function() {

  //获取我的信息
  loadURL(wrapIosNativeCallback("getUser"));

  //获取我的银行卡账户
  loadURL(wrapIosNativeCallback("getMyBankAccount"));

  //获取用户认证信息  当实名认证 和 银行卡 都绑定 且成功充值过 返回 true
  loadURL(wrapIosNativeCallback("getUserVerify"));
  
  //如果从转入页面传来的充值金额大于0  则赋值
    if(recharge_amount!=undefined && recharge_amount!=null  && recharge_amount>0){
        $('#money_order').val(recharge_amount);
        $('#money_order').attr("disabled","disabled");
    }

 //银行卡bin查询  文本改变
     $("#bankCard").bind("input propertychange",function(){
            //alert($(this).val().length);
            $('#bankCardMessage').hide();
            if($(this).val().length>=16){
               loadURL(wrapIosNativeCallback("queryBankCardBinLimit", $('#bankCard').val()));
            }
        });
	
	


  //充值
  $('#rechargeButton').click(function() {
    loadURL(wrapIosNativeCallback("recharge", $('#money_order').val(), $('#have_id_card').val(), $('#have_bank_card').val(), $('#name').val(), $('#idCard').val(), $('#bankCard').val()));
  });


    //编辑
    $('#edit_verify').click(function() {
         $(this).hide();
         $('#name').attr("disabled",false);
         $('#idCard').attr("disabled",false);
         $('#bankCard').attr("disabled",false);
         $('#bankFullNameDiv').hide();


         //获取焦点第一次触发
         $('#name').one("focus",function() {
                      $(this).val("");
                      //是否绑定过身份证
                      $('#have_id_card').val("false");
                    });

         //获取焦点第一次触发
         $('#idCard').one("focus",function() {
                      $(this).val("");
                      //是否绑定过身份证
                      $('#have_id_card').val("false");
                    });

          //获取焦点第一次触发
         $('#bankCard').one("focus",function() {
                         $(this).val("");
                         $('#bankCard').attr("type","number");
                          //是否绑定过银行卡
                          $('#have_bank_card').val("false");
                    });


      });

});



//充值回调赋值
function doRecharge(data) {
  $('#req_data').val(JSON.stringify(data));
  $('#charge').submit();
}

//银行卡bin查询
function queryBankCardBinLimit(data){

  var obj = jQuery.parseJSON(data);

  $('#bankCardMessage').text(obj.bank_name+"支付额度："+(obj.count_limit==undefined?"系统维护期间":obj.count_limit)+"，"+(obj.day_limit==undefined?"暂停交易":obj.day_limit)+"。");
  $('#bankCardMessage').show();

}




//获取我的信息
function getUser(data){
   var obj = jQuery.parseJSON(data);
   $('#name').val(obj.NAME);
   $('#idCard').val(obj.ID_CARD);


  //如果实名认证过
   if(obj.ID_CARD_STATUS == 0 || obj.ID_CARD_STATUS==1){
         $('#name').attr("disabled","disabled");
         $('#idCard').attr("disabled","disabled");

         //是否绑定过身份证
         $('#have_id_card').val("true");
   }else{
      $('#edit_verify').hide();
   }

}

//获取我的银行卡账户
function getMyBankAccount(data){

   var obj = jQuery.parseJSON(data);

   if(obj.BANK_FULL_NAME != undefined && obj.BANK_FULL_NAME != null && obj.BANK_FULL_NAME != ''){
       $('#bankFullName').val(obj.BANK_FULL_NAME);
       $('#bankFullNameDiv').show();

    //查询限额
    loadURL(wrapIosNativeCallback("queryBankLimit", obj.BANK_FULL_NAME));
  }
  //如果绑定过银行卡
  if (obj.BANK_ACCOUNT != undefined && obj.BANK_ACCOUNT != null && obj.BANK_ACCOUNT != '') {
    $('#bankCard').attr("disabled", "disabled");
    $('#bankCard').attr("type", "text");
    $('#bankCard').val(obj.BANK_ACCOUNT);

       //是否绑定过银行卡
       $('#have_bank_card').val("true");
       $('#yellow_msg').hide();
   }else{
       $('#edit_verify').hide();
   }
}

//银行卡查询限额
function queryBankLimit(data){

    var obj = jQuery.parseJSON(data);

    $('#bankFullName').val($('#bankFullName').val()+"  支付额度："+(obj.count_limit==undefined?"系统维护期间":obj.count_limit)+"，"+(obj.day_limit==undefined?"暂停交易":obj.day_limit)+"。");

}


//获取用户认证信息  当实名认真 和 银行卡 都绑定 返回 true
function getUserVerify(data){
    jsLog("getUserVerify: data = " + data);
    //如果已经充值过
    if(data=="true"){
         $('#edit_verify').hide();

    }
}

