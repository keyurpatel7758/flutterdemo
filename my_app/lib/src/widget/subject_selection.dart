import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tution_class/src/models/Subject.dart';
import 'package:tution_class/src/providers/profile_provider.dart';

class SubjectSelection extends StatefulWidget {
  final String selectedSubject;

  SubjectSelection({required this.selectedSubject});

  @override
  _SubjectSelectionState createState() => _SubjectSelectionState();
}

class _SubjectSelectionState extends State<SubjectSelection> {
  List<Subject> subjects = [
    Subject(subValue: 'Science', subText: 'Science', isSelected: false),
    Subject(subValue: 'Maths', subText: 'Maths', isSelected: false),
    Subject(subValue: 'S.S', subText: 'S.S', isSelected: false),
    Subject(subValue: 'English', subText: 'English', isSelected: false),
    Subject(subValue: 'Hindi', subText: 'Hindi', isSelected: false),
  ];

  @override
  void initState() {
    final profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);
    var selectedSub = profileProvider.subjects;

    subjects.forEach((element) {
      if (selectedSub.indexOf(element.subValue) > -1) {
        element.isSelected = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context);

    return Container(
      child: Column(
        children: [
          ...subjects
              .map((b) => buildSingleCheckbox(b, profileProvider))
              .toList(),
        ],
      ),
    );
  }

  Widget buildSingleCheckbox(
          Subject subject, ProfileProvider profileProvider) =>
      buildCheckbox(
        subject: subject,
        onClicked: () {
          setState(() {
            final newValue = !subject.isSelected;
            subject.isSelected = newValue;
            if (newValue) {
              profileProvider.addSubject = subject.subValue;
            } else {
              profileProvider.removeSubject = subject.subValue;
            }
          });
        },
      );

  Widget buildCheckbox({
    required Subject subject,
    required VoidCallback onClicked,
  }) =>
      ListTile(
        onTap: onClicked,
        leading: Checkbox(
          value: subject.isSelected,
          onChanged: (value) => onClicked(),
        ),
        title: Text(
          subject.subText,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      );
}
