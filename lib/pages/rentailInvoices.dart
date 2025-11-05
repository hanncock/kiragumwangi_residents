import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../Services/Services.dart';
import '../Services/spin_loader.dart';
import '../wrapp.dart';
import 'Statements.dart';
import 'payment.dart';
import 'resusables.dart';


class RentalInvoices extends StatefulWidget {
  final List data;
  const RentalInvoices({Key? key,required this.data});

  @override
  State<RentalInvoices> createState() => _RentalInvoicesState();
}

class _RentalInvoicesState extends State<RentalInvoices> {

  final Auth auth = Auth();


  List data = [];
  List payments = [];
  List charges = [];



  getData(String? endp)async{
    var resu = await auth.getData(
        endp == null ? '/api/lease/statement?companyId=${Userdata[1]['companyId']}&accountId=${Userdata[1]['ledgerId']}' :
        '/api/lease/statement?companyId=${Userdata[1]['companyId']}&accountId=${Userdata[1]['ledgerId']}&dateFrom=${selectedDate?.month}-${selectedDate?.year}&dateTo=${endDate?.month}-${endDate?.year}'
    );
    setState(() {
      data = resu['list'];
    });
  }

  getPayments(String? endp)async{
    var resu = await auth.getData(endp==null?
    '/api/lease/payments?companyId=${Userdata[1]['companyId']}&accountId=${Userdata[1]['ledgerId']}':
    '/api/lease/payments?companyId=${Userdata[1]['companyId']}&accountId=${Userdata[1]['ledgerId']}&dateFrom=${selectedDate?.month}-${selectedDate?.year}&dateTo=${endDate?.month}-${endDate?.year}');
    setState(() {
      payments = resu['list'];
    });

  }

  getCharges(String? endp)async{
    var resu = await auth.getData( endp==null?
    '/api/lease/charges?companyId=${Userdata[1]['companyId']}&accountId=${Userdata[1]['ledgerId']}':
    '/api/lease/charges?companyId=${Userdata[1]['companyId']}&accountId=${Userdata[1]['ledgerId']}&dateFrom=${selectedDate?.month}-${selectedDate?.year}&dateTo=${endDate?.month}-${endDate?.year}'
    );
    setState(() {
      charges = resu['list'];
    });

  }

  @override
  void initState(){
    super.initState();
    getData(null);
    getPayments(null);
    getCharges(null);
  }

  TextEditingController dateTimeCont = TextEditingController();
  DateTime? selectedDate;
  DateTime? endDate;
  String? showDate;
  DateTime now = DateTime.now();

