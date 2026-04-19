import 'package:flutter/material.dart';

extension TimeOfDayParse on TimeOfDay {
  static TimeOfDay parse(String s) {
    return TimeOfDay(
      hour: int.parse(s.split(":")[0]),
      minute: int.parse(s.split(":")[1]),
    );
  }

  String toJson() {
    String addLeadingZeroIfNeeded(int value) {
      if (value < 10) {
        return '0$value';
      }
      return value.toString();
    }

    final String hourLabel = addLeadingZeroIfNeeded(hour);
    final String minuteLabel = addLeadingZeroIfNeeded(minute);

    return '$hourLabel:$minuteLabel';
  }
}

extension DurationParse on Duration {
  static Duration parse(String s) {
    return Duration(
      hours: int.parse(s.split(":")[0]),
      minutes: int.parse(s.split(":")[1]),
      seconds: int.parse(s.split(":")[2]),
    );
  }

  String toJson() {
    String addLeadingZeroIfNeeded(int value) {
      if (value < 10) {
        return '0$value';
      }
      return value.toString();
    }

    final String hourLabel = addLeadingZeroIfNeeded(inSeconds ~/ 3600);
    final String minuteLabel = addLeadingZeroIfNeeded(inSeconds ~/ 60);
    final String secondLabel = addLeadingZeroIfNeeded(inSeconds % 60);

    return '$hourLabel:$minuteLabel:$secondLabel';
  }
}
