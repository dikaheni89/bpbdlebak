import 'package:bpbd/model/ProdukModel.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class Produk {
  List<ProdukModel> produk  = [];

  Future<void> getProduk() async{
    var response = await http.get(Uri.parse("https://adminbpbd.bpbd-lebak.id/api/getproduk"));

    var jsonData = jsonDecode(response.body);

    if(jsonData['status'] == true){
      jsonData["results"].forEach((element){

        if(element['file'] != null && element['deskripsi'] != null){
          ProdukModel produks = ProdukModel(
            nmProduk: element['nm_produk'],
            kategori: element['kategori'],
            uud: element['uud'],
            deskripsi: element['deskripsi'],
            file: element['file'],
            tanggal: element['tanggal']
          );
          produk.add(produks);
        }

      });
    }
  }
}