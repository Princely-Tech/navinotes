
  String formatDate(DateTime date) {
    return '${getMonthName(date.month)} ${date.day}, ${date.year}';
  }

  String getMonthName(int month) {
    return [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ][month - 1];
  }