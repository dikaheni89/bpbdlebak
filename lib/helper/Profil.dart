import 'package:bpbd/model/ProfilModel.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class Profil {
  List<ProfilModel> profil  = [];

  Future<void> getProfil() async{
    var response = await http.get(Uri.parse("https://adminbpbd.bpbd-lebak.id/api/getprofil"));

    var jsonData = jsonDecode(response.body);

    if(jsonData['status'] == true){
      jsonData["results"].forEach((element){

        if(element['image'] != null && element['deskripsi'] != null){
          ProfilModel profils = ProfilModel(
            judul: element['judul'],
            deskripsi: element['deskripsi'],
            image: element['image'],
            tanggal: element['tanggal']
          );
          profil.add(profils);
        }

      });
    }
  }
}