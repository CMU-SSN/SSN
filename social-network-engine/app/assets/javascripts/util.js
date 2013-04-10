function hide_header_footer() {
    $("div[data-role='header']").hide();
	$("div[data-role='footer']").hide();
}

function previewImage(input) {
	if (input.files && input.files[0]) {
		var reader = new FileReader();
		reader.onload = function (e) {
			$("#img_preview").empty();
			
			var img = new Image();
			img.id = Math.random().toString(36).substring(5);
			img.src = e.target.result;

			$("#img_preview").append(img);
			$("#img_preview").show();
		}
		
		reader.readAsDataURL(input.files[0]);	
	}
}