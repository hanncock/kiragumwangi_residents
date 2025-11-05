import 'package:ezenresidents/wrapp.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';


void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  // final prefs = await SharedPreferences.getInstance();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((value) => runApp(MyApp()));
  // runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kiragu & Mwangi Residents',
      theme: ThemeData(
        textTheme: Theme.of(context).textTheme.apply(
            fontSizeFactor: .9,
            fontSizeDelta: 0.1,
            fontFamily: GoogleFonts.poppins().fontFamily
        ),

        // textTheme: Theme.of(context).textTheme.apply(
        //   fontSizeFactor: .9,
        //   fontSizeDelta: 0.1,
        // ),

        // fontFamily: GoogleFonts.poppins().fontFamily,
        // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Wrapper(),
    );
  }
}


