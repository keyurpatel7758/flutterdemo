import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tution_class/src/providers/entry_provider.dart';
import 'package:tution_class/src/screens/home.dart';
import 'package:tution_class/src/screens/login.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => EntryProvider(),
      child: MaterialApp(
        home: HomeScreen(),
        //home: LoginScreen(),
        theme: ThemeData(
          accentColor: Colors.pinkAccent,
          primaryColor: Colors.black,
          textTheme: GoogleFonts.patrickHandScTextTheme(),
        ),
      ),
    );
  }
}
