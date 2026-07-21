import 'package:intl/intl.dart';
import 'package:transactions/ui/analysis/analysis_interval_size.dart';

class AnalysisInterval {
  AnalysisInterval({
    this.intervalIndex = 0,
    this.intervalSize = AnalysisIntervalSize.monthly,
  });

  /// Number of intervals to reach the currently selected
  /// time span, going backwards.
  int intervalIndex;
  AnalysisIntervalSize intervalSize;

  DateTime get intervalStart {
    DateTime date = DateTime.now();
    switch (intervalSize) {
      case AnalysisIntervalSize.yearly:
        return DateTime(date.year - intervalIndex);
      case AnalysisIntervalSize.sixMonthly:
        if (date.month >= 6) {
          return DateTime(
            date.year - intervalIndex ~/ 2,
            intervalIndex % 2 == 0 ? 7 : 1,
          );
        } else {
          return DateTime(
            date.year - (intervalIndex + 1) ~/ 2,
            intervalIndex % 2 == 0 ? 1 : 7,
          );
        }
      case AnalysisIntervalSize.monthly:
        int month = date.month - intervalIndex;
        int years = 0;
        if (month <= 0) {
          years = (-month + 12) ~/ 12;
          month = month.remainder(12) + 12;
        }
        return DateTime(date.year - years, month);
      case AnalysisIntervalSize.weekly:
        date = date.subtract(Duration(days: 7 * intervalIndex));
        return DateTime(
          date.year,
          date.month,
          date.day,
        ).subtract(Duration(days: date.weekday - 1));
    }
  }

  DateTime get intervalEnd {
    DateTime date = DateTime.now();
    switch (intervalSize) {
      case AnalysisIntervalSize.yearly:
        return DateTime(
          date.year + 1 - intervalIndex,
        ).subtract(Duration(milliseconds: 1));
      case AnalysisIntervalSize.sixMonthly:
        if (date.month >= 6) {
          return DateTime(
            date.year - (intervalIndex + 1) ~/ 2 + 1,
            intervalIndex % 2 == 0 ? 1 : 7,
          ).subtract(Duration(milliseconds: 1));
        } else {
          return DateTime(
            date.year - (intervalIndex) ~/ 2,
            intervalIndex % 2 == 0 ? 7 : 1,
          ).subtract(Duration(milliseconds: 1));
        }
      case AnalysisIntervalSize.monthly:
        int month = date.month - intervalIndex;
        int years = 0;
        if (month == 12) {
          return DateTime(date.year + 1, 1).subtract(Duration(milliseconds: 1));
        }
        month += 1;
        if (month <= 0) {
          years += (-month + 12) ~/ 12;
          month = month.remainder(12) + 12;
        }
        return DateTime(
          date.year - years,
          month,
        ).subtract(Duration(milliseconds: 1));
      case AnalysisIntervalSize.weekly:
        date = date.subtract(Duration(days: 7 * intervalIndex));
        return DateTime(date.year, date.month, date.day)
            .add(Duration(days: 8 - date.weekday))
            .subtract(Duration(milliseconds: 1));
    }
  }

  String get text {
    if (intervalIndex == 0) {
      switch (intervalSize) {
        case AnalysisIntervalSize.yearly:
          return "Dieses Jahr";
        case AnalysisIntervalSize.sixMonthly:
          return "Dieses Halbjahr";
        case AnalysisIntervalSize.monthly:
          return "Diesen Monat";
        case AnalysisIntervalSize.weekly:
          return "Diese Woche";
      }
    }
    int currentYear = DateTime.now().year;
    DateTime start = intervalStart;
    DateTime end = intervalEnd;

    switch (intervalSize) {
      case AnalysisIntervalSize.yearly:
        return start.year.toString();
      case AnalysisIntervalSize.sixMonthly:
        if (start.year == currentYear) {
          var format = DateFormat.MMM("de_DE");
          return "${format.format(start)} - ${format.format(end)}";
        } else {
          var format = DateFormat.yMMM("de_DE");
          return "${format.format(start)} - ${format.format(end)}";
        }
      case AnalysisIntervalSize.monthly:
        if (start.year == currentYear) {
          var format = DateFormat.MMMM("de_DE");
          return format.format(start);
        } else {
          var format = DateFormat.yMMMM("de_DE");
          return format.format(start);
        }
      case AnalysisIntervalSize.weekly:
        if (start.year == currentYear && end.year == currentYear) {
          if (start.month == end.month) {
            return "${DateFormat.d("de_DE").format(start)}. - ${DateFormat.MMMMd("de_DE").format(end)}";
          } else {
            var format = DateFormat.MMMd("de_DE");
            return "${format.format(start)} - ${format.format(end)}";
          }
        } else {
          if (start.month == end.month) {
            return "${DateFormat.d("de_DE").format(start)}. - ${DateFormat.yMMMMd("de_DE").format(end)}";
          } else if (start.year == end.year) {
            return "${DateFormat.MMMd("de_DE").format(start)} - ${DateFormat.yMMMd("de_DE").format(end)}";
          } else {
            var format = DateFormat.yMMMd("de_DE");
            return "${format.format(start)} - ${format.format(end)}";
          }
        }
    }
  }
}
