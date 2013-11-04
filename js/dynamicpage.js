$(function() {

    if(Modernizr.history){

    var newHash      = "",
        $content = $("#content"),
    
    
    $("nav").delegate("a", "click", function() {
        _link = $(this).attr("href");
        history.pushState(null, null, _link);
        loadContent(_link);
        return false;
    });

    function loadContent(href){
        $("#content")
                .fadeOut(200, function() {
                    $content.hide().load(href + "#content", 
                        function() {
                            $mainContent.fadeIn(200);
                        });
                });
    };
    
    $(window).bind('popstate', function(){
       _link = location.pathname.replace(/^.*[\\\/]/, ''); //get filename only
       loadContent(_link);
    });

    } // otherwise, history is not supported, so nothing fancy here.
    
});