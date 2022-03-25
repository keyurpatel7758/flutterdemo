import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tution_class/src/models/profile.dart';
import 'package:tution_class/src/providers/google_sign_in.dart';
import 'package:tution_class/src/providers/profile_provider.dart';
import 'package:tution_class/src/widget/logged_in_widget.dart';
import 'package:tution_class/src/widget/standard_selection.dart';
import 'package:tution_class/src/widget/subject_selection.dart';

class ProfileSetup extends StatefulWidget {
  Profile? profile;

  ProfileSetup({this.profile});

  @override
  _ProfileSetupState createState() => _ProfileSetupState();
}

class _ProfileSetupState extends State<ProfileSetup> {
  final double spacing = 8;
  final ButtonStyle style =
      ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20));

  @override
  void initState() {
    // TODO: implement initState
    final user = FirebaseAuth.instance.currentUser;

    final profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);

    if (user != null) {
      if (widget.profile != null) {
        profileProvider.loadAll(user.uid, widget.profile);
      } else {
        profileProvider.loadAll(user.uid, null);
      }
    }

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context);
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return Text('Invalid login');
    //final selectedStandards = profileProvider.standards.join(',')
    return Scaffold(
      appBar: AppBar(
        title: Text(user.displayName!),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(children: [
          // StreamBuilder<Profile>(
          //   stream: profileProvider.getProfile(user.uid),
          //   builder: (context, snapshot) {
          //     if (!snapshot.hasData) {
          //       return Center(
          //         child: Text('Loading current profile...'),
          //       );
          //     } else {
          // return
          Wrap(runSpacing: spacing, spacing: spacing, children: [
            ChoiceChip(
              label: Text('Gujarati'),
              labelStyle:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              selected: profileProvider.isGujaratiSelected,
              onSelected: (bool selected) {
                setState(() {
                  profileProvider.changeIsGujarati = selected;
                });
              },
              selectedColor: Colors.green,
              backgroundColor: Colors.blue,
            ),
            ChoiceChip(
              label: Text('English'),
              labelStyle:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              selected: profileProvider.isEnglishSelected,
              onSelected: (bool selected) {
                setState(() {
                  profileProvider.changeIsEnglish = selected;
                });
              },
              selectedColor: Colors.green,
              backgroundColor: Colors.blue,
            ),
            ChoiceChip(
              label: Text('Main Teacher'),
              labelStyle:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              selected: profileProvider.isMainTeacher,
              onSelected: (bool selected) {
                setState(() {
                  profileProvider.changeIsMainTeacher = selected;
                });
              },
              selectedColor: Colors.green,
              backgroundColor: Colors.blue,
            ),
            ChoiceChip(
              label: Text('Assistant Teacher'),
              labelStyle:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              selected: profileProvider.isAssistantTeacher,
              onSelected: (bool selected) {
                setState(() {
                  profileProvider.changeIsAssistantTeacher = selected;
                });
              },
              selectedColor: Colors.green,
              backgroundColor: Colors.blue,
            )
          ]),

          StandardSelection(selectedStandards: ''),
          SubjectSelection(selectedSubject: ''),

          ElevatedButton(
            style: style,
            onPressed: () {
              profileProvider.saveProfile();
              Navigator.of(context).pop();
            },
            child: const Text('Save'),
          )
        ]),
      ),
    );
  }
  //   },
  // ),

}
