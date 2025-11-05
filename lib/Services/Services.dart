import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:ezenresidents/wrapp.dart';

class Auth{

  // var url = Userdata[0] ?? null;


  Map<String, String> headers = {
    "Access-Control-Allow-Origin": "*",
    'Content-Type': 'application/json',
    'Accept': '*/*',
  };

  internetFunctions()async{
    try {
      final checkConnection = await InternetAddress.lookup('google.com');
      if (checkConnection.isNotEmpty && checkConnection[0].rawAddress.isNotEmpty) {
        return true;
      }
    }on SocketException catch (_) {
      print('not connected');
      return false;
    }
  }

  login(username,password,url)async{

    Map data = {
      "username": username,
      "password": password
    };
    print(data);

    String all = '$url/live/api/auth/login';
    print(all);

    var send = jsonEncode(data);
    var resp = await http.post(Uri.parse(all), body: send, headers: headers);
    print(resp.body);
    return jsonDecode(resp.body);
  }

  getData(endpoint)async{
    var url = Userdata[0].toString()+endpoint;
    print(url);
    try{
      var response =  await get(Uri.parse(url));
      var jsondata = jsonDecode(response.body);
      print(jsondata);
      // return jsondata['list'];
      return jsondata;
    }catch(e){
      return e.toString();
    }
  }

  getStatement(ednpoint)async{
    // var memberStatement = await Userdata[0] + '/live/api/sacco_members/statementpdf?membershipId='+userData[1]['saccoMembershipId'].toString();
    var memberStatement = await Userdata[0] + ednpoint;
    print(memberStatement);
    try{
      var resposne = await get(Uri.parse(memberStatement));
      var jsondata = jsonDecode(resposne.body);
      return jsondata['message'];
      // var data = await http.get(Uri.parse(jsondata['message']));
      // return data.bodyBytes;
    }catch(e){
      return e.toString();
    }

  }


  //  saveWorkOrder(companyid,categoryId,tenantIdinView,unitNo,propId,raisedByTnt,priority,description,timeOption,timetoSend,selectedDate/*,_imageFile*/) async{
  //
  //   Map<String, String> headers = {
  //     'Content-type': 'application/json',
  //     'Accept': 'application/json',
  //   };
  //
  //   Map data = {
  //     //"id": defaultCompanyId,
  //     //"putmId": tenantIdinView,
  //     "propertyId": int.parse(propId),
  //     "punitId": int.parse(unitNo),
  //     "raisedByTnt": raisedByTnt,
  //     "serviceCatId": categoryId,
  //     "description": description,
  //     "priority": priority,
  //     "timeOption": timeOption,
  //     "preferredDate": selectedDate,
  //     "preferredTime": timetoSend,
  //     // "attachments": [_imageFile]
  //   };
  //
  //
  //   var send = jsonEncode(data);
  //   // return send;
  //   String saveWorkOrder =  Userdata[0]+'/live/api/workorder/save';
  //   try{
  //     var response =  await http.post(Uri.parse(saveWorkOrder), body: send, headers: headers);
  //     var jsondata = jsonDecode(response.body);
  //     return jsondata;
  //   }catch(e){
  //     return e.toString();
  //   }
  //
  // }


  saveworkorder(data)async{

    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };
    // print(data);
    var send = jsonEncode(data);
    // return send;
    String url =  Userdata[0]+'/live/api/repairrequest/save';
    print(url);
    try{
      var response =  await http.post(Uri.parse(url), body: send, headers: headers);
      var jsondata = jsonDecode(response.body);
      return jsondata;
    }catch(e){
      return e.toString();
    }
  }

  Future lipaNaMpesa(bizShortCode, amount, phoneNo, accountRef) async{
    Map paymentDetails = {
      "bizShortCode" : bizShortCode,
      "amount": amount,
      "phoneNo" : phoneNo,
      "accountRef" : accountRef,
    };
    var paymentPayload = jsonEncode(paymentDetails);
    String url = Userdata[0].toString() + '/live/api/lipanampesa/stkpush';//+ paymentPayload.toString() + headers.toString();
    // return url;
    print(url);
    try{
      var payment = await http.post(Uri.parse(url), body: paymentPayload, headers: headers);
      // print(payment);
      // return payment;
      var jsondata = jsonDecode(payment.body);
      return jsondata;
    }catch(e){
      return e.toString();
    }
  }

}