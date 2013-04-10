function followUser(user) {
	$.ajax({
    type: "POST",
    url: "/followUser/" + user,
    dataType: "script",
    success: function(){
	    $("[name='followUser" + user + "']").addClass('disabled');
			$("[name='removeUser" + user + "']").removeClass('disabled');
		},
		error: function(){
			alert('Failure following user.');
		}
	});
}

function removeUser(user) {
	$.ajax({
    type: "POST",
    url: "/removeUser/" + user,
    dataType: "script",
    success: function(){
			$("[name='followUser" + user + "']").removeClass('disabled');
	    $("[name='removeUser" + user + "']").addClass('disabled');
			$("#followingFeedItemId" + user).hide();
		},
		error: function(){
			alert('Failure removing user.');
		}
	});
}

function followOrganization(organization) {
	$.ajax({
    type: "POST",
    url: "/followOrganization/" + organization,
    dataType: "script",
    success: function(){
	    $("[name='followOrganization" + organization + "']").addClass('disabled');
			$("[name='removeOrganization" + organization + "']").removeClass('disabled');
		},
		error: function(){
			alert('Failure following organization.');
		}
	});
}

function removeOrganization(organization) {
	$.ajax({
    type: "POST",
    url: "/removeOrganization/" + organization,
    dataType: "script",
    success: function(){
	    $("[name='removeOrganization" + organization + "']").addClass('disabled');
			$("[name='followOrganization" + organization + "']").removeClass('disabled');
			$("#followingFeedItemId" + organization).hide();
		},
		error: function(){
			alert('Failure removing organization.');
		}
	});
}