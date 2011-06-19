module("Application Object"); // {{{1
test("APP contents should be defined correctly", function() { // {{{2
  ok(APP !== undefined, "APP should be defined");
  ok(APP.cache !== undefined, "APP.cache should be definded");
  ok(APP.cache.loading !== undefined, "APP.cache.loading should be defined");
  ok(APP.config !== undefined, "APP.config should be defined");
  ok(APP.config.debug !== undefined, "APP.config.debug should be defined");
  ok(APP.config.jquery_theme_path !== undefined, "APP.config.jquery_theme_path should be defined");
  ok(APP.locale !== undefined, "APP.locale should be defined");
});

module("APP.getTimeValues()"); // {{{1
test("should get time values from string", function()  { // {{{2
  deepEqual(APP.getTimeValues("02/03/11 12:30"), {hour:"12",minute:"30"}, "should return parsed time with '12/03/11 12:30'");
  deepEqual(APP.getTimeValues("12/03/11 1230"), {hour:"12",minute:"30"}, "should return parsed time with '12/03/11 1230'");
  deepEqual(APP.getTimeValues("12/03/111230"), {hour:"12",minute:"30"}, "should return parsed time with '12/03/111230'");
  deepEqual(APP.getTimeValues("12:30"), {hour:"12",minute:"30"}, "should return parsed time with '12:30'");
  deepEqual(APP.getTimeValues("1230"), {hour:"12",minute:"30"}, "should return parsed time with '1230'");
  deepEqual(APP.getTimeValues("230"), {hour:"2",minute:"30"}, "should return parsed time with '230'");
  deepEqual(APP.getTimeValues("230"), {hour:"2",minute:"30"}, "should return parsed time with '230'");
  deepEqual(APP.getTimeValues("2"), {hour:"2",minute:"0"}, "should return parsed time with '2'");
});

module("APP.getDateValues()"); // {{{1
test("should get date values from string", function() { // {{{2
  deepEqual(APP.getDateValues("02/03/11 12:30"), {month:"2",day:"3",year:"11"}, "should return parsed date with '12/03/11 12:30'");
  deepEqual(APP.getDateValues("02/03/2011 12:30"), {month:"2",day:"3",year:"2011"}, "should return parsed date with '12/03/2011 12:30'");
  deepEqual(APP.getDateValues("02/03/11"), {month:"2",day:"3",year:"11"}, "should return parsed date with '12/03/11'");
  // equal(APP.getDateValues("020311"), null, "should return null with '020311'");
  // equal(APP.getDateValues("020311 12:30"), null, "should return null with '020311 12:30'");
});

module("APP.getDateTimeStringFromHash()"); // {{{1
test("should create string from hash values", function() { // {{{2
  equal(APP.getDateTimeStringFromHash({
    month:"03", day:"04", year:"2011", hour:"12", minute:"30"
  }), "03/04/2011 12:30", "should return correctly formed date string");
});

module("APP.saveDateValues()", { // {{{1
  setup: function() { // {{{2
    this.datetime = $("<div class='datetime'></div>")
      .append("<input type='test' id='test_input' />");
    this.datetime.find("#test_input")
      .val("1/2/3 4:5");
    this.select = $("<select><option value='0'>0</option><option value='1'>1</option><option value='2'>2</option><option value='3'>3</option><option value='4'>4</option><option value='5'>5</option></select>");
    for (var i = 0; i < 5; i++)
    {
      this.select.clone()
        .attr("id", "select_" + i)
        .appendTo(this.datetime);
    }
    this.datetime.appendTo("#qunit-fixture");
    this.input = $("#test_input").bind("test", APP.saveDateValues);
  }
});
test("should assign select values from text field", function() { // {{{2
  this.input.trigger("test");
  equal($("#select_0").val(), "3", "select_0 should be set to year ('3')"); // year
  equal($("#select_1").val(), "1", "select_1 should be set to month ('1')"); // month
  equal($("#select_2").val(), "2", "select_2 should be set to day ('2')"); // day
  equal($("#select_3").val(), "4", "select_3 should be set to hour ('4')"); // hour
  equal($("#select_4").val(), "5", "select_4 should be set to minute ('5')"); // minute
});

module("APP.syncStartEndDates()", { // {{{1
  setup: function() { // {{{2
    this.start_input = $("<div><input type='text' class='ui-date-text' /></div>")
      .clone()
      .attr("id", "event_start_time_input")
      .appendTo("#qunit-fixture")
      .find("input")
        .bind("test", APP.syncStartEndDates);
    this.end_input = $("<div><input type='text' class='ui-date-text' /></div>")
      .clone()
      .attr("id", "event_end_time_input")
      .appendTo("#qunit-fixture")
      .find("input");
  }
});
test("should assign a value to end_date text field", function() { // {{{2
  this.end_input.val('');
  this.start_input.val("2").trigger("test");
  equal(this.end_input.val(), "2", "end_input should be set to start_input if end_input is blank");

  this.end_input.val(APP.locale.pick_datetime);
  this.start_input.val("3").trigger("test");
  equal(this.end_input.val(), "3", "end_input should be set to start_input if end_input is default placeholder");

  this.end_input.val(APP.locale.pick_datetime);
  this.start_input.val("4").trigger("test");
  equal(this.end_input.val(), "4", "end_input should be set to start_input if < start_input");

  this.start_input.val("1").trigger("test");
  equal(this.end_input.val(), "4", "end_input should not change if > start_input");
});

