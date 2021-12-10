import 'package:bpbd/screen/BeritaScreen.dart';
import 'package:bpbd/screen/HomeScreen.dart';
import 'package:bpbd/screen/InformasiScreen.dart';
import 'package:bpbd/screen/LaporanScreen.dart';
import 'package:bpbd/screen/ProfilScreen.dart';
import 'package:bpbd/screen/RekapScreen.dart';
import 'package:bpbd/screen/login/LoginScreen.dart';
import 'package:bpbd/services/ShowToast.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
// ignore: unused_import
import 'package:url_launcher/url_launcher.dart';

class KontakScreen extends StatefulWidget {
  @override
  _KontakScreenState createState() => _KontakScreenState();
}

class _KontakScreenState extends State<KontakScreen> {
  bool login;
  var fileImage;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController namaController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController alamatController = TextEditingController();
  final TextEditingController isiController = TextEditingController();

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
    var saveUrl = Uri.parse("https://adminbpbd.bpbd-lebak.id/api/savekontak");
    var request = http.MultipartRequest("POST", saveUrl);
    var uploadImg = await http.MultipartFile.fromPath("image", fileImage);

    request.fields['nama'] = namaController.text;
    request.fields['email'] = emailController.text;
    request.fields['phone'] = phoneController.text;
    request.fields['alamat'] = alamatController.text;
    request.fields['isi'] = isiController.text;
    request.files.add(uploadImg);
    var response = await request.send();

