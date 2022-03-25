import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tution_class/src/models/entry.dart';
import 'package:tution_class/src/providers/entry_provider.dart';
import 'package:tution_class/src/screens/entry.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final entryProvider = Provider.of<EntryProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('My Jounaral'),
      ),
      body:
          // StreamBuilder(
          //   stream: entries.snapshots(),
          //   builder: (BuildContext context,
          //       AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          //     if (snapshot.hasData) {
          //       return ListView.builder(
          //         itemCount: snapshot.data?.docs.length,
          //         itemBuilder: (BuildContext context, int index) {
          //           return ListTile(
          //             trailing:
          //                 Icon(Icons.edit, color: Theme.of(context).accentColor),
          //             title: Text(
          //               formatDate(
          //                   DateTime.parse(
          //                       snapshot.data?.docs.elementAt(index)['date']),
          //                   [MM, ' ', d, ', ', yyyy]),
          //             ),
          //             onTap: () {
          //               Navigator.of(context).push(
          //                 MaterialPageRoute(
          //                   builder: (context) => EntryScreen(new Entry(
          //                       date: snapshot.data?.docs.elementAt(index)['date'],
          //                       entry:
          //                           snapshot.data?.docs.elementAt(index)['entry'],
          //                       entryId: snapshot.data?.docs
          //                           .elementAt(index)['entryId'])),
          //                 ),
          //               );
          //             },
          //           );
          //         },
          //       );
          //     } else {
          //       return const Text('Firestore snapshot is loading..');
          //     }
          //   },
          // ),
          StreamBuilder<List<Entry>>(
              stream: entryProvider.entries,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          trailing: Icon(Icons.edit,
                              color: Theme.of(context).accentColor),
                          title: Text(
                            formatDate(
                                DateTime.parse(snapshot.data![index].date),
                                [MM, ' ', d, ', ', yyyy]),
                          ),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    EntryScreen(entry: snapshot.data![index]),
                              ),
                            );
                          },
                        );
                      });
                } else {
                  return const Text('Firestore snapshot is loading..');
                }
              }),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => EntryScreen(
                    entry: null,
                  )));
        },
      ),
    );
  }
}
