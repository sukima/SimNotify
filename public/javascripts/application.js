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
var APP = { config: {
    debug: false,
    jquery_theme_path: "/stylesheets/jquery-ui-themes/themes/%s/jquery.ui.all.css"
}};

// Locale text {{{2
APP.locale = {
    pick_datetime: "Pick a date and time..."
};

// Function: log() {{{2
// APP.log = function (msg) {
    // var alert_needed = true;
    // var str = msg;
    // if (!typeof msg === String) srt = msg.toString();
    // if (console && console.log) {
        // console.log(msg);
        // alert_needed = false;
    // }
    // if ( $("#general_debug_info").length > 0 ) {
        // $("#general_debug_info").append(str);
        // alert_needed = false;
    // }
    // if (alert_needed) alert(str);
// };

// Function: getTimeValues() {{{2
APP.getTimeValues = function(dateTimeStr) {
    var t = dateTimeStr.replace(/^.*\s+/, '').split(":");
    return { hour: t[0], minute: t[1] };
};

// Function: getDateValues() {{{2
APP.getDateValues = function(dateTimeStr) {
    var d = dateTimeStr.replace(/\s+.*$/, '').split("/");
    // the month and day are not 0 padded unlike the rest of the select values.
    d[0] = d[0].replace(/^0+/, '');
    d[1] = d[1].replace(/^0+/, '');
    return { month: d[0], day: d[1], year: d[2] };
};

// Function: getDateTimeStringFromHashes() {{{2
APP.getDateTimeStringFromHash = function(d) {
    return d.month + "/" + d.day + "/" + d.year + " " + d.hour + ":" + d.minute;
};

// Function: saveDateValues() {{{2
// Rails default select list uses the following order:
//     year, month, day, hour, minute
APP.saveDateValues = function () {
    var sels = $(this).closest('.datetime').find("select:lt(5)");
    var t = APP.getTimeValues($(this).val());
    var d = APP.getDateValues($(this).val());
    $(sels[0]).val(d.year);
    $(sels[1]).val(d.month);
    $(sels[2]).val(d.day);
    $(sels[3]).val(t.hour);
    $(sels[4]).val(t.minute);
};

// Function: syncStartEndDates() {{{2
APP.syncStartEndDates = function () {
    var end_date = $("#event_end_time_input .ui-date-text");
    var d1 = $(this).val().replace(/[^\d]/g, '');
    var d2 = (end_date.val() == APP.locale.pick_datetime) ?
        0 : end_date.val().replace(/[^\d]/g, '');
    if  (d2 < d1)
        end_date.val($(this).val()).trigger('change').effect('highlight');
};

// Function: initNotifications() {{{2
APP.initNotifications = function (scope) {
    if (jQuery.browser.msie)
        return;

    scope = (scope === undefined) ? null : scope;

    $(".notification", scope).wrap("<div class=\"ui-widget\" />").
        after("<div class=\"clear\" />").
        addClass("ui-state-highlight ui-corner-all").
        prepend("<span class=\"ui-icon ui-icon-info\" />");

    $(".warning", scope).wrap("<div class=\"ui-widget\" />").
        after("<div class=\"clear\" />").
        addClass("ui-state-error ui-corner-all").
        prepend("<span class=\"ui-icon ui-icon-alert\" />");

    $("#flash_notice", scope).wrap("<div class=\"ui-widget\" />").
        after("<div class=\"clear\" />").
        addClass("ui-corner-all").
        prepend("<span class=\"ui-icon ui-icon-info\" />");

    $("#flash_error", scope).wrap("<div class=\"ui-widget\" />").
        after("<div class=\"clear\" />").
        addClass("ui-corner-all").
        prepend("<span class=\"ui-icon ui-icon-alert\" />");
};

// Function: initHelpTabs() {{{2
APP.initHelpTabs = function () {
    $("#help").tabs();
    $(".help-buttons").addClass("ui-widget").wrap("<div class=\"ui-helper-clearfix\" />");
    $("a.help-button").button().click(function (e) {
        e.preventDefault();
        $("#help").tabs('select', $(this).attr('href'));
        return false;
    });
};

// Function: initThemePicker() {{{2
APP.initThemePicker = function () {
    if (!jQuery.support.htmlSerialize)
        return;

    $("#instructor_gui_theme").change(function () {
        url = APP.config.jquery_theme_path.replace(/(^|[^%])%s/, "$1" + $(this).val());
        $("link.theme").attr("href", url);
        $("#theme_sample").show();
    });
};

// }}}1

