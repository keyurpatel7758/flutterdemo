import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tution_class/src/models/Subject.dart';
import 'package:tution_class/src/models/entry.dart';
import 'package:tution_class/src/models/timelog_assistant.dart';
import 'package:tution_class/src/models/timelog_entry.dart';
import 'package:tution_class/src/models/timelog_main.dart';
import 'package:tution_class/src/services/firestore_service.dart';
import 'package:uuid/uuid.dart';

class TimelogEntryProvider with ChangeNotifier {
  final firestoreService = FirestoreService();

  late String _id = '';
  late String _standard;
  late String _medium;
  late String _subject;
  late DateTime _dateTimeOn;
  late String _workAs;
  late List<TimelogMain> _mainTimelog;
  late List<TimelogAssistant> _assistantTimelog;
  late Stream<TimelogEntry> _timelogs;
  var uuid = Uuid();
  late TimelogMain _mainTimelogToEdit;
  late String _userId;

  //Getters
  String get standard => _standard;
  String get medium => _medium;
  String get subject => _subject;
  DateTime get onDatetime => _dateTimeOn;
  String get workAs => _workAs;
  List<TimelogMain> get mainTimelog => _mainTimelog;
  List<TimelogAssistant> get assistantTimelog => _assistantTimelog;
  Stream<TimelogEntry> get timelogs => _timelogs;
  TimelogMain get mainTimelogToEdit => _mainTimelogToEdit;
  String get userId => _userId;
  String get id => _id;

  //Setters
  set changeStandard(String standard) {
    _standard = standard;
    notifyListeners();
  }

  set changeMedium(String medium) {
    _medium = medium;
    notifyListeners();
  }

  set changeSubject(String subject) {
    _subject = subject;
    notifyListeners();
  }

  set changeWorkAs(String workAs) {
    _workAs = workAs;
    notifyListeners();
  }

  set changeDateTimeOn(DateTime dateTimeOn) {
    _dateTimeOn = dateTimeOn;
    notifyListeners();
  }

  set changeMainTimelogToEdit(TimelogMain timelogMain) {
    _mainTimelogToEdit = timelogMain;
    notifyListeners();
  }

  set changeTimelogs(Stream<TimelogEntry> timelogs) {
    _timelogs = timelogs;
    notifyListeners();
  }

  // updateMainTeacherTimelog(TimelogMain timelogMain) {
  //   if (mainTimelog.any((element) => element.id == timelogMain.id)) {
  //     var entry =
  //         mainTimelog.firstWhere((element) => element.id == timelogMain.id);
  //     entry.chapterName = timelogMain.chapterName;
  //     entry.chapterNo = timelogMain.chapterNo;
  //     entry.duration = timelogMain.duration;
  //     entry.from = timelogMain.from;
  //     entry.remark = timelogMain.remark;
  //     entry.to = timelogMain.to;
  //     entry.medium = timelogMain.medium;
  //     entry.standard = timelogMain.standard;
  //     entry.subject = timelogMain.subject;
  //     entry.workAs = timelogMain.workAs;
  //     notifyListeners();
  //   }
  // }
  updateMainTeacherTimelog(TimelogMain timelogMain) {
    if (timelogMain.id == '') {
      timelogMain.id = uuid.v1();
      mainTimelog.add(timelogMain);
    } else {
      var existingItem =
          mainTimelog.where((element) => element.id == timelogMain.id);

      var itemToUpdate = existingItem.first;
      itemToUpdate.duration = timelogMain.duration;
      itemToUpdate.to = timelogMain.to;
      itemToUpdate.from = timelogMain.from;
      itemToUpdate.remark = timelogMain.remark;
    }
    notifyListeners();
  }

  deleteAssistantTeacherTimelog(
      String userId, DateTime dateToLoad, String id, String idToDelete) {
    var existingItem =
        assistantTimelog.where((element) => element.id == idToDelete);

    firestoreService
        .deleteAssistantTeacherTimelog(userId, dateToLoad, id, idToDelete)
        .then((value) => assistantTimelog.remove(existingItem));
    notifyListeners();
  }

  deleteMainTeacherTimelog(
      String userId, DateTime dateToLoad, String id, String idToDelete) {
    var existingItem = mainTimelog.where((element) => element.id == idToDelete);

    firestoreService
        .deleteMainTeacherTimelog(userId, dateToLoad, id, idToDelete)
        .then((value) => mainTimelog.remove(existingItem));
    notifyListeners();
  }

