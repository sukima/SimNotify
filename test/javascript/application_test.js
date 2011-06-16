module("Application Object");
test("APP contents should be defined correctly", function() { // {{{1
  ok(APP !== undefined, "APP should be defined");
  ok(APP.cache !== undefined, "APP.cache should be definded");
  ok(APP.config !== undefined, "APP.config should be defined");
  ok(APP.config.debug !== undefined, "APP.config.debug should be defined");
  ok(APP.config.jquery_theme_path !== undefined, "APP.config.jquery_theme_path should be defined");
  ok(APP.locale !== undefined, "APP.locale should be defined");
});
// }}}1

module("supporting functions tests");
test("APP.getTimeValues()", function()  { // {{{1
  deepEqual(APP.getTimeValues("02/03/11 12:30"), {hour:"12",minute:"30"}, "should return parsed time with '12/03/11 12:30'");
  deepEqual(APP.getTimeValues("12/03/11 1230"), {hour:"12",minute:"30"}, "should return parsed time with '12/03/11 1230'");
  deepEqual(APP.getTimeValues("12:30"), {hour:"12",minute:"30"}, "should return parsed time with '12:30'");
  deepEqual(APP.getTimeValues("1230"), {hour:"12",minute:"30"}, "should return parsed time with '1230'");
  // equals(APP.getTimeValues("02/03/1112:30"), null, "should return null with '02/03/1112:30'");
});

test("APP.getDateValues()", function() { // {{{1
  deepEqual(APP.getDateValues("02/03/11 12:30"), {month:"2",day:"3",year:"11"}, "should return parsed date with '12/03/11 12:30'");
  deepEqual(APP.getDateValues("02/03/2011 12:30"), {month:"2",day:"3",year:"2011"}, "should return parsed date with '12/03/2011 12:30'");
  deepEqual(APP.getDateValues("02/03/11"), {month:"2",day:"3",year:"11"}, "should return parsed date with '12/03/11'");
  // equals(APP.getDateValues("020311"), null, "should return null with '020311'");
  // equals(APP.getDateValues("020311 12:30"), null, "should return null with '020311 12:30'");
});

test("APP.getDateTimeStringFromHash()", function() { // {{{1
  equal(APP.getDateTimeStringFromHash({
    month:"03", day:"04", year:"2011", hour:"12", minute:"30"
  }), "03/04/2011 12:30", "should return correctly formed date string");
});

test("APP.saveDateValues()", function() { // {{{1
  var datetime = $("<div class='datetime'></div>")
    .append("<input type='test' id='test_input' />");
  datetime.find("#test_input")
    .val("1/2/3 4:5");
  var select = $("<select><option value='0'>0</option><option value='1'>1</option><option value='2'>2</option><option value='3'>3</option><option value='4'>4</option><option value='5'>5</option></select>");
  for (var i = 0; i < 5; i++)
  {
    select.clone()
      .attr("id", "select_" + i)
      .appendTo(datetime);
  }
  datetime.appendTo("#qunit-fixture");
  $("#test_input").bind("change", APP.saveDateValues).trigger("change");

  equals($("#select_0").val(), "3", "select_0 should be set to year ('3')"); // year
  equals($("#select_1").val(), "1", "select_1 should be set to month ('1')"); // month
  equals($("#select_2").val(), "2", "select_2 should be set to day ('2')"); // day
  equals($("#select_3").val(), "4", "select_3 should be set to hour ('4')"); // hour
  equals($("#select_4").val(), "5", "select_4 should be set to minute ('5')"); // minute
});
/* vim:set sw=2 et fdm=marker: */