// Document Ready {{{1
$(document).ready(function() {
    // Flag Detection {{{2
    if ( $("#NewUserFlag").length > 0 ) {
        APP.config.new_user = true;
        if (APP.config.debug) $("NewUserFlag").append("NewUserFlag set").show();
    } else {
        APP.config.new_user = false;
    }

    // Reusable Resources {{{2
    var $loading = $("<img src=\"/images/loading.gif\" alt=\"loading\" />");

    // Autocomplete {{{2
    $.getJSON('/main/autocomplete_map', function(data) {
        APP.autocomplete_map = data;
        $('input.autocomplete').each(function(index) {
            $(this).autocomplete({ source: APP.autocomplete_map[$(this).attr('id')] });
        });

        $("select.multiselect").each(function () {
            if ( $(this).attr("multiple") === undefined )
            {
                $(this).multiSelect({
                    multiple: false,
                    showHeader: false,
                    minWidth: 200,
                    selectedText: function (numChecked, numTotal, checkedItem) {
                        return $(checkedItem).attr("title");
                    }
                });
            }
            else
            {
                $(this).multiSelect({
                    minWidth: 300,
                    selectedList: 2,
                    showHeader: false
                });
            }
        });
    });

    // Datepicker / Timepicker {{{2
    // Define the dateFormat for the datepicker
    // $.datepicker._defaults.dateFormat = 'M dd yy';

    /**
     * Replaces the date or datetime field with jquey-ui datepicker
     */
    // Date/Time Picker Init {{{3
    $('.datetime').each(function(i, el) {
        var input = document.createElement('input');
        if ($(el).attr('id') == "event_start_time_input")
            $(input).bind('change', APP.syncStartEndDates);

        // datepicker field
        $(input).attr({'type': 'text', 'class': 'ui-date-text'});
        // Insert the input:text before the first select
        $(el).find("select:first").before(input);
        if (!APP.config.debug) $(el).find("select:lt(5)").hide();
        // Set the input with the value of the selects
        var values = [ ];
        $(el).find("select:lt(5)").each(function(i, el) {
            var val = $(el).val();
            if(val != '') values.push(val);
        });
        if( values.length > 1 ) {
            d = new Date(values[0], parseInt(values[1]) - 1, values[2]);
            $(input).val(APP.getDateTimeStringFromHash({
                year: values[0],
                month: values[1],
                day: values[2],
                hour: values[3],
                minute: values[4]
            }));
        }
        else
        {
            $(input).val(APP.locale.pick_datetime);
        }

        $(input).datetimepicker({
            stepMinute: 15,
            minuteGrid: 15,
            hourGrid: 4
        });
    });

    /**
     * Sets the date for each select with the date selected with datepicker
     */
    // Input change events {{{3
    $('input.ui-date-text').live('change', APP.saveDateValues);

    // }}}3


    // Accordions {{{2
    $(".accordion").accordion({
      header: '.accordion-header',
      collapsible: true,
      clearStyle: true 
    });

    // Buttons {{{2
    $("#navigation a, input.create, input.update").button();

    $(".button_box").addClass("ui-widget");

    $(".button").button();

    if (APP.config.new_user) {
        $("#nav_help_link").button("option", "icons", {primary:'ui-icon-info'});
    }

    // Notifications {{{2
    APP.initNotifications();

    // Override confirm() {{{2
    // This is a bit of a hack to override the :confirm option in link_to but
    // it degrades nicely.
    $("a[confirm_message]").each(function () {
        // OPTIMIZE: Use this blog to optimize
        // http://blog.nemikor.com/2009/04/08/basic-usage-of-the-jquery-ui-dialog/
        $(this).removeAttr('onclick');
        $(this).unbind('click', false);
        $(this).click(function (e) {
            var anchor = this;
            $("<div>" + $(this).attr('confirm_message') + "</div>").dialog({
                resizable: false,
                modal: true,
                title: $(this).text(),
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
    // Help dialog {{{2
    APP.initHelpTabs();

    $("#nav_help_link").each(function () {
        var help_href = $(this).attr('href') + "?partial=1";
        var help_dialog = $("<div />").append($loading.clone());
        var help_link = $(this).one('click', function (e) {
            e.preventDefault();
            help_dialog.load(help_href, function () {
                APP.initHelpTabs();
                APP.initNotifications(this);
            });
            help_dialog.dialog({
                title: "Help",
                width: 550
            });
            help_link.click(function () {
                e.preventDefault();
                help_dialog.dialog('open');
                return false;
            });
            return false;
        });
    });

    // Deprecated in favor of #NewUserFlag
    if ( $("#force_display_help").length > 0 ) {
        $("#nav_help_link").trigger('click');
    }

    // Theme Viewer {{{2
    APP.initThemePicker();

    // Submit Event Form {{{2
    var no_scenario_link = $("#no-scenario-link");
    if (no_scenario_link.length > 0) {
        no_scenario_link.click(function (e) {
            $(this).hide();
            $("form.submit_note").show();
        });

        $("form.submit_note").hide();
    }

}); // }}}1

// vim:set sw=4 ts=4 et fdm=marker:
