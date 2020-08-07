import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<Album> fetchAlbum() async {
  final response =
      await http.get('https://api.weather.gov/gridpoints/BGM/96,45/forecast');
  // await http.get('https://jsonplaceholder.typicode.com/albums/1');

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Album.fromJson(json.decode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load data');
  }
}

class Album {
  // final int userId;
  // final int id;
  // final String title;
  final String name;
  final int temp;
  final String forc;
  final String nameB;
  final int tempB;
  final String forcB;
  final Object mappedData;
  final Object allData;

  // Album({this.userId, this.id, this.title});
  Album(
      {this.temp,
      this.name,
      this.forc,
      this.tempB,
      this.nameB,
      this.forcB,
      this.allData,
      this.mappedData});

  factory Album.fromJson(Map<String, dynamic> json) {
    final mappedData = json['properties']['periods'].map((m) {
      return "${m['name']} : ${m['temperature']} degrees. ${m['detailedForecast']}";
    });

    // var mappedQuestion = questionMap[0].answer['answers'].map((answer){
    //   return 'This is the ${answer['text']}, and it\'s score is ${answer['score']}';
    // });
    return Album(
      // userId: json['userId'],
      // id: json['id'],
      temp: json['properties']['periods'][0]['temperature'],
      name: json['properties']['periods'][0]['name'],
      forc: json['properties']['periods'][0]['detailedForecast'],
      tempB: json['properties']['periods'][1]['temperature'],
      nameB: json['properties']['periods'][1]['name'],
      forcB: json['properties']['periods'][1]['detailedForecast'],
      allData: mappedData,
    );
  }
}

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<Album> futureAlbum;

  @override
  void initState() {
    super.initState();
    futureAlbum = fetchAlbum();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fetch Data Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Narrowsburg, NY'),
        ),
        body: Center(
          child: FutureBuilder<Album>(
            future: futureAlbum,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Card(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text(
                            "${snapshot.data.name} : ${snapshot.data.temp} Degrees. ${snapshot.data.forc}"),
                      ),
                    ),
                    Card(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text(
                            "${snapshot.data.nameB} : ${snapshot.data.tempB} Degrees. ${snapshot.data.forcB}"),
                      ),
                    ),
                    Card(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text("${snapshot.data.allData}"),
                      ),
                    ),
                  ],
                );
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }

              // By default, show a loading spinner.
              return CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}
