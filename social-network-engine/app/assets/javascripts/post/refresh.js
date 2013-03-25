$(document).ready(function () {

    // auto refresh posts
    setInterval(function () {
        var token = $('#posts').data('token');
        $.get('/refresh', { token: token }).done(function (data) {
            var jqHtml = $(data);
            var newToken = jqHtml.children("#token").text();
            if (newToken) {
                $("#posts").data('token', newToken);
            }

            var feedItems = jqHtml.children(".feed-item");

            if (feedItems.length > 0) {
                if ($("#posts").is(":visible") == true) {
                    $("#posts").prepend(feedItems);
                }
            }
        });

    }, 10000);
});