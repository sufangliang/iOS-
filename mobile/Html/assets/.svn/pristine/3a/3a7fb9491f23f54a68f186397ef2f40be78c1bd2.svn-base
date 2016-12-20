//加载完毕
$(function() {

  loadURL(wrapIosNativeCallback("getHost"));

  //点击事件
  $('.container-fluid').on('click', '.list-group-item', function() {

    loadURL(wrapIosNativeCallback("gotoWebUrl", $(this).data("hidden").replace("file:///android_asset/", "")));
  });
});

//加载资讯
function loadNews(data) {
  //alert(data);

}

function getHost(host) {
  $.getJSON(host + '/getnews', function(data) {
    $('.list-group').empty();
    $.each(data.detail, function(i, val) {
      $('.list-group').append(
        '<li class="list-group-item" data-hidden="' + val.content_url + '">' + '<a class="media" href="#">' + '<div class="media-left">' + '<img class="media-object" src="' + host + data.url + val.image_url + '" style="width: 107px; height: 80px;">' + '</div>' + '<div class="media-body">' + '<h4 class="media-heading">' + val.title + '</h4>' + '<h6 style="margin: 0 0;">' + val.stamp + '</h6>' + '<p>' + val.abstract + '</p>' + '</div>' + '</a>' +
        '</li>'
      );
    });
  });
}