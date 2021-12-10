import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:bpbd/screen/HomeScreen.dart';
import 'package:bpbd/screen/login/LoginScreen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MemberScreen extends StatefulWidget {
  MemberScreen({Key key}) : super(key: key);

  @override
  _MemberScreenState createState() => _MemberScreenState();
}

class _MemberScreenState extends State<MemberScreen> {
  bool login;
  String profil = "";
  List member;
  DateTime backbuttonpressedTime;
  var theme1 = Colors.white;
  var theme2 = Color(0xff2E324F);
  var white = Colors.white;
  var black = Colors.black;
  bool switchColor = false;

  @override
  void initState() {
    super.initState();
    cekLogin();
    fetchMember();
  }

  cekLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      login = prefs.getBool('login') ?? false;
    });
  }

  fetchMember() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      profil = prefs.getString('_id') ?? "";
    });
    final response = await http
        .get(Uri.parse("https://adminbpbd.bpbd-lebak.id/api/getuserid?_id=" + profil));
    if (response.statusCode == 200) {
      setState(() {
        member = jsonDecode(response.body);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: theme1,
      appBar: AppBar(
        backgroundColor: theme1,
        elevation: 0.0,
        leading: new IconButton(
          icon: new Icon(
            Icons.arrow_back,
            color: black,
          ),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => HomeScreen()));
          },
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 8.0, 12.0, 8.0),
            child: Icon(
              Icons.more_vert,
              color: black,
            ),
          ),
        ],
      ),
      body: Container(
        width: 400,
        height: 690,
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
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                _profilePic(),
                Container(
                  child: ListView(
                    shrinkWrap: true,
                    children: member?.map((element) {
                          return DetailProfil(
                              nama: element['full_name'],
                              phone: element['phone'],
                              email: element['email'],
                              alamat: element['alamat']);
                        })?.toList() ??
                        [],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 50.0),
                ),
                _hireButton(),
                Padding(
                  padding: const EdgeInsets.fromLTRB(40.0, 8.0, 40.0, 0.0),
                  child: Divider(
                    color: Color(0xff78909c),
                    height: 50.0,
                  ),
                ),
              ],
            ),
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

  Container _profilePic() => Container(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(50.0, 30.0, 50.0, 15.0),
          child: Stack(
            alignment: const Alignment(0.9, 0.9),
            children: <Widget>[
              CircleAvatar(
                backgroundImage: AssetImage("assets/icon/user.png"),
                radius: 50.0,
              ),
            ],
          ),
        ),
      );

  MaterialButton _hireButton() => MaterialButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.0)),
        onPressed: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setBool('login', false);
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => LoginScreen(),
              ),
              (Route<dynamic> route) => false);
          setState(() {
            if (switchColor == false) {
              black = Colors.white;
              white = Colors.black;
              theme1 = Color(0xff2E324F);
              switchColor = true;
            } else {
              black = Colors.black;
              white = Colors.white;
              theme1 = Colors.white;
              switchColor = false;
            }
          });
        },
        height: 40.0,
        minWidth: 140.0,
        child: Text(
          "Log Out",
          style: TextStyle(color: Colors.white, fontSize: 18.0),
        ),
        color: Colors.orange,
      );
}

class DetailProfil extends StatelessWidget {
  final String nama;
  final String phone;
  final String email;
  final String alamat;

  DetailProfil({this.nama, this.phone, this.email, this.alamat});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 4.0),
            child: Text(nama,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 26.0,
                    fontWeight: FontWeight.bold)),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 8.0),
            child: Text(
              phone,
              style: TextStyle(
                  color: Colors.grey,
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Text(alamat,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 15.0,
                  fontWeight: FontWeight.normal)),
          Text(email,
              style: TextStyle(
                  color: Colors.black,
                  decoration: TextDecoration.underline,
                  fontSize: 15.0,
                  fontWeight: FontWeight.normal)),
        ],
      ),
    );
  }
}
