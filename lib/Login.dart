import 'dart:convert';

import 'package:ezenresidents/Services/Services.dart';
import 'package:ezenresidents/wrapp.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'Services/spin_loader.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  String url = 'https://cloud.kiraguandmwangi.co.ke';
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = new GlobalKey<ScaffoldState>();

  Auth auth =Auth();

  bool loading = false;
  bool togglePassword = true;
  bool showServer = false;
  var email ;
  String password = '';
  String error = '';

  TextEditingController _urlCtrl =
  new TextEditingController(text: 'https://cloud.kiraguandmwangi.co.ke');

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      body:  SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    Color(0xFF046307),
                    Color(0xFF046307)
                  ],
                ),
              ),
              height: height * 0.4,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Kiragu&Mwangi Residents\n',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20
                      ),
                    ),
                    Column(
                      children: [
                        Image.asset('assets/logo-white.png')
                      ],
                    ),
                    // Text('Login',
                    //   style: TextStyle(
                    //       color: Colors.white,
                    //       fontWeight: FontWeight.bold,
                    //       fontSize: width * 0.05
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
            Container(
              color: Color(0xFF046307),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                    color: Colors.white
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(

                    children: [
                      Padding(padding: EdgeInsets.only(left: 30,right: 30,top: 10)),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      // children: [
                      // Text(
                      //     'Sign In',
                      // textAlign: TextAlign.center,
                      //   style: TextStyle(
                      //     fontSize: 28,
                      //     color: Colors.redAccent,
                      //     fontWeight: FontWeight.bold,
                      //   ),
                      // )
                      // ],
                      // ),
                      //  SizedBox(height: height * 0.01),
                      SizedBox(height: height * 0.05),

                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              TextFormField(
                                validator: (val) => val!.isEmpty ? "Enter  Username" : null,
                                onChanged: (val){setState(() => email = val);},
                                decoration: InputDecoration(
                                  hintText: 'Username',
                                  suffixIcon: Icon(Icons.account_box),
                                  labelText: "Username",
                                  hintStyle: TextStyle(fontSize: 14),
                                  floatingLabelBehavior: FloatingLabelBehavior.always,
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.redAccent),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                              ),
                              SizedBox(height: height * 0.04),
                              TextFormField(
                                validator: (val) => val!.isEmpty ? "Enter  Password" : null,
                                obscureText: togglePassword,
                                onChanged: (val) {setState(() => password = val);},
                                decoration: InputDecoration(
                                  hintText: 'Enter Your Password',
                                  labelText: "Password",
                                  hintStyle: TextStyle(fontSize: 14),
                                  floatingLabelBehavior: FloatingLabelBehavior.always,
                                  suffixIcon: GestureDetector(
                                    child: Icon(togglePassword
                                        ? Icons.visibility
                                        : Icons.visibility_off),
                                    onTap: () {
                                      setState(() {
                                        togglePassword = !togglePassword;
                                      });
                                    },
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    InkWell(
                                        onTap: (){
                                          // Navigator.push(context, customePageTransion(Register(title: 'Reset Password',)));
                                        },
                                        child: Text('Forgot Password ?',style: TextStyle(color: Colors.redAccent),))
                                  ],
                                ),
                              ),
                              SizedBox(height: height * 0.04),
                             /* CheckboxListTile(
                                title: Text("Change Server Url",style: TextStyle(fontSize: 14),),
                                value: showServer,
                                onChanged: (newValue) {
                                  setState(() {
                                    showServer = !showServer;
                                  });
                                },
                                controlAffinity: ListTileControlAffinity
                                    .leading, //  <-- leading Checkbox
                              ),
                              showServer
                                  ? TextFormField(
                                controller: _urlCtrl,
                                // validator: (val) => val!.isEmpty ? "Enter  Url" : null,
                                validator: (val) {
                                  String patttern =  r"((https?:www\.)|(https?:\/\/)|(www\.))[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9]{1,6}(\/[-a-zA-Z0-9()@:%_\+.~#?&\/=]*)?";
                                  RegExp regExp = new RegExp(patttern);
                                  if (!regExp.hasMatch(val!)) {
                                    return 'Please enter valid URL';
                                  }
                                },
                                onChanged: (val){setState(() => url = val);},
                                decoration: InputDecoration(
                                  hintText: 'url',
                                  suffixIcon: Icon(Icons.web),
                                  border: OutlineInputBorder(
                                    // borderSide: BorderSide(color: kPrimaryColor),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                              )
                                  : Container(),*/
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // Text(
                                  //   'Forget password?',
                                  //   style: TextStyle(fontSize: 12.0),
                                  // ),
                                  Expanded(
                                    child: ButtonTheme(
                                      minWidth: MediaQuery.of(context).size.width * 0.8,
                                      child: ElevatedButton(
                                        child: Text(
                                          'Login',
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Color(0xFF046307),
                                          padding:  EdgeInsets.all(16.0),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10.0),
                                          ),
                                        ),
                                        onPressed: () async {
                                          if (_formKey.currentState!.validate()) {
                                            showDialog(
                                                context: context,
                                                builder: (_) => LoadingSpinCircle());

                                            setState(() { loading = true;});
                                            print(url);
                                            try{
                                              dynamic result = await auth.login(email,password,url);
                                              if(result['success'] == 'false'){
                                                setState(() {
                                                  loading = false;
                                                  Navigator.of(context).pop();
                                                  Fluttertoast.showToast(
                                                      msg:  result['message'],
                                                      toastLength: Toast.LENGTH_SHORT,
                                                      gravity: ToastGravity.CENTER,
                                                      timeInSecForIosWeb: 1,
                                                      //backgroundColor: Colors.white,
                                                      textColor: Colors.white,
                                                      fontSize: 16.0
                                                  );
                                                });
                                              }else{

                                                setState(() async {
                                                  SharedPreferences preferences = await SharedPreferences.getInstance();
                                                  var alldata = [url,result];
                                                  preferences.setString('email', jsonEncode(alldata));
                                                  print(preferences);
                                                  Fluttertoast.showToast(
                                                      msg:  'Login Success',
                                                      toastLength: Toast.LENGTH_SHORT,
                                                      gravity: ToastGravity.CENTER,
                                                      timeInSecForIosWeb: 1,
                                                      backgroundColor: Colors.white,
                                                      textColor: Colors.green,
                                                      fontSize: 16.0
                                                  );
                                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Wrapper()));


                                                });
                                              }
                                            }catch(e){
                                              setState(() {
                                                Fluttertoast.showToast(
                                                    msg: e.toString(),
                                                    toastLength: Toast.LENGTH_SHORT,
                                                    gravity: ToastGravity.CENTER,
                                                    timeInSecForIosWeb: 1,
                                                    backgroundColor: Colors.white,
                                                    textColor: Colors.red,
                                                    fontSize: 16.0
                                                );
                                                print(error);
                                              });
                                              print(e.toString());

                                            }
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 50,),
                              Text(''),
                              Column(
                                children: [
                                  Text('Powered By  '),
                                  Container(
                                      width: 200,
                                      height: 50,
                                      child: Image.asset('assets/logo_ezn.png'))
                                ],
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
