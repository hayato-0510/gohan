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

  String getFormattedHours() {
    if (weeklyHours.isEmpty) {
      return "営業時間情報なし";
    }

    List<String> formattedHours = [];
    List<String> daysOfWeek = ['月', '火', '水', '木', '金', '土', '日'];

    for (int i = 0; i < 7; i++) {
      if (closedDays.contains(i)) {
        formattedHours.add("${daysOfWeek[i]}: 休業");
      } else if (weeklyHours.containsKey(i)) {
        String dayHours = weeklyHours[i]!.openRanges.map((range) {
          return "${_formatTime(range.start)}-${_formatTime(range.end)}";
        }).join(", ");
        formattedHours.add("${daysOfWeek[i]}: $dayHours");
      } else {
        formattedHours.add("${daysOfWeek[i]}: 情報なし");
      }
    }

    return formattedHours.join("\n");
  }

  String _formatTime(TimeOfDay time) {
    return "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";
  }


  static BusinessHours parseFromGooglePlaces(Map<String, dynamic>? openingHours) {
    if (openingHours == null) {
      return BusinessHours(weeklyHours: {}, closedDays: []);
    }

    final weeklyHours = <int, DayHours>{};
    final closedDays = <int>[];

    final periods = openingHours['periods'] as List<dynamic>?;
    if (periods != null) {
      for (var period in periods) {
        final open = period['open'];
        final close = period['close'];
        if (open != null && close != null) {
          final day = open['day'];
          final openTime = TimeOfDay(hour: int.parse(open['time'].substring(0, 2)), minute: int.parse(open['time'].substring(2)));
          final closeTime = TimeOfDay(hour: int.parse(close['time'].substring(0, 2)), minute: int.parse(close['time'].substring(2)));
          
          if (weeklyHours.containsKey(day)) {
            weeklyHours[day]!.openRanges.add(TimeRange(start: openTime, end: closeTime));
          } else {
            weeklyHours[day] = DayHours(openRanges: [TimeRange(start: openTime, end: closeTime)]);
          }
        }
      }
    }

    // 閉店日を特定
    for (int i = 0; i < 7; i++) {
      if (!weeklyHours.containsKey(i)) {
        closedDays.add(i);
      }
    }

    return BusinessHours(weeklyHours: weeklyHours, closedDays: closedDays);
  }

  Map<String, dynamic> toJson() {
    return {
      'weeklyHours': weeklyHours.map((key, value) => MapEntry(key.toString(), value.toJson())),
      'closedDays': closedDays,
    };
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
  Map<String, dynamic> toJson() {
    return {
      'openRanges': openRanges.map((range) => range.toJson()).toList(),
    };
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
  Map<String, dynamic> toJson() {
    return {
      'start': '${start.hour.toString().padLeft(2, '0')}:${start.minute.toString().padLeft(2, '0')}',
      'end': '${end.hour.toString().padLeft(2, '0')}:${end.minute.toString().padLeft(2, '0')}',
    };
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