// Test Helper {{{1
if (test_helper === undefined) { var test_helper = {}; }
test_helper.jquery_ajax = jQuery.ajax;
test_helper.moduleSetupAjaxMock = { // {{{2
  setup: function(scope) {
    if (scope === undefined) { scope = this; }
    this.options = null;
    jQuery.ajax = function(settings) {
      scope.options = settings;
    };
  },
  teardown: function() {
    jQuery.ajax = test_helper.jquery_ajax;
  }
};

module("Calendar Object"); // {{{1
test("should define initial values", function() { // {{{2
  ok(CAL !== undefined, "Cal is defined");
  ok(CAL.calendar_path !== undefined, "CAL.calendar_path is defined");
  ok(CAL.save_preferences_path !== undefined, "CAL.save_preferences_path is defined");
});

module("Calendar Cache Object"); // {{{1
test("should define initial values", function() { // {{{2
  ok(CAL.cache !== undefined, "CAL.cache is defined");
  ok(CAL.cache.facility_urls !== undefined, "CAL.cache.facility_urls is defined");
});

module("CAL.buildURL()"); // {{{1
test("should return correct string", function() { // {{{2
  var result = CAL.buildURL("Unique-test-identifier-xlkjdi");
  ok(typeof result == "string", "returns a string");
  ok(result.indexOf(CAL.calendar_path) == 0, "start with CAL.calendar_path");
  ok(result.indexOf("?facility") != -1, "have facility parameter");
  ok(result.indexOf("Unique-test-identifier-xlkjdi") != -1, "have proper value from paramerter");
});

module("CAL.cache.sync()", { // {{{1
  setup: function() { // {{{2
    this.input = $("<input type='checkbox' id='facility-box' class='facility' />")
      .attr('value', "Unique-test-identifier-jhjfhise")
      .attr('checked', true)
      .appendTo("#qunit-fixture");
    this.special = $("<input type='checkbox' id='facility-box' />")
      .attr('value', "special")
      .attr('checked', true)
      .appendTo("#qunit-fixture");
  },
  teardown: function() { // {{{2
    CAL.cache.facility_urls = [ ];
  }
});
test("should sync facility_urls with facility checkboxes", function() { // {{{2
  CAL.cache.sync();
  ok(CAL.cache.facility_urls.length > 0, "CAL.cache.facility_urls is not empty");
  ok(CAL.cache.facility_urls[0].indexOf("Unique-test-identifier-jhjfhise") != -1, "have proper value from checkbox");
});
test("with special should sync facility_urls with special", function() { // {{{2
  this.special.addClass("facility");
  CAL.cache.sync();
  ok(CAL.cache.facility_urls.length > 1, "CAL.cache.facility_urls is not empty and has two elements");
  ok(CAL.cache.facility_urls[0].indexOf("Unique-test-identifier-jhjfhise") != -1, "have proper value from checkbox");
  ok(CAL.cache.facility_urls[1].indexOf("special") != -1, "have value of 'special' for facility_urls");
});
test("without facility should sync facility_urls with all", function() { // {{{2
  this.input.remove();
  CAL.cache.sync();
  ok(CAL.cache.facility_urls.length > 0, "CAL.cache.facility_urls is not empty");
  ok(CAL.cache.facility_urls[0].indexOf("all") != -1, "have value of 'all' for facility_urls");
});
test("with special and without facility should sync facility_urls with all", function() { // {{{2
  this.input.remove();
  this.special.addClass("facility");
  CAL.cache.sync();
  ok(CAL.cache.facility_urls.length > 1, "CAL.cache.facility_urls is not empty and has two elements");
  ok(CAL.cache.facility_urls[0].indexOf("special") != -1, "have value of 'special' for facility_urls");
  ok(CAL.cache.facility_urls[1].indexOf("all") != -1, "have value of 'all' for facility_urls");
});

module("CAL.scanFacilityOptions()", { // {{{1
  setup: function() { // {{{2
    test_helper.moduleSetupAjaxMock.setup(this);
    $("<input type='checkbox' id='facility-box' class='facility' />")
      .attr('value', "Unique-test-identifier-jshdajsiu")
      .attr('checked', true)
      .appendTo("#qunit-fixture");
    $("<input type='checkbox' id='facility-box' class='facility' />")
      .attr('value', "Unique-test-identifier-iuryhweh")
      .appendTo("#qunit-fixture");
    CAL.cache.calendar = { a:[],b:[],fullCalendar: function(a,b) { this.a.push(a); this.b.push(b); } };
    CAL.cache.facility_urls = [ CAL.buildURL("Unique-test-identifier-iuryhweh") ];
  },
  teardown: function() { // {{{2
    test_helper.moduleSetupAjaxMock.teardown();
    CAL.cache.facility_urls = [ ];
    delete CAL.cache.calendar;
  }
});
test("should sync facility_urls with facility checkboxes", function() { // {{{2
  CAL.scanFacilityOptions();
  ok(CAL.cache.facility_urls.length == 1, "CAL.cache.facility_urls is not empty");
  ok(CAL.cache.facility_urls[0].indexOf("Unique-test-identifier-jshdajsiu") != -1, "have proper value from checkbox");
  equal(CAL.cache.calendar.a[0], "addEventSource", "adds new eventSource");
  ok(CAL.cache.calendar.b[0].indexOf("Unique-test-identifier-jshdajsiu") != -1, "sets addEventSource to new checkbox value");
  equal(CAL.cache.calendar.a[1], "removeEventSource", "removes old eventSource");
  ok(CAL.cache.calendar.b[1].indexOf("Unique-test-identifier-iuryhweh") != -1, "sets removeEventSource to old checkbox value");
});

module("CAL.initFullCalendar()", { // {{{1
  setup: function() { // {{{2
    $("<div id='#calendar'></div>").appendTo("#qunit-fixture");
    // Prevent unnecessary ajax.
    this.old_calendar_path = CAL.calendar_path;
    CAL.calendar_path = "#";
  },
  teardown: function() { // {{{2
    CAL.calendar_path = this.old_calendar_path;
  }
});
test("should execute cleanly", function() { // {{{2
  expect(2);
  try
  {
    CAL.initFullCalendar();
    ok(true, "executed without error");
  }
  catch(e) { ok(false, "executed with an error: "+ e.message) }
  ok(CAL.cache.calendar !== undefined, "Sets calendar cache");
});

module("CAL.initFacilityChangeEvents()"); // {{{1
test("should be defined (no functional tests)", function() { // {{{2
  ok(CAL.initFacilityChangeEvents !== undefined, "function is defined");
});

module("CAL.savePreferences()", { // {{{1
  setup: function() { // {{{2
    test_helper.moduleSetupAjaxMock.setup(this);
    CAL.cache.facility_urls = [ "/test?facility=12345", "/test?facility=special", "/test?facility=A&foo" ];
    CAL.savePreferences();
  },
  teardown: test_helper.moduleSetupAjaxMock.teardown // {{{2
});
test("should build properly formatted parameter data", function() { // {{{2
  expect(5);
  var data = this.options.data;
  if (data !== undefined && data.facilities !== undefined)
  {
    ok(true, "data is defined correctly");
    ok(data.facilities.length == 3, "array has correct length (3)");
    equal(data.facilities[0], "12345", "first element is '12345'");
    equal(data.facilities[1], "special", "second element is 'special'");
    equal(data.facilities[2], "A", "second element is 'A'");
  }
  else
  {
    ok(false, "data is defined correctly");
  }
});
/* vim:set sw=2 et fdm=marker: */
