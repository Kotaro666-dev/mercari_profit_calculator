class DateData {
  int currentMonth = 1000;
  int currentDay = 1000;

  bool shouldDisplayDate(int month, int day) {
    if (currentMonth != month && currentDay != day) {
      currentMonth = month;
      currentDay = day;
      return true;
    }
    return false;
  }
}
