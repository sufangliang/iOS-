//加载完毕
$(function() {
  //获取银行列表
  //Callback.getBankList();


  //获取我的信息
  loadURL(wrapIosNativeCallback("getUser"));

  //获取我的银行卡账户
  loadURL(wrapIosNativeCallback("getMyBankAccount"));

  //获取用户认证信息  当实名认真 和 银行卡 都绑定 返回 true
  loadURL(wrapIosNativeCallback("getUserVerify"));

  //银行卡bin查询  文本改变
     $("#bankCard").bind("input propertychange",function(){
            //var str = $(this).val().replace(/\s/g,'').replace(/(\d{4})(?=\d)/g,"$1 ");
            //$(this).val(str) ;
            $('#bankCardMessage').hide();
            if($(this).val().length>=16){
               loadURL(wrapIosNativeCallback("queryBankCardBinLimit", $('#bankCard').val()));
            }
        });

    //实名认证
  $('#verifyButton').click(function() {
    loadURL(wrapIosNativeCallback("verify", $('#name').val(), $('#idCard').val(), $('#bankCard').val()));
  });
   //获取焦点第一次触发
    $('#name').one("focus",function() {
            	  $(this).val("");
            	});

  //获取焦点第一次触发
  $('#idCard').one("focus", function() {
    $(this).val("");
  });

  //获取焦点第一次触发
  $('#bankCard').one("focus", function() {
    $(this).val("");
    $('#bankCard').attr("type", "number");
  });


});


//获取我的信息
function getUser(data) {
  var obj = jQuery.parseJSON(data);
  if (obj.NAME != "" && obj.NAME != undefined && obj.NAME != null) {
    $('#name').val(obj.NAME);
    $('#idCard').val(obj.ID_CARD);

  }
}

//获取我的银行卡账户
function getMyBankAccount(data) {
  var obj = jQuery.parseJSON(data);
  if (obj.BANK_ACCOUNT != "" && obj.BANK_ACCOUNT != undefined && obj.BANK_ACCOUNT != null) {
    $('#bankCard').attr("type", "text");
    $('#bankFullName').val(obj.BANK_FULL_NAME);
    $('#bankCard').val(obj.BANK_ACCOUNT);

    //查询限额
    loadURL(wrapIosNativeCallback("queryBankLimit", obj.BANK_FULL_NAME));
  }

}


//获取用户认证信息  当实名认真 和 银行卡 都绑定 返回 true
function getUserVerify(data) {
  //如果已经充值过
  if (data == "true") {
    $('#verifyButton').hide();
    $('#name').attr("disabled", "disabled");
    $('#idCard').attr("disabled", "disabled");
    $('#bankFullName').attr("disabled", "disabled");
    $('#bankCard').attr("disabled", "disabled");
    $('#bankFullNameDiv').show();
    $('#yellow_msg').hide();

  }
}

//银行卡bin查询
function queryBankCardBinLimit(data) {

  var obj = jQuery.parseJSON(data);

  $('#bankCardMessage').text(obj.bank_name + "支付额度：" + (obj.count_limit == undefined ? "" : obj.count_limit) + "，" + (obj.day_limit == undefined ? "" : obj.day_limit) + "。");
  $('#bankCardMessage').show();

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

//银行卡查询限额
function queryBankLimit(data) {
  var obj = jQuery.parseJSON(data);
  $('#bankFullName').val($('#bankFullName').val() + "  支付额度：" + (obj.count_limit == undefined ? "" : obj.count_limit) + "，" + (obj.day_limit == undefined ? "" : obj.day_limit) + "。");
}