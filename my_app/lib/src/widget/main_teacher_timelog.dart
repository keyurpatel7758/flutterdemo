import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tution_class/src/models/timelog_main.dart';
import 'package:tution_class/src/providers/main_teacher_timelog_provider.dart';
import 'package:tution_class/src/providers/timelog_entry_provider.dart';

class MainTeacherTimelogScreen extends StatefulWidget {
  TimelogMain? timelogMain;

  MainTeacherTimelogScreen({this.timelogMain});

  @override
  _MainTeacherTimelogScreenState createState() =>
      _MainTeacherTimelogScreenState();
}

class _MainTeacherTimelogScreenState extends State<MainTeacherTimelogScreen> {
  final entryController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    final entryProvider =
        Provider.of<MainTeacherTimelogProvider>(context, listen: false);
    if (widget.timelogMain != null) {
      //edit
      entryController.text = widget.timelogMain!.remark;
      entryProvider.loadAll(widget.timelogMain);
    } else {
      entryProvider.loadAll(null);
    }
    super.initState();
  }

  @override
  void dispose() {
    entryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final entryProvider = Provider.of<MainTeacherTimelogProvider>(context);
    final timelogEntryProvider = Provider.of<TimelogEntryProvider>(context);
    final ButtonStyle style =
        ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20));

    return Scaffold(
      appBar: AppBar(
        title: Text(
          formatDate(
                  timelogEntryProvider.onDatetime, [MM, ' ', dd, ',', yyyy]) +
              ' ' +
              timelogEntryProvider.standard +
              ' std ' +
              timelogEntryProvider.medium +
              ' medium ',
          style: TextStyle(fontSize: 16),
        ),
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
                      Text(
                        'From',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        formatTimeOfDay(entryProvider.from!),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Expanded(
                        child: IconButton(
                          onPressed: () {
                            _pickTime(context, entryProvider.from!)
                                .then((value) {
                              if (value != null) {
                                entryProvider.changeFrom = value;
                                entryProvider.changeDuration = _getDuration(
                                    entryProvider.from!, entryProvider.to!);
                              }
                            });
                          },
                          icon: Icon(Icons.calendar_today),
                        ),
                      ),
                      Text(
                        'To',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        formatTimeOfDay(entryProvider.to!),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Expanded(
                        child: IconButton(
                          onPressed: () {
                            _pickTime(context, entryProvider.to!).then((value) {
                              if (value != null) {
                                entryProvider.changeTo = value;
                                String duration = _getDuration(
                                    entryProvider.from!, entryProvider.to!);
                                entryProvider.changeDuration = duration;
                              }
                            });
                          },
                          icon: Icon(Icons.calendar_today),
                        ),
                      ),
                    ],
                  ),
                  flex: 1,
                ),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(child: Text(entryProvider.duration!)),
                      Expanded(
                          child: Text(
                              'Subject (' + timelogEntryProvider.subject + ')'))
                    ],
                  ),
                  flex: 1,
                ),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(child: Text(entryProvider.chapterNo!)),
                      Expanded(child: Text(entryProvider.chapterName!))
                    ],
                  ),
                  flex: 1,
                ),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Remark',
                      border: InputBorder.none,
                    ),
                    maxLines: 12,
                    minLines: 10,
                    onChanged: (String value) =>
                        entryProvider.changeRemark = value,
                    controller: entryController,
                  ),
                  flex: 6,
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        style: style,
                        onPressed: () async {
                          var test = '';
                          timelogEntryProvider.updateMainTeacherTimelog(
                            TimelogMain(
                                userId: timelogEntryProvider.userId,
                                chapterName: entryProvider.chapterName!,
                                chapterNo: entryProvider.chapterNo!,
                                duration: entryProvider.duration!,
                                from: entryProvider.from!,
                                remark: entryProvider.remark!,
                                to: entryProvider.to!,
                                id: entryProvider.id!,
                                medium: timelogEntryProvider.medium,
                                standard: timelogEntryProvider.standard,
                                subject: timelogEntryProvider.subject,
                                workAs: timelogEntryProvider.workAs),
                          );
                          Navigator.of(context).pop();
                        },
                        child: const Text('Save'),
                      ),
                      entryProvider.id != ''
                          ? SizedBox(
                              width: 20,
                            )
                          : new Container(),
                      entryProvider.id != ''
                          ? ElevatedButton(
                              style: style,
                              onPressed: () async {
                                var test = '';
                                timelogEntryProvider.deleteMainTeacherTimelog(
                                    timelogEntryProvider.userId,
                                    timelogEntryProvider.onDatetime,
                                    timelogEntryProvider.id,
                                    entryProvider.id!);

                                Navigator.of(context).pop();
                              },
                              child: const Text('Delete'),
                            )
                          : new Container(),
                    ],
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
        [HH, ':', nn]);
  }

  formatTimeOfDay(TimeOfDay timeOfDay) {
    return formatDate(
        DateTime(2021, 6, 1, timeOfDay.hour, timeOfDay.minute), [HH, ':', nn]);
  }
}
