(function () {
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
        $.get('/refresh', parameters).done(function (data) {
            var jqHtml = $(data);

            var feedItems = jqHtml.children(".feed-item");

            $("#posts").empty();
            if (feedItems.length > 0) {
                $("#posts").prepend(feedItems);
            }
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
            /*Set address*/
//            $.ajax({
//                url: "/location",
//                dataType: "json",
//                data: {latitude: lat, longitude: lng},
//                success: function(data){
//                    $("#location").val(data.address);
//                }
//            });

            pullFeeds({ latitude: lat, longitude: lng, radius: $("#radius").val() });

            /*Update filter summary text*/
            $("#filter-summary").text("Filtered posts");

            /*Add a clear filter button*/
            $("#clear-filter-btn").show();
        });
    }

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
            filterCurrentLocation();
        })
    });
})();