    if (response.statusCode == 200) {
      print(response.reasonPhrase);
    }
  }

  // ignore: unused_element
  _logOut() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('login', false);
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => LoginScreen(),
        ),
        (Route<dynamic> route) => false);
  }

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    cekLogin();
  }

  cekLogin() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      login = prefs.getBool('login') ?? false;
    });
  }

  // ignore: unused_field
  final List<Widget> _children = [];
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
                            controller: namaController,
                            validator: (String value) {
                              if (value.isEmpty) {
                                return 'Nama Lengkap Tidak Boleh Kosong';
                              }
                              return null;
                            },
                            style: TextStyle(height: 0.5, color: Colors.black),
                            decoration: InputDecoration(
                              labelText: 'Nama Lengkap',
                              hintText: 'Nama Lengkap',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0)),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 20.0),
                          ),
                          TextFormField(
                            controller: emailController,
                            validator: (String value) {
                              if (value.isEmpty) {
                                return 'E-Mail Tidak Boleh Kosong';
                              }
                              return null;
                            },
                            style: TextStyle(height: 0.5, color: Colors.black),
                            decoration: InputDecoration(
                              labelText: 'E-mail',
                              hintText: 'E-mail',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0)),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 20.0),
                          ),
                          TextFormField(
                            controller: phoneController,
                            validator: (String value) {
                              if (value.isEmpty) {
                                return 'Nomor Telp/Wa Tidak Boleh Kosong';
                              }
                              return null;
                            },
                            style: TextStyle(height: 0.5, color: Colors.black),
                            decoration: InputDecoration(
                              labelText: 'phone',
                              hintText: 'phone',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0)),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 20.0),
                          ),
                          TextFormField(
                            controller: alamatController,
                            validator: (String value) {
                              if (value.isEmpty) {
                                return 'Alamat Pesan Tidak Boleh Kosong';
                              }
                              return null;
                            },
                            style: TextStyle(height: 0.5, color: Colors.black),
                            decoration: InputDecoration(
                              labelText: 'Alamat Pesan',
                              hintText: 'Alamat Pesan',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0)),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 20.0),
                          ),
                          TextFormField(
                            controller: isiController,
                            validator: (String value) {
                              if (value.isEmpty) {
                                return 'Isi Pesan Tidak Boleh Kosong';
                              }
                              return null;
                            },
                            maxLines: 3,
                            decoration: InputDecoration(
                              labelText: 'Isi Pesan',
                              hintText: 'Isi Pesan',
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
                                  borderRadius: new BorderRadius.circular(10.0)),
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
                            padding: EdgeInsets.only(top: 35.0),
                          ),
                          ButtonTheme(
                            buttonColor: Colors.amber[900],
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
                                if (_formKey.currentState.validate()) {
                                  addData();
                                  ShowToast()
                                      .showToastSuccess('Berhasil Terkirim');
                                  setState(() {
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => KontakScreen(),
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
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              BottomSheet(login),
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

class BottomSheet extends StatelessWidget {
  final login;
  BottomSheet(this.login);

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.050,
      minChildSize: 0.050,
      maxChildSize: 0.4,
      builder: (context, scrollController) {
        return Container(
          child: ListItems(scrollController,login),
          padding: EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
            color: Colors.orange[200],
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
        );
      },
    );
  }
}

class ListItems extends StatelessWidget {
  final ScrollController scrollController;
  final login;
  ListItems(this.scrollController,this.login);
  @override
  Widget build(BuildContext context) {
    return ListView(
      controller: this.scrollController,
      shrinkWrap: true,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Center(
            child: Container(
              height: 8,
              width: 80,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            child: Row(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    SizedBox(
                      width: 100,
                      height: 50,
                      child: InkWell(
                          onTap: () => Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HomeScreen(),
                              ),
                              (route) => false),
                          child: Image.asset("assets/icon/home.png")),
                    ),
                    Text("Home",
                        style: TextStyle(
                            fontSize: 9, fontWeight: FontWeight.bold)),
                  ],
                ),
                Column(
                  children: <Widget>[
                    SizedBox(
                      width: 100,
                      height: 50,
                      child: InkWell(
                          onTap: () => Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BeritaScreen(),
                              ),
                              (route) => false),
                          child: Image.asset("assets/icon/news.png")),
                    ),
                    Text("Berita",
                        style: TextStyle(
                            fontSize: 9, fontWeight: FontWeight.bold)),
                  ],
                ),
                Column(
                  children: <Widget>[
                    SizedBox(
                      width: 100,
                      height: 50,
                      child: InkWell(
                          onTap: () => Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProfilScreen(),
                              ),
                              (route) => false),
                          child: Image.asset("assets/icon/laporan.png")),
                    ),
                    Text("Profil BPBD",
                        style: TextStyle(
                            fontSize: 9, fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            child: Row(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    SizedBox(
                      width: 100,
                      height: 50,
                      child: InkWell(
                          onTap: () => Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => KontakScreen(),
                              ),
                              (route) => false),
                          child: Image.asset(
                              "assets/icon/data.png")),
                    ),
                    Text("Lapor",
                        style: TextStyle(
                            fontSize: 9, fontWeight: FontWeight.bold)),
                  ],
                ),
                Column(
                  children: <Widget>[
                    SizedBox(
                      width: 100,
                      height: 50,
                      child: InkWell(
                          onTap: () => Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => InformasiScreen()
                              ),
                              (route) => false),
                          child: Image.asset(
                              "assets/icon/produk.png")),
                    ),
                    Text("Produk Hukum",
                        style: TextStyle(
                            fontSize: 9, fontWeight: FontWeight.bold)),
                  ],
                ),
                Column(
                  children: <Widget>[
                    SizedBox(
                      width: 100,
                      height: 50,
                      child: InkWell(
                          onTap: () => Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => login ? LaporanScreen() : LoginScreen(),
                              ),
                              (route) => false),
                          child: Image.asset(
                              "assets/icon/pelaporan.png")),
                    ),
                    Text("Pelaporan Relawan",
                        style: TextStyle(
                            fontSize: 9, fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            child: Row(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    SizedBox(
                      width: 100,
                      height: 50,
                      child: InkWell(
                          onTap: () => Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => login ? RekapScreen() : LoginScreen(),
                              ),
                              (route) => false),
                          child: Image.asset(
                              "assets/icon/pelaporan.png")),
                    ),
                    Text("Rekap Data",
                        style: TextStyle(
                            fontSize: 9, fontWeight: FontWeight.bold)),
                  ],
                ),
                Column(
                  children: <Widget>[
                    SizedBox(
                      width: 100,
                      height: 50,
                      child: login ? InkWell(
                          onTap: () async {
                              SharedPreferences prefs = await SharedPreferences.getInstance();
                              prefs.setBool('login', false);
                              Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => LoginScreen(),
                                    ),
                                    (Route<dynamic> route) => false);
                            },
                          child: Image.asset(
                              "assets/icon/setting.png")) : InkWell(),
                    ),
                    Text(login ? "Logout" : "",
                        style: TextStyle(
                            fontSize: 9, fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
