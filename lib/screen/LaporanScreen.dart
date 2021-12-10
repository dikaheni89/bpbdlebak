import 'dart:convert';

import 'package:bpbd/screen/HomeScreen.dart';
import 'package:bpbd/services/ShowToast.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';

class LaporanScreen extends StatefulWidget {
  @override
  _LaporanScreenState createState() => _LaporanScreenState();
}

class _LaporanScreenState extends State<LaporanScreen> {
  bool login;
  DateTime selectedDate = DateTime.now();
  var fileImage;
  final _formKey = GlobalKey<FormState>();
  String selectedDesa;
  String selectedKecamatan;
  String selectedJenis;
  final TextEditingController tanggalController = TextEditingController();
  final TextEditingController uraianController = TextEditingController();
  final TextEditingController kecamatanController = TextEditingController();
  final TextEditingController rugiController = TextEditingController();
  final TextEditingController realisasiController = TextEditingController();
  final TextEditingController keteranganController = TextEditingController();

  List jenislist;
  List kecamatanlist;
  List desalist;
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

  getAllDesa() async {
    final response = await http
        .get(Uri.parse("https://adminbpbd.bpbd-lebak.id/api/getdesa"));
    if (response.statusCode == 200) {
      setState(() {
        desalist = jsonDecode(response.body);
        _loading = false;
      });
    }
  }

  getAllKecamatan() async {
    final response = await http
        .get(Uri.parse("https://adminbpbd.bpbd-lebak.id/api/getkecamatan"));
    if (response.statusCode == 200) {
      setState(() {
        kecamatanlist = jsonDecode(response.body);
        _loading = false;
      });
    }
  }

  fileimg() async {
    FilePickerResult result = await FilePicker.platform.pickFiles();
    if (result != null) {
      PlatformFile file = result.files.first;

      print(file.name);
      print(file.bytes);
      print(file.size);
      print(file.extension);
      print(file.path);
      setState(() {
        fileImage = file.path;
      });
      print(fileImage);
    } else {
      // User canceled the picker
    }
  }

  void addData() async {
    var saveUrl = Uri.parse("https://adminbpbd.bpbd-lebak.id/api/savelaporan");
    var request = http.MultipartRequest("POST", saveUrl);
    var uploadImg = await http.MultipartFile.fromPath("gambar1", fileImage);
    request.fields['tgl'] = tanggalController.text;
    request.fields['idjenis'] = selectedJenis;
    request.fields['uraian'] = uraianController.text;
    request.fields['desa'] = selectedDesa;
    request.fields['kecamatan'] = selectedKecamatan;
    request.fields['rugi'] = rugiController.text;
    request.fields['realisasi'] = realisasiController.text;
    request.fields['keterangan'] = keteranganController.text;
    request.files.add(uploadImg);
    var response = await request.send();

    if (response.statusCode == 200) {
      print(response.reasonPhrase);
    }
  }

