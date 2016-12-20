	document.write("<script language='javascript' src='/assets/js/util/common.js'></script>");
//加载完毕
$(function(){

      //获取我的资金
      getMyMoneyStatistics();

});


//获取我的资金
function getMyMoneyStatistics(){
	$.getJSON('/getmymoneystatistics', $.extend({}, getRequestData()), function(data) {
		 var obj = jQuery.parseJSON(data.detail);
     $("#useBalance").text(formatMoney(obj.useBalance));
     $("#withdrawFrozenAmount").text(formatMoney(obj.withdrawFrozenAmount));
     $("#applyFrozenAmount").text(formatMoney(obj.applyFrozenAmount));
     $("#memberDsbj").text(formatMoney(obj.memberDsbj));
     $("#memberDslx").text(formatMoney(obj.memberDslx));
     $("#memberWalletBx").text(formatMoney(obj.memberWalletBx));
     $("#sumBalance").text(formatMoney(obj.sumBalance));
  });
}