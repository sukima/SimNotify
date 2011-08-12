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

// Global Settings {{{1
$.n.defaults.timeout = 3000;

// Application object {{{1
var APP = {
    cache: {
        loading: $("<img src=\"/images/loading.gif\" alt=\"loading\" />")
    },
    config: {
        debug: false,
        jquery_theme_path: "/stylesheets/jquery-ui-themes/themes/%s/jquery.ui.all.css"
    }
};

// Locale text {{{1
APP.locale = {
    pick_datetime: "Pick a date and time..."
};

// Function: log() {{{1
// APP.log = function (msg) {
    // var alert_needed = true;
    // var str = msg;
    // if (!typeof msg === String) srt = msg.toString();
    // if (console && console.log) {
        // console.log(msg);
        // alert_needed = false;
    // }
    // if ( $("#general_debug_info").length ) {
        // $("#general_debug_info").append(str);
        // alert_needed = false;
    // }
    // if (alert_needed) alert(str);
// };

// Function: getTimeValues() {{{1
APP.getTimeValues = function(dateTimeStr) {
    var t;
    if (dateTimeStr.length < 3)
    {
        t = [ dateTimeStr, "0" ];
    }
    else
    {
        t = dateTimeStr.replace(/^.*\s+/, '').split(":");
        if (t.length < 2)
        {
            var re = /(\d?\d)(\d\d)$/;
            var result = re.exec(t[0]);
            t[0] = (result[1]) ? result[1] : "0";
            t[1] = (result[2]) ? result[2] : "0";
        }
    }
    return { hour: t[0], minute: t[1] };
};

// Function: getDateValues() {{{1
APP.getDateValues = function(dateTimeStr) {
    var d = dateTimeStr.replace(/\s+.*$/, '').split("/");
    // the month and day are not 0 padded unlike the rest of the select values.
    d[0] = d[0].replace(/^0+/, '');
    d[1] = d[1].replace(/^0+/, '');
    return { month: d[0], day: d[1], year: d[2] };
};

// Function: getDateTimeStringFromHash() {{{1
APP.getDateTimeStringFromHash = function(d) {
    return d.month + "/" + d.day + "/" + d.year + " " + d.hour + ":" + d.minute;
};

// Function: saveDateValues() {{{1
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

// Function: syncStartEndDates() {{{1
APP.syncStartEndDates = function () {
    var end_date = $("#event_end_time_input .ui-date-text");
    var d1 = $(this).val().replace(/[^\d]/g, '');
    var d2 = (end_date.val() == APP.locale.pick_datetime) ?
        "0" : end_date.val().replace(/[^\d]/g, '');
    if  (d2 < d1)
        end_date.val($(this).val()).trigger('change').effect('highlight');
};

// Function: initNotifications() {{{1
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

// Function: initHelpTabs() {{{1
APP.initHelpTabs = function () {
    $("#help").tabs();
    $(".help-buttons").addClass("ui-widget").wrap("<div class=\"ui-helper-clearfix\" />");
    $("a.help-button").button().click(function (e) {
        e.preventDefault();
        $("#help").tabs('select', $(this).attr('href'));
        return false;
    });
};

// Function: initThemePicker() {{{1
APP.initThemePicker = function () {
    if (!jQuery.support.htmlSerialize)
        return;

    $("#instructor_gui_theme").change(function () {
        var url = APP.config.jquery_theme_path.replace(/(^|[^%])%s/, "$1" + $(this).val());
        $("link.theme").attr("href", url);
        $("#theme_sample").show();
    });
};

// Function: flagDetection() {{{1
APP.flagDetection = function() {
    if ( $("#NewUserFlag").length ) {
        APP.config.new_user = true;
        if (APP.config.debug) $("NewUserFlag").append("NewUserFlag set").show();
    } else {
        APP.config.new_user = false;
    }
};

// Function: autocomplete() {{{1
APP.autocomplete = {
    init: function(data) {
        APP.cache.autocomplete_map = data;
        $('input.autocomplete').each(function(index) {
            $(this).autocomplete({ source: APP.cache.autocomplete_map[$(this).attr('id')] });
        });
    },
    load: function() {
        $.getJSON('/main/autocomplete_map', this.init);
    }
};

