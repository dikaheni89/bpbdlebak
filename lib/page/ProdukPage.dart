import 'package:bpbd/helper/Produk.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ProdukPage extends StatefulWidget {
  @override
  _ProdukPageState createState() => _ProdukPageState();
}

class _ProdukPageState extends State<ProdukPage> {
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
    return Container(
      child: produklist == null
        ? Center(
            child: CircularProgressIndicator(),
          )
        : ListView.builder(
        itemCount: produklist.length,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsetsDirectional.fromSTEB(20, 5, 20, 30),
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
                                'https://adminbpbd.bpbd-lebak.id/uploads/file/pdf.png'
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
                                  produklist[index].nmProduk,
                                  style: TextStyle(
                                      fontSize: 14, fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  'Kategori : ' +produklist[index].kategori,
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[500],
                                      fontWeight: FontWeight.w300),
                                ),                                
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              urlBrowser(produklist[index].file);
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