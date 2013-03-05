$(document).ready(function () {

    $("body").delegate(".update-status", "click", function() {
		$("#post_status").val(true);
		$("#post_text").val($(this).attr("value"));
        $("#new_post").submit();
	});
    // auto refresh posts
    setInterval(function () {
        var token = $('#posts').data('token');
        $.get('/refresh', { token: token }).done(function(data){
            var jqHtml = $(data);
            var newToken = jqHtml.children("#token").text();
            if (newToken)
            {
                $("#posts").data('token', newToken);
            }

            var feedItems = jqHtml.children(".feed-item");

            if (feedItems.length > 0)
            {
                $("#posts").prepend(feedItems);
            }
        });

    }, 10000);

    // intercept post button clicking event
    $("body").delegate("#submitNewPost", "click", submitPost );
	
	function submitPost(e){
        e.preventDefault();
        e.stopPropagation();

        $("#post_text").val($("#new_post_text").val());

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

$(document).bind("pagechange", function(toPage) {
	clearBindings();
	createBindings();
	updatePickerText();
	hidePicker();
});

$("#newPostDialog").on('pagebeforeshow', function() {
	clearFormValues();
});

function createBindings() {
	// Handlers for the organization picker
	$("#postAsSwitch").click(function() {
		if ($("#organizationPicker").is(":visible")) { hidePicker(); }
		else { showPicker(); }
	});
	
	$("#organizationPicker").find("input[name='post_as']").click(function() {
		if (this.value == "self") {
			$("#postAsBar").removeClass("gray");
			$("#postAsBar").addClass("orange");
			hidePicker();
		} else {
			$("#postAsBar").removeClass("orange");
			$("#postAsBar").addClass("gray");
			hidePicker();
		}		
		var organization = $("label[for='"+$(this).attr('id')+"']");
		$("#postAsName").text("Posting as " + organization.text());
		
		$.ajax({
			url: '/context',
			data: { id: $(this).attr('id') },
			dataType: 'json'
		});
		
		//$("input[name='post[organization_id]']").val($(this).attr('id'));
	});

	// Handlers for the check-in dialog
	$("#submitAllClear").click(function() {
		$("#post_text").val("STATUS_OK");
		$("#post_status").val("true");
		$("#new_post").submit();
	});		
	
	$("#submitNeedAssistance").click(function() {
		$("#post_text").val("STATUS_NEEDS_ASSISTANCE");
		$("#post_status").val("true");
		$("#new_post").submit();
		
	});
	
	$("#submitNeedHelp").click(function() {
		$("#post_text").val("STATUS_NEEDS_HELP");
		$("#post_status").val("true");
		$("#new_post").submit();
	});
}

function clearBindings() {
	$("#postAsSwitch").unbind('click');	
	$("#organizationPicker").find("input[name='post_as']").unbind('click');	
	$("#submitNewPost").unbind('click');
	$("#submitAllClear").unbind('click');	
	$("#submitNeedAssistance").unbind('click');	
	$("#submitNeedHelp").unbind('click');	
};

function showPicker() {
	$("#organizationPicker").show();
	$("#postAsSwitch").find(".ui-icon").removeClass("ui-icon-arrow-d");
	$("#postAsSwitch").find(".ui-icon").addClass("ui-icon-arrow-u");	
};

function hidePicker() {
	$("#organizationPicker").hide();
	$("#postAsSwitch").find(".ui-icon").removeClass("ui-icon-arrow-u");
	$("#postAsSwitch").find(".ui-icon").addClass("ui-icon-arrow-d");
};

function updatePickerText() {
	var id = $("input[checked='checked']").attr("id");
	var organization = $("label[for='" + id + "']");
	$("#postAsName").text("Posting as " + organization.text());
	
	console.log(id + " : " + organization);
	if (id == "self") {
		$("#postAsBar").removeClass("gray");
		$("#postAsBar").addClass("orange");
		hidePicker();
	} else {
		$("#postAsBar").removeClass("orange");
		$("#postAsBar").addClass("gray");
		hidePicker();
	}
};

// Dialog Helper Methods
function clearFormValues() {
	$("#post_latitude").val('');
	$("#post_longitude").val('');
	$("#post_text").val('');
	$("#post_status").val('');
	
	// Clear the text boxes
	$("#new_post_text").val('');
};