// Function: loadMultiselect() {{{1
APP.loadMultiselect = function() {
    $("select.multiselect").each(function () {
        if ( $(this).attr("multiple") )
        {
            $(this).multiselect({
                minWidth: 300,
                selectedList: 2,
                showHeader: false
            });
        }
        else
        {
            $(this).multiselect({
                multiple: false,
                showHeader: false,
                minWidth: 200,
                selectedText: function (numChecked, numTotal, checkedItem) {
                    return $(checkedItem).attr("title");
                }
            });
        }
    });
};

// Function: initNavBar() {{{1
APP.initNavBar = function() {
    $("#navigation").removeClass("side-navigation").addClass("nav-widget ui-widget ui-widget-header ui-corner-all ui-helper-clearfix");
    $("#content").removeClass("side-nav-width").addClass("top-nav-width");
    $("#navigation>ul").addClass("nav-list");
    $("#navigation>ul li>ul").addClass("sub-nav-list ui-widget ui-widget-content ui-corner-all ui-helper-clearfix").hide();
    $(".nav-list li").hover(function() {
        $('ul', this).slideDown(100);
    }, function() {
        $('ul', this).slideUp(100);
    });
};

// Function: initDateTimePickers() {{{1
APP.initDateTimePickers = function() {
    // Datepicker / Timepicker 
    // Define the dateFormat for the datepicker
    // $.datepicker._defaults.dateFormat = 'M dd yy';

    /**
     * Replaces the date or datetime field with jquey-ui datepicker
     */
    // Date/Time Picker Init {{{3
    $('.datetime').each(function(i, el) {
        var input = $("<input type='text' class='ui-date-text' />");
        if ($(el).attr('id') == "event_start_time_input")
            input.bind('change', APP.syncStartEndDates);

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
            var d = new Date(values[0], parseInt(values[1]) - 1, values[2]);
            input.val(APP.getDateTimeStringFromHash({
                year: values[0],
                month: values[1],
                day: values[2],
                hour: values[3],
                minute: values[4]
            }));
        }
        else
        {
            input.val(APP.locale.pick_datetime);
        }

        input.datetimepicker({
            stepMinute: 15,
            minuteGrid: 15,
            hourGrid: 4
        });
    }); // }}}3

    /**
     * Sets the date for each select with the date selected with datepicker
     */
    // Input change events {{{3
    $('input.ui-date-text').bind('change', APP.saveDateValues);

    // }}}3
};

// Function: initAccordions() {{{1
APP.initAccordions = function() {
    $(".accordion").accordion({
      header: '.accordion-header',
      collapsible: true,
      clearStyle: true
    });
};

// Function: initButtons() {{{1
APP.initButtons = function() {
    // Setup default buttons.
    $("#navigation a").each(function() {
        if ($(this).hasClass("dropdown"))
        {
            $(this).button({icons:{secondary:'ui-icon-triangle-1-s'}});
        }
        else if ($(this).data('button-icon') !== undefined)
        {
            $(this).button({icons:{primary:$(this).data('button-icon')}});
        }
        else
        {
            $(this).button();
        }
    });

    $("input.create, input.update").button();

    $(".button_box").addClass("ui-widget");

    // Create button links into buttons and include icons if specified.
    $(".button").each(function() {
        var icon = $(this).data('button-icon');
        var pos = $(this).data('button-icon-pos');
        if (icon)
        {
            switch (pos)
            {
                case "r", "R", "e", "E":
                    $(this).button({icons:{secondary:icon}});
                    break;
                default:
                    $(this).button({icons:{primary:icon}});
                    break;
            }
        }
        else
        {
            $(this).button();
        }
    });

    // Add a new user icon to the help button.
    if (APP.config.new_user) {
        $("#nav_help_link").button("option", "icons", {secondary:'ui-icon-info'});
    }
};

