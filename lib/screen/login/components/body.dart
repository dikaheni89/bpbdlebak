import 'dart:convert';

import 'package:bpbd/components/text_field_container.dart';
import 'package:bpbd/screen/HomeScreen.dart';
import 'package:bpbd/screen/LaporanScreen.dart';
import 'package:bpbd/screen/login/components/background.dart';
import 'package:bpbd/services/Constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Body extends StatefulWidget {
  const Body({Key key}) : super(key: key);
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool visible = false;
  // ignore: unused_field
  bool _isLoading = false;
  final String sUrl = "https://adminbpbd.bpbd-lebak.id/api/";

  @override
  void initState() {
    super.initState();
  }

  _cekLogin() async {
    setState(() {
      visible = true;
    });
    final prefs = await SharedPreferences.getInstance();
    var params = "login?username=" +
        _usernameController.text +
        "&password=" +
        _passwordController.text;

    try {
      var res = await http.get(sUrl + params);
      if (res.statusCode == 200) {
        var response = json.decode(res.body);
        if (response['status'] == true) {
          prefs.setBool('login', true);
          prefs.setString('_id', response['data']['_id']);
          setState(() {
            visible = false;
          });

          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => LaporanScreen(),
              ),
              (Route<dynamic> route) => false);
        } else {
          setState(() {
            visible = false;
          });
          _showAlertDialog(context, response['message']);
        }
      }
    } catch (e) {}
  }

  _showAlertDialog(BuildContext context, String err) {
    // ignore: deprecated_member_use
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () => Navigator.pop(context),
    );
    AlertDialog alert = AlertDialog(
      title: Text("Error"),
      content: Text(err),
      actions: [
        okButton,
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      // ignore: missing_return
      onWillPop: () {
        onWillPop();
      },
      child: Background(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "LOGIN",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: size.height * 0.03),
              SvgPicture.asset(
                "assets/login/signup.svg",
                height: size.height * 0.35,
              ),
              SizedBox(height: size.height * 0.03),
              TextFieldContainer(
                child: TextField(
                  controller: _usernameController,
                  cursorColor: kPrimaryColor,
                  decoration: InputDecoration(
                    icon: Icon(
                      Icons.person,
                      color: kPrimaryColor,
                    ),
                    hintText: "Your Username",
                    border: InputBorder.none,
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.03),
              TextFieldContainer(
                child: TextField(
                  controller: _passwordController,
                  obscureText: true,
                  cursorColor: kPrimaryColor,
                  decoration: InputDecoration(
                    hintText: "Password",
                    icon: Icon(
                      Icons.lock,
                      color: kPrimaryColor,
                    ),
                    suffixIcon: Icon(
                      Icons.visibility,
                      color: kPrimaryColor,
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.03),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                width: size.width * 0.8,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(29),
                  // ignore: deprecated_member_use
                  child: FlatButton(
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                    color: kPrimaryColor,
                    onPressed: _cekLogin,
                    child: Text(
                      "LOGIN",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.03),
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
