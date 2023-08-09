import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iller_ilceler/il.dart';
import 'package:iller_ilceler/ilce.dart';

class CitiesPage extends StatefulWidget {
  CitiesPage({super.key});

  @override
  State<CitiesPage> createState() => _CitiesPageState();
}

class _CitiesPageState extends State<CitiesPage> {
  List<Il> iller = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _readJsonFile();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("İller - İlçeler"),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return ListView.builder(
      itemCount: iller.length,
      itemBuilder: _buildListItem,
    );
  }

  Widget _buildListItem(BuildContext context, int index) {
    List<Widget> children = [];
    for (Ilce ilce in iller[index].districts) {
      children.add(
        ListTile(
          title: Text(
            ilce.name,
            style: TextStyle(
              fontSize: 30,
            ),
          ),
        ),
      );
    }
    return ExpansionTile(
      title: Text(
        iller[index].name,
        style: TextStyle(
          fontSize: 36,
        ),
      ),
      children: children,
      /*
      iller[index].districts.map((ilce){
        return ListTile(
          title: Text(
            ilce.name,
            style: TextStyle(
              fontSize: 30,
            ),
          ),
        );
      }).toList(),
      */
    );
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

    setState(() {});
  }
}