// Function: initAutoApproveDialog() {{{1
APP.initAutoApproveDialog = function() {
    // Cache the form that needs to be interacted with.
    APP.cache.event_form = $("form#new_event");
    // Setup the #confirm_auto_approve_text dialog box.
    APP.cache.confirm_auto_approve_dialog = $("#confirm_auto_approve_text");
    if (APP.cache.event_form.length > 0)
    {
        APP.cache.confirm_auto_approve_dialog.dialog({
            modal: true,
            autoOpen: false,
            buttons: {
                "Auto Approve Session": function() {
                    $(this).dialog("close");
                    $("input#auto_approve").val("yes");
                    APP.cache.event_form.submit();
                },
                "Save and do not approve": function() {
                    $(this).dialog("close");
                    $("input#auto_approve").val("");
                    APP.cache.event_form.submit();
                }
            }
        });
    }
    // Setup the submit button to use the above dialog box.
    if (APP.cache.confirm_auto_approve_dialog.length > 0)
    {
        $(".confirm_auto_approve").click(function() {
            APP.cache.confirm_auto_approve_dialog.dialog("open");
            return false;
        });
    }
};

// Function: overideConfirmLinks() {{{1
APP.overideConfirmLinks = function() {
    // This is a bit of a hack to override the :confirm option in link_to but
    // it degrades nicely.
    $("a[confirm_message]").each(function () {
        // TODO: Use this blog to optimize
        // http://blog.nemikor.com/2009/04/08/basic-usage-of-the-jquery-ui-dialog/
        $(this).removeAttr('onclick');
        $(this).unbind('click', false);
        $(this).click(function (e) {
            var anchor = this;
            $("<div />").clone()
                .text($(this).attr('confirm_message'))
                .dialog({
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
};

// Function: initHelpDialog() {{{1
APP.initHelpDialog = function() {
    $("#nav_help_link").each(function () {
        var help_href = $(this).attr('href') + "?partial=1";
        var help_dialog = $("<div />").clone().append(APP.cache.loading.clone());
        var help_link = $(this).one('click', function (e) {
            e.preventDefault();
            help_dialog.load(help_href, function () {
                APP.initHelpTabs();
                APP.initNotifications(this);
            });
            help_dialog.dialog({
                title: "Help",
                width: 750,
                height: 500
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
    if ( $("#force_display_help").length ) {
        $("#nav_help_link").trigger('click');
    }
};

// Function: initEventSubmitNote() {{{1
APP.initEventSubmitNote = function() {
    var no_scenario_link = $("#no-scenario-link");
    if (no_scenario_link.length) {
        no_scenario_link.click(function (e) {
            $(this).hide();
            $("form.submit_note").show();
        });

        $("form.submit_note").hide();
    }
};

// Object: instructorActiveButton() {{{1
APP.instructorActiveButton = {
    renderCheckboxExtras: function(el) { // {{{2
        if ( $(el.currentTarget).attr("checked") == true )
        {
            $("#instructor_inactive_warning").hide();
            $(el.currentTarget).parent().removeClass("instructor_inactive");
        }
        else
        {
            $("#instructor_inactive_warning").show();
            $(el.currentTarget).parent().addClass("instructor_inactive");
        }
    },
    init: function() { // {{{2
        $("input#instructor_active")
            .change(APP.instructorActiveButton.renderCheckboxExtras)
            .change()
    }
};
// Function: initAgendaButtons() {{{1
APP.initAgendaButtons = function() {
    $("input:submit").button();
    $("#print-button").button({icons:{primary:'ui-icon-print'}})
        .click(function() { window.print(); });
    $("#return-button").button({icons:{primary:'ui-icon-arrowreturnthick-1-w'}});
};

// Function: appendToNavBar() {{{1
APP.appendToNavBar = function(selector) {
    var nav = $("#navigation");
    $("<div />").clone()
        .addClass("ui-helper-clearfix")
        .appendTo(nav);
    $(selector).detach()
        .removeClass("ui-widget ui-widget-header ui-widget-content ui-corner-all")
        .appendTo(nav);
};

// vim:set sw=4 ts=4 et fdm=marker:
