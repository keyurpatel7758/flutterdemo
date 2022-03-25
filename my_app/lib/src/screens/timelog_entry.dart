import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tution_class/src/models/entry.dart';
import 'package:tution_class/src/models/profile.dart';
import 'package:tution_class/src/models/timelog_entry.dart';
import 'package:tution_class/src/models/timelog_main.dart';
import 'package:tution_class/src/providers/profile_provider.dart';
import 'package:tution_class/src/providers/timelog_entry_provider.dart';
import 'package:tution_class/src/screens/profile_setup.dart';
import 'package:tution_class/src/widget/assistant_teacher_timelog.dart';
import 'package:tution_class/src/widget/main_teacher_timelog.dart';

class TimelogEntryScreen extends StatefulWidget {
  Profile? profile;
  String duration = '';

  TimelogEntryScreen({this.profile});

  @override
  _TimelogEntryState createState() => _TimelogEntryState();
}

class _TimelogEntryState extends State<TimelogEntryScreen> {
  List<String> mediums = [];
  List<String> workAs = [];
  bool isProfileIncomplete = false;

  @override
  void initState() {
    widget.duration = '';
    // TODO: implement initState
    final user = FirebaseAuth.instance.currentUser;

    final profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);
    final timelogEntryProvider =
        Provider.of<TimelogEntryProvider>(context, listen: false);

    if (user != null) {
      if (widget.profile != null) {
        profileProvider.loadAll(user.uid, widget.profile);
        timelogEntryProvider.loadAll(user.uid, null);
        if (widget.profile!.isAssistantTeacher) {
          workAs.add('Assistant');
        }
        if (widget.profile!.isMainTeacher) {
          workAs.add('Main');
        }
        if (widget.profile!.isEnglishSelected) {
          mediums.add('English');
        }
        if (widget.profile!.isGujaratiSelected) {
          mediums.add('Gujarati');
        }

        if (mediums.isEmpty ||
            profileProvider.standards.isEmpty ||
            profileProvider.subjects.isEmpty ||
            workAs.isEmpty) {
          isProfileIncomplete = true;
        } else {
          timelogEntryProvider.changeMedium = mediums[0];
          timelogEntryProvider.changeStandard = profileProvider.standards[0];
          timelogEntryProvider.changeSubject = profileProvider.subjects[0];
          timelogEntryProvider.changeWorkAs = workAs[0];

          loadTimelogsForSelectedDate(
              timelogEntryProvider, user, timelogEntryProvider.onDatetime);
        }
        // if (mediums.isEmpty ||
        //     profileProvider.standards.isEmpty ||
        //     profileProvider.subjects.isEmpty ||
        //     workAs.isEmpty) {
        //   showDialog<String>(
        //     context: context,
        //     builder: (BuildContext context) => AlertDialog(
        //       title: const Text('Profile setup missing'),
        //       content: const Text('Please setup the profile correctly!!'),
        //       actions: <Widget>[
        //         TextButton(
        //           onPressed: () => Navigator.of(context).push(
        //             MaterialPageRoute(
        //               builder: (context) => ProfileSetup(
        //                   profile: Profile(
        //                       userId: user.uid,
        //                       isAssistantTeacher:
        //                           profileProvider.isAssistantTeacher,
        //                       isEnglishSelected:
        //                           profileProvider.isEnglishSelected,
        //                       isGujaratiSelected:
        //                           profileProvider.isGujaratiSelected,
        //                       isMainTeacher: profileProvider.isMainTeacher,
        //                       standards: profileProvider.standards.join(','),
        //                       subjects: profileProvider.subjects.join(','))),
        //             ),
        //           ),
        //           child: const Text('Setup it'),
        //         )
        //       ],
        //     ),
        //   );
        // }
        // timelogEntryProvider.changeMedium = mediums[0];
        // timelogEntryProvider.changeStandard = profileProvider.standards[0];
        // timelogEntryProvider.changeSubject = profileProvider.subjects[0];
        // timelogEntryProvider.changeWorkAs = workAs[0];

        // loadTimelogsForSelectedDate(
        //     timelogEntryProvider, user, timelogEntryProvider.onDatetime);
      }
      // else {
      //   profileProvider.loadAll(user.uid, null);
      //   timelogEntryProvider.loadAll(null);
      // }
    }

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ButtonStyle style =
        ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20));

    final profileProvider = Provider.of<ProfileProvider>(context);
    final timelogEntryProvider = Provider.of<TimelogEntryProvider>(context);
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return Text('Invalid login');

    if (isProfileIncomplete) {
      return Scaffold(
          appBar: AppBar(
            title: Text(user.displayName! +
                ' ' +
                formatDate(
                    timelogEntryProvider.onDatetime, [MM, ' ', dd, ',', yyyy])),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(child: Text('Incomplete profile setup!!')),
                ElevatedButton(
                  style: style,
                  onPressed: () {
                    // Navigator.of(context).push(
                    //   MaterialPageRoute(
                    //       builder: (context) => ProfileSetup(
                    //           profile: Profile(
                    //               userId: user.uid,
                    //               isAssistantTeacher:
                    //                   profileProvider.isAssistantTeacher,
                    //               isEnglishSelected:
                    //                   profileProvider.isEnglishSelected,
                    //               isGujaratiSelected:
                    //                   profileProvider.isGujaratiSelected,
                    //               isMainTeacher: profileProvider.isMainTeacher,
                    //               standards:
                    //                   profileProvider.standards.join(','),
                    //               subjects:
                    //                   profileProvider.subjects.join(',')))),
                    //);
                    Navigator.of(context).pop();
                  },
                  child: const Text('Update Profile'),
                ),
              ],
            ),
          ));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(user.displayName! +
            ' ' +
            formatDate(
                timelogEntryProvider.onDatetime, [MM, ' ', dd, ',', yyyy])),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          child: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: DropdownButton<String>(
                          hint: Text('select subject...'),
                          dropdownColor: Colors.white,
                          icon: Icon(Icons.arrow_drop_down),
                          iconSize: 30,
                          isExpanded: true,
                          underline: SizedBox(),
                          style: TextStyle(color: Colors.black, fontSize: 16),
                          value: (timelogEntryProvider.subject == '')
                              ? profileProvider.subjects[0]
                              : timelogEntryProvider.subject,
                          onChanged: (String? newValue) {
                            setState(() {
                              timelogEntryProvider.changeSubject = newValue!;
                            });
                          },
                          items: profileProvider.subjects
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                        flex: 5,
                      ),
                      Expanded(
                        child: DropdownButton<String>(
                          hint: Text('select standard...'),
                          dropdownColor: Colors.white,
                          icon: Icon(Icons.arrow_drop_down),
                          iconSize: 30,
                          isExpanded: true,
                          underline: SizedBox(),
                          style: TextStyle(color: Colors.black, fontSize: 16),
                          value: (timelogEntryProvider.standard == '')
                              ? profileProvider.standards[0]
                              : timelogEntryProvider.standard,
                          onChanged: (String? newValue) {
                            setState(() {
                              timelogEntryProvider.changeStandard = newValue!;
                            });
                          },
                          items: profileProvider.standards
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                        flex: 5,
                      )
                    ],
                  ),
                  flex: 1,
                ),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: DropdownButton<String>(
                          hint: Text('select medium...'),
                          dropdownColor: Colors.white,
                          icon: Icon(Icons.arrow_drop_down),
                          iconSize: 30,
                          isExpanded: true,
                          underline: SizedBox(),
                          style: TextStyle(color: Colors.black, fontSize: 16),
                          value: (timelogEntryProvider.medium == '')
                              ? mediums[0]
                              : timelogEntryProvider.medium,
                          onChanged: (String? newValue) {
                            setState(() {
                              timelogEntryProvider.changeMedium = newValue!;
                            });
                          },
                          items: mediums
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                        flex: 4,
                      ),
                      Expanded(
                        child: DropdownButton<String>(
                          hint: Text('select workas...'),
                          dropdownColor: Colors.white,
                          icon: Icon(Icons.arrow_drop_down),
                          iconSize: 30,
                          isExpanded: true,
                          underline: SizedBox(),
                          style: TextStyle(color: Colors.black, fontSize: 16),
                          value: (timelogEntryProvider.workAs == '')
                              ? workAs[0]
                              : timelogEntryProvider.workAs,
                          onChanged: (String? newValue) {
                            setState(() {
                              timelogEntryProvider.changeWorkAs = newValue!;
                            });
                          },
                          items: workAs
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                        flex: 4,
                      ),
                      Expanded(
                          child: IconButton(
                              onPressed: () {
                                _pickDate(context,
                                        timelogEntryProvider.onDatetime)
                                    .then((value) async {
                                  if (value != null) {
                                    //load the timelogs for the selected date
                                    // CollectionReference users =
                                    //     FirebaseFirestore.instance
                                    //         .collection('profile');
                                    // FutureBuilder<DocumentSnapshot>(
                                    //   future: users.doc(user.uid).get(),
                                    //   builder: (BuildContext context,
                                    //       AsyncSnapshot<DocumentSnapshot>
                                    //           snapshot) {
                                    //     if (snapshot.hasError) {
                                    //       return Text("Something went wrong");
                                    //     }

                                    //     if (snapshot.hasData &&
                                    //         !snapshot.data!.exists) {
                                    //       return Text(
                                    //           "Document does not exist");
                                    //     }

                                    //     if (snapshot.connectionState ==
                                    //         ConnectionState.done) {
                                    //       Map<String, dynamic> data =
                                    //           snapshot.data!.data()
                                    //               as Map<String, dynamic>;
                                    //       return Text(
                                    //           "subjects: ${data['subjects']} ${data['standards']}");
                                    //     }

                                    //     return Text("loading");
                                    //   },
                                    // );
                                    // var timelogs = timelogEntryProvider
                                    //     .getTimelogs(user.uid, value).toList().then((value) {
                                    //       for (var i = 0; i < value..le; i++) {

                                    //     }
                                    //     });

                                    // getCalendarEventList(
                                    //     timelogEntryProvider, user.uid, value);

                                    // var loadedData = timelogEntryProvider
                                    //     .getTimelogs(user.uid, value);

                                    // var p =
                                    //     profileProvider.getProfile(user.uid);
                                    // StreamBuilder<Profile>(
                                    //     stream: profileProvider
                                    //         .getProfile(user.uid),
                                    //     builder: (context, snapshot) {
                                    //       if (snapshot.hasData) {
                                    //         return Text('data loaded');
                                    //       } else {
                                    //         return Text('data loading');
                                    //       }
                                    //     });

                                    // var timelogs = timelogEntryProvider
                                    //     .getTimelogs(user.uid, value)
                                    //     .then((timelog) {
                                    //   timelog.forEach((element) {
                                    //     String id = element.id;
                                    //     timelogEntryProvider
                                    //         .getMainTeacherTimelogs(
                                    //             user.uid, value, id)
                                    //         .then((event) {
                                    //       event.forEach((mt) {
                                    //         var mainTeacherlogs =
                                    //             element.mainTimelog;
                                    //         mainTeacherlogs!.add(mt);
                                    //       });
                                    //       //print(event);
                                    //     });
                                    //     timelogEntryProvider.loadAll(
                                    //         user.uid, element);
                                    //   });
                                    // });

                                    // var timelogs = timelogEntryProvider
                                    //     .getTimelogs(user.uid, value)
                                    //     .then((timelogs) {
                                    //   return timelogs.map((timelog) {
                                    //     String id = timelog.id;
                                    //     timelogEntryProvider
                                    //         .getMainTeacherTimelogs(
                                    //             user.uid, value, id)
                                    //         .then((mainTeacherTimelogs) {
                                    //       return mainTeacherTimelogs
                                    //           .map((mttl) {
                                    //         return timelog.mainTimelog!
                                    //             .add(mttl);
                                    //       });
                                    //     });
                                    //   });
                                    // });

                                    //First we need to remove the existing data of past selected date
                                    timelogEntryProvider.loadAll(user.uid, null,
                                        whenDateSelectionChange: true);

                                    timelogEntryProvider.changeDateTimeOn =
                                        value;

                                    await loadTimelogsForSelectedDate(
                                        timelogEntryProvider, user, value);

                                    var str = '';
                                    // return StreamBuilder<Profile>(
                                    //     stream: profileProvider
                                    //         .getProfile(user.uid),
                                    //     builder: (context, snapshot) {
                                    //       if (snapshot.hasData) {
                                    //         // var loadedData = snapshot.data!;
                                    //         // for (int i = 0;
                                    //         //     i < loadedData.length;
                                    //         //     i++) {
                                    //         //   timelogEntryProvider.loadAll(
                                    //         //       user.uid, loadedData.first);
                                    //         // }
                                    //         return const Text(
                                    //             'Data is loaded..');
                                    //       } else {
                                    //         return const Text(
                                    //             'Firestore snapshot is loading..');
                                    //       }
                                    //     });
                                  }
                                });
                              },
                              icon: Icon(Icons.calendar_today)),
                          flex: 2)
                    ],
                  ),
                  flex: 1,
                ),
                Expanded(
                  child: ElevatedButton(
                    style: style,
                    onPressed: () async {
                      if (timelogEntryProvider.workAs == 'Main') {
                        var newEntry =
                            timelogEntryProvider.addNewMainTeacherTimelog(
                                user.uid,
                                timelogEntryProvider.medium,
                                timelogEntryProvider.standard,
                                timelogEntryProvider.subject);
                        // _showMainTeacherTimelogDialog(
                        //     context, newEntry, timelogEntryProvider);
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                MainTeacherTimelogScreen(timelogMain: newEntry),
                          ),
                        );
                      } else {
                        var newEntry =
                            timelogEntryProvider.addNewAssistantTeacherTimelog(
                                user.uid,
                                timelogEntryProvider.medium,
                                timelogEntryProvider.standard,
                                timelogEntryProvider.subject);
                        // _showMainTeacherTimelogDialog(
                        //     context, newEntry, timelogEntryProvider);
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => AssistantTeacherTimelogScreen(
                                timelogAssistant: newEntry),
                          ),
                        );
                      }
                    },
                    child: const Text('Add Entry'),
                  ),
                  flex: 1,
                ),
                Text('Main Teacher Logs',
                    style: TextStyle(
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 16)),
                Expanded(
                    child:
                        // StreamBuilder<List<TimelogEntry>>(
                        //     stream: timelogEntryProvider.getTimelogs(
                        //         user.uid, timelogEntryProvider.onDatetime),
                        //     builder: (context, snapshot) {
                        //       if (snapshot.hasData) {
                        //         //timelogEntryProvider.loadAll(user.uid, timelogEntry)
                        //         return
                        Scrollbar(
                      child: ListView.builder(
                          itemCount: timelogEntryProvider.mainTimelog.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              trailing: Icon(Icons.edit,
                                  color: Theme.of(context).accentColor),
                              title: Text(timelogEntryProvider
                                      .mainTimelog[index].standard +
                                  ' ' +
                                  timelogEntryProvider
                                      .mainTimelog[index].medium +
                                  ' ' +
                                  timelogEntryProvider
                                      .mainTimelog[index].subject +
                                  ' ' +
                                  formatDate(
                                      DateTime(
                                          2021,
                                          6,
                                          1,
                                          timelogEntryProvider
                                              .mainTimelog[index].from.hour,
                                          timelogEntryProvider
                                              .mainTimelog[index].from.minute),
                                      [HH, ':', nn]) +
                                  '-' +
                                  formatDate(
                                      DateTime(
                                          2021,
                                          6,
                                          1,
                                          timelogEntryProvider
                                              .mainTimelog[index].to.hour,
                                          timelogEntryProvider
                                              .mainTimelog[index].to.minute),
                                      [HH, ':', nn]) +
                                  ' (' +
                                  timelogEntryProvider
                                      .mainTimelog[index].duration +
                                  ')'),
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        MainTeacherTimelogScreen(
                                            timelogMain: timelogEntryProvider
                                                .mainTimelog[index]),
                                  ),
                                );
                              },
                            );
                          }),
                    )
                    //         ;
                    //   } else {
                    //     return const Text(
                    //         'Firestore snapshot is loading..');
                    //   }
                    // }),
                    ,
                    flex: 4),
                Text('Assistant Teacher Logs',
                    style: TextStyle(
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 16)),
                Expanded(
                    child: ListView.builder(
                        itemCount: timelogEntryProvider.assistantTimelog.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            trailing: Icon(Icons.edit,
                                color: Theme.of(context).accentColor),
                            title: Text(timelogEntryProvider
                                    .assistantTimelog[index].standard +
                                ' ' +
                                timelogEntryProvider
                                    .assistantTimelog[index].medium +
                                ' ' +
                                timelogEntryProvider
                                    .assistantTimelog[index].subject +
                                ' ' +
                                formatDate(
                                    DateTime(
                                        2021,
                                        6,
                                        1,
                                        timelogEntryProvider
                                            .assistantTimelog[index].from.hour,
                                        timelogEntryProvider
                                            .assistantTimelog[index]
                                            .from
                                            .minute),
                                    [HH, ':', nn]) +
                                '-' +
                                formatDate(
                                    DateTime(
                                        2021,
                                        6,
                                        1,
                                        timelogEntryProvider
                                            .assistantTimelog[index].to.hour,
                                        timelogEntryProvider
                                            .assistantTimelog[index].to.minute),
                                    [HH, ':', nn]) +
                                ' (' +
                                timelogEntryProvider
                                    .assistantTimelog[index].duration +
                                ')'),
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      AssistantTeacherTimelogScreen(
                                          timelogAssistant: timelogEntryProvider
                                              .assistantTimelog[index]),
                                ),
                              );
                            },
                          );
                        })
                    //         ;
                    //   } else {
                    //     return const Text(
                    //         'Firestore snapshot is loading..');
                    //   }
                    // }),
                    ,
                    flex: 3),
                Expanded(
                  //Grtids of Assistant and Main teacher timelogs
                  child: ElevatedButton(
                    style: style,
                    onPressed: () async {
                      var test = '';
                      timelogEntryProvider.saveEntry();
                      Navigator.of(context).pop();
                    },
                    child: const Text('Submit'),
                  ),
                  flex: 1,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> loadTimelogsForSelectedDate(
      TimelogEntryProvider timelogEntryProvider,
      User user,
      DateTime value) async {
    var timelogs = await timelogEntryProvider
        .getTimelogs(user.uid, value)
        .then((timelogs) {
      timelogs.forEach((element) async {
        String id = element.id;
        await timelogEntryProvider
            .getMainTeacherTimelogs(user.uid, value, id)
            .then((mainTeacherTimelogs) {
          mainTeacherTimelogs.forEach((mttl) {
            element.mainTimelog!.add(mttl);
          });
          var c = '';
        });
        await timelogEntryProvider
            .getAssistantTeacherTimelogs(user.uid, value, id)
            .then((assistantTeacherTimelogs) {
          assistantTeacherTimelogs.forEach((attl) {
            element.assistantTimelog!.add(attl);
          });
          var c = '';
        });
        var b = '';
        timelogEntryProvider.loadAll(user.uid, element);
        timelogEntryProvider.changeDateTimeOn = value;
      });
      var a = '';
    });
  }

  Future<void> _showMainTeacherTimelogDialog(BuildContext context,
      TimelogMain entry, TimelogEntryProvider timelogEntryProvider) async {
    final entryController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: IconButton(
                          onPressed: () {
                            _pickTime(context, entry.from).then((value) {
                              if (value != null) {
                                entry.from = value;
                                entry.duration =
                                    _getDuration(entry.from, entry.to);
                              }
                            });
                          },
                          icon: Icon(Icons.calendar_today),
                        ),
                      ),
                      Expanded(
                        child: IconButton(
                          onPressed: () {
                            _pickTime(context, entry.to).then((value) {
                              if (value != null) {
                                entry.to = value;
                                String duration =
                                    _getDuration(entry.from, entry.to);
                                entry.duration = duration;

                                widget.duration = duration;
                              }
                            });
                          },
                          icon: Icon(Icons.calendar_today),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(child: Text(widget.duration)),
                      Expanded(child: Text('2'))
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(child: Text('1')),
                      Expanded(child: Text('2'))
                    ],
                  ),
                ),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Remark',
                      border: InputBorder.none,
                    ),
                    maxLines: 12,
                    minLines: 10,
                    onChanged: (String value) => entry.remark = value,
                    controller: entryController,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Save'))
          ],
        );
      },
    );
  }

  Future<void> _showAssistantTeacherTimelogDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: SafeArea(
            child: Column(
              children: [
                Expanded(
                    child: Row(
                  children: [Text('2')],
                ))
              ],
            ),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Save'))
          ],
        );
      },
    );
  }

  Future<void> getCalendarEventList(
      TimelogEntryProvider provider, String userId, DateTime dateToLoad) async {
    //var data = await provider.getTimelogs(userId, dateToLoad);
    var year = dateToLoad.year.toString();
    var month = dateToLoad.month.toString();
    FirebaseFirestore.instance
        .collection('timelogs')
        // .doc(userId)
        // .collection('years')
        // .doc(year.toString())
        // .collection('months')
        // .doc(month.toString())
        // .collection('user_timelogs')
        // //.where('dateTime', isEqualTo: formatDate(dateToLoad, [dd, '/', mm, '/', yyyy]))
        // .where('userId', isEqualTo: userId)
        .snapshots()
        .map((event) {
      return event.docs.map((e) {
        return TimelogEntry.fromJson(e.data());
      }).toList();
    });

    setState(() {});
    //var str = '';
  }

  Future<DateTime?> _pickDate(
      BuildContext context, DateTime initialDate) async {
    final picked = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: DateTime(2021),
        lastDate: DateTime(2025));
    if (picked != null) return picked;
  }

  Future _pickTime(BuildContext context, TimeOfDay initialTime) async {
    //final initialTime = TimeOfDay(hour: 7, minute: 0);
    final newTime =
        await showTimePicker(context: context, initialTime: initialTime);

    if (newTime == null) return;
    return newTime;
  }

  String _getDuration(TimeOfDay from, TimeOfDay to) {
    DateTime d2 = DateTime(2021, 6, 1, to.hour, to.minute);

    return formatDate(
        d2.subtract(Duration(hours: from.hour, minutes: from.minute)),
        [HH, ':', n]);
  }
}
