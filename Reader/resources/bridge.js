var YDPublication = {

    message: function(name) {
        var iframe = document.createElement("IFRAME");
        iframe.setAttribute("src", "reader://" + name);
        document.documentElement.appendChild(iframe);
        iframe.parentNode.removeChild(iframe);
        iframe = null;
    },
    
    showTOC: function() {
        this.message("showTOC");
    },
    
};
