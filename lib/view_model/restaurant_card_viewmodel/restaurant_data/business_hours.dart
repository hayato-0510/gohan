export 'business_hours.dart';

import 'package:flutter/material.dart';


class BusinessHours {
  final Map<int, DayHours> weeklyHours;
  final List<int> closedDays; // 定休日（1 = 月曜日, 7 = 日曜日）
  final List<SpecialDate> specialDates;

  BusinessHours({
    required this.weeklyHours,
    this.closedDays = const [],
    this.specialDates = const [],
  });

  bool isOpenNow() {
    final now = DateTime.now();
    
    // 特別な日付かどうかをチェック
    for (var special in specialDates) {
      if (special.date.year == now.year && 
          special.date.month == now.month && 
          special.date.day == now.day) {
        return special.isOpen;
      }
    }

    // 定休日かどうかをチェック
    if (closedDays.contains(now.weekday)) {
      return false;
    }

    // 通常の営業時間をチェック
    final dayHours = weeklyHours[now.weekday];
    if (dayHours == null) return false;  // この曜日の情報がない場合は閉店とみなす

    return dayHours.isOpenAt(TimeOfDay.fromDateTime(now));
  }

  String getClosedDaysString() {
    List<String> days = ['月', '火', '水', '木', '金', '土', '日'];
    return closedDays.map((day) => days[day - 1]).join(', ');
  }
}

class DayHours {
  final List<TimeRange> openRanges;

  DayHours({required this.openRanges});

  bool isOpenAt(TimeOfDay time) {
    for (var range in openRanges) {
      if (range.contains(time)) return true;
    }
    return false;
  }
}

class TimeRange {
  final TimeOfDay start;
  final TimeOfDay end;

  TimeRange({required this.start, required this.end});

  bool contains(TimeOfDay time) {
    final startMinutes = start.hour * 60 + start.minute;
    final endMinutes = end.hour * 60 + end.minute;
    final timeMinutes = time.hour * 60 + time.minute;

    if (endMinutes > startMinutes) {
      return timeMinutes >= startMinutes && timeMinutes < endMinutes;
    } else {
      // 深夜をまたぐ場合
      return timeMinutes >= startMinutes || timeMinutes < endMinutes;
    }
  }
}

class SpecialDate {
  final DateTime date;
  final bool isOpen;
  final List<TimeRange>? customHours;

  SpecialDate({
    required this.date,
    required this.isOpen,
    this.customHours,
  });
}