//加载完毕
$(function(){
    //加载资讯
	Callback.loadNews();
	  
	//点击事件
	$('.container-fluid').on('click','.list-group-item',function(){
		 Callback.gotoWebViewPage($(this).data("hidden"), 'false');
	});
});

//加载资讯
function loadNews(data) {
	$('.list-group').empty();
	jQuery.each(data.detail, function(i, val) {		
		$('.list-group').append(
			'<li class="list-group-item" data-hidden="' + val.content_url +'">'
			+	'<a class="media" href="#">'
			+ 		'<div class="media-left">'
			+			'<img class="media-object" src="' + Callback.getHost() + data.url + val.image_url + '" style="width: 107px; height: 80px;">'
			+		'</div>'
			+		'<div class="media-body">'
			+			'<h4 class="media-heading">' + val.title + '</h4>'
			+			'<h6 style="margin: 0 0;">' + val.stamp + '</h6>'
			+			'<p>' + val.abstract + '</p>'
			+		'</div>'
			+	'</a>'+
			'</li>'
		);
	});
}