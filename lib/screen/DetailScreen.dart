import 'package:bpbd/model/ProfilModel.dart';
import 'package:bpbd/screen/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';


class DetailScreen extends StatelessWidget {
  final ProfilModel detailInfo;

  const DetailScreen({Key key, this.detailInfo}) : super(key: key);

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
                  "BPBD KABUPATEN LEBAK",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: <Widget>[
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 2.0, left: 10.0, right: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(height: 50),
                        Text(
                          detailInfo.judul,
                          style: TextStyle(
                            fontFamily: 'Avenir',
                            fontSize: 28,
                            color: primaryTextColor,
                            fontWeight: FontWeight.w900,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        Text(
                          'BPBD',
                          style: TextStyle(
                            fontFamily: 'Avenir',
                            fontSize: 20,
                            color: primaryTextColor,
                            fontWeight: FontWeight.w300,
                          ),
                          textAlign: TextAlign.right,
                        ),
                        Divider(color: Colors.black38),
                        SizedBox(height: 12),
                        Text(
                          detailInfo.deskripsi ?? '',
                          maxLines: 300,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: 'Avenir',
                            fontSize: 14,
                            color: contentTextColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 32),
                        Divider(color: Colors.black38),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 60,
              left: 32,
              child: Text(
                'BPBD',
                style: TextStyle(
                  fontFamily: 'Avenir',
                  fontSize: 150,
                  color: primaryTextColor.withOpacity(0.08),
                  fontWeight: FontWeight.w900,
                ),
                textAlign: TextAlign.left,
              ),
            ),
          ],
        ),
      ),
    );
  }
}