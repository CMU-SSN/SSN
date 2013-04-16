var setup = function () {

    onPageShow("newPost");

    if ($("#submit_NewPost").length > 0) {
        $("#submit_NewPost").click(function () {
						var valid = false;
						if ($("#new_post_text").val().length > 0) {
							console.log("We have text!");
							$("#post_text").val($("#new_post_text").val());		
							valid = true;					
						} else if ($("#post_image").val().length > 0) {
							valid = true;
						}
						
						if (valid) {
							submitPost();
						}
				});
    }

		if ($("#post_image").length > 0) {
			$("#post_image").hide();
			$("#img_preview").hide();	

			$("#attach_picture").click(function(e) {
				$("#post_image").click();
			});
			
			$("#post_image").change(function(e) {
				if ($("#post_image").val().length == 0) {
					$("#img_preview").empty();
					$("#img_preview").hide();
				}
			});
		}
};

(function () {
    setup();
})();


