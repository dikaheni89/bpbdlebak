import 'package:bpbd/screen/HomeScreen.dart';
import 'package:flutter/material.dart';

class DetailnewsScreen extends StatefulWidget {
  final String id;
  final String judul;
  final String image;
  final String deskripsi;
  final String tanggal;
  DetailnewsScreen({this.id, this.judul, this.image, this.deskripsi, this.tanggal});

  @override
  _DetailnewsScreenState createState() => _DetailnewsScreenState();
}

class _DetailnewsScreenState extends State<DetailnewsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: WillPopScope(
          // ignore: missing_return
          onWillPop: () {
            onWillPop();
          },
          child: getBody()),
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

  Widget getBody() {
    var size = MediaQuery.of(context).size;
    return SafeArea(
      child: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            Container(
              width: double.infinity,
              height: size.height * 0.55,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(widget.image), fit: BoxFit.cover),
              ),
              child: SafeArea(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(Icons.arrow_back, color: Colors.white)),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: size.height * 0.45),
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(30)),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Align(
                      child: Container(
                        width: 50,
                        height: 7,
                        decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(20)),
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      widget.judul,
                      style: TextStyle(fontSize: 20, height: 1.5),
                    ),
                    SizedBox(height: 4),
                    RichText(
                      text: TextSpan(
                        children: [
                          WidgetSpan(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 2.0),
                              child: Icon(Icons.calendar_today_outlined,
                                  size: 15.0),
                            ),
                          ),
                          TextSpan(
                            text: "Publish " + widget.tanggal.toString(),
                            style: TextStyle(color: Colors.black, fontSize: 10),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      widget.deskripsi,
                      style: TextStyle(height: 1.6),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
