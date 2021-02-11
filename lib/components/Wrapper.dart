import 'package:flutter/material.dart';
import 'package:gyroscope/components/MyHomePage.dart';

class Wrapper extends StatefulWidget {
  Wrapper({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: MyHomePage());
  }
}
