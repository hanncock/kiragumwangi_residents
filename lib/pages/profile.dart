import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';

import '../wrapp.dart';
import 'resusables.dart';

class Profile extends StatefulWidget {
  final List?  data;
  const Profile({Key? key,this.data});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    print(Userdata);

    return Scaffold(
      appBar: AppBar(
        title: Text('Lease Details'),
      ),
      body: Column(
        children: [
          Column(
            children: [
              Card(

                child: Container(
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
                  child: ClipPath(

                    clipper: WaveClipperOne(flip: true),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CircleAvatar(
                              radius: 60,
                              backgroundColor: Colors.red.withOpacity(0.1),
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Image.asset('assets/tenantdets.png',color: Colors.white.withOpacity(0.9),),
                              )),
                          Column(
                            // mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Row(
                                children: [
                                  Text('${widget.data![0]['surname'] ?? ''}',style: TextStyle(color: Colors.white),),
                                  // SizedBox(width: 5,),
                                  Text('${widget.data![0]['lastName'] ?? ''}',style: TextStyle(color: Colors.white)),
                                ],
                              ),
                              SizedBox(height: 10,),
                              Text('${widget.data![0]['fixedPhone']}',style: const TextStyle(fontSize: 12,color: Colors.white),overflow: TextOverflow.ellipsis,),
                              SizedBox(height: 10,),
                              Text('${widget.data![0]['email']}',style: const TextStyle(fontSize: 12,color: Colors.white),overflow: TextOverflow.ellipsis,)

                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10,),
              widget.data![0]['tenancyType'] != null ? IntrinsicHeight(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('Lease Start Date',style: TextStyle(color: Colors.black),),
                          SizedBox(height: 5,),
                          Text('${frmtd.format(DateTime.fromMillisecondsSinceEpoch(widget.data![0]['startDate']))}',
                            style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),overflow: TextOverflow.ellipsis,textAlign: TextAlign.end,)

                        ],
                      ),
                    ),
                    VerticalDivider(color: Colors.black45,),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Lease End Date',style: TextStyle(color: Colors.black),),
                          SizedBox(height: 5,),
                          Text('${ widget.data![0]['endDate']==null ? '' : frmtd.format(DateTime.fromMillisecondsSinceEpoch(widget.data![0]['endDate']))}',style:
                          TextStyle(fontSize: 12,fontWeight: FontWeight.bold),overflow: TextOverflow.ellipsis,)

                        ],
                      ),
                    ),
                  ],
                ),
                // ): SizedBox(),
              ): IntrinsicHeight(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('Lease Start Date',style: TextStyle(color: Colors.black),),
                          SizedBox(height: 5,),
                          Text('${widget.data![0]['curEscStartDate'] == null ? '' :frmtd.format(DateTime.fromMillisecondsSinceEpoch(widget.data![0]['curEscStartDate']))}',
                            style: const TextStyle(fontSize: 12,fontWeight: FontWeight.bold),overflow: TextOverflow.ellipsis,)

                        ],
                      ),
                    ),
                    VerticalDivider(color: Colors.black45,),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Lease End Date',style: TextStyle(color: Colors.black),),
                          SizedBox(height: 5,),
                          Text('${widget.data![0]['curEscEndDate'] == null ? '' : frmtd.format(DateTime.fromMillisecondsSinceEpoch(widget.data![0]['curEscEndDate'] ?? '' ))}',
                            style: const TextStyle(fontSize: 12,fontWeight: FontWeight.bold),overflow: TextOverflow.ellipsis,)

                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10,),
              Divider(height: 0.1,color: Colors.black12,),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:  EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Property Name',style: TextStyle(color: Colors.black),),
                        SizedBox(height: 5,),
                        Text('${widget.data![0]['propName'].replaceAll(RegExp(r'\[.*?\]'), '').trim()}',
                          style:  TextStyle(fontSize: 12,fontWeight: FontWeight.bold),overflow: TextOverflow.ellipsis,)
                      ],
                    ),
                  ),
                  // Divider(height: 0.1,color: Colors.black12,),

                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Lease Type',style: TextStyle(color: Colors.black),),
                              SizedBox(height: 5,),
                              Text('${widget.data![0]['leaseType']}',
                                style: const TextStyle(fontSize: 12,fontWeight: FontWeight.bold),overflow: TextOverflow.ellipsis,)

                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  // Divider(height: 0.1,color: Colors.black12,),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Payment Frequency',style: TextStyle(color: Colors.black),),
                        SizedBox(height: 5,),
                        Text('${widget.data![0]['paymentFreq']}',style: const TextStyle(fontSize: 12,fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,)

                      ],
                    ),
                  ),
                  // Divider(height: 0.1,color: Colors.black12,),
                  widget.data![0]['tenancyType'] != null ? IntrinsicHeight(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text('Current Escalation Date',style: TextStyle(color: Colors.black),),
                              SizedBox(height: 5,),
                              Text('${widget.data![0]['curEscStartDate'] == null ? '' :frmtd.format(DateTime.fromMillisecondsSinceEpoch(widget.data![0]['curEscStartDate']))}',
                                style: const TextStyle(fontSize: 12,fontWeight: FontWeight.bold),overflow: TextOverflow.ellipsis,)

                            ],
                          ),
                        ),
                        VerticalDivider(color: Colors.black45,),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Current Escalation End Date',style: TextStyle(color: Colors.black),),
                              SizedBox(height: 5,),
                              Text('${widget.data![0]['curEscEndDate'] == null ? '' : frmtd.format(DateTime.fromMillisecondsSinceEpoch(widget.data![0]['curEscEndDate'] ?? '' ))}',
                                style: const TextStyle(fontSize: 12,fontWeight: FontWeight.bold),overflow: TextOverflow.ellipsis,)

                            ],
                          ),
                        ),
                      ],
                    ),
                  ): SizedBox(),
                  Divider(height: 0.1,color: Colors.black12,),
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Days To Expiry',style: TextStyle(color: Colors.black),),
                              SizedBox(height: 5,),
                              Text('${widget.data![0]['daysToExpire']}',
                                style: const TextStyle(fontSize: 12,fontWeight: FontWeight.bold),
                                overflow: TextOverflow.ellipsis,)

                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  // Divider(height: 0.1,color: Colors.black12,),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Account No.',style: TextStyle(color: Colors.black),),
                        SizedBox(height: 5,),
                        Text('${widget.data![0]['accountNo']}',
                          style: const TextStyle(fontSize: 12,fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,)
                      ],
                    ),
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
