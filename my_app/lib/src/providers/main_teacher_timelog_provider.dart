import 'package:flutter/material.dart';
import 'package:tution_class/src/models/timelog_main.dart';
import 'package:tution_class/src/services/firestore_service.dart';
import 'package:uuid/uuid.dart';

class MainTeacherTimelogProvider with ChangeNotifier {
  final firestoreService = FirestoreService();
  var uuid = Uuid();

  String? _id;
  TimeOfDay? _from;
  TimeOfDay? _to;
  String? _duration;
  String? _chapterNo;
  String? _chapterName;
  String? _remark;

  //getters
  String? get id => _id;
  TimeOfDay? get from => _from;
  TimeOfDay? get to => _to;
  String? get duration => _duration;
  String? get chapterNo => _chapterNo;
  String? get chapterName => _chapterName;
  String? get remark => _remark;

  //Setters
  set changeId(String id) {
    _id = id;
    notifyListeners();
  }

  set changeFrom(TimeOfDay from) {
    _from = from;
    notifyListeners();
  }

  set changeTo(TimeOfDay to) {
    _to = to;
    notifyListeners();
  }

  set changeDuration(String duration) {
    _duration = duration;
    notifyListeners();
  }

  set changeChapterNo(String chapterNo) {
    _chapterNo = chapterNo;
    notifyListeners();
  }

  set changeChaperName(String chapterName) {
    _chapterName = chapterName;
    notifyListeners();
  }

  set changeRemark(String remark) {
    _remark = remark;
    notifyListeners();
  }

  loadAll(TimelogMain? timelogMain) {
    if (timelogMain == null) {
      _chapterName = '';
      _chapterNo = '';
      _duration = '';
      _from = TimeOfDay(hour: 7, minute: 0);
      _to = TimeOfDay(hour: 8, minute: 0);
      _remark = '';
    } else {
      _chapterName = timelogMain.chapterName;
      _chapterNo = timelogMain.chapterNo;
      _duration = timelogMain.duration;
      _from = timelogMain.from;
      _to = timelogMain.to;
      _id = timelogMain.id;
      _remark = timelogMain.remark;
    }
  }
}
