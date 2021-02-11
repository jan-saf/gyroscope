import 'package:flutter/material.dart';

import 'Sensor.dart';

class SensorSwitcher extends StatefulWidget {
  SensorSwitcher({Key key, this.onSwitch}) : super(key: key);

  final Function onSwitch;

  @override
  _SensorSwitcherState createState() => _SensorSwitcherState();
}

/// Widget displaying two Buttons to switch between Gyroscope and Accelerometer data streaming
class _SensorSwitcherState extends State<SensorSwitcher> {
  Color _active = Color.fromRGBO(111, 209, 122, 1);
  Color _inactive = Color.fromRGBO(220, 220, 220, 1);
  bool gyroscopeActive = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          RaisedButton(
            onPressed: () {
              gyroscopeActive = true;
              widget.onSwitch(Sensor.Gyroscope);
            },
            color: gyroscopeActive ? _active : _inactive,
            child: const Text('Gyroscope', style: TextStyle(fontSize: 20)),
          ),
          RaisedButton(
            onPressed: () {
              gyroscopeActive = false;
              widget.onSwitch(Sensor.Accelerometer);
            },
            color: gyroscopeActive ? _inactive : _active,
            child: const Text('Accelerometer', style: TextStyle(fontSize: 20)),
          ),
        ],
      ),
    );
  }
}
