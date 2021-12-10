import 'dart:convert';

import 'package:bpbd/screen/HomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

class RekapScreen extends StatefulWidget {
  RekapScreen({Key key}) : super(key: key);

  @override
  _RekapScreenState createState() => _RekapScreenState();
}

class _RekapScreenState extends State<RekapScreen> {
  bool visible = false;
  final String sUrl = "https://adminbpbd.bpbd-lebak.id/api/";
  DateTime selectedDate = DateTime.now();
  var fileImage;
  final _formKey = GlobalKey<FormState>();
  String selectedJenis;
  final TextEditingController tanggaliController = TextEditingController();
  final TextEditingController tanggaliiController = TextEditingController();

  List jenislist;
  bool _loading;

  getAllJenis() async {
    final response = await http
        .get(Uri.parse("https://adminbpbd.bpbd-lebak.id/api/getjenis"));
    if (response.statusCode == 200) {
      setState(() {
        jenislist = jsonDecode(response.body);
        _loading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getAllJenis();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: false,
        backgroundColor: Colors.white,
        title: Text(' '),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset("assets/images/logo.png", width: 40),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  children: [
                    Text(""),
                  ],
                ),
                Text(
                  "BPBD Kabupaten Lebak",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  "",
                  style: TextStyle(
                      color: Colors.blue,
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: WillPopScope(
          // ignore: missing_return
          onWillPop: () {
            onWillPop();
          },
          child: Stack(
            children: [
              ListView(
                children: [
                  Container(
                    padding: EdgeInsets.only(top: 50.0, right: 10.0, left: 10.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            controller: tanggaliController,
                            validator: (String value) {
                              if (value.isEmpty) {
                                return 'Tanggal mulai Tidak Boleh Kosong';
                              }
                              return null;
                            },
                            style: TextStyle(height: 0.5, color: Colors.black),
                            decoration: InputDecoration(
                              labelText: 'Tanggal mulai',
                              hintText: 'xxxx-xx-xx',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0)),
                            ),
                            onTap: () async {
                              await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2015),
                                lastDate: DateTime(2025),
                              ).then((selectedDate) {
                                if (selectedDate != null) {
                                  tanggaliController.text =
                                      DateFormat('yyyy-MM-dd')
                                          .format(selectedDate);
                                }
                              });
                            },
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 20.0),
                          ),
                          TextFormField(
                            controller: tanggaliiController,
                            validator: (String value) {
                              if (value.isEmpty) {
                                return 'Tanggal akhir Tidak Boleh Kosong';
                              }
                              return null;
                            },
                            style: TextStyle(height: 0.5, color: Colors.black),
                            decoration: InputDecoration(
                              labelText: 'Tanggal Akhir',
                              hintText: 'xxxx-xx-xx',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0)),
                            ),
                            onTap: () async {
                              await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2015),
                                lastDate: DateTime(2025),
                              ).then((selectedDate) {
                                if (selectedDate != null) {
                                  tanggaliiController.text =
                                      DateFormat('yyyy-MM-dd')
                                          .format(selectedDate);
                                }
                              });
                            },
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 20.0),
                          ),
                          Center(
                            child: jenislist == null
                                ? Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : Padding(
                                  padding: const EdgeInsets.all(0.0),
                                  child: Container(
                                    padding: EdgeInsets.only(left: 10, right: 10),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.grey,
                                        width: 1
                                      ),
                                      borderRadius: BorderRadius.circular(20)
                                    ),
                                    child: DropdownButton(
                              value: selectedJenis,
                              hint: Text('Pilih Jenis Bencana'),
                              icon: Icon(Icons.arrow_drop_down),
                              iconSize: 36,
                              isExpanded: true,
                              underline: SizedBox(),
                              items: jenislist?.map(
                                    (list) {
                                      return DropdownMenuItem(
                                        child: Text(list['jenis']),
                                        value: list['id'].toString(),
                                      );
                                    },
                              )?.toList() ??
                              [],
                              onChanged: (value){
                                    setState(() {
                                      selectedJenis = value;
                                    });
                              },
                            ),
                                  ),
                                ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 20.0),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 40.0),
                            child: ButtonTheme(
                              buttonColor: Colors.orange[400],
                              minWidth: 200.0,
                              height: 50.0,
                              textTheme: ButtonTextTheme.accent,
                              colorScheme: Theme.of(context)
                                  .colorScheme
                                  .copyWith(secondary: Colors.white),
                              shape: RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(30.0)),
                              // ignore: deprecated_member_use
                              child: RaisedButton(
                                onPressed: () {
                                  _launchExport(
                                      tanggaliController.text.toString(),
                                      tanggaliiController.text.toString(),
                                      selectedJenis.toString());
                                },
                                child: Text(
                                  "Export to Excel",
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onWillPop() {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(),
        ),
        (route) => false);
  }
}

void _launchExport(String start, String end, String jenis,
    {bool forceWebView = false, bool enableJavaScript = false}) async {
  final String excel =
      "https://adminbpbd.bpbd-lebak.id/api/rekaplaporan?start=$start&end=$end&jenis=$jenis";
  await launch(excel,
      forceWebView: forceWebView, enableJavaScript: enableJavaScript);
}
