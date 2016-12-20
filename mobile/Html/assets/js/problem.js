//加载完毕
$(function(){

    var otherDiv = $(".cjwd_div_2");//其他隐藏div
    var otherImg = $(".cjwd_div img");//其他 标题中的img
    //  alert(otherImg.length);
    //点击标题div
    $( ".cjwd_div" ).click(function(){
        var nextDiv = $(this).next("div");//当前点击div的下一个div
        var img = $(this).find("img");//当前点击div内的图片
        //alert(img.attr("src"));
        if(nextDiv.css("display") == 'none'){
             otherDiv.hide();
             nextDiv.show();
             otherImg.attr("src","img/cjbottom.gif");
             img.attr("src","img/cjtop.gif");
        }else{
             otherDiv.hide();
             otherImg.attr("src","img/cjbottom.gif");
        }
    });



});


