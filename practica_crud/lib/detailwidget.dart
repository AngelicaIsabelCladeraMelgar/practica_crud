import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:practica_crud/models/job.dart';

class DetailWidget extends StatefulWidget {
  final Job cases;

  DetailWidget(this.cases);

  @override
  _DetailWidgetState createState() => _DetailWidgetState();
}

class _DetailWidgetState extends State<DetailWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Detalles")),
        body: Container(
          child: ListView(
            children: <Widget>[
              SizedBox(height: 140.0),
              Center(
                  child: Text(
                widget.cases.lastName,
                style: TextStyle(fontSize: 20.0),
              )),
              SizedBox(height: 30.0),
              Center(
                  child: Text(
                widget.cases.firstName,
                style: TextStyle(fontSize: 20.0),
              )),
              SizedBox(height: 30.0),
              Center(
                  child: Text(
                widget.cases.studentID.toString(),
                style: TextStyle(fontSize: 20.0),
              )),
              SizedBox(height: 30.0),
              Center(
                  child: Text(
                widget.cases.enrollmentDate.toString(),
                style: TextStyle(fontSize: 20.0),
              )),
            ],
          ),
        ));
  }
}

/*Center(
        child: Text(
          widget.cases.lastName,
          style: TextStyle(fontSize: 20.0),
        ),
      ),*/
