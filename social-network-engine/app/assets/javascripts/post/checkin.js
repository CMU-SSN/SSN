var setup = function() {
    onPageShow("checkin");

    if ($("#submit_AllClear").length > 0) {
        $("#submit_AllClear").click(function() {
            $("#post_text").val("STATUS_OK");
            $("#post_status").val("true");
            submitPost();
        });
    }

    if ($("#submit_NeedHelp").length > 0) {
        $("#submit_NeedHelp").click(function() {
            $("#post_text").val("STATUS_NEEDS_HELP");
            $("#post_status").val("true");
            submitPost();
        });
    }

    if ($("#submit_NeedAssistance").length > 0) {
        $("#submit_NeedAssistance").click(function() {
            $("#post_text").val("STATUS_NEEDS_ASSISTANCE");
            $("#post_status").val("true");
            submitPost();
        });
    }
};

(function(){
    setup();
})();