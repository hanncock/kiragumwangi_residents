import 'package:flutter/material.dart';

class Switchprofile extends StatefulWidget {
  const Switchprofile({super.key});

  @override
  State<Switchprofile> createState() => _SwitchprofileState();
}

class _SwitchprofileState extends State<Switchprofile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          DefaultTabController(
          length: 2,
          child: Column(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                // height: 80,
                child: TabBar(


                  // indicator: Colors.red,
                  tabs: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Profiles'),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Add Profiles'),
                    ),
                  ],
                ),
              ),
              Container(
                child: TabBarView(
                  children: [
                    Text('Profile 1'),
                    Text('Add new Profiles')
                  ],
                ),
              )
        ],
      )

    )]));
  }
}
