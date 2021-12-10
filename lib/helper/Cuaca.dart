import 'package:bpbd/model/CuacaModel.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class Cuaca {
  List<CuacaModel> cuacas  = [];

  Future<void> getCuaca() async{
    var response = await http.get(Uri.parse("https://bpbd-lebak.id/cuaca/cuacaapi.php"));

    var jsonData = jsonDecode(response.body);

    if(jsonData['status'] == true){
      jsonData["results"].forEach((element){

        if(element['gambar'] != null){
          CuacaModel cuaca = CuacaModel(
            hari: element['hari'],
            waktu: element['waktu'],
            gambar: element['gambar'],
            judul: element['judul'],
            suhu: element['suhu'],
            kelembaban: element['kelembaban'],
            angin: element['angin'],
          );
          cuacas.add(cuaca);
        }
      });
    }
  }
}