module("APP.initNotifications()", { // {{{1
  setup: function() { // {{{2
    this.div = $("<div></div>");
    this.notification_div = this.div.clone()
      .addClass("notification")
      .text("notification")
      .appendTo("#qunit-fixture");
    this.warning_div = this.div.clone()
      .addClass("warning")
      .text("warning")
      .appendTo("#qunit-fixture");
    this.flash_notice_div = this.div.clone()
      .attr("id", "flash_notice")
      .text("flash_notice")
      .appendTo("#qunit-fixture");
    this.flash_error_div = this.div.clone()
      .attr("id", "flash_error")
      .text("flash_error")
      .appendTo("#qunit-fixture");
    APP.initNotifications();
  }
});
test("should set ui-widget for .notification div's", function() { // {{{2
  ok(this.notification_div.parent().hasClass("ui-widget"), "has class 'ui-widget' on wrapper div");
  ok(this.notification_div.hasClass("ui-state-highlight"), "has class 'ui-state-highlight' on div");
  ok(this.notification_div.children().first().is("span"), "has a span inside div");
  ok(this.notification_div.children().first().hasClass("ui-icon"), "icon span has class 'ui-icon'");
  ok(this.notification_div.children().first().hasClass("ui-icon-info"), "icon span has class 'ui-icon-info'");
  ok(this.notification_div.next().is("div"), "Has a div after");
  ok(this.notification_div.next().hasClass("clear"), "div after has class 'clear'");
});
test("should set ui-widget for .warning div's", function() { // {{{2
  ok(this.warning_div.parent().hasClass("ui-widget"), "has class 'ui-widget' on wrapper div");
  ok(this.warning_div.hasClass("ui-state-error"), "has class 'ui-state-error' on div");
  ok(this.warning_div.children().first().is("span"), "has a span inside div");
  ok(this.warning_div.children().first().hasClass("ui-icon"), "icon span has class 'ui-icon'");
  ok(this.warning_div.children().first().hasClass("ui-icon-alert"), "icon span has class 'ui-icon-alert'");
  ok(this.warning_div.next().is("div"), "Has a div after");
  ok(this.warning_div.next().hasClass("clear"), "div after has class 'clear'");
});
test("should set ui-widget for #flash_notice div", function() { // {{{2
  ok(this.flash_notice_div.parent().hasClass("ui-widget"), "has class 'ui-widget' on wrapper div");
  ok(this.flash_notice_div.children().first().is("span"), "has a span inside div");
  ok(this.flash_notice_div.children().first().hasClass("ui-icon"), "icon span has class 'ui-icon'");
  ok(this.flash_notice_div.children().first().hasClass("ui-icon-info"), "icon span has class 'ui-icon-info'");
  ok(this.flash_notice_div.next().is("div"), "Has a div after");
  ok(this.flash_notice_div.next().hasClass("clear"), "div after has class 'clear'");
});
test("should set ui-widget for #flash_error div", function() { // {{{2
  ok(this.flash_error_div.parent().hasClass("ui-widget"), "has class 'ui-widget' on wrapper div");
  ok(this.flash_error_div.children().first().is("span"), "has a span inside div");
  ok(this.flash_error_div.children().first().hasClass("ui-icon"), "icon span has class 'ui-icon'");
  ok(this.flash_error_div.children().first().hasClass("ui-icon-alert"), "icon span has class 'ui-icon-alert'");
  ok(this.flash_error_div.next().is("div"), "Has a div after");
  ok(this.flash_error_div.next().hasClass("clear"), "div after has class 'clear'");
});

module("APP.initThemePicker()", { // {{{1
  setup: function() { // {{{2
    $("<link class='theme' href='test_value_not_set_yet' />").appendTo("#qunit-fixture");
    $("<input id='instructor_gui_theme' value='test_value_set' />").appendTo("#qunit-fixture");
    APP.initThemePicker();
  }
});
test("should attach change event to #instructor_gui_theme", function() { // {{{2
  $("#instructor_gui_theme").trigger("change");
  ok($("link.theme").attr("href").match(/test_value_set/), "change event sets correct url to link href");
});

module("APP.flagDetection()"); // {{{1
test("should detect if new user", function() {
  APP.flagDetection();
  ok(!APP.config.new_user, "new user is false if no #NewUserFlag found");
  $("<div id='NewUserFlag' />").appendTo("#qunit-fixture");
  APP.flagDetection();
  ok(APP.config.new_user, "new user is true if #NewUserFlag found");
});
/* vim:set sw=2 et fdm=marker: */
