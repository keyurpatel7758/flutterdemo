import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tution_class/src/models/timelog_assistant.dart';

class TimelogMain {
  late String id;
  late TimeOfDay from;
  late TimeOfDay to;
  late String duration;
  late String chapterNo;
  late String chapterName;
  late String remark;
  late String userId;
  late String standard;
  late String medium;
  late String subject;
  late String workAs;

  TimelogMain(
      {required this.chapterName,
      required this.chapterNo,
      required this.duration,
      required this.from,
      required this.id,
      required this.remark,
      required this.to,
      required this.userId,
      required this.standard,
      required this.medium,
      required this.subject,
      required this.workAs});

  factory TimelogMain.fromJson(Map<String, dynamic>? json) {
    return TimelogMain(
        id: json!['id'],
        chapterName: json['chapterName'],
        chapterNo: json['chapterNo'],
        duration: json['duration'],
        from: getTimeOfDay(json['from']),
        remark: json['remark'],
        to: getTimeOfDay(json['to']),
        userId: json['userId'],
        standard: json['standard'],
        medium: json['medium'],
        subject: json['subject'],
        workAs: json['workAs']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'chapterName': chapterName,
      'chapterNo': chapterNo,
      'duration': duration,
      'from': formatTimeOfDay(from),
      'to': formatTimeOfDay(to),
      'remark': remark,
      'userId': userId,
      'medium': medium,
      'standard': standard,
      'subject': subject,
      'workAs': workAs
    };
  }

  formatTimeOfDay(TimeOfDay timeOfDay) {
    return formatDate(
        DateTime(2021, 6, 1, timeOfDay.hour, timeOfDay.minute), [HH, ':', nn]);
  }

  static TimeOfDay getTimeOfDay(String timeofday) {
    var dateToFormat = DateFormat("HH:mm").parse(timeofday);
    return TimeOfDay.fromDateTime(dateToFormat);
  }
}
