import 'package:flutter/foundation.dart';
import 'package:tution_class/src/models/profile.dart';
import 'package:tution_class/src/models/standard.dart';
import 'package:tution_class/src/services/firestore_service.dart';

class ProfileProvider with ChangeNotifier {
  final firestoreService = FirestoreService();

  late bool _isGujaratiSelected;
  late bool _isEnglishSelected;
  late bool _isMainTeacher;
  late bool _isAssistantTeacher;
  late String _userId;
  late List<String> _standards;
  late List<String> _subjects;

  //Getters
  bool get isGujaratiSelected => _isGujaratiSelected;
  bool get isEnglishSelected => _isEnglishSelected;
  bool get isMainTeacher => _isMainTeacher;
  bool get isAssistantTeacher => _isAssistantTeacher;

  String get userId => _userId;
  //String get standards => _standards;
  //Stream<Profile> get profile  => (userId) firestoreService.getProfile();
  List<String> get standards => _standards;
  List<String> get subjects => _subjects;

  Stream<Profile> getProfile(String userId) =>
      firestoreService.getProfile(userId);

  //Setter
  set setUserId(String userId) {
    _userId = userId;
  }

  set changeIsGujarati(bool isGujarati) {
    _isGujaratiSelected = isGujarati;
    notifyListeners();
  }

  set changeIsEnglish(bool isEnglish) {
    _isEnglishSelected = isEnglish;
    notifyListeners();
  }

  set changeIsMainTeacher(bool isMain) {
    _isMainTeacher = isMain;
    notifyListeners();
  }

  set changeIsAssistantTeacher(bool isAssist) {
    _isAssistantTeacher = isAssist;
    notifyListeners();
  }

  set addStandard(String std) {
    if (_standards.indexOf(std) == -1) {
      _standards.add(std);
    }
  }

  set removeStandard(String std) {
    if (_standards.indexOf(std) > -1) {
      _standards.remove(std);
    }
  }

  set addSubject(String sub) {
    if (_subjects.indexOf(sub) == -1) {
      _subjects.add(sub);
    }
  }

  set removeSubject(String sub) {
    if (_subjects.indexOf(sub) == -1) {
      _subjects.remove(sub);
    }
  }
  // set changeStandards(String standards) {
  //   _standards = standards;
  //   notifyListeners();
  // }

  loadAll(String userId, Profile? profile) {
    if (profile != null) {
      _userId = profile.userId;
      _isGujaratiSelected = profile.isGujaratiSelected;
      _isEnglishSelected = profile.isEnglishSelected;
      _isMainTeacher = profile.isMainTeacher;
      _isAssistantTeacher = profile.isAssistantTeacher;
      _standards = profile.standards.split(',');
      _subjects = profile.subjects.split(',');
    } else {
      _userId = userId;
      _isGujaratiSelected = false;
      _isEnglishSelected = false;
      _isMainTeacher = false;
      _isAssistantTeacher = false;
      _standards = [];
      _subjects = [];
    }
  }

  saveProfile() {
    var profile = Profile(
        userId: _userId,
        isGujaratiSelected: _isGujaratiSelected,
        isEnglishSelected: _isEnglishSelected,
        isMainTeacher: _isMainTeacher,
        isAssistantTeacher: _isAssistantTeacher,
        standards: _standards.join(','),
        subjects: _subjects.join(','));
    firestoreService.setProfile(profile);
  }
}
