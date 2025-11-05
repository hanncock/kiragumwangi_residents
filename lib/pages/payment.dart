import 'package:ezenresidents/pages/resusables.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../Home.dart';
import '../Services/Services.dart';
import '../Services/spin_loader.dart';
import '../wrapp.dart';

class LipaNaMpesa extends StatefulWidget {
  final List data;
  const LipaNaMpesa({super.key,required this.data});

  @override
  State<LipaNaMpesa> createState() => _LipaNaMpesaState();
}

class _LipaNaMpesaState extends State<LipaNaMpesa> {

  final Auth auth = Auth();
  var amntToPay;
  var phoneNo;
  var paybill;
  List paybills = [];
  List filtered = [];
  var bizShortCode;

  getPabills()async{
    // print(Userdata[1]['companyId']);
    var paybillslist = await auth.getData('/api/lipanampesa/list?companyId=' + Userdata[1]['companyId'].toString());
    print(paybillslist);
    setState(() {
      paybills = paybillslist['list'];
      print(paybills);
    });

    // filtered = paybills.where((paybill) => paybill['id'] == widget.data[0]['mpesaIntegratedConfigId']).toList();
    // bizShortCode= filtered[0]['shortCode'];

  }



//   /api/lipanampesa/list?companyId
//   {
//   "bizShortCode": "000000",
//   "amount":1000,
//   "phoneNo":"0700000000",
//   "accountRef":"TNT23344444"
// }

  @override
  void initState(){
    // phoneNo = widget.data[0]['fixedPhone'].toString();
    getPabills();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Make Payment'),
      ),
      body: Card(
        child: Column(
          children: [
            // Text('${widget.data}'),
            Container(
              height: 100,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(10)
              ),
                width: MediaQuery.of(context).size.width ,
                child: Center(child: Text('M-PESA',style: TextStyle(fontSize: 20,color: Colors.white),))),
            Card(
              elevation: 8,
              child: Column(

              children: [
                Row(
                  children: [

                    Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Text('Rent Amount'),
                        ),
                        Text('${widget.data[0]['rentAmount']}',style: TextStyle(color: Colors.blue),),
                      ],
                    ),
                    IntrinsicHeight(
                      child: VerticalDivider(width: 2,thickness: 2,),
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text('Rent Bal'),
                        ),
                        Text('${formatCurrency(widget.data[0]['accountBal'])}',style: TextStyle(color: Colors.red),),
                      ],
                    ),
                  ],
                )
              ],
            ),),
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(width: 0.4,color: Colors.grey)
              ),
              padding: EdgeInsets.all(4),
              // width: 200,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Paybill',
                    style: TextStyle(
                      fontFamily: "Muli",
                      fontWeight: FontWeight.bold,
                    ),),
                  DropdownButton(
                    value: paybill,
                    items: paybills.map((list){
                      return DropdownMenuItem(
                        child: Text(list['shortCode'],style: TextStyle(color: Colors.black87)),
                        value: list['shortCode'].toString(),
                      );
                    },).toList(),
                    /*items: paybills.map((list){
                          return DropdownMenuItem(
                            child: Text(list['shortCode'],style: TextStyle(color: Colors.black87)),
                            value: list['shortCode'].toString(),
                          );
                        },).toList(),*/
                    onChanged: (value)=>setState(() {
                      paybill = value.toString();
                      bizShortCode = value.toString();
                    }),
                  ),
                ],
              ),
            ),

            SizedBox(height: 40,),
            Container(
              width: 400,
              child: TextFormField(
                // initialValue: widget.data[0]['accountBal'].abs().toString() ?? '',
                initialValue: widget.data[0]['accountBal']?.abs()?.toString() ?? '',
                // controller: cost,//TextEditingController(text: _textFieldValue),
                onChanged: (newValue) {
                  setState(() {
                    amntToPay = newValue;
                  });
                },
                style: TextStyle(fontSize: 12),
                decoration: InputDecoration(
                  labelText: 'Balance',
                  // labelStyle: boldfont,
                  border: OutlineInputBorder(),
                ),
              ),
              // child: Text('Save'),
            ),
            SizedBox(height: 20,),
            Container(
              width: 400,
              child: TextFormField(
                  initialValue: widget.data[0]['fixedPhone'].toString(),
                // controller: cost,//TextEditingController(text: _textFieldValue),
                onChanged: (newValue) {
                  setState(() {
                    phoneNo = newValue;
                  });
                },
                style: TextStyle(fontSize: 12),
                decoration: InputDecoration(
                  labelText: 'Phone No...',
                  // labelStyle: boldfont,
                  border: OutlineInputBorder(),
                ),
              ),
              // child: Text('Save'),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('* To use another number for payment change the number above to the desired number',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.black45
                ),),
            ),
            SizedBox(height: 20,),
            GestureDetector(
              onTap: ()async{
                Map data = {
                  "bizShortCode": "${bizShortCode}",
                  "amount": "${amntToPay}",
                  "phoneNo":"${phoneNo}",
                  "accountRef":"${widget.data[0]['accountNo']}"
                };

                print(data);

                if(bizShortCode == null){
                  Fluttertoast.showToast(
                    msg:  'Select Paybill'.toUpperCase(),
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIosWeb: 3,
                    backgroundColor: Colors.white,
                    textColor: Colors.red,
                    fontSize: 16.0,
                  );
                }else{
                  // var resu = await auth.lipaNaMpesa(bizShortCode, amntToPay, phoneNo, Userdata[1]['accountNo']);
                  if(amntToPay != 0){
                    showDialog(
                        context: context,
                        builder: (_) => LoadingSpinCircle());
                    var result = await auth.lipaNaMpesa(bizShortCode, amntToPay, phoneNo, Userdata[1]['accountNo']);
                    print(result);
                    //print(bizShortCode); print(amount); print(phoneNumber); print(accountRef);
                    if(result['success'] == "false" ){
                      Fluttertoast.showToast(
                        msg:  '${result['message']}'.toUpperCase(),
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 3,
                        backgroundColor: Colors.white,
                        textColor: Colors.red,
                        fontSize: 16.0,
                      );
                      Navigator.of(context).pop();
                    }else{
                      Fluttertoast.showToast(
                        msg:  '${result['message']}'.toUpperCase(),
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 3,
                        backgroundColor: Colors.white,
                        textColor: Colors.green,
                        fontSize: 16.0,
                      );
                      Navigator.of(context).pop();

                    }
                  }else{
                    Fluttertoast.showToast(
                      msg:  'Amount Should be more than 0'.toUpperCase(),
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 3,
                      backgroundColor: Colors.white,
                      textColor: Colors.red,
                      fontSize: 16.0,
                    );
                  }
                }


              },
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.green
                ),
                child: Padding(
                  padding:  EdgeInsets.symmetric(vertical: 10.0,horizontal: 100),
                  child: Text('Pay',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
