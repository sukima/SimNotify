// Javascript for calendar/index view
// Main CAl object.
CAL = {};
CAL.calendar_path = '/calendar/events';

// cache object {{{1
CAL.cache = {
    facility_urls: [ ],
    // Function: sync() {{{2
    sync: function() {
        CAL.cache.facility_urls = [ ];
        $(".facility").each(function() {
            if (this.checked)
            {
                CAL.cache.facility_urls.push(CAL.buildURL($(this).val()));
            }
        });
    } // }}}2
};

// Function: buildURL() {{{1
CAL.buildURL = function(param) {
    return CAL.calendar_path + '?facility=' + param;
};

// Function: scanFacilityOptions() {{{1
CAL.scanFacilityOptions = function() {
    $(".facility").each(function() {
        var url = CAL.buildURL($(this).val());
        var index = $.inArray(url, CAL.cache.facility_urls);
        if (this.checked && index == -1) // Checked, not in array: add
        {
            CAL.cache.facility_urls.push(url);
            CAL.cache.calendar.fullCalendar("addEventSource", url);
        }
        else if (!this.checked && index != -1) // Not Checked, in array: remove
        {
            CAL.cache.facility_urls.splice(index, 1);
            CAL.cache.calendar.fullCalendar("removeEventSource", url);
        }
    });
};

// Function: initFullCalendar() {{{1
CAL.initFullCalendar = function () {
    CAL.cache.sync();

    var options = {
        firstDay: 1, // Monday
        defaultView: 'agendaWeek',
        header: {
            left: 'prev,next today',
            center: 'title',
            right: 'month,agendaWeek,agendaDay'
        }
    };

    // fullCalendar uses eaith events option or eventSources option but not both.
    // Default to events option wen there are no checkboxes (.facility) elements on the page.
    // Otherwise use the established URLs in CAL.cache.facility_urls
    if (CAL.cache.facility_urls.length > 0)
    {
        options.eventSources = CAL.cache.facility_urls;
    }
    else
    {
        options.events = CAL.calendar_path;
    }

    CAL.cache.calendar = $("#calendar").fullCalendar(options);
};

// Function: initFacilityChangeEvents() {{{1
CAL.initFacilityChangeEvents = function () {
    $(".facility").change(function() {
        $.doTimeout('facilityOptions', 500, CAL.scanFacilityOptions);
    });
};

// vim:set sw=4 ts=4 et fdm=marker:
