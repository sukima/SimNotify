// Test Helper {{{1
if (!test_helper) { var test_helper = {}; }
test_helper.moduleDateTimeInputConfig = { // {{{2
  setup: function() { // {{{3
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
  },
  teardown: function() { // {{{3
    // the dateTimePicker() manipulates the DOM outside of #qunit-fixture
    // Clean up litter.
    $("#ui-datepicker-div").remove();
  }
};
test_helper.dialogCleanup = function() { // {{{2
    // dialog() manipulates the DOM outside of #qunit-fixture
    // Clean up litter.
    $(".ui-dialog").remove();
};

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

module("APP.saveDateValues()", test_helper.moduleDateTimeInputConfig); // {{{1
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
  // ok(this.notification_div.next().is("div"), "Has a div after");
  // ok(this.notification_div.next().hasClass("clear"), "div after has class 'clear'");
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

module("APP.autocomplete.init()", { // {{{1
  setup: function() { // {{{2
    // set up autocomplete input
    this.input = $("<input type='text' class='autocomplete' id='test_autocomplete_input' />").appendTo("#qunit-fixture");
    // set up mock json response from ajax
    this.json = { "test_autocomplete_input": "/test_url/path" };
    // No need to test APP.autocomplete.load(); only calls getJSON.
    APP.autocomplete.init(this.json);
  }
});
test("Create autocomplete widgets", function() { // {{{2
  ok(APP.cache.autocomplete_map !== undefined, "APP.cache.autocomplete_map is assiged a value");
  ok(this.input.hasClass("ui-autocomplete-input"), "#test_autocomplete_input should be an autocomplete widget");
  equals(this.input.autocomplete("option", "source"), "/test_url/path", "source should be set to correct test path");
});

module("APP.loadMultiselect()", { // {{{1
  setup: function() { // {{{2
    this.select1 = $("<select class='multiselect'><option value='1' title='foo'>1</option><option vlaue='2' title='bar'>2</option></select>")
      .attr("name", "select0")
      .appendTo("#qunit-fixture");
    this.select2 = $("<select class='multiselect'><option value='1' title='foo'>1</option><option vlaue='2' title='bar'>2</option></select>")
      .clone()
      .attr("name", "select1")
      .attr("multiple", true)
      .appendTo("#qunit-fixture");
    APP.loadMultiselect();
  }
});
test("should create multiselect for select elements", function() { // {{{2
  ok($("#ui-multiselect-0-option-0").attr("type") == "radio", "non-multiple select uses radio buttons");
  ok($("#ui-multiselect-1-option-0").attr("type") == "checkbox", "multiple select uses checkboxes buttons");
});

module("APP.initNavBar()", { // {{{1
  setup: function() { // {{{2
    this.navdiv = $("<div id='navigation' class='side-navigation'><ul><li><ul><li></li></ul></li></ul></div>")
      .appendTo("#qunit-fixture");
    this.content = $("<div id='content' class='side-nav-width'></div>").appendTo("#qunit-fixture");
    APP.initNavBar();
  }
});
test("should reconfigure nav bar", function() { // {{{2
  ok(!this.navdiv.hasClass("side-navigation"), "#navigation should not have class 'side-navigation'");
  ok(this.navdiv.hasClass("nav-widget"), "#navigation should have class 'nav-widget'");
  ok(!this.content.hasClass("side-nav-width"), "#content should not have class 'side-nav-width'");
  ok(this.content.hasClass("top-nav-width"), "#content should have class 'top-nav-width'");
  ok(this.navdiv.find("ul").hasClass("nav-list"), "#navigation>ul should have 'class nav-list'");
  ok(this.navdiv.find("ul li>ul").hasClass("sub-nav-list"), "#navigation>ul li>ul should have class 'sub-nav-list'");
});

module("APP.initDateTimePickers()", test_helper.moduleDateTimeInputConfig); // {{{1
test("should create correctly formed Date Time Picker", function() { // {{{2
  APP.initDateTimePickers();
  equal($("input.ui-date-text").length, 1, "should only have one 'ui-date-text' input");
});

module("APP.initAccordions()", { // {{{1
  setup: function() { // {{{2
    $("<div class='accordion'><div class='accordion-header'><a>#</a></div><div class='accordion-content'></div></div>")
      .appendTo("#qunit-fixture");
  }
});
test("should create jQuery-UI accordion widgets", function() { // {{{2
  APP.initAccordions();
  ok($(".accordion").hasClass('ui-accordion'), "jQuery-ui accordian created succesfully");
});

module("APP.initButtons()", { // {{{1
  setup: function() { // {{{2
    this.nav_div = $("<div id='navigation'></div>").appendTo("#qunit-fixture");
    this.a = $("<a></a>").attr("id", "test-link-1").appendTo("#qunit-fixture");
    this.a.clone().attr("id", "test-link-2").addClass("button").appendTo("#qunit-fixture");
    this.a.clone().attr("id", "test-link-3").appendTo(this.nav_div);
    this.a.clone().attr("id", "test-link-4").addClass("dropdown").appendTo(this.nav_div);
    this.a.clone().attr("id", "nav_help_link").appendTo(this.nav_div);
    this.a.clone().attr("id", "test-link-6").data('button-icon', "ui-icon-check").appendTo(this.nav_div);
    this.data_btn = this.a.clone()
      .attr("id", "test-link-7")
      .addClass("button")
      .data('button-icon', "ui-icon-check")
      .appendTo("#qunit-fixture");
    this.data_btn.clone()
      .attr("id", "test-link-8")
      .data('button-icon', "ui-icon-check")
      .data('button-icon-pos', 'l')
      .appendTo("#qunit-userAgent");
    this.data_btn.clone()
      .attr("id", "test-link-9")
      .data('button-icon', "ui-icon-check")
      .data('button-icon-pos', 'w')
      .appendTo("#qunit-fixture");
    this.data_btn.clone()
      .attr("id", "test-link-10")
      .data('button-icon', "ui-icon-check")
      .data('button-icon-pos', 'r')
      .appendTo("#qunit-fixture");
    this.data_btn.clone()
      .attr("id", "test-link-11")
      .data('button-icon', "ui-icon-check")
      .data('button-icon-pos', 'e')
      .appendTo("#qunit-fixture");
    APP.config.new_user = true;
  },
  teardown: function() { // {{{2
    APP.config.new_user = false;
  }
});
test("should create all button widgets", function() { // {{{2
  APP.initButtons();
  ok(!$("#test-link-1").hasClass("ui-button"), "test-link-1 is not a button");
  ok($("#test-link-2").hasClass("ui-button"), "test-link-2 is a button");
  ok($("#test-link-3").hasClass("ui-button"), "test-link-3 is a button");
  ok($("#test-link-4").hasClass("ui-button"), "test-link-4 is a button");
  ok($("#test-link-4").find(".ui-icon").length > 0, "test-link-4 has an icon");
  ok($("#nav_help_link").hasClass("ui-button"), "nav_help_link is a button");
  ok($("#nav_help_link").find(".ui-icon").length > 0, "nav_help_link has an icon");
  ok($("#test-link-6").hasClass("ui-button"), "test-link-6 is a button");
  ok($("#test-link-6").find(".ui-icon").length > 0, "test-link-6 has an icon");
  ok($("#test-link-7").hasClass("ui-button"), "test-link-7 is a button");
  ok($("#test-link-7").find(".ui-icon").length > 0, "test-link-7 has an icon");
  ok($("#test-link-7").find(".ui-button-icon-primary").length > 0, "test-link-7 icon is on the left");
  ok($("#test-link-8").hasClass("ui-button"), "test-link-8 is a button");
  ok($("#test-link-8").find(".ui-icon").length > 0, "test-link-8 has an icon");
  ok($("#test-link-8").find(".ui-button-icon-primary").length > 0, "test-link-8 icon is on the left");
  ok($("#test-link-9").hasClass("ui-button"), "test-link-9 is a button");
  ok($("#test-link-9").find(".ui-icon").length > 0, "test-link-9 has an icon");
  ok($("#test-link-9").find(".ui-button-icon-primary").length > 0, "test-link-9 icon is on the left");
  ok($("#test-link-10").hasClass("ui-button"), "test-link-10 is a button");
  ok($("#test-link-10").find(".ui-icon").length > 0, "test-link-10 has an icon");
  ok($("#test-link-10").find(".ui-button-icon-primary").length > 0, "test-link-10 icon is on the right");
  ok($("#test-link-11").hasClass("ui-button"), "test-link-11 is a button");
  ok($("#test-link-11").find(".ui-icon").length > 0, "test-link-11 has an icon");
  ok($("#test-link-11").find(".ui-button-icon-primary").length > 0, "test-link-11 icon is on the right");
});

module("APP.initAutoApproveDialog()", { // {{{1
  setup: function() { // {{{2
    var that = this;
    this.was_submitted = false;
    this.form = $("<form id='new_event'></form>")
      .submit(function() { that.was_submitted = true; return false; })
      .appendTo("#qunit-fixture");
    this.hidden = $("<input />").clone()
      .attr("type", "hidden")
      .attr("id", "auto_approve")
      .attr("name", "auto_approve")
      .val("xxxxxx")
      .appendTo(this.form);
    this.submit = $("<input />").clone()
      .attr("type", "submit")
      .addClass("confirm_auto_approve")
      .appendTo(this.form);
    $("<div></div>").clone()
      .attr("id", "confirm_auto_approve_text")
      .appendTo("#qunit-fixture");
    APP.initAutoApproveDialog();
  },
  teardown: function() { // {{{2
    delete APP.cache.confirm_auto_approve_dialog;
    delete APP.cache.event_form;
    test_helper.dialogCleanup();
    $("#confirm_auto_approve_text").remove();
  }
});
test("should initialize auto approve dialog cache", function() { // {{{2
  ok(APP.cache.event_form !== undefined, "APP.cache.event_form assigned");
  ok(APP.cache.confirm_auto_approve_dialog !== undefined, "APP.cache.confirm_auto_approve_dialog assigned");
});
test("should handle auto approve request from user", function() { // {{{2
  this.buttons = $(".ui-dialog-buttonset > :button")

  this.submit.trigger("click");
  $(this.buttons[0]).trigger("click");
  equal(this.hidden.val(), "yes", "dialog sets input#auto_approve to 'yes'");
  ok(this.was_submitted, "form was submitted");
});
test("should handle save request from user", function() { // {{{2
  this.buttons = $(".ui-dialog-buttonset > :button")

  this.submit.trigger("click");
  $(this.buttons[1]).trigger("click");
  equal(this.hidden.val(), "", "dialog sets input#auto_approve to ''");
  ok(this.was_submitted, "form was submitted");
});

module("APP.initNotifications()", { // {{{1
  setup: function() { // {{{2
    this.test1 = $("<div></div>").clone()
      .addClass("notification")
      .appendTo("#qunit-fixture");
    this.test2 = $("<div></div>").clone()
      .addClass("warning")
      .appendTo("#qunit-fixture");
    this.test3 = $("<div></div>").clone()
      .attr("id", "flash_notice")
      .appendTo("#qunit-fixture");
    this.test4 = $("<div></div>").clone()
      .attr("id", "flash_error")
      .appendTo("#qunit-fixture");
    APP.initNotifications();
  }
});
test("should set ui-widgets for all notification types (fails with IE)", function() { // {{{2
  ok(this.test1.parent().hasClass("ui-widget"), "should turn .notification div into a ui-widget");
  ok(this.test1.children("span.ui-icon").length > 0, ".notification should have a child span.ui-icon");
  ok(this.test2.parent().hasClass("ui-widget"), "should turn .warning div into a ui-widget");
  ok(this.test2.children("span.ui-icon").length > 0, ".warning should have a child span.ui-icon");
  ok(this.test3.parent().hasClass("ui-widget"), "should turn #flash_notice div into a ui-widget");
  ok(this.test3.children("span.ui-icon").length > 0, "#flash_notice should have a child span.ui-icon");
  ok(this.test4.parent().hasClass("ui-widget"), "should turn #flash_error div into a ui-widget");
  ok(this.test4.children("span.ui-icon").length > 0, "#flash_error should have a child span.ui-icon");
});

module("APP.overideConfirmLinks", { // {{{1
  setup: function() { // {{{2
    this.a = $("<a></a>").clone()
      .attr("confirm_message", "xxxxxx")
      .attr("onclick", "return false;")
      .appendTo("#qunit-fixture");
    APP.overideConfirmLinks();
  },
  teardown: test_helper.dialogCleanup // {{{2
});
test("should setup confirmation dialog", function() { // {{{2
  ok(this.a.attr("onclick") == null, "onclick attribute removed");
  this.a.click();
  ok($(".ui-dialog").length > 0, "dialog is created");
  $(".ui-dialog :button")[1].click();
  ok($(".ui-dialog").length == 0, "dialog is removed");
})

module("APP.instructorActiveButton", { // {{{1
  setup: function() { // {{{2
    this.label = $("<label />").clone()
      .attr("for", "instructor_active")
      .appendTo("#qunit-fixture");
    this.input = $("<input />").clone()
      .attr("type", "checkbox")
      .attr("id", "instructor_active")
      .attr("name", "instructor_active")
      .appendTo(this.label);
    this.box = $("<div></div>").clone()
      .attr("id", "instructor_inactive_warning")
      .appendTo("#qunit-fixture");
  }
});
test("renderCheckboxExtras() should correctly adjust for checkbox value", function() { // {{{2
  // use trigger to properly set the event to pass in
  this.input.bind("test_event", APP.instructorActiveButton.renderCheckboxExtras);

  this.input.removeAttr("checked");
  this.input.trigger("test_event");
  ok(this.label.hasClass("instructor_inactive"), "label has instructor_inactive class");

  this.input.attr("checked", true);
  this.input.trigger("test_event");
  ok(!this.label.hasClass("instructor_inactive"), "label does not have instructor_inactive class");
})
test("init() should setup correct DOM layout", function() { // {{{2
  ok(true, "No tests for this function");
})

module("APP.initAgendaButtons", { // {{{1
  setup: function() { // {{{2
    this.input = $("<input />").clone()
      .attr("type", "submit")
      .appendTo("#qunit-fixture");
    this.printBtn = $("<div />").clone()
      .attr("id", "print-button")
      .appendTo("#qunit-fixture");
    this.returnBtn = $("<div />").clone()
      .attr("id", "return-button")
      .appendTo("#qunit-fixture");
  }
});
test("should initialize buttons", function() { // {{{2
  APP.initAgendaButtons();
  ok(this.input.hasClass("ui-button"), "'input:submit' is a button");
  ok(this.printBtn.hasClass("ui-button"), "'#print-button' is a button");
  ok(this.returnBtn.hasClass("ui-button"), "'#return.button' is a button");
});

module("APP.appendToNavBar", { // {{{1
  setup: function() { // {{{2
    this.nav_bar = $("<div />").clone()
      .attr("id", "navigation")
      .appendTo("#qunit-fixture");
    this.test_content_1 = $("<div />").clone()
      .attr("id", "test-content-1")
      .addClass("ui-widget ui-widget-header ui-corner-all")
      .appendTo("#qunit-fixture");
    this.test_content_2 = $("<div />").clone()
      .attr("id", "test-content-2")
      .addClass("ui-widget ui-widget-content ui-corner-all")
      .appendTo("#qunit-fixture");
  }
});
test("should append items to navigation bar", function() { // {{{2
  APP.appendToNavBar(this.test_content_1);
  ok(this.test_content_1.parent().attr("id") == this.nav_bar.attr("id"), "test_content_1 moved to nav_bar");
  ok(!this.test_content_1.hasClass("ui-widget"), "Class 'ui-widget' removed from test_content_1");
  ok(!this.test_content_1.hasClass("ui-widget-header"), "Class 'ui-widget-header' removed from test_content_1");
  ok(!this.test_content_1.hasClass("ui-corner-all"), "Class 'ui-corner-all' removed from test_content_1");
  APP.appendToNavBar(this.test_content_2);
  ok(this.test_content_2.parent().attr("id") == this.nav_bar.attr("id"), "test_content_2 moved to nav_bar");
  ok(!this.test_content_2.hasClass("ui-widget"), "Class 'ui-widget' removed from test_content_2");
  ok(!this.test_content_2.hasClass("ui-widget-content"), "Class 'ui-widget-content' removed from test_content_2");
  ok(!this.test_content_2.hasClass("ui-corner-all"), "Class 'ui-corner-all' removed from test_content_2");
});

/* vim:set sw=2 et fdm=marker: */
