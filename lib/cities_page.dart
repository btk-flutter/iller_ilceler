import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iller_ilceler/il.dart';
import 'package:iller_ilceler/ilce.dart';

class CitiesPage extends StatelessWidget {
  List<Il> iller = [];

  CitiesPage({super.key});

  @override
  Widget build(BuildContext context) {
    _readJsonFile();
    return const Placeholder();
  }

  void _readJsonFile() async {
    String jsonStr = await rootBundle.loadString(
      "assets/iller_ilceler.json",
    );
    Map<String, dynamic> veriler = json.decode(jsonStr);

    List<String> cityCodes = veriler.keys.toList();
    for (String cityCode in cityCodes) {
      Map<String, dynamic> cityMap = veriler[cityCode];

      String cityName = cityMap["name"];

      List<Ilce> ilceler = [];

      Map<String, dynamic> districtsMap = cityMap["districts"];

      List<String> districtCodes = districtsMap.keys.toList();

      for (String districtCode in districtCodes) {
        Map<String, dynamic> districtMap = districtsMap[districtCode];

        String districtName = districtMap["name"];

        Ilce ilce = Ilce(districtCode, districtName);
        ilceler.add(ilce);
      }

      Il il = Il(cityCode, cityName, ilceler);
      iller.add(il);
    }

    print(iller[58].districts[0].name);
  }
}