  @override
  void initState() {
    super.initState();
    getAllJenis();
    getAllDesa();
    getAllKecamatan();
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
                    padding:
                        EdgeInsets.only(top: 50.0, right: 10.0, left: 10.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            controller: tanggalController,
                            validator: (String value) {
                              if (value.isEmpty) {
                                return 'Tanggal Kejadian Tidak Boleh Kosong';
                              }
                              return null;
                            },
                            style: TextStyle(height: 0.5, color: Colors.black),
                            decoration: InputDecoration(
                              labelText: 'Tanggal Kejadian',
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
                                  tanggalController.text =
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
                          TextFormField(
                            maxLines: 3,
                            controller: uraianController,
                            validator: (String value) {
                              if (value.isEmpty) {
                                return 'Uraian Tidak Boleh Kosong';
                              }
                              return null;
                            },
                            style: TextStyle(height: 0.5, color: Colors.black),
                            decoration: InputDecoration(
                              labelText: 'Uraian',
                              hintText: 'Uraian',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0)),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 20.0),
                          ),
                          Center(
                            child: kecamatanlist == null
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
                                    child: SearchableDropdown(
                                    value: selectedKecamatan,
                                    hint: Text('Pilih Kecamatan'),
                                    icon: Icon(Icons.arrow_drop_down),
                                    iconSize: 36,
                                    isExpanded: true,
                                    underline: SizedBox(),
                                    items: kecamatanlist?.map(
                                    (list) {
                                      return DropdownMenuItem(
                                        child: Text(list['kecamatan']),
                                        value: list['kecamatan'].toString(),
                                      );
                                    },
                              )?.toList() ??
                              [],
                              onChanged: (value){
                                    setState(() {
                                      selectedKecamatan = value;
                                    });
                              },
                            ),
                                  ),
                                ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 20.0),
                          ),
                          Center(
                            child: desalist == null
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
                                    child: SearchableDropdown(
                                    value: selectedDesa,
                                    hint: Text('Pilih Desa / Kelurahan'),
                                    icon: Icon(Icons.arrow_drop_down),
                                    iconSize: 36,
                                    isExpanded: true,
                                    underline: SizedBox(),
                                    items: desalist?.map(
                                    (list) {
                                      return DropdownMenuItem(
                                        child: Text(list['desa']),
                                        value: list['desa'].toString(),
                                      );
                                    },
                              )?.toList() ??
                              [],
                              onChanged: (value){
                                    setState(() {
                                      selectedDesa = value;
                                    });
                              },
                            ),
                                  ),
                                ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 20.0),
                          ),
                          TextFormField(
                            controller: rugiController,
                            validator: (String value) {
                              if (value.isEmpty) {
                                return 'Estimasi Kerugian (Rp) Tidak Boleh Kosong';
                              }
                              return null;
                            },
                            style: TextStyle(height: 0.5, color: Colors.black),
                            decoration: InputDecoration(
                              labelText: 'Estimasi Kerugian (Rp)',
                              hintText: 'Estimasi Kerugian (Rp)',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0)),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 20.0),
                          ),
                          TextFormField(
                            maxLines: 3,
                            controller: realisasiController,
                            validator: (String value) {
                              if (value.isEmpty) {
                                return 'Realisasi Penanganan Tidak Boleh Kosong';
                              }
                              return null;
                            },
                            style: TextStyle(height: 0.5, color: Colors.black),
                            decoration: InputDecoration(
                              labelText: 'Realisasi Penanganan',
                              hintText: 'Realisasi Penanganan',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0)),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 20.0),
                          ),
                          TextFormField(
                            controller: keteranganController,
                            validator: (String value) {
                              if (value.isEmpty) {
                                return 'Keterangan Kejadian Tidak Boleh Kosong';
                              }
                              return null;
                            },
                            maxLines: 3,
                            decoration: InputDecoration(
                              labelText: 'Keterangan',
                              hintText: 'Keterangan',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0)),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 20.0),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: ButtonTheme(
                              buttonColor: Colors.blueGrey[50],
                              minWidth: 500.0,
                              height: 50.0,
                              textTheme: ButtonTextTheme.accent,
                              colorScheme: Theme.of(context)
                                  .colorScheme
                                  .copyWith(secondary: Colors.white),
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      new BorderRadius.circular(10.0)),
                              // ignore: deprecated_member_use
                              child: RaisedButton(
                                onPressed: () {
                                  fileimg();
                                },
                                child: Text(
                                  "Choose Gambar Kejadian",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                              ),
                            ),
                          ),
                          Text(fileImage != null
                              ? fileImage
                              : "Select Photo Kejadian"),
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
                                  borderRadius:
                                      new BorderRadius.circular(30.0)),
                              // ignore: deprecated_member_use
                              child: RaisedButton(
                                onPressed: () {
                                  if (_formKey.currentState.validate()) {
                                    addData();
                                    ShowToast()
                                        .showToastSuccess('Berhasil Tersimpan');
                                    setState(() {
                                      Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => HomeScreen(),
                                          ),
                                          (route) => false);
                                    });
                                  }
                                },
                                child: Text(
                                  "Kirim",
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
