import 'package:ezenresidents/pages/SwitchProfile.dart';
import 'package:ezenresidents/pages/payment.dart';
import 'package:ezenresidents/pages/profile.dart';
import 'package:ezenresidents/pages/rentailInvoices.dart';
import 'package:ezenresidents/pages/resusables.dart';
import 'package:ezenresidents/wrapp.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Services/Services.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'Services/repairrequest.dart';
import 'Services/spin_loader.dart';
import 'package:flutter_html/flutter_html.dart';


class Home extends StatefulWidget {
  const Home({Key? key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final Auth auth = Auth();
  List data = [];
  var hour = DateTime.now().hour;

  getData()async{
    // var resu = await auth.getData('/api/lease/list?companyId=${Userdata[1]['companyId']}&tenantAccNo=${Userdata[1]['uniqTenantId']}');
    var resu = await auth.getData('/api/lease/load/${Userdata[1]['uniqTenantId']}');
    setState(() {
      data.add(resu);
    });
  }

  @override
  void initState(){
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      // drawer: const AppDrawer(),
      appBar: AppBar(
        flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF046307),
                  Color(0xFF046307)
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            )),
        title:  Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Container(
            //   width: 80,
            //   height: 50,
            //   child: Image.asset('assets/logo.png',fit: BoxFit.fill,),),
            Text('Kiragu&Mwangi Residents',style: TextStyle(fontSize: 14,color: Colors.white),),

            PopupMenuButton(
              // offset: Offset(0.0, appBarHeight),
              // color: darkmode ? Colors.black: Colors.grey[100],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
                side: BorderSide(
                    width: 1,
                    color: Colors.grey.shade200
                ),
              ),
              icon: CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.more_vert_sharp,color: Colors.black,size: 30,)),
              // color: iconColor,
              itemBuilder: (BuildContext context) {
                return [

                  PopupMenuItem(
                      child: TextButton(
                          onPressed: () {
                            showModalBottomSheet(
                                context: context,
                                builder: (BuildContext context) {
                                  return Switchprofile();
                                });
                          },
                          child:  Row(
                            children: [
                              Icon(Icons.swap_horiz,color: Colors.red,),
                              Text('\t'),
                              Text(' Switch / Add Profile'),
                            ],
                          ))
                  ),

                  PopupMenuItem(
                      child: Row(
                        children: [
                          Column(
                            children: [
                              Divider(height: 10,),
                              TextButton(onPressed: () async {
                                showDialog(context: context, builder: (_) => AlertDialog(
                                  title: Text('Do you want to exit this application?'),
                                  // content: Text('We hate to see you leave...'),
                                  actions: <Widget>[
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.grey[200],
                                        padding:  EdgeInsets.all(10.0),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(5.0),
                                        ),
                                      ),
                                      onPressed: () {
                                        print("you choose no");
                                        Navigator.of(context).pop(false);
                                      },
                                      child: Text('No',style: TextStyle(color: Colors.blue),),
                                    ),
                                    SizedBox(width: 30,),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red,
                                        padding:  EdgeInsets.all(10.0),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(5.0),
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
                                      child: Text('Yes',style: TextStyle(color: Colors.white),),
                                    ),
                                  ],
                                  elevation: 24,
                                  backgroundColor: Colors.grey[400],
                                )
                                );
                              }, child: Row(
                                children: [
                                  Icon(Icons.logout_outlined,color: Colors.red,),
                                  Text('\t'),
                                  Text('Logout'),
                                ],
                              ))
                            ],
                          ),
                        ],
                      )
                  )
                ];
              },

            ),

          ],
        ),
      ),
      floatingActionButton: GestureDetector(
        onTap: (){
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => LipaNaMpesa(data: data)));
        },
        child: Container(
          width: 150,
          height: 45,
          decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  Color(0xFF046307),
                  Color(0xFF046307)
                ],
              ),
              // color: Colors.blue,
              borderRadius: BorderRadius.circular(20)
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              // CircleAvatar(
              //   backgroundColor: Colors.black.withOpacity(0.2),
              //   // child: const Icon(Icons.monetization_on_sharp,color: Colors.red,),
              // ),
              Text('Make Payment',
                style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12,color: Colors.white),)
            ],
          ),
        ),
      ),
      extendBody:
      true,
      body: data.isEmpty ?const LoadingSpinCircle() :SingleChildScrollView(
        child: Column(
          children: [
            Container(
              child: Column(
                children: [
        
                  ClipPath(
                    clipper: WaveClipperOne(flip: true),
                    child: Container(
                      height: height * 0.18,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          colors: [
                            Color(0xFF046307),
                            Color(0xFF046307)
                            // Colors.black,
                          ],
                        ),
                      ),
                      // color: Colors.redAccent.withOpacity(0.1),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      hour < 12 ? 'Good Morning ' : hour <
                                          17
                                          ? 'Good Afternoon'
                                          : 'Good Evening',
                                      style: const TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                        // fontWeight: FontWeight.w400,
                                        // fontFamily: "Inter",
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10,),
                                Row(
                                  children: [
                                    Text('${data[0]['surname'] ?? ''}',
                                      style: TextStyle(color: Colors.white),),
                                    SizedBox(width: 5,),
                                    Text('${data[0]['lastName'] ?? ''}',
                                      style: TextStyle(color: Colors.white),),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
        
                ],
              ),
            ),
        
        
        
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(90),
                      color: Colors.red,
        
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(1.0),
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        radius:width * 0.2,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text('Balance',style: TextStyle(fontSize: 12),),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text('${data.isEmpty ? 0.0 : formatCurrency(data[0]['accountBal']) ?? 0.0}',
                                    style: TextStyle(fontWeight: FontWeight.bold
                                        ,color: data[0]['accountBal'] > 0 ? Colors.red : Colors.black),
                                  ),
                                ),
                              ],
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: Divider(
                                thickness: 0.5,
                                color: Colors.black,
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text('${data.isEmpty ? 0.0 : formatCurrency(data[0]['rentAmount']) ?? 0.0}',
                                    style: const TextStyle(fontWeight: FontWeight.bold,color: Colors.green),),
                                ),
                                const Text('Rent',style: TextStyle(fontSize: 12),),
        
                              ],
                            ),
        
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
        
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Column(
                          // mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text('Account No.',style: TextStyle(color: Colors.black),),
                            SizedBox(height: 5,),
                            Text('${data[0]['accountNo']}',style: const TextStyle(fontSize: 12,fontWeight: FontWeight.bold),overflow: TextOverflow.ellipsis,),
        
                            SizedBox(height: 10,),
                            Text('Unit No',style: TextStyle(color: Colors.black),),
                            Text('${data[0]['unitNo']}',style: const TextStyle(fontSize: 12,fontWeight: FontWeight.bold),overflow: TextOverflow.ellipsis,),
        
                            const SizedBox(height: 10,),
        
                            Text('Property',style: TextStyle(color: Colors.black),),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                SizedBox(
                                    width: width * 0.4,
                                    child: Text('${data[0]['propName'].replaceAll(RegExp(r'\[.*?\]'), '').trim() ?? ''}',
                                      style:  TextStyle(fontSize: 12,fontWeight: FontWeight.bold),
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.end,
        
                                    )
                                ),
                              ],
                            ),
        
                          ],
                        ),
                      ),
        
                    ],
                  ),
                )
              ],
            ),
            InkWell(
              onTap: (){
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => Profile(data:data)));
              },
              child: Row(
                children: [
                  Expanded(
                    child: Card(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 20.0,horizontal: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                    radius: 24,
                                    backgroundColor: Colors.blue.withOpacity(0.1),
                                    child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Image.asset('assets/tenantdets.png',color: Color(0xFF046307),),
                                    )),
                                SizedBox(width: 10,),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Tenant Profile',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                                    Text('Lease & Details',style: TextStyle(color: Colors.black45,fontSize: 12),),
                                  ],
                                ),
                              ],
                            ),
                            Icon(Icons.navigate_next,color: Colors.red,)
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: (){
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => RentalInvoices(data: data,)));
              },
              child: Row(
                children: [
                  Expanded(
                    child: Card(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 20.0,horizontal: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                    radius: 24,
                                    backgroundColor: Colors.blue.withOpacity(0.1),
                                    child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Image.asset('assets/rentalreceipt2.png',color: Color(0xFF046307),),
                                    )),
                                SizedBox(width: 10,),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Statement',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold)),
                                    Text('Charges & Payments',style: TextStyle(color: Colors.black45,fontSize: 12),),
                                  ],
                                ),
                              ],
                            ),
                            Icon(Icons.navigate_next,color: Colors.red,)
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: (){
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => RepairRewquest(data: data,)));
              },
              child: Row(
                children: [
                  Expanded(
                    child: Card(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 20.0,horizontal: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                    radius: 24,
                                    backgroundColor: Colors.blue.withOpacity(0.1),
                                    child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Image.asset('assets/services.png',color: Color(0xFF046307),),
                                    )),
                                SizedBox(width: 10,),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Services',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold)),
                                    Text('Repair & Maintenance Services',style: TextStyle(color: Colors.black45,fontSize: 12),),
                                  ],
                                ),
                              ],
                            ),
                            Icon(Icons.navigate_next,color: Colors.red,)
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: (){
        
                showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return Container(
                      height: 400,
                      width: MediaQuery.of(context).size.width,// Set the height of the modal sheet
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          SingleChildScrollView(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 14.0),
                                child: Html(
                                  data:"${data[0]['propertyContacts'] ?? ''}",
                                  style:  {
                                    "body": Style(
                                      letterSpacing: 1.0,
                                      fontSize: FontSize(14.0), // Set font size
                                      // color: Colors.black, // Set text color
                                      lineHeight: LineHeight(1.5), // Set line height
                                    )},
                                ),
                              ))
                        ],
                      ),
                    );
                  },
                );
        
              },
              child: Row(
                children: [
                  Expanded(
                    child: Card(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 20.0,horizontal: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                    radius: 24,
                                    backgroundColor: Colors.blue.withOpacity(0.1),
                                    child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Image.asset('assets/management.png',color: Color(0xFF046307),),
                                    )),
                                SizedBox(width: 10,),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Contacts',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold)),
                                    Text('Caretaker & Management',style: TextStyle(color: Colors.black45,fontSize: 12),),
                                  ],
                                ),
                              ],
                            ),
                            Icon(Icons.navigate_next,color: Colors.red,)
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
        
        
          ],
        ),
      ),

    );
  }
}