  updateAssistantTeacherTimelog(TimelogAssistant timelogAssistant) {
    if (timelogAssistant.id == '') {
      timelogAssistant.id = uuid.v1();
      assistantTimelog.add(timelogAssistant);
    } else {
      var existingItem = assistantTimelog
          .where((element) => element.id == timelogAssistant.id);
      var itemToUpdate = existingItem.first;
      itemToUpdate.duration = timelogAssistant.duration;
      itemToUpdate.to = timelogAssistant.to;
      itemToUpdate.from = timelogAssistant.from;
      itemToUpdate.lactureType = timelogAssistant.lactureType;
      itemToUpdate.whatDone = timelogAssistant.whatDone;
      itemToUpdate.remark = timelogAssistant.remark;
    }
    notifyListeners();
  }

  addNewAssistantTeacherTimelog(
      String userId, String medium, String standard, String subject) {
    //var id = uuid.v1();
    //_mainTimelog.add(TimelogMain(
    return TimelogAssistant(
        lactureType: 'Regular',
        whatDone: 'Homework check',
        duration: '01:00',
        from: TimeOfDay(hour: 7, minute: 0),
        id: '',
        remark: '',
        userId: userId,
        to: TimeOfDay(hour: 8, minute: 0),
        medium: medium,
        standard: standard,
        subject: subject,
        workAs: 'Assistant');
    //return _mainTimelog.where((element) => element.id == id).first;
  }

  addNewMainTeacherTimelog(
      String userId, String medium, String standard, String subject) {
    //var id = uuid.v1();
    //_mainTimelog.add(TimelogMain(
    return TimelogMain(
        chapterName: 'Chapter 1 Name',
        chapterNo: 'Chapter 1',
        duration: '01:00',
        from: TimeOfDay(hour: 7, minute: 0),
        id: '',
        remark: '',
        userId: userId,
        to: TimeOfDay(hour: 8, minute: 0),
        medium: medium,
        standard: standard,
        subject: subject,
        workAs: 'Main');
    //return _mainTimelog.where((element) => element.id == id).first;
  }

  //functions
  loadAll(String userId, TimelogEntry? timelogEntry,
      {bool whenDateSelectionChange = false}) {
    if (timelogEntry != null) {
      _id = timelogEntry.id;
      _assistantTimelog = timelogEntry.assistantTimelog!;
      _dateTimeOn = timelogEntry.logDate;
      _mainTimelog = timelogEntry.mainTimelog!;
      // _medium = timelogEntry.medium ?? '';
      // _standard = timelogEntry.standard ?? '';
      // _subject = timelogEntry.subject ?? '';
      // _workAs = timelogEntry.workAs ?? '';
      _userId = timelogEntry.userId;
    } else {
      _assistantTimelog = [];
      _dateTimeOn = DateTime.now();
      _mainTimelog = [];
      _medium = whenDateSelectionChange ? medium : '';
      _standard = whenDateSelectionChange ? standard : '';
      _subject = whenDateSelectionChange ? subject : '';
      _workAs = whenDateSelectionChange ? workAs : '';
      _id = uuid.v1();
      _userId = userId;
    }
  }

  saveEntry() {
    var newEntry = TimelogEntry(
        userId: userId,
        //standard: standard,
        logDate: onDatetime,
        // medium: medium,
        // subject: subject,
        // workAs: workAs,
        id: id,
        mainTimelog: mainTimelog,
        assistantTimelog: assistantTimelog);

    //newEntry.jsonMainTimelog = jsonEncode(mainTimelog);

    firestoreService.setTimelogs(newEntry);
  }

  Future<List<TimelogEntry>> getTimelogs(
          String userId, DateTime dateToLoad) async =>
      await firestoreService.getTimelogsNew(userId, dateToLoad);

  Future<List<TimelogMain>> getMainTeacherTimelogs(
          String userId, DateTime dateToLoad, String id) async =>
      await firestoreService.getMainTeacherTimelog(userId, dateToLoad, id);

  Future<List<TimelogAssistant>> getAssistantTeacherTimelogs(
          String userId, DateTime dateToLoad, String id) async =>
      await firestoreService.getAssistantTeacherTimelog(userId, dateToLoad, id);

  Stream<List<Entry>> getEntries(String userId, DateTime dateToLoad) =>
      firestoreService.getEntries();

  Stream<List<TimelogEntry>> getEntries1(String userId, DateTime dateToLoad) =>
      firestoreService.getEntries1();
}
