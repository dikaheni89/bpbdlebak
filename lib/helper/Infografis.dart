import 'package:bpbd/model/InfografisModel.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class Infografis {
  List<InfografisModel> infografis  = [];

  Future<void> getInfografis() async{
    var response = await http.get(Uri.parse("https://adminbpbd.bpbd-lebak.id/api/getinfografis"));

    var jsonData = jsonDecode(response.body);

    if(jsonData['status'] == true){
      jsonData["results"].forEach((element){

        if(element['image'] != null && element['title'] != null){
          InfografisModel infograf = InfografisModel(
            title: element['title'],
            image: element['image'],
            tanggal: element['tanggal']
          );
          infografis.add(infograf);
        }

      });
    }
  }
}