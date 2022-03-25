import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tution_class/src/data/choice_chips.dart';
import 'package:tution_class/src/models/choice_chip_data.dart';
import 'package:tution_class/src/models/profile.dart';
import 'package:tution_class/src/models/timelog_entry.dart';
import 'package:tution_class/src/providers/google_sign_in.dart';
import 'package:tution_class/src/providers/profile_provider.dart';
import 'package:tution_class/src/screens/profile_setup.dart';
import 'package:tution_class/src/screens/timelog_entry.dart';

class LoggedInWidget extends StatefulWidget {
  @override
  _LoggedInWidgetState createState() => _LoggedInWidgetState();
}

class _LoggedInWidgetState extends State<LoggedInWidget> {
  final double spacing = 8;
  //List<ChoiceChipData> choiceChips = ChoiceChips.all;
  final ButtonStyle style =
      ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20));

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final provider = Provider.of<GoogleSignInProvider>(context);
    final profileProvider = Provider.of<ProfileProvider>(context);
    if (user != null) {
      profileProvider.setUserId = user.uid;
    }
    return Container(
      alignment: Alignment.center,
      color: Colors.blueGrey.shade900,
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Logged In',
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 8),
            CircleAvatar(
              maxRadius: 25,
              backgroundImage: NetworkImage(user!.photoURL ?? ''),
            ),
            SizedBox(height: 8),
            Text(
              'Name: ' + getDisplayName(user),
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 8),
            Text(
              'Email: ' + getEmail(user),
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                final provider =
                    Provider.of<GoogleSignInProvider>(context, listen: false);
                provider.logout();
              },
              child: Text('Logout'),
            ),
            SizedBox(height: 8),
            StreamBuilder<Profile>(
                stream: profileProvider.getProfile(user.uid),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      children: [
                        ElevatedButton(
                          style: style,
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    ProfileSetup(profile: snapshot.data),
                              ),
                            );
                          },
                          child: const Text('Update Profile'),
                        ),
                        ElevatedButton(
                          style: style,
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    TimelogEntryScreen(profile: snapshot.data),
                              ),
                            );
                          },
                          child: const Text('Enter Timelog'),
                        ),
                      ],
                    );
                  } else {
                    return ElevatedButton(
                      style: style,
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ProfileSetup(profile: null),
                          ),
                        );
                      },
                      child: const Text('Setup Profile'),
                    );
                  }
                })
          ]),
    );
  }

  String getEmail(User user) => user.email ?? '';

  String getDisplayName(User user) => user.displayName ?? '';
}