  Future<void> selectDateAndTime(BuildContext context) async {
    await showDateRangePicker(
      context: context,
      initialDateRange: DateTimeRange(
        start: DateTime(DateTime.now().year),
        end: DateTime.now(),
      ),
      lastDate: DateTime.now(),
      currentDate: DateTime.now(),
      firstDate: DateTime(2015),
      builder: (_, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).brightness == Brightness.light
                ? ColorScheme.light(
              primary: Theme.of(context).primaryColor,
            )
                : ColorScheme.dark(
              primary: Theme.of(context).primaryColor,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
            ),
          ),
          child: child!,
        );
      },
    ).then((date) async {
      selectedDate = date!.start;
      endDate = date.end;
      setState(() {
        showDate =
        '${frmtd.format(selectedDate!)} to ${frmtd.format(endDate!)}';
      });
      print(selectedDate);
      print(endDate);
      // BlocProvider.of<ListLeaseStatementBloc>(context).add(
      //   ListLeaseStatement(
      //     accountId: widget.accountId,
      //     dateFrom: formatDate(selectedDate.toString(), format: dateFormat6),
      //     dateTo: formatDate(endDate.toString(), format: dateFormat6),
      //   ),
      // );
    });
  }

  @override
  Widget build(BuildContext context) {
    // print(payments);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction Statement'),
        actions: [
          IconButton(onPressed: (){
            Navigator.push(
                context,  MaterialPageRoute(builder: (_) => Stmts(endpoint: '/api/lease/statementpdf?tenancyId=${Userdata[1]['uniqTenantId']}',)));

          }, icon: Icon(Icons.print,color: Colors.blueAccent,))
        ],
      ),
      floatingActionButton:GestureDetector(
        onTap: (){
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => LipaNaMpesa(data: widget.data)));
        },
        child: Container(
          width: 150,
          height: 50,
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
              //   backgroundColor: Color(0xFF046307),
              //   child: const Icon(Icons.monetization_on_sharp,color: Colors.red,),
              // ),
              Text('Make Payment',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 12),)
            ],
          ),
        ),
      ),
      body: DefaultTabController(
          length: 3,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  readOnly: true,
                  decoration: InputDecoration(
                    hintText:
                    'From ${showDate ?? 'Jan, ${DateTime.now().year} to ${DateTime.now().month}, ${DateTime.now().year}'}',
                    prefixIcon:
                    const Icon(Icons.filter_list_outlined),
                  ),
                  onTap: () {
                    selectDateAndTime(context).whenComplete((){
                      getData('refresh');
                      getPayments('refresh');
                      getCharges('refresh');
                    }

                    );
                  },
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                // height: 80,
                child: TabBar(


                  // indicator: Colors.red,
                  tabs: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Statements'),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Payments'),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Charges'),
                    ),
                    // Text('Charges'),
                  ],
                ),
              ),
              Container(
                  color:Color(0xFF046307).withOpacity(0.8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('Current Balance',style: TextStyle(color: Colors.white),),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('${formatCurrency(widget.data[0]['accountBal'])}',style: TextStyle(color: Colors.white),),
                      )
                    ],
                  )),
              data.isEmpty? LoadingSpinCircle() : Expanded(
                child: TabBarView(
                    children: [

                      //Statement
                      SingleChildScrollView(
                        child: Column(
                          children: data.reversed.map((invList){
                            return  GestureDetector(
                              onTap: (){
                                // invList['txnType'] == 'INV' ?
                                // Navigator.push(
                                //     context,  MaterialPageRoute(builder: (_) => Stmts(endpoint: '/api/lease/invoicepdf?invoiceId=${invList['txnId']}',))) :
                                // print('welcome');
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 1.0),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment:MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Padding(
                                                        padding: EdgeInsets.all(8.0),
                                                        child: Text(frmtd.format(DateTime.fromMillisecondsSinceEpoch(invList['txnDate'])),style: styler,),
                                                      ),
                                                    ],
                                                  ),
                                                  invList['txnType'] == 'BAL'? Container(
                                                      decoration: BoxDecoration(
                                                          color: invList['debit'] > 0 ? Colors.redAccent.withOpacity(0.1) : Colors.green.withOpacity(0.1) ,
                                                          borderRadius: BorderRadius.circular(5)
                                                      ),
                                                      child: Padding(
                                                        padding:EdgeInsets.symmetric(vertical: 5.0,horizontal: 10),
                                                        // child: Text('${invList['txnType']}',style: TextStyle(color: Colors.white,fontSize: 12),),
                                                        child: Text('${formatCurrency(invList['debit'])}',style: TextStyle(
                                                            color: invList['debit'] > 0 ? Colors.red : Colors.green,
                                                            fontSize: 12),),
                                                      )
                                                  ) :(invList['txnType']== 'INV' ||invList['txnType']== 'DBN') ? Container(
                                                      decoration: BoxDecoration(
                                                          color: Colors.redAccent.withOpacity(0.1),
                                                          borderRadius: BorderRadius.circular(5)
                                                      ),
                                                      child: Padding(
                                                        padding:EdgeInsets.symmetric(vertical: 5.0,horizontal: 10),
                                                        // child: Text('${invList['txnType']}',style: TextStyle(color: Colors.white,fontSize: 12),),
                                                        child: Text('${formatCurrency(invList['debit'])}',style: TextStyle(color: Colors.red,fontSize: 12),),
                                                      )
                                                  ) : invList['txnType'] == 'RCPT' ? Container(
                                                      decoration: BoxDecoration(
                                                          color: Colors.green.withOpacity(0.1),
                                                          borderRadius: BorderRadius.circular(5)
                                                      ),
                                                      child: Padding(
                                                        padding:EdgeInsets.symmetric(vertical: 5.0,horizontal: 10),
                                                        // child: Text('${invList['txnType']}',style: TextStyle(color: Colors.white,fontSize: 12),),
                                                        child: Text('${formatCurrency(invList['credit'])}',style: TextStyle(color: Colors.green,fontSize: 12),),
                                                      )
                                                  ) :invList['txnType'] == 'PMT' ? Container(
                                                      decoration: BoxDecoration(
                                                          color: Colors.red.withOpacity(0.1),
                                                          borderRadius: BorderRadius.circular(5)
                                                      ),
                                                      child: Padding(
                                                        padding:EdgeInsets.symmetric(vertical: 5.0,horizontal: 10),
                                                        // child: Text('${invList['txnType']}',style: TextStyle(color: Colors.white,fontSize: 12),),
                                                        child: Text('${formatCurrency(invList['debit'])}',style: TextStyle(color: Colors.red,fontSize: 12),),
                                                      )
                                                  ) : SizedBox()
                                                ],
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 12),
                                                child: Text('${invList['descr']}'),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                    Divider(height: 1,color: Colors.black12,)
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),

                      //Payments
                      SingleChildScrollView(
                        child: Column(
                          children: payments.reversed.map((invList) {
                            return GestureDetector(
                              onTap: (){
                                // invList['txnType'] == 'RCPT' ?
                                // Navigator.push(
                                //     context,  MaterialPageRoute(builder: (_) => Stmts(endpoint: '/api/lease/invoicepdf?invoiceId=${invList['txnId']}',))) :
                                // print('welcome');
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment:MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Text(frmtd.format(DateTime.fromMillisecondsSinceEpoch(invList['txnDate'])),style: styler,),
                                                  ),
                                                  invList['txnType'] == 'INV'? Container(
                                                      decoration: BoxDecoration(
                                                          color: Colors.redAccent.withOpacity(0.1),
                                                          borderRadius: BorderRadius.circular(5)
                                                      ),
                                                      child: Padding(
                                                        padding:EdgeInsets.symmetric(vertical: 5.0,horizontal: 10),
                                                        // child: Text('${invList['txnType']}',style: TextStyle(color: Colors.white,fontSize: 12),),
                                                        child: Text('${formatCurrency(invList['debit'])}',style: TextStyle(color: Colors.red,fontSize: 12),),
                                                      )
                                                  ) : invList['txnType'] == 'RCPT' ? Container(
                                                      decoration: BoxDecoration(
                                                          color: Colors.green.withOpacity(0.1),
                                                          borderRadius: BorderRadius.circular(5)
                                                      ),
                                                      child: Padding(
                                                        padding:EdgeInsets.symmetric(vertical: 5.0,horizontal: 10),
                                                        // child: Text('${invList['txnType']}',style: TextStyle(color: Colors.white,fontSize: 12),),
                                                        child: Text('${formatCurrency(invList['credit'])}',style: TextStyle(color: Colors.green,fontSize: 12),),
                                                      )
                                                  ) :invList['txnType'] == 'PMT' ? Container(
                                                      decoration: BoxDecoration(
                                                          color: Colors.red.withOpacity(0.1),
                                                          borderRadius: BorderRadius.circular(5)
                                                      ),
                                                      child: Padding(
                                                        padding:EdgeInsets.symmetric(vertical: 5.0,horizontal: 10),
                                                        // child: Text('${invList['txnType']}',style: TextStyle(color: Colors.white,fontSize: 12),),
                                                        child: Text('${formatCurrency(invList['debit'])}',style: TextStyle(color: Colors.green,fontSize: 12),),
                                                      )
                                                  ) : SizedBox()
                                                ],
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Text('${invList['descr']}'),
                                              ),

                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                    Divider(height: 4,color: Colors.black12,)
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),

                      SingleChildScrollView(
                        // scrollDirection: Axis.vertical,
                        child: Column(
                          children: [
                            ...charges.reversed.map((invList){
                              return GestureDetector(
                                onTap: (){
                                  // invList['txnType'] == 'INV' ?
                                  // Navigator.push(
                                  //     context,  MaterialPageRoute(builder: (_) => Stmts(endpoint: '/api/lease/invoicepdf?invoiceId=${invList['txnId']}',))) :
                                  // print('welcome');
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: Text(frmtd.format(DateTime.fromMillisecondsSinceEpoch(invList['txnDate'])),style: styler,),
                                                    ),
                                                    invList['txnType']== 'INV' ||invList['txnType']== 'DBN'? Container(
                                                        decoration: BoxDecoration(
                                                            color: Colors.redAccent.withOpacity(0.1),
                                                            borderRadius: BorderRadius.circular(5)
                                                        ),
                                                        child: Padding(
                                                          padding:EdgeInsets.symmetric(vertical: 5.0,horizontal: 10),
                                                          // child: Text('${invList['txnType']}',style: TextStyle(color: Colors.white,fontSize: 12),),
                                                          child: Text('${formatCurrency(invList['debit'])}',style: TextStyle(color: Colors.red,fontSize: 12),),
                                                        )
                                                    ) :invList['txnType'] == 'PMT' ? Container(
                                                        decoration: BoxDecoration(
                                                            color: Colors.red.withOpacity(0.1),
                                                            borderRadius: BorderRadius.circular(5)
                                                        ),
                                                        child: Padding(
                                                          padding:EdgeInsets.symmetric(vertical: 5.0,horizontal: 10),
                                                          // child: Text('${invList['txnType']}',style: TextStyle(color: Colors.white,fontSize: 12),),
                                                          child: Text('${formatCurrency(invList['debit'])}',style: TextStyle(color: Colors.red,fontSize: 12),),
                                                        )
                                                    ) :SizedBox()
                                                    // Text('${invList['txnType']}')
                                                  ],
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Text('${invList['descr']}'),
                                                ),

                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                      Divider(height: 1,color: Colors.black12,)
                                    ],
                                  ),
                                ),
                              );
                            })
                          ],
                        ),
                        /*child: Container(
                          height: MediaQuery.of(context).size.height * 0.8,
                          child: ListView.builder(
                            reverse: true,
                            shrinkWrap: true,
                            itemCount:charges.length,
                            itemBuilder: (context, index){
                              var invList = charges[index];
                              return GestureDetector(
                                onTap: (){
                                  invList['txnType'] == 'INV' ?
                                  Navigator.push(
                                      context,  MaterialPageRoute(builder: (_) => Stmts(endpoint: '/api/lease/invoicepdf?invoiceId=${invList['txnId']}',))) :
                                  print('welcome');
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: Text(frmtd.format(DateTime.fromMillisecondsSinceEpoch(data[index]['txnDate'])),style: styler,),
                                                    ),
                                                    invList['txnType']== 'INV' ||invList['txnType']== 'DBN'? Container(
                                                        decoration: BoxDecoration(
                                                            color: Colors.redAccent.withOpacity(0.1),
                                                            borderRadius: BorderRadius.circular(5)
                                                        ),
                                                        child: Padding(
                                                          padding:EdgeInsets.symmetric(vertical: 5.0,horizontal: 10),
                                                          // child: Text('${invList['txnType']}',style: TextStyle(color: Colors.white,fontSize: 12),),
                                                          child: Text('${formatCurrency(invList['debit'])}',style: TextStyle(color: Colors.red,fontSize: 12),),
                                                        )
                                                    ) :SizedBox()
                                                    // Text('${invList['txnType']}')
                                                  ],
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Text('${invList['descr']}'),
                                                ),

                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                      Divider(height: 1,color: Colors.black12,)
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),*/
                      ),

                    ]),
              )
            ],
          )),
    );
  }
}
