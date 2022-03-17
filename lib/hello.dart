
import 'package:flutter/material.dart';

class Hello extends StatefulWidget {
  static const routeName = '/hello';



  @override
  _HelloState createState() => _HelloState();
}

class _HelloState extends State<Hello> {
  @override
  Widget build(BuildContext context) {
    return

      Scaffold(
          appBar: AppBar(title: Text('you are in an authorized screen'),),
          body: Center(child: Text('Hello user'),));


  }
}
