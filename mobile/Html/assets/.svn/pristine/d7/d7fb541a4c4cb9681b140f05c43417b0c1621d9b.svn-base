//加载完毕
$(function(){
      //申购id
      var applyId = queryString("applyId");
      //获取我的合同信息
      loadURL(wrapIosNativeCallback("getMyProtocol", applyId));
});


	//获取我的合同信息
	function getMyProtocol(data) {
        jsLog("getMyProtocol data = " + data);

	    var obj = jQuery.parseJSON(data);

        $('#name').text(obj.name);
        $('#loginname').text(obj.loginName);
        $('#idCard').text(obj.idCard);

        $('#ydbname').text(obj.ydjName);
        $('#protocol').text(obj.protocol);

        $('#amount').text(formatMoney(obj.amount,0));
        $('#amountup').text(obj.amountUp);
        $('#peroid').text(obj.peroid+"天");
        $('#rate').text(obj.rate+"%");

        $('#now').text(obj.fulfilTime);

	}
