import 'package:flutter/material.dart';

class RepairDescription extends StatefulWidget {
  const RepairDescription({super.key});

  @override
  State<RepairDescription> createState() => _RepairDescriptionState();
}

class _RepairDescriptionState extends State<RepairDescription> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Row(
            children: [
              Text('Problem in View'),
              Row(
                children: [
                  Container(
                    child:Text('')
                  ),
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
