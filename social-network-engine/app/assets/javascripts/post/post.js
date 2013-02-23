$('document').ready(function () {

    // auto refresh posts
    setInterval(function () {
        var token = $('#posts').data('token');
        $.ajax({
            type: 'GET',
            url: '/posts',
            dataType: 'json',
            data: {token: token},
            context: $(this),
            timeout: 25000,
            beforeSend: function (data) {
            },
            success: function (data) {
                if (data.code === 200) {
                    if (data.token) {
                        $('#posts').data('token', data.token);
                    }

                    $("#posts").prepend(
                        $("#postTemplate").render(data.data)
                    );

                    $(".timeago").timeago().removeClass("timeago");
                }
                else if (data.code === 500) {
                }

            },
            error: function (data) {

            },
            complete: function (data) {
            }
        });
    }, 10000);

    // intercept post button clicking event
    $("body").delegate("#submit-post", "click", function (e) {
        e.preventDefault();
        e.stopPropagation();

        if (navigator.geolocation) {
            navigator.geolocation.getCurrentPosition(function (position) {
                    if (position && position.coords && position.coords.latitude && position.coords.longitude) {
                        $("#post_latitude").val(position.coords.latitude);
                        $("#post_longitude").val(position.coords.longitude);
                    }

                    $("#new_post").submit();
                }, function (err) {
                    $("#new_post").submit();
                },
                {
                    timeout: 3000
                });

            return;
        }

        $("#new_post").submit();
    });
});