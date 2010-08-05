// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

// Configure jQuery {{{1
jQuery.ajaxSetup({
    'beforeSend': function(xhr) {xhr.setRequestHeader("Accept", "text/javascript")}
});

// jQuery Custom Functions {{{1
jQuery.fn.submitWithAjax = function() {
    this.submit(function() {
        $.post(this.action, $(this).serialize(), null, "script");
        return false;
    });
    return this;
};

// Application object {{{1
var APP = {};
// }}}1

// Document Ready {{{1
$(document).ready(function() {
    // Async requests
    jQuery.getJSON('/main/autocomplete_map', function(data) {
        APP.autocomplete_map = data;
        $('input.autocomplete').each(function(index) {
            $(this).autocomplete({ source: APP.autocomplete_map[$(this).attr('id')] });
        });
    });
});
// }}}1

// vim:set fdm=marker:
