var setup = function () {

    onPageShow("newPost");

    if ($("#submit_NewPost").length > 0) {
        $("#submit_NewPost").click(function () {
            $("#post_text").val($("#new_post_text").val());
            submitPost();
        });
    }

};

(function () {
    setup();
})();


