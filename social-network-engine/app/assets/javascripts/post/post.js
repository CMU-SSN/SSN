$(document).ready(function () {

    $("body").delegate(".update-status", "click", function() {
		$("#post_status").val(true);
		$("#post_text").val($(this).attr("value"));
        $("#new_post").submit();
	});
    // auto refresh posts
    setInterval(function () {
        var token = $('#posts').data('token');
        $.get('/refresh', { token: token }).done(function(data){
            var jqHtml = $(data);
            var newToken = jqHtml.children("#token").text();
            if (newToken)
            {
                $("#posts").data('token', newToken);
            }

            var feedItems = jqHtml.children(".feed-item");

            if (feedItems.length > 0)
            {
                $("#posts").prepend(feedItems);
            }
        });

    }, 10000);
});