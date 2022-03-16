import 'dart:async';
import 'dart:convert';


import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import './secure_storage.dart';




void main() {

  runApp(MyApp());}

class MyApp extends StatelessWidget {



  @override
  Widget build(BuildContext context) {
    const appTitle = 'Authentication';
    return MaterialApp(
      title: appTitle,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(appTitle),
        ),
        body: const MyCustomForm(),
      ),

    );
  }
}

Future<Map<String, String>> createAuth(String email,String password,String FCM) async {

  final response= await http.post(
    Uri.parse('http://192.168.1.15:3000/auth/signin'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },

    body: jsonEncode(<String, String>{
      'email': email,
      'password':password,
      'FCM':FCM,
    }),
  );






  dynamic?  token=response.body;
  SecureStorage tokenStorage=SecureStorage();
  tokenStorage.stockToken(token);




  Map<String,String> result={'statusCode':response.statusCode.toString(),
    'data':response.statusCode==201 ? json.decode(response.body)['accessToken'] :''};


  return(result);

}


class MyCustomForm extends StatefulWidget {
  const MyCustomForm({Key? key}) : super(key: key);

  @override
  State<MyCustomForm> createState() => _MyCustomFormState();
}

class _MyCustomFormState extends State<MyCustomForm> {
  final myController = TextEditingController();
  String password ="";
  String FCM="";
  Map<String,String> _futureAuth={};





  @override
  Widget build(BuildContext context) {


    return Column(
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: TextField(decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Enter your email',
          ),

            controller: myController,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: TextFormField(
            onChanged: (text) {
              print('First text field: $text');
              password=text;
            },
            obscureText: true,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              hintText: 'Enter your password',
            ),
          ),
        ),

        ElevatedButton(onPressed: () async{

          _futureAuth= await createAuth(myController.text,password,FCM);
          print('******');

          if(_futureAuth['statusCode']=='201') {


            print('logged in successfully');

          }
        },
            child: Text("Log in"))

      ],
    );
  }
}


