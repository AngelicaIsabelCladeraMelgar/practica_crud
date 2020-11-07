import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:practica_crud/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:practica_crud/studentlista.dart';
import 'package:practica_crud/adddatawidget.dart';

void main() => runApp(StudentApp());

class StudentApp extends StatelessWidget {
  const StudentApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "StudentApp",
      home: Inicio(),
    );
  }
}

class Inicio extends StatefulWidget {
  Inicio({Key key}) : super(key: key);

  @override
  _InicioState createState() => _InicioState();
}

class _InicioState extends State<Inicio> {
  SharedPreferences sharedPreferences;

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  checkLoginStatus() async {
    //chequea si el token es valido
    sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString("token") == null) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => LoginPage()),
          (Route<dynamic> route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("StudentApp de Daniel",
            style: TextStyle(color: Colors.white)), //titulo del appbar
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              sharedPreferences
                  .clear(); //borra los datos de sharedPreferences ya que nos vamos a logear de nuevo y debemos almacenar un nueevo token
              // ignore: deprecated_member_use
              sharedPreferences.commit();
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (BuildContext context) => LoginPage()),
                  (Route<dynamic> route) => false);
            },
            child: Text("Log Out", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: Center(child: JobsListView()),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //funcion agregar usuario
          final result = Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddDataWidget()),
          );
        },
        tooltip: 'Ingresar Usuario',
        child: Icon(Icons.add, color: Colors.white),
      ),
      drawer: Drawer(),
    );
  }
}
