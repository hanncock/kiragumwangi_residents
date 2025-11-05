import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import '../Services/Services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

import '../Services/spin_loader.dart';


class Stmts extends StatefulWidget {

  final endpoint;
  const Stmts({super.key, required this.endpoint});

  @override
  State<Stmts> createState() => _StmtsState();
}


class _StmtsState extends State<Stmts> {


  List datafuture = [];
  final Auth auth = Auth();
  final f = DateFormat('yyyy-MM-dd');
  final styless = const TextStyle(fontFamily: "Muli", color: Colors.redAccent,);
  var path;
  bool loading = true;
  int _totalPages = 0;
  int _currentPage = 0;
  bool pdfReady = false;
  late PDFViewController _pdfViewController;
  bool loaded = false;
  bool exists = false;

  getFile()async{
    var fileName = "Member_Statement";
    var resu = await auth.getStatement(widget.endpoint);
    print(resu);
    var data = await http.get(Uri.parse(resu));
    // return data.bodyBytes;
    var dir = await getApplicationDocumentsDirectory();
    File file = File("${dir.path}/$fileName.pdf");
    File urlFile = await file.writeAsBytes(data.bodyBytes);
    print(urlFile);
    setState(() {
      path = urlFile.path;
      loaded = true;
      // print(path);
    });
  
    // return urlFile;
  }



  @override
  void initState(){
    super.initState();
    getFile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.blueAccent,
        label: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.share),
              onPressed: () async {
                try {
                  print('Share Invoked');
                  await Share.shareXFiles(
                    [XFile('$path')], // Use XFile instead of a raw path string
                    text: '${DateTime.now()}',
                  );
                } catch (e) {
                  print('EXCEPTION $e');
                }
              },
            ),
            const SizedBox(
              width: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  //iconSize: 50,
                  color: Colors.white,
                  onPressed: () {
                    setState(() {
                      if (_currentPage > 0) {
                        _currentPage--;
                        _pdfViewController.setPage(_currentPage);
                      }
                    });
                  },
                ),
                Text(
                  "${_currentPage + 1}/$_totalPages",
                  style: const TextStyle(color: Colors.white, fontSize: 20),
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  //iconSize: 50,
                  color: Colors.white,
                  onPressed: () {
                    setState(() {
                      if (_currentPage < _totalPages - 1) {
                        _currentPage++;
                        _pdfViewController.setPage(_currentPage);
                      }
                    });
                  },
                ),
              ],
            ),
          ],
        ),
        onPressed: () {},
      ),
      body: loaded ? PDFView(
        filePath: path,
        autoSpacing: true,
        enableSwipe: true,
        pageSnap: true,
        swipeHorizontal: true,
        nightMode: false,
        onError: (e) {
          Text(e.toString());
          //Show some error message or UI
        },
        onRender: (pages) {
          setState(() {
            _totalPages = pages!;
            pdfReady = true;
          });
        },
        onViewCreated: (PDFViewController vc) {
          setState(() {
            _pdfViewController = vc;
          });
        },
        onPageError: (page, e) {},
      ) : const LoadingSpinCircle(),
    );
  }
}
