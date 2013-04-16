function followUser(user) {
	$.ajax({
	  beforeSend: function() { $.mobile.showPageLoadingMsg(); }, //Show spinner
    complete: function() { $.mobile.hidePageLoadingMsg() }, //Hide spinner
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
	  beforeSend: function() { $.mobile.showPageLoadingMsg(); }, //Show spinner
    complete: function() { $.mobile.hidePageLoadingMsg() }, //Hide spinner	
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
	  beforeSend: function() { $.mobile.showPageLoadingMsg(); }, //Show spinner
    complete: function() { $.mobile.hidePageLoadingMsg() }, //Hide spinner	
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
	  beforeSend: function() { $.mobile.showPageLoadingMsg(); }, //Show spinner
    complete: function() { $.mobile.hidePageLoadingMsg() }, //Hide spinner	
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

$(".userPostsButton").live("ajax:beforeSend", function() {
	$.mobile.showPageLoadingMsg();
});

$(".userPostsButton").live("ajax:complete", function() {
	$.mobile.hidePageLoadingMsg();
});

$(".userFriendsButton").live("ajax:beforeSend", function() {
	$.mobile.showPageLoadingMsg();
});

$(".userFriendsButton").live("ajax:complete", function() {
	$.mobile.hidePageLoadingMsg();
});

$(".userFollowingsButton").live("ajax:beforeSend", function() {
	$.mobile.showPageLoadingMsg();
});

$(".userFollowingsButton").live("ajax:complete", function() {
	$.mobile.hidePageLoadingMsg();
});

$(".userOrganizationsButton").live("ajax:beforeSend", function() {
	$.mobile.showPageLoadingMsg();
});

$(".userOrganizationsButton").live("ajax:complete", function() {
	$.mobile.hidePageLoadingMsg();
});

$(".organizationPostsButton").live("ajax:beforeSend", function() {
	$.mobile.showPageLoadingMsg();
});

$(".organizationPostsButton").live("ajax:complete", function() {
	$.mobile.hidePageLoadingMsg();
});

$(".organizationFriendsButton").live("ajax:beforeSend", function() {
	$.mobile.showPageLoadingMsg();
});

$(".organizationFriendsButton").live("ajax:complete", function() {
	$.mobile.hidePageLoadingMsg();
});