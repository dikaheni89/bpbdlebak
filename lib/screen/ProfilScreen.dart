import 'package:bpbd/helper/Profil.dart';
import 'package:bpbd/screen/BeritaScreen.dart';
import 'package:bpbd/screen/DetailScreen.dart';
import 'package:bpbd/screen/HomeScreen.dart';
import 'package:bpbd/screen/InformasiScreen.dart';
import 'package:bpbd/screen/KontakScreen.dart';
import 'package:bpbd/screen/LaporanScreen.dart';
import 'package:bpbd/screen/MemberScreen.dart';
import 'package:bpbd/screen/RekapScreen.dart';
import 'package:bpbd/screen/constants.dart';
import 'package:bpbd/screen/login/LoginScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:shared_preferences/shared_preferences.dart';

const itemSize = 150.0;

class ProfilScreen extends StatefulWidget {
  @override
  _ProfilScreenState createState() => _ProfilScreenState();
}

class _ProfilScreenState extends State<ProfilScreen> {
  // ignore: unused_field
  bool login;
  DateTime backbuttonpressedTime;
  // ignore: unused_field
  var profilist;
  // ignore: unused_field
  bool _loading;
  bool loading = true;
  final scrollController = ScrollController();

  void onListen() {
    setState(() {});
  }

  void getProfil() async {
    Profil profil = Profil();
    await profil.getProfil();
    profilist = profil.profil;
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
    getProfil();
    cekLogin();
  }

  cekLogin() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      login = prefs.getBool('login') ?? false;
    });
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
              Container(
                child: SafeArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        height: 500,
                        padding: const EdgeInsets.only(top: 60.0, left: 32.0),
                        child: profilist == null
                            ? Center(
                                child: CircularProgressIndicator(),
                              )
                            : Swiper(
                                itemCount: profilist.length,
                                itemWidth:
                                    MediaQuery.of(context).size.width - 2 * 64,
                                layout: SwiperLayout.STACK,
                                itemBuilder: (context, index) {
                                  return InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        PageRouteBuilder(
                                          pageBuilder: (context, a, b) =>
                                              DetailScreen(
                                            detailInfo: profilist[index],
                                          ),
                                        ),
                                      );
                                    },
                                    child: Stack(
                                      children: <Widget>[
                                        Column(
                                          children: <Widget>[
                                            SizedBox(height: 100),
                                            Card(
                                              elevation: 20,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(32),
                                              ),
                                              color: Colors.white,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(32.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    SizedBox(height: 100),
                                                    Text(
                                                      profilist[index].judul,
                                                      style: TextStyle(
                                                        fontFamily: 'Avenir',
                                                        fontSize: 20,
                                                        color: const Color(
                                                            0xff47455f),
                                                        fontWeight:
                                                            FontWeight.w900,
                                                      ),
                                                      textAlign: TextAlign.left,
                                                    ),
                                                    Text(
                                                      'BPBD Lebak',
                                                      style: TextStyle(
                                                        fontFamily: 'Avenir',
                                                        fontSize: 23,
                                                        color: primaryTextColor,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                      textAlign: TextAlign.left,
                                                    ),
                                                    SizedBox(height: 32),
                                                    Row(
                                                      children: <Widget>[
                                                        Text(
                                                          'Detail More',
                                                          style: TextStyle(
                                                            fontFamily: 'Avenir',
                                                            fontSize: 18,
                                                            color:
                                                                secondaryTextColor,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                          textAlign:
                                                              TextAlign.left,
                                                        ),
                                                        Icon(
                                                          Icons.arrow_forward,
                                                          color:
                                                              secondaryTextColor,
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Hero(
                                          tag: 1,
                                          child: Image.network(
                                              'https://bpbd-lebak.id/logo.png',
                                              width: 150),
                                        ),
                                        Positioned(
                                          top: 150,
                                          right: 24,
                                          bottom: 60,
                                          child: Text(
                                            'BPBD',
                                            style: TextStyle(
                                              fontFamily: 'Avenir',
                                              fontSize: 50,
                                              color: primaryTextColor
                                                  .withOpacity(0.08),
                                              fontWeight: FontWeight.w900,
                                            ),
                                            textAlign: TextAlign.left,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
                ),
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
          child: ListItems(scrollController, login),
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
  ListItems(this.scrollController, this.login);
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
                              "assets/icon/file.png")),
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
                          onTap: () => Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MemberScreen(),
                              ),
                              (route) => false),
                          child: Image.asset(
                              "assets/icon/user.png")) : InkWell(),
                    ),
                    Text(login ? "Info Profil" : "",
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
