import 'dart:async';
import 'dart:convert';


import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_retry/http_retry.dart';
import './hello.dart';




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
        body: Login(),),
        routes: {

          '/hello': (context) => Hello(),
        },
      );
  }
}







class Login  extends StatelessWidget {
  final myController = TextEditingController();
  String password ="";
  String FCM="";
  Map<String,String> _futureAuth={};
  final storage = new FlutterSecureStorage();

  dynamic _futureHello;
  String Token="" ;

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

    Map<String,String> result={'statusCode':response.statusCode.toString(),
      'data':response.statusCode==201 ? json.decode(response.body)['accessToken'] :''};
    return(result);
  }




  Future<http.Response> fetchHelloUser() async {
    String? Token= await storage.read(key: 'jwt');
    final client = RetryClient(
      http.Client(),
      retries: 1,
      when: (response) {
        return response.statusCode == 401 ? true : false;
      },
      onRetry: (req, res, retryCount) async {
        if (retryCount == 0 && res?.statusCode == 401) {
          print('you are not authorized');
          // Navigator.pushNamed(context, '/');
        }
      },
    );

    try {
      final response = await client.get(
        Uri.parse('http://192.168.1.15:3000/auth/hello-user'),
        headers: {
          'Authorization': 'Bearer $Token',
        },
      );

      return (response);
    } finally {
      client.close();
    }
  }




  @override
  Widget build(BuildContext context) {
    return Column(

      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: TextFormField(
            decoration: InputDecoration(
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

           String? token=await _futureAuth['data'];

          await storage.write(key: 'jwt',value:token);

           Map<String,String> allValues=await storage.readAll();
           print('my secure storage');
           print(allValues);



        },
            child: Text("Log in")),

        ElevatedButton(
            onPressed: () async {
              _futureHello = await fetchHelloUser();

              if (_futureHello.statusCode == 200)
                Navigator.pushNamed(context, '/hello');
            },
            child: Text('Navigate to your authorized screen'))




      ],
    );
  }
}



