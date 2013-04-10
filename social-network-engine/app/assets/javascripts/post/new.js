var setup = function () {

    onPageShow("newPost");

    if ($("#submit_NewPost").length > 0) {
        $("#submit_NewPost").click(function () {
            $("#post_text").val($("#new_post_text").val());
            submitPost();
        });
    }

		if ($("#post_image").length > 0) {
			$("#post_image").hide();
			$("#img_preview").hide();	

			$("#attach_picture").click(function(e) {
				$("#post_image").click();
			});
		}
};

(function () {
    setup();
})();


