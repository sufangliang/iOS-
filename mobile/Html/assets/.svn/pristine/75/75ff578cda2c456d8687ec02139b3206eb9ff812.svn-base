$(function() {

   // 邀请码和二维码
   Callback.getInviteCode();

});

// 邀请码和二维码
function getInviteCode(data){
    var obj = jQuery.parseJSON(data);
    new QRCode(document.getElementById("qrcode"), "http://www.178bank.net/assets/register.html?inviteCode=" + obj.INVITE_CODE);
}