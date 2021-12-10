import 'package:bpbd/helper/News.dart';
import 'package:bpbd/helper/Widget.dart';
import 'package:bpbd/screen/HomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BeritaScreen extends StatefulWidget {
  @override
  _BeritaScreenState createState() => _BeritaScreenState();
}

class _BeritaScreenState extends State<BeritaScreen> {
  // ignore: unused_field
  GlobalKey _bottomNavigationKey = GlobalKey();
  bool login;
  bool _loading;
  var newslist;

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
      appBar: MyAppBar(),
      body: WillPopScope(
        // ignore: missing_return
        onWillPop: () {
          onWillPop();
        },
        child: Stack(
          children: [
            SafeArea(
              child: _loading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  :

                  /// News Article
                  Container(
                      margin: EdgeInsets.only(top: 16),
                      child: ListView.builder(
                          itemCount: newslist.length,
                          shrinkWrap: true,
                          physics: ClampingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return NewsTile(
                              image: newslist[index].image ?? "",
                              judul: newslist[index].judul ?? "",
                              deskripsi: newslist[index].deskripsi ?? "",
                              tanggal: newslist[index].tanggal ?? "",
                              id: newslist[index].id ?? "",
                            );
                          }),
                    ),
            ),
          ],
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
