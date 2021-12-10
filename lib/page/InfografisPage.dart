import 'package:bpbd/helper/Infografis.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class InfografisPage extends StatefulWidget {
  @override
  _InfografisPageState createState() => _InfografisPageState();
}

class _InfografisPageState extends State<InfografisPage> {
  var infografislist;
  // ignore: unused_field
  bool _loading;
  bool loading = true;

  void getInfografis() async {
    Infografis infografis = Infografis();
    await infografis.getInfografis();
    infografislist = infografis.infografis;
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
    getInfografis();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: infografislist == null
        ? Center(
            child: CircularProgressIndicator(),
          )
        : ListView.builder(
        itemCount: infografislist.length,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsetsDirectional.fromSTEB(20, 0, 20, 40),
            child: AspectRatio(
              aspectRatio: 3 / 1,
              child: Container(
                child: Row(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                      },
                      child: Row(
                        children: <Widget>[
                          AspectRatio(
                            aspectRatio: 1 / 1,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                infografislist[index].image
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          AspectRatio(
                            aspectRatio: 4 / 3,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  infografislist[index].title,
                                  style: TextStyle(
                                      fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              urlBrowser(infografislist[index].image);
                            },
                            icon: Icon(
                              Icons.download,
                              color: Colors.black,
                              size: 36,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

Future<void> urlBrowser(String url,
    {bool forceWebView = false, bool enableJavaScript = false}) async {
  await launch(url,
      forceWebView: forceWebView, enableJavaScript: enableJavaScript);
}