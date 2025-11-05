import 'package:ezenresidents/Services/spin_loader.dart';
import 'package:ezenresidents/wrapp.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:ezenresidents/pages/resusables.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import '../Services/Services.dart';
import 'dart:convert';
import 'dart:io';
import 'package:mime/mime.dart';

class RepairForm extends StatefulWidget {
  final List data;
  final List categories;
  final List summary;
  const RepairForm({super.key, required this.data,required this.categories, required this.summary});

  @override
  State<RepairForm> createState() => _RepairFormState();
}

class _RepairFormState extends State<RepairForm> {

  var selectedTime = TimeOfDay.now();
  var selectedDate = DateTime.now();
  final Auth auth = Auth();
  final ImagePicker _picker = ImagePicker();
  var prioritylevel ;
  List _imageFile = [];
  var imagepath;
  bool pathavailable = true;
  late String _imageBytes;
  var priority = ['LOW', 'NORMAL', 'HIGH', 'ROUTINE'];
  late TextEditingController description = new TextEditingController();
  var selCat;
  var selCatId;
  List fileEncoded = [];
  var selctedSummary;




  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != selectedDate) {
      setState(() {
        selectedDate = picked!;
      });
    }
  }

  _selectTime(BuildContext context) async {
    final TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: selectedTime,
      initialEntryMode: TimePickerEntryMode.dial,
    );
    if (timeOfDay != selectedTime) {
      setState(() {
        selectedTime = timeOfDay!;
        // timetoSend = "${selectedTime.hour}:${selectedTime.minute}";
      });
    }
  }

  Future<void> captureImage() async {
    print('selecting');
    try {
      ImagePicker picker = ImagePicker();
      // final pickedFile = await picker.pickImage(source: source)
      final pickedFile = await picker.pickImage(source: ImageSource.camera,);
      //preferredCameraDevice: CameraDevice.back);

      setState((){
        imagepath = pickedFile!.path.toString();
      });

      var mimeType = lookupMimeType(imagepath);

      setState(() {
        // _imageFile = File(pickedFile!.path);
        _imageFile.add( File(pickedFile!.path));
        pathavailable = false;

        // imageset = true;
      });

      setState((){
        // filePath = (filess.path);
        fileEncoded .add ("data:${mimeType};base64,${base64Encode(File(imagepath).readAsBytesSync())}");
        print(fileEncoded);
      });
      // } else {
      //   // User canceled the picker
      // }

    } catch (e) {
      //return e.toString();
    }
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();



  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding:  EdgeInsets.only(left: 8.0,right: 8),
          child: Form(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Container(
                      margin: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                          )
                      ),
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text('Service Category'),
                                  ),
                                  Container(
                                    width: width*0.88,
                                    //margin: ,
                                    margin: EdgeInsets.only(left: 10, right: 10),
                                    decoration: BoxDecoration(
                                      // color: Colors.grey[300],
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(5),
                                      // border: Border(
                                      //   bottom: BorderSide(
                                      //     width: 1,
                                      //     color: Colors.black
                                      //   )
                                      // )
                                      // border: Border.only(color: Colors.black45, width: 1)
                                    ),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton2(

                                        isExpanded: true,
                                        // value: selCat == null ? '---' : selCat,
                                        hint: Text('${selCat ?? ''}  ',
                                          style: TextStyle(fontSize: 12,),
                                          softWrap: true,
                                        ),
                                        items: widget.categories.map(
                                              (list) {
                                            return DropdownMenuItem(
                                              child: Text('${list['name'].toString()}',
                                                  style: TextStyle(fontSize: 12)
                                              ),
                                              value: [list],
                                            );
                                          },
                                        ).toList(),

                                        // validator: (selCat){
                                        //   if(selCat == null){
                                        //     return '* required';
                                        //   }
                                        // },
                                        onChanged: (value) => setState(() {
                                          var cats = value as List;
                                          setState(() {
                                            selCatId = cats[0]['id'];
                                            selCat = cats[0]['name'];
                                          });
                                        }),
                                        dropdownStyleData: DropdownStyleData(
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(5)),
                                          // maxHeight: height * 0.6,
                                        ),

                                        barrierColor: Colors.black45,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                            ],
                          ),
                          SizedBox(height: 4),Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding:  EdgeInsets.all(8.0),
                                    child: Text('Priority'),
                                  ),
                                  Container(
                                    width: width * 0.88,
                                    //margin: ,
                                    margin: EdgeInsets.only(left: 10, right: 10),
                                    decoration: BoxDecoration(
                                      color: Colors.white70,
                                      // color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(5),
                                      // border: Border(
                                      //   bottom: BorderSide(
                                      //     width: 1,
                                      //     color: Colors.black
                                      //   )
                                      // )
                                      // border: Border.only(color: Colors.black45, width: 1)
                                    ),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton2(
                                        isExpanded: true,
                                        // value: prioritylevel,
                                        hint: Text('${prioritylevel ?? ''}',
                                          // style: TextStyle(fontSize: width * 0.035)
                                        ),
                                        items: priority.map(
                                              (list) {
                                            return DropdownMenuItem(
                                              child: Text(list,
                                                // style: TextStyle(fontSize: width * 0.035)
                                              ),
                                              value: list
                                            );
                                          },
                                        ).toList(),

                                        // validator: (prioritylevel){
                                        //   if(prioritylevel == null){
                                        //     return '* required';
                                        //   }
                                        // },
                                        onChanged: (value) => setState(() {
                                          prioritylevel = value.toString();
                                        }),
                                        dropdownStyleData: DropdownStyleData(
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(5)),
                                          // maxHeight: height * 0.6,
                                        ),

                                        barrierColor: Colors.black45,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),

                          SizedBox(height: 4),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              // crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text('Preffered Date'),
                                    ),
                                    GestureDetector(
                                      onTap: (){
                                        _selectDate(context);
                                      },
                                      child: Row(
                                        children: [
                                          Icon(Icons.calendar_month,color: Colors.redAccent,),
                                          Container(
                                            width: 120,
                                            decoration: BoxDecoration(
                                              // color: Colors.grey[300],
                                              color: Colors.white,

                                              borderRadius: BorderRadius.circular(5),
                                              // border: Border.all(width: 0.5)
                                              //   border: Border(
                                              //       bottom: BorderSide(
                                              //           width: 1,
                                              //           color: Colors.black
                                              //       )
                                              //   )
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.all(12.0),
                                              child: Text('${frmtd.format(selectedDate)}'),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(height: 5,),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text('Preffered Time'),
                                    ),
                                    GestureDetector(
                                      onTap: (){
                                        _selectTime(context);
                                      },
                                      child: Row(
                                        children: [
                                          Icon(Icons.timer_sharp,color: Colors.red,),
                                          Container(
                                            width: 120,
                                            decoration: BoxDecoration(

                                              borderRadius: BorderRadius.circular(5),
                                              // color: Colors.grey[300]
                                              color: Colors.white,

                                              // border: Border.all(width: 0.5)
                                              //   border: Border(
                                              //       bottom: BorderSide(
                                              //           width: 1,
                                              //           color: Colors.black
                                              //       )
                                              //   )
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(12.0),
                                              child: Text('${(selectedTime.hour)}:${selectedTime.minute}'),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                          SizedBox(height: 10),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text('Summary'),
                                  ),
                                  Container(
                                    width: width * 0.88,
                                    //margin: ,
                                    margin: EdgeInsets.only(left: 10, right: 10),
                                    decoration: BoxDecoration(
                                      color: Colors.white,

                                      // color: Colors.grey[300],
                                      borderRadius: BorderRadius.circular(5),
                                      // border: Border(
                                      //   bottom: BorderSide(
                                      //     width: 1,
                                      //     color: Colors.black
                                      //   )
                                      // )
                                      // border: Border.only(color: Colors.black45, width: 1)
                                    ),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton2(
                                        isExpanded: true,
                                        hint: Text('${selctedSummary ?? ''}  ',
                                          style: TextStyle(fontSize: 12,),
                                          softWrap: true,
                                        ),
                                        items: widget.summary.map(
                                              (list) {
                                            return DropdownMenuItem(
                                              child: Text('${list['name'].toString()}',
                                                  style: TextStyle(fontSize: 12)
                                              ),
                                              value: [list],
                                            );
                                          },
                                        ).toList(),
                                        // validator: (value){
                                        //   if(value == null){
                                        //     return '* required';
                                        //   }
                                        // },
                                        onChanged: (value) => setState(() {
                                          var cats = value as List;
                                          setState(() {
                                            selctedSummary = cats[0]['name'];
                                            description.text = cats[0]['notes'];
                                          });
                                          print(description);
                                        }),
                                        dropdownStyleData: DropdownStyleData(
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(5)),
                                          // maxHeight: height * 0.6,
                                        ),

                                        barrierColor: Colors.black45,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                            ],
                          ),
                          SizedBox(height: 10),
                          // Divider(height: 1,color: Colors.red,),
                          Container(
                            width: width * 0.9,
                            // color: Colors.grey[300],
                            color: Colors.white,
                            child: TextFormField(
                              controller: description,
                              onChanged: (newValue) {
                                setState(() {
                                  description.text = newValue;
                                });
                              },
                              validator: (val) => val!.isEmpty ? "Description" : null,
                              style: TextStyle(fontSize: 12),
                              minLines: 5,
                              maxLines: 5,
                              decoration: InputDecoration(
                                  labelText: 'Description...',
                                  suffixIcon: Icon(Icons.description,color: Colors.black,),
                                  // labelStyle: boldfont,
                                  // border: OutlineInputBorder(),
                                  border: InputBorder.none
                              ),
                            ),
                            // child: Text('Save'),
                          ),
                          SizedBox(height: 10,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width:MediaQuery.of(context).size.width * 0.5,
                                height: 100,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: _imageFile.length,
                                  itemBuilder: (context,index){
                                    return Container(
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                            border: Border.all(width: 1,color: Colors.black45)
                                        ),
                                        width: 100,
                                        height: 100,
                                        child: pathavailable
                                            ? Center(
                                            child: Icon(Icons.photo,color: Colors.redAccent,)
                                        ):Image.file(_imageFile[index])
                                    );
                                  },
                                ),
                              ),
                              _imageFile.length >= 2? Text('') :

                              Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(width: 1,color: Colors.black45)
                                  ),
                                  width: 100,
                                  height: 100,
                                  child: IconButton(
                                      onPressed: ()  {
                                        captureImage();
                                        // captureImage(ImageSource.camera,(){setState(() {

                                        // });
                                      },
                                      icon: Icon(Icons.add_a_photo_outlined)),
                              )



                              // Row(
                              //   children: [
                              //     IconButton(
                              //         onPressed: ()  {
                              //           captureImage();
                              //           // captureImage(ImageSource.camera,(){setState(() {
                              //
                              //           // });
                              //         },
                              //         icon: Icon(Icons.photo_camera)),
                              //     Text('Image'),
                              //   ],
                              // ),
                              // Row(
                              //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                              //   children: [
                              //     Container(
                              //       decoration: BoxDecoration(
                              //           borderRadius: BorderRadius.circular(10),
                              //           border: Border.all(width: 1,color: Colors.black45)
                              //       ),
                              //       width: 100,
                              //       height: 100,
                              //       child: pathavailable
                              //           ? Center(
                              //           child: Icon(Icons.photo,color: Colors.redAccent,)
                              //       ):Image.file(_imageFile)
                              //     ),
                              //   ],
                              // ),

                            ],
                          ),

                        ],
                      ),
                    )
                  ],
                ),
                SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: ()async{
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.redAccent,
                              borderRadius: BorderRadius.circular(10)
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 50.0,vertical: 10),
                            child: Text('Cancel',style: TextStyle(color: Colors.white),),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: ()async{
                          if(selCat  == null ){
                            Fluttertoast.showToast(
                                msg:  'Input Service Category',
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 1,
                                //backgroundColor: Colors.white,
                                textColor: Colors.white,
                                fontSize: 16.0
                            );
                          }else{
                            if(prioritylevel == null){
                              Fluttertoast.showToast(
                                  msg:  'Input Priority ',
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIosWeb: 1,
                                  //backgroundColor: Colors.white,
                                  textColor: Colors.white,
                                  fontSize: 16.0
                              );
                            }else{
                              if(selctedSummary == null){
                                Fluttertoast.showToast(
                                    msg:  'Input Summary',
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 1,
                                    //backgroundColor: Colors.white,
                                    textColor: Colors.white,
                                    fontSize: 16.0
                                );
                              }else{
                                if (_formKey.currentState!.validate()) {

                                  showDialog(context: context, builder: (context) => LoadingSpinCircle());

                                  Map data = {
                                    "priority": "LOW",
                                    "raisedByTnt": "YES",
                                    "description": description.text,
                                    "propertyId": widget.data[0]['propertyId'],
                                    "preferredDate": "${f.format(selectedDate)}",
                                    "summary": "${selctedSummary}",
                                    "preferredTime": "${selectedTime.hour}:${selectedTime.minute}",
                                    "putmId": "${Userdata[1]['uniqTenantId']}",
                                    "serviceCatId": "${selCatId}",
                                    "attachments":fileEncoded,

                                  };
                                  print(data);
                                  print(Userdata[1]['uniqTenantId']);
                                  var resu = await auth.saveworkorder(data);
                                  Navigator.of(context).pop();
                                  print(resu);
                                  if (resu['success'] == 'true') {
                                    Navigator.of(context).pop();
                                  } else {
                                    Fluttertoast.showToast(
                                        msg: resu['message'],
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.CENTER,
                                        timeInSecForIosWeb: 1,
                                        //backgroundColor: Colors.white,
                                        textColor: Colors.white,
                                        fontSize: 16.0
                                    );
                                  }
                                  // here do what you want when the form is validate :)
                                }
                              }
                            }
                          }

                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(10)
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 50.0,vertical: 10),
                            child: Text('Save',style: TextStyle(color: Colors.white),),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20,)
              ],
            ),
          ),
        ),
      ),
    );
  }
}