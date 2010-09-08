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

// Function: saveDateValues() {{{2
APP.saveDateValues = function () {
    var sels = $(this).closest('.date, .datetime').find("select:lt(3)");
    var d = null;
    try {
        d = $.datepicker.parseDate($.datepicker._defaults.dateFormat, $(this).val() );
        $(sels[0]).val(d.getFullYear());
        $(sels[1]).val(d.getMonth() + 1);
        $(sels[2]).val(d.getDate());
    } catch (e) {
        $(this).val('');
    }
};

// Function: saveTimeValues() {{{2
APP.saveTimeValues = function () {
    var sels = $(this).closest('.date, .datetime').find("select:gt(2)");
    var t = $(this).val().split(":");

    $(sels[0]).val(t[0]);
    $(sels[1]).val(t[1]);
};

// Locale text {{{3
APP.locale = {
    pick_date: "Pick a date...",
    pick_time: "Pick a time..."
};

// Function: syncStartEndDates() {{{2
APP.syncStartEndDates = function () {
    var end_date = $("#event_end_time_input .ui-date-text");
    var d1 = $.datepicker.parseDate($.datepicker._defaults.dateFormat, $(this).val());
    var d2 = (end_date.val() == APP.locale.pick_date) ?
        0 : $.datepicker.parseDate($.datepicker._defaults.dateFormat, end_date.val());
    if  (d2 < d1)
        end_date.val($(this).val()).trigger('change').effect('highlight');
};

// Function: syncStartEndTimes() {{{2
APP.syncStartEndTimes = function () {
    var end_time = $("#event_end_time_input .ui-time-text");
    var t = $(this).val().split(":");
    var t2 = (end_time.val() == APP.locale.pick_time) ?
        0 : end_time.val().replace(/[^\d]/g, '');
    if (t2 < t.join("")) {
        t[0] = (t[0] * 1) + (1 * (t[0] < 23) ? 1 : 0);
        end_time.val(t.join(":")).trigger('change').effect('highlight');
    }
};

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
    // Date Picker Init {{{3
    $('.date, .datetime').each(function(i, el) {
        var input = document.createElement('input');
        if ($(el).attr('id') == "event_start_time_input")
            $(input).bind('change', APP.syncStartEndDates);

        // datepicker field
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
        else
        {
            $(input).val(APP.locale.pick_date);
        }

        $(input).datepicker();
    });

    // Time Picker Init {{{3
    $('.time, .datetime').each(function(i, el) {
        var input = document.createElement('input');
        var saveFunction = null;
        if ($(el).attr('id') == "event_start_time_input")
            $(input).bind('change', APP.syncStartEndTimes);

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
        else
        {
            $(input).val(APP.locale.pick_time);
        }

        $(input).timepickr({
            convention: 24,
            select: function () {
                $(this).trigger('change');
            },
            width: 260
        });
    });
    // }}}3

    /**
     * Sets the date for each select with the date selected with datepicker
     */
    // Input change events {{{3
    $('input.ui-date-text').live('change', APP.saveDateValues);

    $('input.ui-time-text').live('change', APP.saveTimeValues);

    // }}}3


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

    $("#calendar-legend").wrap("<div class=\"ui-widget\" />").
        addClass("ui-corner-all ui-helper-clearfix");

    // Accordions {{{2
    $(".accordion").accordion({
      header: '.accordion-header',
      collapsible: true,
      clearStyle: true 
    });

    // Buttons {{{2
    $("#navigation a, input.create, input.update").button();

    // Notifications {{{2
    $(".notification").wrap("<div class=\"ui-widget\" />").
        after("<div class=\"clear\" />").
        addClass("ui-state-highlight ui-corner-all ui-helper-clearfix").
        prepend("<span class=\"ui-icon ui-icon-info\" />");

    $(".warning").wrap("<div class=\"ui-widget\" />").
        after("<div class=\"clear\" />").
        addClass("ui-state-error ui-corner-all").
        prepend("<span class=\"ui-icon ui-icon-alert\" />");

    $("#flash_notice").wrap("<div class=\"ui-widget\" />").
        after("<div class=\"clear\" />").
        addClass("ui-corner-all").
        prepend("<span class=\"ui-icon ui-icon-alert\" />");

    // Override confirm() {{{2
    // This is a bit of a hack to override the :confirm option in link_to but
    // it degrades nicely.
    $("a[confirm_message]").each(function () {
        $(this).removeAttr('onclick');
        $(this).unbind('click', false);
        $(this).click(function (e) {
            var anchor = this;
            $("<div>" + $(this).attr('confirm_message') + "</div>").dialog({
                resizable: false,
                modal: true,
                buttons: {
                    Ok: function() {
                        window.location.href = $(anchor).attr('href');
                    },
                    Cancel: function() {
                        $(this).dialog('close');
                        $(this).remove();
                    }
                }
            });
            return false;
        });
    });

    // }}}2
});
// }}}1

// vim:set sw=4 ts=4 et fdm=marker:
