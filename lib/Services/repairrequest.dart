import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../pages/repairdescription.dart';
import '../pages/repairform.dart';
import '../pages/resusables.dart';
import '../wrapp.dart';
import 'Services.dart';
import 'package:grouped_list/grouped_list.dart';

class RepairRewquest extends StatefulWidget {
  final List data;
  const RepairRewquest({super.key,required this.data});

  @override
  State<RepairRewquest> createState() => _RepairRewquestState();
}

class _RepairRewquestState extends State<RepairRewquest> {



  final Auth auth = Auth();
  List repairsdata = [];
  List categoryList = [];
  List summary = [];

  getData()async{
    var resu = await auth.getData('/live/api/repairrequest/list?companyId=${Userdata[1]['companyId']}&putmId=${Userdata[1]['uniqTenantId']}');
    // print(resu);
    setState(() {
      repairsdata = resu['list'];
    });
  }

  getCats()async{
    var resu = await auth.getData('/live/api/woservicecat/list?companyId=${Userdata[1]['companyId']}&putmId=${Userdata[1]['uniqTenantId']}');
    setState(() {
    categoryList = resu['list'];
    });
  }

  getSummary()async{
    var resu = await auth.getData('/live/api/commonmaintissue/list?companyId=${Userdata[1]['companyId']}');
    setState(() {
      summary = resu['list'];
    });
  }


  @override
  void initState(){
    super.initState();
    getData();
    getCats();
    getSummary();
  }


