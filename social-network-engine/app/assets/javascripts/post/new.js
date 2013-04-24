var setup = function () {

    onPageShow("newPost");

    if ($("#submit_NewPost").length > 0) {
        $("#submit_NewPost").click(function () {
						var valid = false;
						if ($("#new_post_text").val().length > 0) {
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
				if( window.FormData === undefined ) {
					alert("This browser likely doesn't support file upload. Trying anyway.\nIf nothing happens try a different browser.")
				} 
				$("#post_image").click();				
			});
		}
};

(function () {
    setup();
})();

function previewImage(input) {
	if (input.files && input.files[0]) {
		var reader = new FileReader();
		
		reader.onload = function(e) {
			var img = new Image();		
			img.id = Math.random().toString(36).substring(5);
			img.src = e.target.result;

			$("#img_preview").empty();
			$("#img_preview").append(img);
			$("#img_preview").show();
		}	
		
		reader.readAsDataURL(input.files[0]);	
	}
}


