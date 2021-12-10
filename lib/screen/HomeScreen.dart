import 'dart:async';
import 'dart:convert';

import 'package:bpbd/helper/News.dart';
import 'package:bpbd/helper/Widget.dart';
import 'package:bpbd/screen/BeritaScreen.dart';
import 'package:bpbd/screen/InformasiScreen.dart';
import 'package:bpbd/screen/KontakScreen.dart';
import 'package:bpbd/screen/LaporanScreen.dart';
import 'package:bpbd/screen/MemberScreen.dart';
import 'package:bpbd/screen/ProfilScreen.dart';
import 'package:bpbd/screen/RekapScreen.dart';
import 'package:bpbd/screen/login/LoginScreen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool login;
  DateTime backbuttonpressedTime;
  // ignore: unused_field
  var newslist;
  // ignore: unused_field
  bool _loading;
  List cuacaself;
  List cuacalist;
  List gempalist;
  List rekomlist;
  bool loading = true;

  fetchSelfCuaca() async {
    final response = await http
        .get(Uri.parse("https://bpbd-lebak.id/cuaca/cuacaself.php"));
    if (response.statusCode == 200) {
      setState(() {
        cuacaself = jsonDecode(response.body);
        _loading = false;
      });
    }
  }

  fetchAllCuaca() async {
    final response =
        await http.get(Uri.parse("https://bpbd-lebak.id/cuaca/cuacaapi.php"));
    if (response.statusCode == 200) {
      setState(() {
        cuacalist = jsonDecode(response.body);
        _loading = false;
      });
    }
  }

  fetchAllGempa() async {
    final response =
        await http.get(Uri.parse("https://bpbd-lebak.id/gempa/gempaapi.php"));
    if (response.statusCode == 200) {
      setState(() {
        gempalist = jsonDecode(response.body);
        _loading = false;
      });
    }
  }

  fetchAllRekomendasi() async {
    final response = await http
        .get(Uri.parse("https://adminbpbd.bpbd-lebak.id/api/getlink"));
    if (response.statusCode == 200) {
      setState(() {
        rekomlist = jsonDecode(response.body);
        _loading = false;
      });
    }
  }

  void getNews() async {
    News news = News();
    await news.getNews();
    newslist = news.news;
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
    fetchSelfCuaca();
    fetchAllCuaca();
    fetchAllGempa();
    fetchAllRekomendasi();
    getNews();
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
      body: WillPopScope(
        onWillPop: onWillPop,
        child: Stack(
          children: [
            Container(
              child: Scaffold(
                resizeToAvoidBottomInset: false,
                body: Stack(
                  children: [
                    Container(
                      child: ListView(
                        shrinkWrap: true,
                        children: [
                          LimitedBox(
                            child: Stack(
                              children: cuacaself ?.map((element) {
                                    return SelfCuaca(
                                      hari: element['hari'],
                                      waktu: element['waktu'],
                                      gambar: element['gambar'],
                                      judul: element['judul'],
                                      suhu: element['suhu'],
                                      kelembaban: element['kelembaban'],
                                      angin: element['angin'],
                                    );
                                  })?.toList() ??
                                  [],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(50.0),
                          ),
                          Column(
                            children: [
                              SectionTile(
                                text: "Prakiraan Cuaca",
                              ),
                              SizedBox(height: 10),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: cuacalist?.map((element) {
                                        return CuacaAll(
                                          hari: element['hari'],
                                          waktu: element['waktu'],
                                          gambar: element['gambar'],
                                          judul: element['judul'],
                                          suhu: element['suhu'],
                                          kelembaban: element['kelembaban'],
                                          angin: element['angin'],
                                        );
                                      })?.toList() ??
                                      [],
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(1.0),
                          ),
                          LimitedBox(
                            child: Stack(
                              children: gempalist?.map((element) {
                                    return GempaTer(
                                      judul: element['judul'],
                                      waktu: element['waktu'],
                                      lintang: element['lintang'],
                                      bujur: element['bujur'],
                                      magnitudo: element['magnitudo'],
                                      kedalaman: element['kedalaman'],
                                      wilayah: element['wilayah'],
                                    );
                                  })?.toList() ??
                                  [],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                          ),
                          Container(
                            color: Colors.grey[200],
                            height: 8,
                          ),
                          Column(
                            children: [
                              SectionTile(
                                text: "Recomendasi Link",
                              ),
                              SizedBox(height: 20),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: rekomlist?.map((element) {
                                        return RecomendasiLink(
                                          gambar: element['gambar'],
                                          press: () {
                                            urlBrowser(element['url']);
                                          },
                                        );
                                      })?.toList() ??
                                      [],
                                ),
                              ),
                            ],
                          ),
                          Container(
                            color: Colors.grey[200],
                            height: 8,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Berita Terbaru",
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold)),
                          ),
                          SafeArea(
                            child: newslist == null
                                ? Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : Container(
                                    margin: EdgeInsets.only(top: 16),
                                    child: ListView.builder(
                                        itemCount: newslist.length,
                                        shrinkWrap: true,
                                        physics: ClampingScrollPhysics(),
                                        itemBuilder: (context, index) {
                                          return NewsTile(
                                            image: newslist[index].image ?? "",
                                            judul: newslist[index].judul ?? "",
                                            deskripsi:
                                                newslist[index].deskripsi ?? "",
                                            tanggal:
                                                newslist[index].tanggal ?? "",
                                            id: newslist[index].id ?? "",
                                          );
                                        },
                                      ),
                                  ),
                          ),
                        ],
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
    );
  }

  Future<bool> onWillPop() async {
    DateTime currentTime = DateTime.now();

    //bifbackbuttonhasnotbeenpreedOrToasthasbeenclosed
    //Statement 1 Or statement2
    bool backButton = backbuttonpressedTime == null ||
        currentTime.difference(backbuttonpressedTime) > Duration(seconds: 3);

    if (backButton) {
      backbuttonpressedTime = currentTime;
      Fluttertoast.showToast(
          msg: "Klik Dua Kali Untuk Keluar Aplikasi",
          backgroundColor: Colors.black,
          textColor: Colors.white);
      return false;
    }
    return true;
  }
}

Future<void> urlBrowser(String url,
    {bool forceWebView = false, bool enableJavaScript = false}) async {
  await launch(url,
      forceWebView: forceWebView, enableJavaScript: enableJavaScript);
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
                          child:
                              Image.asset("assets/icon/home.png")),
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
                          child:
                              Image.asset("assets/icon/news.png")),
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
                        child: Image.asset(
                            "assets/icon/laporan.png")),
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

class SectionTile extends StatelessWidget {
  const SectionTile({
    Key key,
    @required this.text,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 1.0, left: 8.0),
      child: Row(
        children: [
          Text(
            text,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class RecomendasiLink extends StatelessWidget {
  RecomendasiLink({
    this.gambar,
    @required this.press,
  });

  final String gambar;
  final GestureTapCallback press;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 1.0, bottom: 10.0, left: 10.0),
      child: SizedBox(
        width: 340.0,
        height: 100.0,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: Stack(
            children: [
              Image.network(gambar,
                  width: MediaQuery.of(context).size.width, fit: BoxFit.cover),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF343434).withOpacity(0.4),
                      Color(0xFF343434).withOpacity(0.15)
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: press,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SelfCuaca extends StatelessWidget {
  final String hari;
  final String waktu;
  final String gambar;
  final String judul;
  final String suhu;
  final String kelembaban;
  final String angin;

  SelfCuaca({
    this.hari,
    this.waktu,
    this.gambar,
    this.judul,
    this.suhu,
    this.kelembaban,
    this.angin,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 1.0, bottom: 10.0, left: 10.0),
      child: SizedBox(
        width: 340.0,
        height: 200.0,
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                'assets/images/bnpb.jpg',
              ),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(25),
              bottomRight: Radius.circular(25),
            ),
          ),
          child: Stack(
            children: <Widget>[
              Container(
                child: Align(
                  alignment: Alignment(0.0, 1.0),
                  child: SizedBox(
                    height: 10,
                    width: 10,
                    child: OverflowBox(
                      minWidth: 0.0,
                      maxWidth: MediaQuery.of(context).size.width,
                      minHeight: 0.0,
                      maxHeight: (MediaQuery.of(context).size.height / 4),
                      child: Stack(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            width: double.infinity,
                            height: double.infinity,
                            child: Card(
                              color: Colors.white,
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.only(
                                        top: 15, left: 20, right: 20),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Center(
                                          child: Text(
                                            'KABUPATEN LEBAK',
                                            style: Theme.of(context)
                                                .textTheme
                                                .caption
                                                .copyWith(
                                                  color: Colors.black,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'flutterfonts',
                                                ),
                                          ),
                                        ),
                                        Center(
                                          child: Text(
                                            hari,
                                            style: Theme.of(context)
                                                .textTheme
                                                .caption
                                                .copyWith(
                                                  color: Colors.black,
                                                  fontSize: 12,
                                                  fontFamily: 'flutterfonts',
                                                ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Divider(),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Container(
                                        padding: EdgeInsets.only(left: 50),
                                        child: Column(
                                          children: <Widget>[
                                            Text(
                                              judul,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .caption
                                                  .copyWith(
                                                    color: Colors.black,
                                                    fontSize: 12,
                                                    fontFamily:
                                                        'flutterfonts',
                                                  ),
                                            ),
                                            SizedBox(height: 10),
                                            Text(
                                              suhu,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline2
                                                  .copyWith(
                                                      color: Colors.black,
                                                      fontSize: 40,
                                                      fontFamily:
                                                          'flutterfonts'),
                                            ),
                                            Text(
                                              angin,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .caption
                                                  .copyWith(
                                                    color: Colors.black,
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.bold,
                                                    fontFamily:
                                                        'flutterfonts',
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(right: 20),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Container(
                                              width: 75,
                                              height: 70,
                                              child: Image.network(
                                                gambar,
                                              ),
                                            ),
                                            Container(
                                              child: Text(
                                                kelembaban,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .caption
                                                    .copyWith(
                                                      color: Colors.black,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontFamily:
                                                          'flutterfonts',
                                                    ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GempaTer extends StatelessWidget {
  final String judul;
  final String waktu;
  final String lintang;
  final String bujur;
  final String magnitudo;
  final String kedalaman;
  final String wilayah;

  GempaTer({
    this.judul,
    this.waktu,
    this.lintang,
    this.bujur,
    this.magnitudo,
    this.kedalaman,
    this.wilayah,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 1.0, bottom: 10.0, left: 5.0),
      child: Container(
        child: Center(
          child: SizedBox(
            width: 500,
            height: 250,
            child: Card(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Container(
                          width: 75,
                          height: 70,
                          child: Image.network(
                              'https://bpbd-lebak.id/gempa.png'),
                        ),
                        Text(judul, textAlign: TextAlign.center),
                        Text(waktu, textAlign: TextAlign.center),
                        Text(lintang, textAlign: TextAlign.center),
                        Text(bujur, textAlign: TextAlign.center),
                        Text(magnitudo, textAlign: TextAlign.center),
                        Text(kedalaman, textAlign: TextAlign.center),
                        Text(wilayah, textAlign: TextAlign.center),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CuacaAll extends StatelessWidget {
  final String hari;
  final String waktu;
  final String gambar;
  final String judul;
  final String suhu;
  final String kelembaban;
  final String angin;

  CuacaAll({
    this.hari,
    this.waktu,
    this.gambar,
    this.judul,
    this.suhu,
    this.kelembaban,
    this.angin,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        child: Align(
          alignment: Alignment.topLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                height: 160,
                child: Container(
                  width: 150,
                  height: 160,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            hari,
                            style: Theme.of(context).textTheme.caption.copyWith(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontFamily: 'flutterfonts',
                                ),
                          ),
                          Text(
                            suhu,
                            style: Theme.of(context).textTheme.caption.copyWith(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontFamily: 'flutterfonts',
                                ),
                          ),
                          Text(
                            judul,
                            style: Theme.of(context).textTheme.caption.copyWith(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontFamily: 'flutterfonts',
                                ),
                          ),
                          Container(
                            width: 40,
                            height: 40,
                            child: Image.network(gambar),
                          ),
                          Text(
                            angin,
                            style: Theme.of(context).textTheme.caption.copyWith(
                                  color: Colors.black45,
                                  fontFamily: 'flutterfonts',
                                  fontSize: 11,
                                ),
                          ),
                          Text(
                            kelembaban,
                            style: Theme.of(context).textTheme.caption.copyWith(
                                  color: Colors.black45,
                                  fontFamily: 'flutterfonts',
                                  fontSize: 11,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
