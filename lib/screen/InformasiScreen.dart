import 'package:bpbd/helper/Produk.dart';
import 'package:bpbd/page/InfografisPage.dart';
import 'package:bpbd/page/ProdukPage.dart';
import 'package:bpbd/screen/HomeScreen.dart';
import 'package:flutter/material.dart';

class InformasiScreen extends StatefulWidget {
  @override
  _InformasiScreenState createState() => _InformasiScreenState();
}

class _InformasiScreenState extends State<InformasiScreen> {
  // ignore: unused_field
  GlobalKey _bottomNavigationKey = GlobalKey();
  // ignore: unused_field
  int _pageIndex = 0;

  var produklist;
  // ignore: unused_field
  bool _loading;
  bool loading = true;

  void getProduk() async {
    Produk produk = Produk();
    await produk.getProduk();
    produklist = produk.produk;
    setState(() {
      _loading = false;
    });
  }

  @override
  void initState() {
    _loading = true;
    // ignore: todo
    // TODO: implement initState
    super.initState();
    getProduk();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
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
      body: WillPopScope(
        // ignore: missing_return
        onWillPop: () {
          onWillPop();
        },
        child: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(
                    height: height * 0.3,
                    width: width,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage("assets/images/bnpb.jpg"),
                            fit: BoxFit.cover)),
                    child: Container(
                      decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [
                        Colors.black.withOpacity(0.0),
                        Colors.black.withOpacity(0.0),
                        Colors.black.withOpacity(0.1),
                        Colors.black.withOpacity(0.5),
                        Colors.black.withOpacity(1.0),
                      ], begin: Alignment.topRight, end: Alignment.bottomLeft)),
                    ),
                  ),
                  Positioned(
                    bottom: 90,
                    left: 20,
                    child: RichText(
                      text: TextSpan(
                          text: "Produk Hukum",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w300,
                              fontSize: 20),
                          children: [
                            TextSpan(
                                text: " & \nInfografis",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 24))
                          ]),
                    ),
                  )
                ],
              ),
              Transform.translate(
                offset: Offset(0.0, -(height * 0.3 - height * 0.26)),
                child: Container(
                  width: width,
                  padding: EdgeInsets.only(top: 10),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30))),
                  child: DefaultTabController(
                      length: 2,
                      child: Column(
                        children: <Widget>[
                          TabBar(
                            labelColor: Colors.black,
                            labelStyle: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                            unselectedLabelColor: Colors.grey[400],
                            unselectedLabelStyle: TextStyle(
                                fontWeight: FontWeight.normal, fontSize: 17),
                            indicatorSize: TabBarIndicatorSize.label,
                            indicatorColor: Colors.transparent,
                            tabs: <Widget>[
                              Tab(
                                child: Text("Produk Hukum"),
                              ),
                              Tab(
                                child: Text("Infografis"),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 20, right: 20, bottom: 1),
                          ),
                          Divider(),
                          Container(
                            height: height * 0.6,
                            child: TabBarView(
                              children: <Widget>[
                                ProdukPage(),
                                InfografisPage(),
                              ],
                            ),
                          )
                        ],
                      )),
                ),
              )
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
}