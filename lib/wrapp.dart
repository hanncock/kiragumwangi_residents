/*
import 'dart:convert';
import 'package:ezenresidents/Home.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Login.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({super.key});

  @override
  State<Wrapper> createState() => _WrapperState();
}

var Userdata;

class _WrapperState extends State<Wrapper> {

  Future<void> checkCreds() async {
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final obtainedEmail = sharedPreferences.getString('email');

    var data;
    if (obtainedEmail == null) {
      data = null;
    } else {
      try {
        data = jsonDecode(obtainedEmail);
      } catch (e) {
        data = null;
      }
    }

    if (!mounted) return; // prevent context use after dispose

    if (data == null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const Login()),
      );
    } else {
      Userdata = data;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const Home()),
            (route) => false,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    checkCreds();

    // Delay until after the first frame so plugins are initialized
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    // });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
*/
// import 'dart:convert';
//
// import 'package:ezenpeople/models/spin_loader.dart';
// import 'package:ezenpeople/pages/home/home.dart';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import 'home/homepage.dart';
// import 'login.dart';
//
//
// var userData;
// int leavetbal = 0;
// int totalpay = 0;
// int totaltask = 0;
// int hourswrkd = 0;
//
//
//
// class Wrapper extends StatefulWidget {
//   const Wrapper({Key? key}) : super(key: key);
//
//   @override
//   State<Wrapper> createState() => _WrapperState();
// }
//
// class _WrapperState extends State<Wrapper> {
//
//   Future getValidationData() async{
//     final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
//     var obtainedEmail = sharedPreferences.getString('email');
//     var datasaved = jsonDecode(obtainedEmail!);
//     if(datasaved == null){
//       setState((){
//         userData = null;
//       });
//
//     }else{
//       setState((){
//         // userData = jsonDecode(obtainedEmail);
//         userData = datasaved;
//       });
//       var results = await auth.dashboard();
//       print(results);
//       setState(() {
//         leavetbal =  results['leaveBalance'].toInt();
//         totalpay = results['totalPay'].toInt();
//         totaltask = results['totalTask'].toInt();
//         hourswrkd = results['hoursWorked'].toInt();
//       });
//     }
//   }
//
//   @override
//   void initState(){
//
//     getValidationData().whenComplete(() async{
//       if(userData == null){
//         Navigator.of(context).pushAndRemoveUntil(
//           MaterialPageRoute(builder: (context) => Login()),
//               (route) => false, // Removes all previous routes
//         );
//         // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login()));
//
//       }else{
//         // print(userData);
//         // getDash();
//         // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home()));
//         // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeDash()));
//
//         Navigator.of(context).pushAndRemoveUntil(
//           MaterialPageRoute(builder: (context) => HomeDash()),
//               (route) => false, // Removes all previous routes
//         );
//       }
//     });
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: LoadingSpinCircle(),
//       ),
//     );
//   }
// }
import 'dart:convert';
import 'package:ezenresidents/Home.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Login.dart';
import 'Services/spin_loader.dart';



var Userdata;


class Wrapper extends StatefulWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {

  Future getValidationData() async{
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var obtainedEmail = sharedPreferences.getString('email');
    var datasaved = jsonDecode(obtainedEmail!);
    if(datasaved == null){
      setState((){
        Userdata = null;
      });

    }else{
      setState((){
        // userData = jsonDecode(obtainedEmail);
        Userdata = datasaved;
      });
      // var results = await auth.dashboard();

    }
  }

  @override
  void initState(){

    getValidationData().whenComplete(() async{
      if(Userdata == null){
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => Login()),
              (route) => false, // Removes all previous routes
        );

        // Navigator.push(context,customePageTransion(Profile()));

        // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login()));

      }else{

        Navigator.of(context).pushAndRemoveUntil(
          // MaterialPageRoute(builder: (context) => Homepage()),
          MaterialPageRoute(builder: (context) => Home()),
              (route) => false, // Removes all previous routes
        );
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: LoadingSpinCircle(),
      ),
    );
  }
}