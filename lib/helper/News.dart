import 'package:bpbd/model/BeritaModel.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class News {
  List<BeritaModel> news  = [];

  Future<void> getNews() async{
    var response = await http.get(Uri.parse("https://adminbpbd.bpbd-lebak.id/api/getnews"));

    var jsonData = jsonDecode(response.body);

    if(jsonData['status'] == true){
      jsonData["results"].forEach((element){

        if(element['image'] != null && element['deskripsi'] != null){
          BeritaModel berita = BeritaModel(
            judul: element['judul'],
            deskripsi: element['deskripsi'],
            image: element['image'],
            tanggal: element['tanggal']
          );
          news.add(berita);
        }

      });
    }
  }
}