import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tution_class/src/providers/google_sign_in.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        body: ChangeNotifierProvider(
          create: (context) => GoogleSignInProvider(),
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Login',
            theme: ThemeData(
              accentColor: Colors.pinkAccent,
              primaryColor: Colors.black,
              textTheme: GoogleFonts.patrickHandScTextTheme(),
            ),
            home: Container(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                    onPrimary: Colors.black,
                    minimumSize: Size(double.infinity, 50)),
                onPressed: () {
                  final provider =
                      Provider.of<GoogleSignInProvider>(context, listen: false);
                  provider.login();
                },
                label: Text('Signup with Google'),
                icon: FaIcon(
                  FontAwesomeIcons.google,
                  color: Colors.red,
                ),
              ),
            ),
          ),
        ),
      );
}
