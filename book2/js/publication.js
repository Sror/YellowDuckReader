function highdpi_init() {
    if ($('.replace-2x').css('font-size') == "1px") {
        var els = $("img.replace-2x").get();
        for (var i = 0; i < els.length; i++) {
            var src = els[i].src
            src = src.replace(".png", "@2x.png");
            src = src.replace(".jpg", "@2x.jpg");
            els[i].src = src;
        }
    }
}

var YDPublication = {

    init: function() {

        $(document).ready(function() {
            highdpi_init();
        });

    },

};
