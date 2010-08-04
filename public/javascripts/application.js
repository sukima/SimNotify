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
APP.autocomplete_state = {
    async_ready         : false,
    document_ready      : false,
    autocomplete_loaded : false
};
APP.autocomplete = function() {
    if (APP.autocomplete_state['async_ready'] && APP.autocomplete_state['document_ready']
        && !APP.autocomplete_state['autocomplete_loaded'])
    {
        APP.autocomplete_state['autocomplete_loaded'] = true;
        $('.autocomplete').each(function(index) {
            id = $(this).attr('id');
            if (id === null) {
                $(this).autocomplete({ disabled: true });
            } else {
                $(this).autocomplete({ source: APP.autocomplete_map[id] });
            }
        });
    }
};
// }}}1

// Async requests
jQuery.getJSON('/main/autocomplete_map', function(data) {
    APP.autocomplete_map = data;
    APP.autocomplete_state['async_ready'] = true;
    APP.autocomplete();
});

// Document Ready
$(document).ready(function() {
    APP.autocomplete_state['document_ready'] = true;
    APP.autocomplete();
});

// vim:set fdm=marker:
