import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:practica_crud/models/job.dart';
import 'package:practica_crud/detailwidget.dart';
import 'package:practica_crud/editdatawidget.dart';
import 'package:http/http.dart';
import 'package:practica_crud/main.dart';

class JobsListView extends StatefulWidget {
  JobsListView({Key key}) : super(key: key);

  @override
  _JobsListViewState createState() => _JobsListViewState();
}

class _JobsListViewState extends State<JobsListView> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Job>>(
      future: _fetchJobs(),
      builder: (context, snapshot) {
        //builder:  lo que pasa mientras carga un  future
        if (snapshot.hasData) {
          //hasData: true si es un valor no nulo//snapshot: los datos??
          //snapshot: Representación inmutable de la interacción más reciente con un cálculo asincrónico.
          List<Job> data = snapshot.data; //snapshot.data??
          return _jobsListView(data); //
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return CircularProgressIndicator();
      },
    );
  }

  Future<List<Job>> _fetchJobs() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String token = sharedPreferences.getString('token');
    final jobsListAPIUrl =
        'https://appserviceisabel.azurewebsites.net/api/students';
    final response = await http.get(jobsListAPIUrl, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((job) => new Job.fromJson(job)).toList(); //
    } else {
      throw Exception('Failed to load jobs from API');
    }
  }

  ListView _jobsListView(data) {
    //funcion que muestra los usuarios
    return ListView.builder(
        itemCount: data.length, //numero de ListView
        itemBuilder: (context, index) {
          return _tile(data[index].lastName, data[index].firstName,
              Icons.person, data[index]); //lo que muestra
        });
  }

  ListTile _tile(String title, String subtitle, IconData icon, Job data) =>
      ListTile(
          //lo que muestra
          title: Text(title,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 20,
              )),
          subtitle: Text(subtitle),
          leading: Icon(
            icon,
            color: Colors.blue[500],
          ),
          onTap: () {
            //Navigator.of(context).pushAndRemoveUntil( MaterialPageRoute( builder: (BuildContext context) => StudentApp()),(Route<dynamic> route) => false);
            final result = Navigator.push(context,
                MaterialPageRoute(builder: (context) => DetailWidget(data)));
          },
          trailing: Container(
              width: 100.0,
              child: Row(
                children: <Widget>[
                  IconButton(
                      icon: Icon(
                        Icons.edit,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        final result = Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditDataWidget(data)),
                        );
                      }),
                  IconButton(
                      icon: Icon(
                        Icons.delete,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        //delete
                        deleteCase(data.studentID.toString());
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    StudentApp()),
                            (Route<dynamic> route) => false);
                      })
                ],
              )));

  Future<void> deleteCase(String id) async {
    // Future<void>: es void por que solo retorna un string, no retorna ningun modelo
    final String jobsListAPIUrl =
        'https://appserviceisabel.azurewebsites.net/api/students';
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String token = sharedPreferences.getString('token');

    Response res = await delete('$jobsListAPIUrl/$id', headers: {
      'Authorization': 'Bearer $token',
    });

    if (res.statusCode == 200) {
      print("Case deleted");
    } else {
      throw "Failed to delete a case.";
    }
  }
}
