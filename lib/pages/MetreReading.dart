import 'package:ezenresidents/wrapp.dart';
import 'package:flutter/material.dart';

import '../Services/Services.dart';

class MetreReading extends StatefulWidget {
  const MetreReading({super.key});

  @override
  State<MetreReading> createState() => _MetreReadingState();
}

class _MetreReadingState extends State<MetreReading> {

  // /api/metereading/list?puId
  final Auth auth = Auth();

  List readings = [];
  getData()async{
    var resu = await auth.getData('/api/metereading/list?companyId=${Userdata[1]['companyId']}&puId=${Userdata[1]['unitId']}');
    setState(() {
      readings = resu;
    });
  }

  @override
  void initState(){
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text('$readings'),
          const Text('getting data'),
          Text('$readings')
        ],
      ),
    );
  }
}
