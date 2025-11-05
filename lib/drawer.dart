import 'package:ezenresidents/wrapp.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      decoration: const BoxDecoration(
        color: Colors.white
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ListTile(
            title: const Text(
              'Log Out',
              style: TextStyle(
                fontFamily: "Muli",
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Colors.blue,
              ),
              textAlign: TextAlign.left,
            ),
            trailing: const Icon(
              Icons.power_settings_new,
              color: Colors.red,
            ),
            onTap: ()  {
              showDialog(context: context, builder: (_) =>
                  AlertDialog(
                    title: const Text(
                      'Do you want to Logout this application?',),
                    content: const Text('We are glad to serve you',),
                    actions: <Widget>[
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: Colors.grey.shade200,
                          padding:  const EdgeInsets.all(10.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        onPressed: () {
                          print("you choose no");
                          Navigator.of(context).pop(false);
                        },
                        child: const Text('No', style: TextStyle(
                            color: Colors.blue,
                            fontFamily: "Muli"),),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: Colors.grey.shade200,
                          padding:  const EdgeInsets.all(10.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        onPressed: () {
                          setState(() async {
                            final SharedPreferences sharePreferences =
                            await SharedPreferences.getInstance();
                            await sharePreferences.clear();
                            final SharedPreferences
                            sharePreferences1 =
                            await SharedPreferences.getInstance();
                            await sharePreferences1.remove('email');
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Wrapper()),
                                  (Route<dynamic> route) => false,
                            );
                          });
                          // SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                        },
                        child: const Text('Yes', style: TextStyle(
                            color: Colors.red,
                            fontFamily: "Muli"),),
                      ),
                    ],
                    elevation: 24,
                    backgroundColor: Colors.grey[400],
                  )
              );
            },
          ),
          // ElevatedButton(
          //   style: ElevatedButton.styleFrom(
          //     elevation: 0,
          //     backgroundColor: Colors.grey.shade200,
          //     padding:  EdgeInsets.all(10.0),
          //     shape: RoundedRectangleBorder(
          //       borderRadius: BorderRadius.circular(10.0),
          //     ),
          //   ),
          //   onPressed: () {
          //     setState(() async {
          //       SharedPreferences prf = await SharedPreferences.getInstance();
          //       prf.clear();
          //       final SharedPreferences sharePreferences1 = await SharedPreferences.getInstance();
          //       await sharePreferences1.remove('email');
          //       Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
          //             builder: (context) => Wrapper()),
          //             (Route<dynamic> route) => false,
          //       );
          //     });
          //     // SystemChannels.platform.invokeMethod('SystemNavigator.pop');
          //   },
          //   child: Text('Yes', style: TextStyle(
          //       color: Colors.red,
          //       fontFamily: "Muli"),),
          // )
        ],
      ),
    );
  }
}
