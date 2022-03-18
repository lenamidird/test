
import 'package:flutter/material.dart';


  class Hello extends StatelessWidget {

    static const routeName = '/hello';
    @override
    Widget build(BuildContext context) {
      return Scaffold(
          appBar: AppBar(title: Text('you are in an authorized screen'),),
           body: Center(child: Text('Hello user'),));
    }
  }
