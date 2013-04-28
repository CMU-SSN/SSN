(function () {
    function getQueryString(name) {
      name = name.replace(/[\[]/, "\\\[").replace(/[\]]/, "\\\]");
      var regexS = "[\\?&]" + name + "=([^&#]*)";
      var regex = new RegExp(regexS);
      var results = regex.exec(window.location.search);
      if(results == null) {
        return "";
      } else {
        return decodeURIComponent(results[1].replace(/\+/g, " "));
      }
    }

    function showGeoFilter(){
        $("#geo-filter").show();
        $("#filter-btn").find(".ui-icon").removeClass("ui-icon-arrow-d").addClass("ui-icon-arrow-u");
    }

    function hideGeoFilter(){
        $("#geo-filter").hide();
        $("#filter-btn").find(".ui-icon").removeClass("ui-icon-arrow-u").addClass("ui-icon-arrow-d");
    }

    function pullFeeds(parameters)
    {
			$.ajax({
				url: "/reloadPosts?f=" + getQueryString("f")
			});
    }
		
    function resetFilter() {
        /*Reset filter values*/
        $("#location").val("");
        $("#radius").val("100");
        $("#radius").slider("refresh");

        /*Reset summary text*/
        $("#filter-summary").text("All posts");


        /*Remove "Clear Filter" button*/
        $("#clear-filter-btn").hide();

        /*Get default feeds*/
        pullFeeds({});
    }

    function filter()
    {
        pullFeeds({ location: $("#location").val(), radius: $("#radius").val() });
        /*Update filter summary text*/
        $("#filter-summary").text("Filtered posts");

        /*Add a clear filter button*/
        $("#clear-filter-btn").show();
    }

    function filterCurrentLocation() {
        geotagPost(function(lat, lng){

            pullFeeds({ latitude: lat, longitude: lng, radius: $("#radius").val() });

            /*Update filter summary text*/
            $("#filter-summary").text("Filtered posts");

            /*Add a clear filter button*/
            $("#clear-filter-btn").show();
        });
    }

    var paginationManager = pagination();
    paginationManager.init(loadPage, 1);

    function loadPage(page)
    {
        var last_token = $('#posts').data('last-token');
        $.get('/refresh', { token: last_token, backward:'true', f: getQueryString("f") }).done(function (data) {
            var jqHtml = $(data);
            var newToken = jqHtml.children("#last-token").text();

            var feedItems = jqHtml.children(".feed-item");

            if (feedItems.length > 0 && $("#posts").is(":visible")) {
                $("#posts").append(feedItems);
                if (newToken) {
                    $("#posts").data('last-token', newToken);
                }
                paginationManager.check();
            }
        });
    }

    $(document).on("pageshow", "#index", function() {

        $.ajax({
            beforeSend: function () {
                $.mobile.showPageLoadingMsg();
            }, //Show spinner
            complete: function () {
                $.mobile.hidePageLoadingMsg()
            }, //Hide spinner
            success: function () {
                paginationManager.check();
            },
            url: "/reloadPosts?f=" + getQueryString("f")
        });
    });

    $(document).ready( function(){

        $("#filter-btn").live("click", function(){
            if ($("#geo-filter").is(":visible")) { hideGeoFilter(); }
            else { showGeoFilter(); }
        });

        $("#clear-filter-btn").live("click", function(){
            resetFilter();
        });

        $("#current-location-btn").live("click", function(){
            filterCurrentLocation();
        });

        $("#location").live("keypress", function(e){
            if (e.keyCode == 13)
            {
                filter();
            }
        });

        $("#location").live("focusout", function(){
            filter();
        });

        $("#radius").live("change", function(){
            if ($("#radius").val() == 0)
            {
                return;
            }
            filterCurrentLocation();
        });
    });
})();
