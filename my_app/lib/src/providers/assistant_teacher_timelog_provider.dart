import 'package:flutter/material.dart';
import 'package:tution_class/src/models/timelog_assistant.dart';
import 'package:tution_class/src/models/timelog_main.dart';
import 'package:tution_class/src/services/firestore_service.dart';
import 'package:uuid/uuid.dart';

class AssistantTeacherTimelogProvider with ChangeNotifier {
  final firestoreService = FirestoreService();
  var uuid = Uuid();

  String? _id;
  TimeOfDay? _from;
  TimeOfDay? _to;
  String? _duration;
  String? _lactureType;
  String? _whatDone;
  String? _remark;
  String? _userId;
  String? _standard;
  String? _medium;
  String? _subject;
  String? _workAs;

  //getters
  String? get id => _id;
  TimeOfDay? get from => _from;
  TimeOfDay? get to => _to;
  String? get duration => _duration;
  String? get lactureType => _lactureType;
  String? get whatDone => _whatDone;
  String? get remark => _remark;
  String? get userId => _userId;
  String? get standard => _standard;
  String? get medium => _medium;
  String? get subject => _subject;
  String? get workAs => _workAs;

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

  set changelactureType(String lactureType) {
    _lactureType = lactureType;
    notifyListeners();
  }

  set changeWhatDone(String whatDone) {
    _whatDone = whatDone;
    notifyListeners();
  }

  set changeRemark(String remark) {
    _remark = remark;
    notifyListeners();
  }

  loadAll(TimelogAssistant? timelogAssistant) {
    if (timelogAssistant == null) {
      _duration = '';
      _from = TimeOfDay(hour: 7, minute: 0);
      _to = TimeOfDay(hour: 8, minute: 0);
      _remark = '';
      _whatDone = '';
      _lactureType = '';
    } else {
      _duration = timelogAssistant.duration;
      _from = timelogAssistant.from;
      _to = timelogAssistant.to;
      _id = timelogAssistant.id;
      _remark = timelogAssistant.remark;
      _whatDone = timelogAssistant.whatDone;
      _lactureType = timelogAssistant.lactureType;
    }
  }
}
