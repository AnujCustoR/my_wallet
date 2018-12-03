DateTime firstMomentOfMonth(DateTime day) {
  return DateTime(day.year, day.month, 0, 24);
}

DateTime lastDayOfMonth(DateTime day) {
  var lastDayDateTime = (day.month < 12) ? new DateTime(day.year, day.month + 1, 0, 24).subtract(Duration(milliseconds: 1)) : new DateTime(day.year + 1, 1, 0, 24).subtract(Duration(milliseconds: 1));

  print("last day of month $lastDayDateTime with milli ${lastDayDateTime.millisecondsSinceEpoch}");
  return lastDayDateTime;
}