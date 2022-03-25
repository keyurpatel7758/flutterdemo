import 'dart:convert';

import 'package:date_format/date_format.dart';
import 'package:intl/intl.dart';
import 'package:tution_class/src/models/timelog_assistant.dart';
import 'package:tution_class/src/models/timelog_main.dart';

class TimelogEntry {
  late String id;
  late String userId;
  late DateTime logDate;
  // late String? standard;
  // late String? medium;
  // late String? subject;
  // late String? workAs;
  List<TimelogAssistant>? assistantTimelog;
  List<TimelogMain>? mainTimelog;
  // late String jsonMainTimelog;

  TimelogEntry(
      {required this.id,
      required this.userId,
      //this.standard,
      required this.logDate,
      // this.medium,
      // this.subject,
      // this.workAs,
      this.mainTimelog,
      this.assistantTimelog});

  factory TimelogEntry.fromJson(Map<String, dynamic>? json) {
    return TimelogEntry(
        id: json!['id'],
        userId: json['userId'],
        logDate: DateFormat('dd/MM/yyyy').parse(
          json['logDate'],
        ),
        // standard: json['standard'],
        // medium: json['medium'],
        // subject: json['subject'],
        // workAs: json['workAs'],
        assistantTimelog: <TimelogAssistant>[],
        mainTimelog: <TimelogMain>[]);
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'logDate': formatDate(logDate, [dd, '/', mm, '/', yyyy]),
      // 'medium': medium,
      // 'standard': standard,
      // 'subject': subject,
      // 'workAs': workAs,
      'id': id,
      // 'mainTimelog': mainTimelog!.map((e) => e.toJson())
      // ,
      // 'mainTimelog': jsonMainTimelog
    };
  }
}
