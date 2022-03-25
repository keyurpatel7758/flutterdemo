import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimelogAssistant {
  late String id;
  late TimeOfDay from;
  late TimeOfDay to;
  late String duration;
  late String lactureType;
  late String whatDone;
  late String remark;
  late String userId;
  late String standard;
  late String medium;
  late String subject;
  late String workAs;

  TimelogAssistant(
      {required this.duration,
      required this.from,
      required this.id,
      required this.lactureType,
      required this.remark,
      required this.to,
      required this.whatDone,
      required this.userId,
      required this.standard,
      required this.medium,
      required this.subject,
      required this.workAs});

  factory TimelogAssistant.fromJson(Map<String, dynamic>? json) {
    return TimelogAssistant(
        id: json!['id'],
        lactureType: json['lactureType'],
        whatDone: json['whatDone'],
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
      'lactureType': lactureType,
      'whatDone': whatDone,
      'duration': duration,
      'from': formatTimeOfDay(from),
      'userId': userId,
      'to': formatTimeOfDay(to),
      'remark': remark,
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