  @override
  Widget build(BuildContext context) {
    // print(summary);
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text('Repairs & Amenities'),
      ),
      body: DefaultTabController(
        length: 2,

        child: Column(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: TabBar(
                  dividerColor: Colors.black12,
                  labelColor: Color(0xFF046307),
                  indicatorColor: Color(0xFF046307),
                  tabs: [
                Padding(
                  padding:  EdgeInsets.all(8.0),
                  child: Text('Repairs'),
                ),
                Padding(
                  padding:  EdgeInsets.all(8.0),
                  child: Text('Amenities'),
                ),
              ]),
            ),
            Container(
              child: Expanded(
                child: TabBarView(
                  children: [
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment:MainAxisAlignment.end,
                          children: [
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: GestureDetector(
                                onTap: (){
                                  showDialog(
                                      context: context,
                                      builder: (context) => Padding(
                                        // padding: const EdgeInsets.symmetric(vertical:50.0,horizontal: 40),
                                        padding: const EdgeInsets.only(top:160.0),
                                        child: RepairForm(data: widget.data, categories: categoryList,summary: summary,),
                                      )).then((val){
                                        getData();
                                        print('has been dimissed');
                                  });
                                  // showModalBottomSheet(
                                  //     context:  context,
                                  //     builder: (context) => RepairForm(data: widget.data, categories: categoryList,summary: summary,)
                                  // );
                                },
                                child: Container(
                                  decoration:BoxDecoration(
                                      color:Color(0xFF046307),
                                      borderRadius: BorderRadius.circular(5)
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(vertical: 10.0,horizontal: 20),
                                    child: Row(
                                      children: [
                                        Icon(Icons.engineering,color: Colors.white,),
                                        SizedBox(width: 10,),
                                        Text('New Repair',style: TextStyle(color: Colors.white),),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (repairsdata.isEmpty) Column(
                          children: [

                            Center(child: Text('No repairs',style: TextStyle(color: Colors.black),)),
                          ],
                        ) else Flexible(
                            child: GroupedListView<dynamic, String>(
                              reverse: false,
                              elements: repairsdata,
                              groupBy: (element) => element['status'],
                              groupComparator: (value1, value2) => value2.compareTo(value1),
                              order: GroupedListOrder.DESC,
                              useStickyGroupSeparators: true,
                              groupSeparatorBuilder: (String value) => Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  value,
                                  // textAlign: TextAlign.center,
                                  style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black45),
                                ),
                              ),

                              itemBuilder: (c,element){
                                return Padding(
                                  padding:  EdgeInsets.symmetric(vertical: 2.0,horizontal: 10),
                                  child: InkWell(
                                    onTap: (){
                                      // Navigator.push(context,  MaterialPageRoute(builder: (_) => RepairDescription()));
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        border: Border.all(width: 0.6,color: Colors.black12)
                                      ),
                                      child: Padding(
                                        padding:  EdgeInsets.only(left: 8.0,right: 8),
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Icon(Icons.circle,
                                                          size: 12,
                                                          color: element['status'] == 'PENDING'? Colors.orange.shade300 :
                                                          element['status'] == 'REJECTED'? Colors.red.shade300 :
                                                          element['status'] == 'APPROVED'? Colors.green.shade300 : Colors.blue.shade300,
                                                        ),
                                                        Padding(
                                                          padding:  EdgeInsets.all(8.0),
                                                          child: Text('${element['serviceCatName']}',style: TextStyle(fontWeight: FontWeight.bold),),
                                                        ),
                                                      ],
                                                    ),

                                                    Divider(height: 1,color: Colors.black,),
                                                    SizedBox(
                                                      width:width * 0.3,
                                                      height:20,
                                                      // child: Padding(
                                                      //   padding: EdgeInsets.all(8.0),
                                                      // )),
                                                      child: Padding(
                                                          padding:  EdgeInsets.only(left: 15.0),
                                                          child: Text('${element['summary'] ?? ''}',
                                                            softWrap: true,
                                                            style:TextStyle(fontSize:13,fontWeight: FontWeight.bold),)),
                                                      // child: Text('nsdnknkdsnname: APPLIANCES REPAIRS & REPLACEMENT, notes: Appliances repairs & Replacement, companyId: 1202, id: 7271221}, {name: BUILDING EXTERIORS, notes: Building exteriors, companyId: 1202, id: 7271222}, {name: CCTV & SURVEILLANCE, notes: CCTV & surveillance, companyId: 1202, id: 7271242}, {name: CLOSET, WARDROBE, DRAWERS, SHELVES & CABINETS, notes: Closet, Wardrobe, Drawers, Shelves & Cabinets, companyId: 1202, id: 7271235}, {name: COMMUNICATION, notes: Communication, companyId: 1202, id: 7271223}, {name: DOORS & LOCKS, notes: Doors & Locks, companyId: 1202, id: 7271224}, {name: ELECTRICAL & LIGHTING, notes: ELECTRICAL & LIGHTING, companyId: 1202, id: 7271226}, {name: ELEVATOR MAINTENANCE & REPAIR, notes: ELEVATOR MAINTENANCE & REPAIR, companyId: 1202, id: 7271240}, {name: FLOORING, notes: Flooring, companyId: 1202, id: 7271227}, {name: FURNITURE & FITTINGS, notes: Furniture & Fittings, companyId: 1202, id: 7271234}, {name: GARBAGE COLLECTION, notes: Garbage Collection, companyIdc sdnkcnsknckdsa',softWrap: true,style: TextStyle(fontSize: 12,),)),
                                                    ),
                                                    SizedBox(
                                                        width:width * 0.3,
                                                        height:20,
                                                        // child: Padding(
                                                        //   padding: EdgeInsets.all(8.0),
                                                        // )),
                                                    child: Padding(
                                                      padding:  EdgeInsets.only(left: 15.0),
                                                      child: Text('${element['description'] ?? ''}',softWrap: true,style:TextStyle(fontSize:12,color: Colors.black45),)),
                                                      // child: Text('nsdnknkdsnname: APPLIANCES REPAIRS & REPLACEMENT, notes: Appliances repairs & Replacement, companyId: 1202, id: 7271221}, {name: BUILDING EXTERIORS, notes: Building exteriors, companyId: 1202, id: 7271222}, {name: CCTV & SURVEILLANCE, notes: CCTV & surveillance, companyId: 1202, id: 7271242}, {name: CLOSET, WARDROBE, DRAWERS, SHELVES & CABINETS, notes: Closet, Wardrobe, Drawers, Shelves & Cabinets, companyId: 1202, id: 7271235}, {name: COMMUNICATION, notes: Communication, companyId: 1202, id: 7271223}, {name: DOORS & LOCKS, notes: Doors & Locks, companyId: 1202, id: 7271224}, {name: ELECTRICAL & LIGHTING, notes: ELECTRICAL & LIGHTING, companyId: 1202, id: 7271226}, {name: ELEVATOR MAINTENANCE & REPAIR, notes: ELEVATOR MAINTENANCE & REPAIR, companyId: 1202, id: 7271240}, {name: FLOORING, notes: Flooring, companyId: 1202, id: 7271227}, {name: FURNITURE & FITTINGS, notes: Furniture & Fittings, companyId: 1202, id: 7271234}, {name: GARBAGE COLLECTION, notes: Garbage Collection, companyIdc sdnkcnsknckdsa',softWrap: true,style: TextStyle(fontSize: 12,),)),
                                                    ),
                                                    SizedBox(height: 5,),
                                                    Padding(
                                                      padding: EdgeInsets.all(8.0),
                                                      child: Text(frmtd.format(DateTime.fromMillisecondsSinceEpoch(element['requestTime'])),style: styler,),
                                                    ),

                                                    // Text("${repairsdata}"),
                                                  ],
                                                ),
                                                Container(
                                                  width:100,
                                                  height:100,
                                                  decoration:BoxDecoration(
                                                      borderRadius: BorderRadius.circular(5),
                                                      color: Colors.redAccent.withOpacity(0.1)
                                                  ),
                                                  child: element['photosView'] == null ? Center(child: Icon(Icons.photo,color: Colors.redAccent,)):
                                                      Image.network('${Userdata[0]}/${element['photosView']}')
                                                  // NetworkImage('${Userdata[0]+element['photosView']}'),
                                                  //element['attachmentsCnt'] > 0 ? NetworkImage() : Center(child: Icon(Icons.photo,color: Colors.redAccent,)),
                                                ),

                                              ],
                                            ),
                                            // Divider(thickness: 1,color: Colors.black12,)
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            )
                        ),
                        
                        // Flexible(
                        //   child: GroupedListView<dynamic, String>(
                        //     reverse: true,
                        //     elements: sales,
                        //     // groupBy: (element) => f.format( DateTime.fromMillisecondsSinceEpoch(element['issueDate'])).toString(),
                        //     groupBy: (element) => element['retailShopName'] ?? f.format( DateTime.fromMillisecondsSinceEpoch(element['issueDate'])).toString(),
                        //
                        //     groupComparator: (value1, value2) => value2.compareTo(value1),
                        //     itemComparator: (item1, item2) => item1['retailShopName'] == null ? item1['issueDate'].compareTo(item2['issueDate']) : item1['retailShopName'].compareTo(item2['retailShopName']),
                        //     // (item1['retailShopName'].compareTo(item2['retailShopName'] ?? item1['issueDate'].compareTo(item2['issueDate']))),
                        //     order: GroupedListOrder.DESC,
                        //     useStickyGroupSeparators: true,
                        //     groupSeparatorBuilder: (String value) => Padding(
                        //       padding: const EdgeInsets.all(8.0),
                        //       child: Container(
                        //         width: width * 0.92,
                        //         color: Colors.redAccent,
                        //         child: Padding(
                        //           padding: const EdgeInsets.all(8.0),
                        //           child: Text(
                        //             value,
                        //             // textAlign: TextAlign.center,
                        //             style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
                        //           ),
                        //         ),
                        //       ),
                        //     ),
                        //     itemBuilder: (c, element) {
                        //       return InkWell(
                        //         onTap: (){
                        //           showDialog(
                        //               context: context,
                        //               builder: (BuildContext context) {
                        //                 return AlertDialog(
                        //                   content: Stack(
                        //                     // overflow: Overflow.visible,
                        //                     children: <Widget>[
                        //                       Positioned(
                        //                         right: -40.0,
                        //                         top: -40.0,
                        //                         child: InkResponse(
                        //                           onTap: () {
                        //                             Navigator.of(context).pop();
                        //                           },
                        //                           child: CircleAvatar(
                        //                             child: Icon(Icons.close),
                        //                             backgroundColor: Colors.red,
                        //                           ),
                        //                         ),
                        //                       ),
                        //                       Form(
                        //                         // key: _formKey,
                        //                           child: Column(
                        //                             children: [
                        //                               Center(child: Text('${companyInfo[0]['companyName']}')),
                        //                               Text(''),
                        //                               Row(
                        //                                 mainAxisAlignment: MainAxisAlignment.end,
                        //                                 children: [
                        //                                   Column(
                        //                                     crossAxisAlignment: CrossAxisAlignment.end,
                        //                                     children: [
                        //
                        //                                       Padding(
                        //                                         padding: const EdgeInsets.all(3.0),
                        //                                         child: Text('${companyInfo[0]['companyAddr']} ',
                        //                                           style: TextStyle(fontSize: 12),),
                        //                                       ),
                        //                                       Padding(
                        //                                         padding: const EdgeInsets.all(3.0),
                        //                                         child: Text('${companyInfo[0]['companyRoad'] ?? ''} ${companyInfo[0]['companyTown'] ?? ''}',
                        //                                             style: TextStyle(fontSize: 12)),
                        //                                       ),
                        //                                       Padding(
                        //                                         padding: const EdgeInsets.all(3.0),
                        //                                         child: Text('${companyInfo[0]['companyEmail'] ?? ''}',
                        //                                             style: TextStyle(fontSize: 12)
                        //                                         ),
                        //                                       ),
                        //                                     ],
                        //                                   ),
                        //                                 ],
                        //                               ),
                        //                               Divider(),
                        //                               Row(
                        //                                 crossAxisAlignment: CrossAxisAlignment.start,
                        //                                 children: [
                        //                                   Text('Receipt No\t\t',style: placeholderfont,),
                        //                                   Text(element["receiptNo"] ?? '')
                        //                                 ],
                        //                               ),
                        //                               Text(''),
                        //                               Row(
                        //                                 crossAxisAlignment: CrossAxisAlignment.start,
                        //                                 children: [
                        //                                   Text('Ref No\t\t',style: placeholderfont,),
                        //                                   Text(element["refNo"] ?? '')
                        //                                 ],
                        //                               ),
                        //                               Text(''),
                        //                               Text(''),
                        //                               Column(
                        //                                 crossAxisAlignment: CrossAxisAlignment.start,
                        //                                 children: [
                        //                                   Text('Description',style: placeholderfont,),
                        //                                   Text(element["notes"] ?? '')
                        //                                 ],
                        //                               ),
                        //                               Text(''),
                        //                               Divider(),
                        //                               Column(
                        //                                 // crossAxisAlignment: CrossAxisAlignment.end,
                        //                                 children: [
                        //                                   // Column(
                        //                                   //   crossAxisAlignment: CrossAxisAlignment.center,
                        //                                   //   children: [
                        //                                   //     Text('Discount',style: placeholderfont,),
                        //                                   //     Text("${element["totalDiscount"]}")
                        //                                   //   ],
                        //                                   // ),
                        //                                   // Column(
                        //                                   //   crossAxisAlignment: CrossAxisAlignment.center,
                        //                                   //   children: [
                        //                                   //     Text('Total Tax',style: placeholderfont,),
                        //                                   //     Text("${element["totalTax"]}")
                        //                                   //   ],
                        //                                   // ),
                        //                                   Padding(
                        //                                     padding: const EdgeInsets.all(5.0),
                        //                                     child: Row(
                        //                                       mainAxisAlignment: MainAxisAlignment.end,
                        //                                       children: [
                        //                                         Text('Total Cost\t',style: placeholderfont,),
                        //                                         Text("${formatCurrency(element["subTotal"])}",
                        //                                           style: TextStyle(fontWeight: FontWeight.bold),
                        //                                         )
                        //                                       ],
                        //                                     ),
                        //                                   ),
                        //                                   Padding(
                        //                                     padding: const EdgeInsets.all(5.0),
                        //                                     child: Row(
                        //                                       mainAxisAlignment: MainAxisAlignment.end,
                        //                                       children: [
                        //                                         Text('Amount Paid\t',style: placeholderfont,),
                        //                                         Text("${formatCurrency(element["amountPaid"])}",
                        //                                           style: TextStyle(fontWeight: FontWeight.bold),
                        //                                         )
                        //                                       ],
                        //                                     ),
                        //                                   ),
                        //                                 ],
                        //                               ),
                        //                               Divider(),
                        //                               Container(
                        //                                 height: 60,
                        //                               ),
                        //                               Row(
                        //                                 mainAxisAlignment: MainAxisAlignment.start,
                        //                                 children: [
                        //                                   Column(
                        //                                     crossAxisAlignment: CrossAxisAlignment.start,
                        //                                     children: [
                        //
                        //                                       Padding(
                        //                                         padding: const EdgeInsets.all(3.0),
                        //                                         child: Text('Thank you for your business',
                        //                                           style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),),
                        //                                       ),
                        //                                       Padding(
                        //                                         padding: const EdgeInsets.all(3.0),
                        //                                         child: Row(
                        //                                           children: [
                        //                                             Text('Served By:',style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold)),
                        //                                             Text('${element['userName'] ?? ''}',
                        //                                                 style: TextStyle(fontSize: 12)),
                        //                                           ],
                        //                                         ),
                        //                                       ),
                        //                                       Padding(
                        //                                         padding: const EdgeInsets.all(3.0),
                        //                                         child: Text('${f.format(new DateTime.fromMillisecondsSinceEpoch(element["issueDate"]))}',
                        //                                           style: TextStyle(
                        //                                               fontSize: 12,
                        //                                               fontWeight: FontWeight.bold
                        //                                           ),),
                        //                                       ),
                        //                                     ],
                        //                                   ),
                        //                                 ],
                        //                               ),
                        //                               Text(''),
                        //                               Spacer(),
                        //                               Row(
                        //                                 children: [
                        //                                   IconButton(
                        //                                       onPressed: (){
                        //                                         printDoc(element);
                        //                                         // createPdf(element).whenComplete(()async{
                        //                                         print(path);
                        //                                         // try {
                        //                                         //   print('Share Invoked');
                        //                                         //   await Share.shareFiles(['${path}'],
                        //                                         //       text: '${DateTime.now()}');
                        //                                         // } catch (e) {
                        //                                         //   print('EXCEPTION $e');
                        //                                         // }
                        //                                         // });
                        //
                        //                                       },
                        //                                       icon: Icon(Icons.print,color: Colors.blueAccent,)
                        //                                   ),
                        //                                   IconButton(
                        //                                       onPressed: (){
                        //                                         createPdf(element).whenComplete(()async{
                        //                                           print(path);
                        //                                           try {
                        //                                             print('Share Invoked');
                        //                                             await Share.shareFiles(['${path}'],
                        //                                                 text: '${DateTime.now()}');
                        //                                           } catch (e) {
                        //                                             print('EXCEPTION $e');
                        //                                           }
                        //                                         });
                        //                                       },
                        //                                       icon: Icon(Icons.share,color: Colors.redAccent,)
                        //                                   ),
                        //                                 ],
                        //                               )
                        //                             ],
                        //                           )
                        //                       ),
                        //                     ],
                        //                   ),
                        //                 );
                        //               });
                        //         },
                        //         child: Card(
                        //           elevation: 8.0,
                        //           margin:
                        //           const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                        //           child: IntrinsicHeight(
                        //             child: Row(
                        //               children: [
                        //                 VerticalDivider(
                        //                   color: element["transactionType"] == 'CASH' ? Colors.green : Colors.blue,
                        //                   thickness: 2,
                        //                 ),
                        //                 // Container(
                        //                 //   width: 20,
                        //                 //   decoration: BoxDecoration(
                        //                 //     color: element["transactionType"] == 'CASH' ? Colors.green : Colors.blue
                        //                 //   ),
                        //                 //   child: Text(''),
                        //                 // ),
                        //                 Text(''),
                        //                 Expanded(
                        //                   child: Padding(
                        //                     padding: const EdgeInsets.all(8.0),
                        //                     child: Column(
                        //                       crossAxisAlignment: CrossAxisAlignment.start,
                        //                       children: [
                        //                         Row(
                        //                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //                           children: [
                        //                             Text("${element["receiptNo"] ?? ''}",
                        //                               style: TextStyle(
                        //                                   color: Colors.blue,
                        //                                   fontWeight: FontWeight.bold
                        //                               ),),
                        //                             Icon(Icons.more_vert)
                        //                           ],),
                        //                         Text(''),
                        //                         DottedLine(dashColor: Colors.black45,),
                        //                         Text(''),
                        //                         Column(
                        //                           crossAxisAlignment: CrossAxisAlignment.start,
                        //                           children: [
                        //                             Text('${element['issuedTo'] ?? '-'}',style: normalfont2,),
                        //                             Text(''),
                        //                             Text(f.format( DateTime.fromMillisecondsSinceEpoch(element['issueDate'])),style: placeholderfont,),
                        //                           ],
                        //                         ),
                        //                         Text(''),
                        //
                        //                         Text(''),
                        //
                        //                         Row(
                        //                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //                           children: [
                        //                             Text('${element['retailShopName'] ?? ''}'),
                        //                             Expanded(child: Row(
                        //                               mainAxisAlignment: MainAxisAlignment.end,
                        //                               children: [
                        //                                 Text('KES:\t',style: placeholderfont,),
                        //                                 Text("${formatCurrency(element["amountPaid"])}",style: TextStyle(
                        //                                     color: Colors.green,
                        //                                     fontWeight: FontWeight.bold
                        //                                 ),)
                        //
                        //                               ],
                        //                             ))
                        //                           ],
                        //                         )
                        //                       ],
                        //                     ),
                        //                   ),
                        //                 ),
                        //               ],
                        //             ),
                        //           ),
                        //           // child: Column(
                        //           //   children: [
                        //           //     Text(element['issuedTo']),
                        //           //     Row(
                        //           //       children: [
                        //           //         Text('Amount Paid:'),Text("${element["amountPaid"]}")
                        //           //       ],
                        //           //     ),
                        //           //     Row(
                        //           //       children: [
                        //           //         Text('Transaction type:'),Text("${element["transactionType"
                        //           //             ]}")
                        //           //       ],
                        //           //     ),
                        //           //     Row(
                        //           //       children: [
                        //           //
                        //           //       ],
                        //           //     ),
                        //           //     Row(
                        //           //       children: [
                        //           //         Text('Ref Num:'),Text(element["refNo"])
                        //           //       ],
                        //           //     ),
                        //           //   ],
                        //           // ),
                        //
                        //           // child: SizedBox(
                        //           //   child: ListTile(
                        //           //     contentPadding: const EdgeInsets.symmetric(
                        //           //         horizontal: 20.0, vertical: 10.0),
                        //           //     leading: const Icon(Icons.account_circle),
                        //           //     title: Text(element['issuedTo']),
                        //           //     trailing: const Icon(Icons.arrow_forward),
                        //           //   ),
                        //           // ),
                        //         ),
                        //       );
                        //     },
                        //   ),
                        // ),

                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Coming Soon Soon'),
                      ],
                    )

                    // GroupedListView<dynamic, String>(
                    //   reverse: false,
                    //   elements: repairsdata,
                    //   groupBy: (element) => element['status'],
                    //   groupComparator: (value1, value2) => value2.compareTo(value1),
                    //   order: GroupedListOrder.DESC,
                    //   useStickyGroupSeparators: true,
                    //   groupSeparatorBuilder: (String value) => Padding(
                    //     padding: const EdgeInsets.all(8.0),
                    //     child: Text(
                    //       value,
                    //       // textAlign: TextAlign.center,
                    //       style: TextStyle(fontWeight: FontWeight.bold),
                    //     ),
                    //   ),
                    //
                    //   itemBuilder: (c,element){
                    //     return Padding(
                    //       padding:  EdgeInsets.symmetric(vertical: 2.0,horizontal: 10),
                    //       child: Container(
                    //         decoration: BoxDecoration(
                    //             borderRadius: BorderRadius.circular(5),
                    //             border: Border.all(width: 0.6,color: Colors.black12)
                    //         ),
                    //         child: Padding(
                    //           padding:  EdgeInsets.only(left: 8.0,right: 8),
                    //           child: Column(
                    //             children: [
                    //               Row(
                    //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //                 children: [
                    //                   Column(
                    //                     crossAxisAlignment: CrossAxisAlignment.start,
                    //                     children: [
                    //                       Row(
                    //                         children: [
                    //                           Icon(Icons.circle,
                    //                             size: 14,
                    //                             color: element['status'] == 'PENDING'? Colors.orange.shade300 :
                    //                             element['status'] == 'REJECTED'? Colors.red.shade300 :
                    //                             element['status'] == 'APPROVED'? Colors.green.shade300 : Colors.blue.shade300,
                    //                           ),
                    //                           Padding(
                    //                             padding:  EdgeInsets.all(8.0),
                    //                             child: Text('${element['serviceCatName']}',style: TextStyle(fontWeight: FontWeight.bold),),
                    //                           ),
                    //                         ],
                    //                       ),
                    //
                    //                       Divider(height: 1,color: Colors.black,),
                    //                       // SizedBox(
                    //                       //   width:250,
                    //                       //   height:100,
                    //                       //   // child: Padding(
                    //                       //   //   padding: EdgeInsets.all(8.0),
                    //                       //   // )),
                    //                       //   child: Padding(
                    //                       //       padding:  EdgeInsets.only(left: 15.0),
                    //                       //       child: Text('${element['description'] ?? ''}',softWrap: true,style:TextStyle(fontSize:12),)),
                    //                       //   // child: Text('nsdnknkdsnname: APPLIANCES REPAIRS & REPLACEMENT, notes: Appliances repairs & Replacement, companyId: 1202, id: 7271221}, {name: BUILDING EXTERIORS, notes: Building exteriors, companyId: 1202, id: 7271222}, {name: CCTV & SURVEILLANCE, notes: CCTV & surveillance, companyId: 1202, id: 7271242}, {name: CLOSET, WARDROBE, DRAWERS, SHELVES & CABINETS, notes: Closet, Wardrobe, Drawers, Shelves & Cabinets, companyId: 1202, id: 7271235}, {name: COMMUNICATION, notes: Communication, companyId: 1202, id: 7271223}, {name: DOORS & LOCKS, notes: Doors & Locks, companyId: 1202, id: 7271224}, {name: ELECTRICAL & LIGHTING, notes: ELECTRICAL & LIGHTING, companyId: 1202, id: 7271226}, {name: ELEVATOR MAINTENANCE & REPAIR, notes: ELEVATOR MAINTENANCE & REPAIR, companyId: 1202, id: 7271240}, {name: FLOORING, notes: Flooring, companyId: 1202, id: 7271227}, {name: FURNITURE & FITTINGS, notes: Furniture & Fittings, companyId: 1202, id: 7271234}, {name: GARBAGE COLLECTION, notes: Garbage Collection, companyIdc sdnkcnsknckdsa',softWrap: true,style: TextStyle(fontSize: 12,),)),
                    //                       // ),
                    //                       Padding(
                    //                         padding: EdgeInsets.all(8.0),
                    //                         child: Text(frmtd.format(DateTime.fromMillisecondsSinceEpoch(element['requestTime'])),style: styler,),
                    //                       ),
                    //
                    //                       // Text("${repairsdata}"),
                    //                     ],
                    //                   ),
                    //                   Container(
                    //                     width:100,
                    //                     height:100,
                    //                     decoration:BoxDecoration(
                    //                         borderRadius: BorderRadius.circular(5),
                    //                         color: Colors.redAccent.withOpacity(0.1)
                    //                     ),
                    //                     child: element['attachmentsCnt'] > 0 ? Image.asset('') : Center(child: Icon(Icons.photo,color: Colors.redAccent,)),
                    //                   ),
                    //
                    //                 ],
                    //               ),
                    //               // Divider(thickness: 1,color: Colors.black12,)
                    //             ],
                    //           ),
                    //         ),
                    //       ),
                    //     );
                    //   },
                    // ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
