// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

// Configure jQuery {{{1
jQuery.ajaxSetup({
    'beforeSend': function(xhr) {xhr.setRequestHeader("Accept", "application/json")}
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
    // Async requests {{{2
    $.getJSON('/main/autocomplete_map', function(data) {
        APP.autocomplete_map = data;
        $('input.autocomplete').each(function(index) {
            $(this).autocomplete({ source: APP.autocomplete_map[$(this).attr('id')] });
        });
    });

    // Datepicker / Timepicker {{{2
    // Define the dateFormat for the datepicker
    $.datepicker._defaults.dateFormat = 'M dd yy';

    /**
     * Replaces the date or datetime field with jquey-ui datepicker
     */
    $('.date, .datetime').each(function(i, el) {
        var input = document.createElement('input');
        $(input).attr({'type': 'text', 'class': 'ui-date-text'});
        // Insert the input:text before the first select
        $(el).find("select:first").before(input);
        $(el).find("select:lt(3)").hide();
        // Set the input with the value of the selects
        var values = [];
        $(el).find("select:lt(3)").each(function(i, el) {
            var val = $(el).val();
            if(val != '') values.push(val);
        });
        if( values.length > 1 ) {
            d = new Date(values[0], parseInt(values[1]) - 1, values[2]);
            $(input).val( $.datepicker.formatDate($.datepicker._defaults.dateFormat, d) );
        }

        $(input).datepicker();


        input = document.createElement('input');
        $(input).attr({'type': 'text', 'class': 'ui-time-text'});
        $(el).find("select:last").after(input);
        $(el).find("select:gt(2)").hide();

        values = [];
        $(el).find("select:gt(2)").each(function(i, el) {
            var val = $(el).val();
            if(val != '') values.push(val);
        });
        if( values.length > 1) {
            $(input).val( values[0] + ":" + values[1] );
        }

        $(input).timePicker({
            show24Hours: true,
            separator: ':',
            step: 15
        });
    });

    /**
     * Sets the date for each select with the date selected with datepicker
     */
    $('input.ui-date-text').live("change", function() {
        var sels = $(this).closest('.date, .datetime').find("select:lt(3)");
        var d = $.datepicker.parseDate($.datepicker._defaults.dateFormat, $(this).val() );

        $(sels[0]).val(d.getFullYear());
        $(sels[1]).val(d.getMonth() + 1);
        $(sels[2]).val(d.getDate());
    });

    $('input.ui-time-text').live("change", function() {
        var sels = $(this).closest('.date, .datetime').find("select:gt(2)");
        var t = $(this).val().split(":");

        $(sels[0]).val(t[0]);
        $(sels[1]).val(t[1]);
    });


    // Calendar {{{2
    $("#calendar").fullCalendar({
        firstDay: 1, // Monday
        events: '/calendar/events',
        header: {
            left: 'prev,next today',
            center: 'title',
            right: 'month,agendaWeek,agendaDay'
        }
    });

    // Accordions {{{2
    $(".accordion").accordion({header: '.accordion-header'});

    // Buttons {{{2
    $("a.nav-link").button();

    // }}}2
});
// }}}1

// vim:set fdm=marker:
