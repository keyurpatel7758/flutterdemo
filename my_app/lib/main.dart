import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tution_class/src/app.dart';
import 'package:tution_class/src/providers/assistant_teacher_timelog_provider.dart';
import 'package:tution_class/src/providers/google_sign_in.dart';
import 'package:tution_class/src/providers/main_teacher_timelog_provider.dart';
import 'package:tution_class/src/providers/profile_provider.dart';
import 'package:tution_class/src/providers/timelog_entry_provider.dart';
import 'package:tution_class/src/screens/home.dart';
import 'package:tution_class/src/screens/home_page.dart';
import 'package:tution_class/src/screens/login.dart';

import 'src/providers/entry_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Provider.debugCheckInvalidValueType = null;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static final String title = 'Google SignIn';

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => GoogleSignInProvider()),
          ChangeNotifierProvider(create: (context) => EntryProvider()),
          ChangeNotifierProvider(create: (context) => ProfileProvider()),
          ChangeNotifierProvider(create: (context) => TimelogEntryProvider()),
          ChangeNotifierProvider(
              create: (context) => MainTeacherTimelogProvider()),
          ChangeNotifierProvider(
              create: (context) => AssistantTeacherTimelogProvider())
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: title,
          theme: ThemeData(
            accentColor: Colors.blueAccent,
            primaryColor: Colors.black,
            textTheme: GoogleFonts.patrickHandScTextTheme(),
          ),
          home: HomePage(),
          //home: HomeScreen(),
        ));
  }
}
