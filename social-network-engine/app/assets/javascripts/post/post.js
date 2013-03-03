$('document').ready(function () {

    $("body").delegate(".update-status", "click", function() {
		$("#post_status").val(true);
		$("#post_text").val($(this).attr("value"));
        $("#new_post").submit();
	});
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
    $("body").delegate("#submit-post", "click", submitPost(e) );
	
	function submitPost(e){
        e.preventDefault();
        e.stopPropagation();

        if (navigator.geolocation) {
            var watchID = navigator.geolocation.watchPosition(function (position) {
                    if (position && position.coords && position.coords.latitude && position.coords.longitude) {
                        $("#post_latitude").val(position.coords.latitude);
                        $("#post_longitude").val(position.coords.longitude);
                    }

                    navigator.geolocation.clearWatch(watchID);
                    $("#new_post").submit();
                }, function (error) {

                    navigator.geolocation.clearWatch(watchID);
                    switch (error.code) {
                        case error.TIMEOUT:
                            alert('Timeout when retrieving your location');
                            // Don't submit for this case
                            return;
                        case error.POSITION_UNAVAILABLE:
                            break;
                        case error.PERMISSION_DENIED:
                            break;
                        case error.UNKNOWN_ERROR:
                            break;
                    }

                    $("#new_post").submit();
                },
                {
                    timeout: 30000,
                    enableHighAccuracy: true
                });

            return;
        }

        $("#new_post").submit();
    }
});