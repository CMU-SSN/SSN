function postsOnly () {
	$(".posts").show();
	$(".friends").hide();
	$(".organizations").hide();
}

function friendsOnly () {
	$(".friends").show();	
	$(".posts").hide();
	$(".organizations").hide();
}

function organizationsOnly() {
	$(".organizations").show();
	$(".posts").hide();
	$(".friends").hide();
}

function resetUserOrg() {
	$(".postsButton").addClass("ui-btn-active");
	postsOnly();
}