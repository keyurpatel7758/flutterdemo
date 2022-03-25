import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:tution_class/src/models/entry.dart';
import 'package:tution_class/src/models/profile.dart';
import 'package:tution_class/src/models/timelog_assistant.dart';
import 'package:tution_class/src/models/timelog_entry.dart';
import 'package:tution_class/src/models/timelog_main.dart';

class FirestoreService {
  FirebaseFirestore _db = FirebaseFirestore.instance;

  //Get Entries
  Stream<List<Entry>> getEntries() {
    return _db.collection('entries').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Entry.fromJson(doc.data());
      }).toList();
    });
    return _db.collection('entries').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Entry.fromJson(doc.data())).toList());
    //.where('date', isGreaterThan: DateTime.now().add(Duration(days: -30)).toIso8601String())
  }

  Stream<List<TimelogEntry>> getEntries1() {
    return _db.collection('entries').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return TimelogEntry.fromJson(doc.data());
      }).toList();
    });
  }

  //Upsert
  Future<void> setEntry(Entry entry) {
    var options = SetOptions(merge: true);
    return _db
        .collection('entries')
        .doc(entry.entryId)
        .set(entry.toMap(), options);
  }

  //Delete
  Future<void> removeEntry(String entryId) {
    return _db.collection('entries').doc(entryId).delete();
  }

//Get Profile
  Stream<Profile> getProfile(String userId) {
    return _db
        .collection('profiles')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Profile.fromJson(doc.data())).first);
  }

//Set Profile
  Future<void> setProfile(Profile profile) {
    var options = SetOptions(merge: true);
    return _db
        .collection('profiles')
        .doc(profile.userId)
        .set(profile.toMap(), options);
  }

//Get Timelogs
  Future<List<TimelogEntry>> getTimelogsNew(String userId, DateTime dateToLoad,
      {bool includeMainTeacherTimelogs = true}) async {
    var year = dateToLoad.year.toString();
    var month = dateToLoad.month.toString();
    var masterList = _db
        .collection('timelogs')
        .doc(userId)
        .collection('years')
        .doc(year.toString())
        .collection('months')
        .doc(month.toString())
        .collection('user_timelogs')
        .where('logDate',
            isEqualTo: formatDate(dateToLoad, [dd, '/', mm, '/', yyyy]))
        .get()
        .then((value) =>
            value.docs.map((e) => TimelogEntry.fromJson(e.data())).toList());

    return masterList;
  }

  Future<List<TimelogEntry>> getTimelogs(String userId, DateTime dateToLoad,
      {bool includeMainTeacherTimelogs = true}) {
    var year = dateToLoad.year.toString();
    var month = dateToLoad.month.toString();
    return _db
        .collection('timelogs')
        .doc(userId)
        .collection('years')
        .doc(year.toString())
        .collection('months')
        .doc(month.toString())
        .collection('user_timelogs')

        //.where('dateTime', isEqualTo: formatDate(dateToLoad, [dd, '/', mm, '/', yyyy]))
        //.where('userId', isEqualTo: userId)
        .get()
        .then((snapshot) {
      return snapshot.docs.map((doc) {
        var timelogEntry = TimelogEntry.fromJson(doc.data());

        if (includeMainTeacherTimelogs) {
          String id = timelogEntry.id;
          getMainTeacherTimelog(userId, dateToLoad, id).then((event) {
            event.forEach((mt) {
              var mainTeacherlogs = timelogEntry.mainTimelog;
              mainTeacherlogs!.add(mt);
            });
            //print(event);
          });
        }

        return timelogEntry;
        // return TimelogEntry(
        //     id: doc.data()['id'],
        //     userId: doc.data()['userId'],
        //     dateTime: doc.data()['dateTime']);
      }).toList();
    });
    // .map((snapshot) => snapshot.docs
    //     .map((doc) => TimelogEntry.fromJson(doc.data()))
    //     .toList());
    // .snapshots()
    // .map((snapshot) => snapshot.docs
    //     .map((doc) => TimelogEntry.fromJson(doc.data()))
    //     .toList());
  }

  Future<List<TimelogMain>> getMainTeacherTimelog(
      String userId, DateTime dateToLoad, String id) async {
    var year = dateToLoad.year.toString();
    var month = dateToLoad.month.toString();
    var masterList = _db
        .collection('timelogs')
        .doc(userId)
        .collection('years')
        .doc(year.toString())
        .collection('months')
        .doc(month.toString())
        .collection('user_timelogs')
        .doc(id)
        .collection('mainTimelogs')
        .get()
        .then((snapshot) => snapshot.docs
            .map((doc) => TimelogMain.fromJson(doc.data()))
            .toList());

    return masterList;
  }

  Future<List<TimelogAssistant>> getAssistantTeacherTimelog(
      String userId, DateTime dateToLoad, String id) async {
    var year = dateToLoad.year.toString();
    var month = dateToLoad.month.toString();
    var masterList = _db
        .collection('timelogs')
        .doc(userId)
        .collection('years')
        .doc(year.toString())
        .collection('months')
        .doc(month.toString())
        .collection('user_timelogs')
        .doc(id)
        .collection('assistantTimelogs')
        .get()
        .then((snapshot) => snapshot.docs
            .map((doc) => TimelogAssistant.fromJson(doc.data()))
            .toList());

    return masterList;
  }

  Future<void> deleteAssistantTeacherTimelog(
      String userId, DateTime dateToLoad, String id, String idToDelete) {
    var year = dateToLoad.year.toString();
    var month = dateToLoad.month.toString();
    return _db
        .collection('timelogs')
        .doc(userId)
        .collection('years')
        .doc(year.toString())
        .collection('months')
        .doc(month.toString())
        .collection('user_timelogs')
        .doc(id)
        .collection('assistantTimelogs')
        .doc(idToDelete)
        .delete();
  }

  Future<void> deleteMainTeacherTimelog(
      String userId, DateTime dateToLoad, String id, String idToDelete) {
    var year = dateToLoad.year.toString();
    var month = dateToLoad.month.toString();
    return _db
        .collection('timelogs')
        .doc(userId)
        .collection('years')
        .doc(year.toString())
        .collection('months')
        .doc(month.toString())
        .collection('user_timelogs')
        .doc(id)
        .collection('mainTimelogs')
        .doc(idToDelete)
        .delete();
  }

  //Upsert
  Future<void> setTimelogs(TimelogEntry timelogs) {
    var options = SetOptions(merge: true);
    var year = timelogs.logDate.year;
    var month = timelogs.logDate.month;
    var day = timelogs.logDate.day;
    var result;

    result = _db
        .collection('timelogs')
        .doc(timelogs.userId)
        .collection('years')
        .doc(year.toString())
        .collection('months')
        .doc(month.toString())
        .collection('user_timelogs')
        .doc(timelogs.id)
        .set(timelogs.toJson(), options);

    if (timelogs.mainTimelog != null) {
      for (int i = 0; i < timelogs.mainTimelog!.length; i++) {
        var e = timelogs.mainTimelog![i];
        result = _db
            .collection('timelogs')
            .doc(timelogs.userId)
            .collection('years')
            .doc(year.toString())
            .collection('months')
            .doc(month.toString())
            .collection('user_timelogs')
            .doc(timelogs.id)
            .collection('mainTimelogs')
            .doc(e.id)
            .set(e.toJson(), options);
      }
    }

    if (timelogs.assistantTimelog != null) {
      for (int i = 0; i < timelogs.assistantTimelog!.length; i++) {
        var e = timelogs.assistantTimelog![i];
        result = _db
            .collection('timelogs')
            .doc(timelogs.userId)
            .collection('years')
            .doc(year.toString())
            .collection('months')
            .doc(month.toString())
            .collection('user_timelogs')
            .doc(timelogs.id)
            .collection('assistantTimelogs')
            .doc(e.id)
            .set(e.toJson(), options);
      }
    }
    // timelogs.mainTimelog!.map((e) => {
    //       result = _db
    //           .collection('timelogs')
    //           .doc(timelogs.userId)
    //           .collection(year.toString())
    //           .doc(year.toString())
    //           .collection(month.toString())
    //           .doc(timelogs.id)
    //           .collection('mainTimelogs')
    //           .doc(e.id)
    //           .set(e.toJson(), options)
    //     });
    return result;
  }
}
