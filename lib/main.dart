import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

Map _data;
List _features;

void main() async {
  _data = await getQuakes();
  _features = _data['features'];
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Quakes",
      home: Home(),
    ),
  );
}

class Home extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Quakes"),
        centerTitle: true,
        backgroundColor: Colors.red,
      ),
      body: Center(
        child: ListView.builder(
            itemCount: _features.length,
            padding: const EdgeInsets.all(16.5),
            itemBuilder: (BuildContext context, int position) {
              if (position.isOdd) return new Divider();
              final index = position ~/ 2;
              var format = new DateFormat.yMMMMd("en_US").add_jm();
              var date = format.format(new DateTime.fromMicrosecondsSinceEpoch(
                  _features[index]['properties']['time'] * 1000,
                  isUtc: false)
              );

              return new ListTile(
                title: Text("At: $date",
                  style: TextStyle(
                    fontSize: 15.5,
                    color: Colors.orange,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                subtitle: Text(
                  "${_data['features'][position]['properties']['place']}",
                  style: TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.normal,
                    color: Colors.grey,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                leading: CircleAvatar(
                  backgroundColor: Colors.green,
                  child: Text(
                    "${_data['features'][position]['properties']['mag']}",
                    style: TextStyle(
                      fontSize: 15.5,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                ),
                onTap: () {
                  showAlertMessage(
                      context, "${_features[index]['properties']['title']}");
                },
              );
            }
        ),
      ),
    );
  }

  void showAlertMessage(BuildContext context, String message) {
    var alert = new AlertDialog(
      title: Text("Quakes"),
      content: Text(message),
      actions: [
        FlatButton(onPressed: () {
          Navigator.pop(context);
        }, child: Text("OK"))
      ],
    );
    showDialog(context: context, child: alert);
  }
}

Future<Map> getQuakes() async {
  String apiUrl = 'https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_day.geojson';
  http.Response response = await http.get(apiUrl);
  return json.decode(response.body);
}