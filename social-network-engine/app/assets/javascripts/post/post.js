$('document').ready(function () {

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
                    if (data.token)
                    {
                        $('#posts').data('token', data.token);
                    }

                    $("#posts").prepend(
                        $("#postTemplate").render(data.data)
                    );
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
});