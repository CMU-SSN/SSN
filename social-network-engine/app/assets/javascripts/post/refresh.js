$(document).ready(function () {

    // auto refresh posts
    setInterval(function () {

        if ($("#posts").is(":visible") == true) {
            var token = $('#posts').data('token');
            $.get('/refresh', { token: token }).done(function (data) {
                var jqHtml = $(data);
                var newToken = jqHtml.children("#token").text();
                if (newToken) {
                    $("#posts").data('token', newToken);
                }

                var feedItems = jqHtml.children(".feed-item");

                if (feedItems.length > 0) {
                    $("#posts").prepend(feedItems);
                }
            });
        }

    }, 10000);
});