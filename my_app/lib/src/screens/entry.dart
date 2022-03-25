import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tution_class/src/models/entry.dart';
import 'package:tution_class/src/providers/entry_provider.dart';

class EntryScreen extends StatefulWidget {
  Entry? entry;

  EntryScreen({this.entry});

  @override
  _EntryScreenState createState() => _EntryScreenState();
}

class _EntryScreenState extends State<EntryScreen> {
  final entryController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    final entryProvider = Provider.of<EntryProvider>(context, listen: false);
    if (widget.entry != null) {
      //edit
      entryController.text = widget.entry?.entry ?? '';
      entryProvider.loadAll(widget.entry);
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
    final entryProvider = Provider.of<EntryProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(formatDate(entryProvider.date, [MM, ' ', d, ',', yyyy])),
        actions: [
          IconButton(
              onPressed: () {
                _pickDate(context, entryProvider).then((value) => {
                      if (value != null) {entryProvider.changeDate = value}
                    });
              },
              icon: Icon(Icons.calendar_today))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Daily Entry',
                border: InputBorder.none,
              ),
              maxLines: 12,
              minLines: 10,
              onChanged: (String value) => entryProvider.changeEntry = value,
              controller: entryController,
            ),
            RaisedButton(
              color: Theme.of(context).accentColor,
              child: Text(
                'Save',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                entryProvider.saveEntry();
                Navigator.of(context).pop();
              },
            ),
            if (widget.entry != null)
              RaisedButton(
                color: Colors.redAccent,
                child: Text(
                  'Delete',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  if (widget.entry != null) {
                    entryProvider.removeEntry(widget.entry?.entryId ?? '');
                  }
                  Navigator.of(context).pop();
                },
              )
            else
              Container()
          ],
        ),
      ),
    );
  }

  Future<DateTime?> _pickDate(
      BuildContext context, EntryProvider initialDate) async {
    final picked = await showDatePicker(
        context: context,
        initialDate: initialDate.date,
        firstDate: DateTime(2021),
        lastDate: DateTime(2025));
    if (picked != null) return picked;
  }
}
