import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:practica_crud/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //container contiene cualquier cosa//Scaffold->appvar y el body
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Colors.blue, Colors.teal],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter),
        ),
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : ListView(
                children: <Widget>[
                  headerSection(), //titlo
                  textSection(), //pedir email
                  buttonSection(), //boton pa logearse
                ],
              ),
      ),
    );
  }

  singIn(String email, pass) async {
    //asincronico la respuesta por el internet puede ser en 1s o 30s
    SharedPreferences sharedPreferences = await SharedPreferences
        .getInstance(); //extrae las preferencias compartidas
    Map data = {
      'grant_type': 'password',
      'username': email,
      'password': pass,
    };
    var jsonResponse;
    var response = await http.post(
        "https://appserviceisabel.azurewebsites.net/token",
        body: data); //envia un post a token
    if (response.statusCode == 200) {
      jsonResponse =
          jsonDecode(response.body); //la respuesta decodificar como json
      if (jsonResponse != null) {
        setState(() {
          _isLoading = false;
        });
        sharedPreferences.setString("token", jsonResponse['access_token']);
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (BuildContext context) => Inicio()),
            (Route<dynamic> route) => false);
      }
    }
  }

  Container buttonSection() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 40.0,
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      margin: EdgeInsets.only(top: 15.0),
      child: RaisedButton(
        onPressed: emailController.text == "" || passwordController.text == ""
            ? null
            : () {
                setState(() {
                  _isLoading = true;
                });
                singIn(emailController.text, passwordController.text);
              },
        elevation: 0.0,
        color: Colors.purple,
        child: Text(
          "Sing In",
          style: TextStyle(color: Colors.white),
        ),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0)), //si email esta vacio
      ),
    );
  }

  final TextEditingController emailController =
      new TextEditingController(); //final es algo fijo que no cambia, una vez ingresado se mantiene el valor
  final TextEditingController passwordController = new TextEditingController();

  Container textSection() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
      child: Column(
        children: <Widget>[
          //todos los hijos seran witget
          TextFormField(
            controller: emailController,
            cursorColor: Colors.white,
            style: TextStyle(color: Colors.white70),
            decoration: InputDecoration(
                icon: Icon(Icons.email, color: Colors.white70),
                hintText: "Email",
                border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white70)),
                hintStyle: TextStyle(color: Colors.white70)),
          ),
          SizedBox(height: 30.0), //espaciado
          TextFormField(
            controller: passwordController,
            cursorColor: Colors.white,
            obscureText: true,
            style: TextStyle(color: Colors.white70),
            decoration: InputDecoration(
                icon: Icon(Icons.lock, color: Colors.white70),
                hintText: "Password",
                border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white70)),
                hintStyle: TextStyle(color: Colors.white70)),
          ),
        ],
      ),
    );
  }

  Container headerSection() {
    return Container(
      margin:
          EdgeInsets.only(top: 50.0), //en la parte superior margen de 50pixeles
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
      child: Text(
        "Student",
        style: TextStyle(
            color: Colors.white70, fontSize: 40.0, fontWeight: FontWeight.bold),
      ),
    );
  }
}
