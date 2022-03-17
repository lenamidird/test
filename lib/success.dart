import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import'./secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:http_retry/http_retry.dart';

class Success extends StatefulWidget {

  static const routeName = '/success';

  @override
  State<Success> createState() => _SuccessState();
}

class _SuccessState extends State<Success> {

  dynamic  _futureHello;



  String Token='';
  Future<http.Response> fetchHelloUser() async{
//     print('Token');
//     print(Token);
//     final response = await http.get(
//       Uri.parse('http://192.168.1.17:3000/auth/hello-user'),
// // Send authorization headers to the backend.
//
//       headers: {
//         // HttpHeaders.authorizationHeader: Token ,
//         'Authorization': 'Bearer $Token',
//       },
//
//     );
//     print('endpoint hello user');
//     print(response.body);
//     return(response);



    final client = RetryClient(
      http.Client(),
      retries: 1,
      when: (response) {
        return response.statusCode == 401 ? true : false;
      },
      onRetry: (req, res, retryCount) async  {
        if (retryCount == 0 && res?.statusCode == 401) {
          print('you are not authorized');
          Navigator.pushNamed(context,'/');




        }
      },
    );

    try {
      final response = await client.get(Uri.parse('http://192.168.1.15:3000/auth/hello-user'), headers: {

        'Authorization': 'Bearer $Token',
      },);

      return(response);

    } finally {
      client.close();
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String,String?>;
    print('args');
    print(args['token']);
    String bearerToken=args['token']!;
    Token=bearerToken;

    return

      Scaffold(
        appBar: AppBar(title: Text('Success'),),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Center(
              child: Text(
                'Logged In Successfully!',

              ),
            ),
            ElevatedButton(onPressed: () async{

              _futureHello= await fetchHelloUser();

              if (_futureHello.statusCode==200)
                Navigator.pushNamed(context,'/hello');

              // else { Navigator.pushNamed(context,'/');  }

            },

                child: Text('Navigate to your authorized screen'))
          ],
        ),

      );



  }
}

