import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:practica_crud/models/job.dart';
import 'package:intl/intl.dart';
import 'package:practica_crud/main.dart';

class EditDataWidget extends StatefulWidget {
  EditDataWidget(this.cases);

  final Job cases;

  @override
  _EditDataWidgetState createState() => _EditDataWidgetState();
}

class _EditDataWidgetState extends State<EditDataWidget> {
  final TextEditingController firstNameController =
      new TextEditingController(); //variable controlador de texto
  final TextEditingController lastNameController = new TextEditingController();
  final TextEditingController fechaController = new TextEditingController();
  final TextEditingController studentIDController = new TextEditingController();
  final _addFormKey = GlobalKey<FormState>();
  final TextEditingController auxID = new TextEditingController();

  void initState() {
    studentIDController.text = widget.cases.studentID.toString();
    lastNameController.text = widget.cases.lastName;
    firstNameController.text = widget.cases.firstName;
    fechaController.text = widget.cases.enrollmentDate.toString();
    auxID.text = widget.cases.studentID.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("EDITAR"),
        ),
        body: Form(
          key: _addFormKey,
          child: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Colors.green, Colors.blue],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter)),
              child: ListView(
                children: <Widget>[
                  textSection(),
                  butttonSection(),
                  // headerSection(),
                ],
              ) //accion
              ),
        ));
  }

  Container butttonSection() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 40.0,
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      margin: EdgeInsets.only(top: 15.0),
      child: RaisedButton(
        onPressed: firstNameController.text == "" ||
                lastNameController.text == "" ||
                fechaController.text == ""
            ? null
            : () {
                if (_addFormKey.currentState.validate()) {
                  _addFormKey.currentState.save();
                  updateCases(
                      auxID.text,
                      Job(
                          studentID: int.parse(studentIDController.text),
                          lastName: lastNameController.text,
                          firstName: firstNameController.text,
                          enrollmentDate:
                              DateTime.parse(fechaController.text)));

                  Navigator.pop(context);
                }

                //2020-02-02T00:00:00
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (BuildContext context) => StudentApp()),
                    (Route<dynamic> route) => false);
              },
        elevation: 0.0,
        color: Colors.purple,
        child: Text(
          "Guardar",
          style: TextStyle(color: Colors.white),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
      ),
    );
  }

  Container textSection() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 30.0),
      child: Column(
        children: <Widget>[
          TextFormField(
            controller: studentIDController,
            cursorColor: Colors.white,
            style: TextStyle(color: Colors.white70),
            decoration: InputDecoration(
                icon: Icon(Icons.person, color: Colors.white70),
                hintText: "StudentID",
                border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white70)),
                hintStyle: TextStyle(color: Colors.white70)),
          ),
          SizedBox(height: 30.0),
          TextFormField(
            controller:
                firstNameController, //controlador de lo que escribamos ahi
            cursorColor: Colors.white70, //color del palito cursor
            style: TextStyle(color: Colors.white70),
            decoration: InputDecoration(
                icon: Icon(Icons.person, color: Colors.white70),
                hintText: "FirstName",
                border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white70)), //??
                hintStyle: TextStyle(color: Colors.white70)),
          ),
          SizedBox(height: 30.0),
          TextFormField(
            controller: lastNameController,
            cursorColor: Colors.white,
            style: TextStyle(color: Colors.white70),
            decoration: InputDecoration(
                icon: Icon(Icons.person, color: Colors.white70),
                hintText: "LastName",
                border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white70)),
                hintStyle: TextStyle(color: Colors.white70)),
          ),
          SizedBox(height: 30.0),
          TextFormField(
            controller: fechaController,
            cursorColor: Colors.white,
            style: TextStyle(color: Colors.white70),
            decoration: InputDecoration(
                icon: Icon(Icons.blur_linear, color: Colors.white70),
                hintText: "Fecha",
                border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white70)),
                hintStyle: TextStyle(color: Colors.white70)),
          ),
        ],
      ),
    );
  }

  Future<Job> updateCases(String id, Job cases) async {
    //metodo (updateCases) que devuelve un Cases//update:actualizar
    Map data = {
      'StudentID': cases.studentID,
      'LastName': cases.lastName,
      'FirstName': cases.firstName,
      'EnrollmentDate':
          DateFormat('yyyy-MM-dd HH:mm:ss').format(cases.enrollmentDate)
    };

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String token = sharedPreferences.getString('token');
    final apiUrl = 'https://appserviceisabel.azurewebsites.net/api/students';
    final Response response = await put(
      //Response: respuesta(de tipo put) de una llamada a alguna url
      '$apiUrl/$id',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(data),
    );
    if (response.statusCode == 204) {
      return Job.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update a case');
    }
  }
}
