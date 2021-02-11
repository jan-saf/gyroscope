import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gyroscope/components/ConnectForm.dart';
import 'package:gyroscope/components/SendButton.dart';
import 'package:gyroscope/components/SensorSwitcher.dart';
import 'package:sensors/sensors.dart';
import 'package:web_socket_channel/io.dart';

import 'Operation.dart';
import 'Vector.dart';
import 'Sensor.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _connected = false;
  String _textField;
  IOWebSocketChannel channel;

  StreamSubscription<dynamic> _streamSubscription;

  List<double> _sensorValues;

  @override
  Widget build(BuildContext context) {
    final List<String> sensor = _sensorValues?.map((double v) => v.toStringAsFixed(2) + "")?.toList();
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          ConnectForm(
            connected: _connected,
            onSubmit: onSubmit,
          ),
          Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    SendButton(
                      icon: Icons.sort,
                      onHold: onSort,
                      onLift: sendZeros,
                      label: "Sort"
                    ),
                    SendButton(
                      icon: Icons.apps_rounded,
                      onHold: onDecimate,
                      onLift: sendZeros,
                      label: "Decimate"
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    SendButton(
                      icon: Icons.auto_fix_high,
                      onHold: onShuffle,
                      onLift: sendZeros,
                      label: "Magic Shuffle"
                    ),
                    SendButton(
                      icon: Icons.restore,
                      onHold: onRestore,
                      onLift: sendZeros,
                      label: "Reset"
                    ),
                  ],
                ),
              ),
            ],
          ),
          SensorSwitcher(
            onSwitch: setStreamSubscription,
          ),
          Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
              children: <Widget>[
                Text('Actual sensor data: $sensor'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    setStreamSubscription(Sensor.Gyroscope);
  }

  @override
  void dispose() {
    super.dispose();
    _streamSubscription.cancel();
  }

  /// Entrypoint method for connect form
  void onSubmit(String textField) {
    _textField = textField;
    if (_connected) {
      disconnect();
    } else {
      connect(textField, context);
    }
  }

  /// Connect to a specified websocket URL
  void connect(String url, BuildContext context) {
    channel = IOWebSocketChannel.connect(url);
    channel.stream.first.then((value) {
      String snackBarText;
      if (value.toString().contains("Connected!")) {
        setState(() {
          _connected = true;
        });
        snackBarText = "Successfully connected";
      } else {
        snackBarText = "Server returned unknown message";
        throw new Exception("Unknown message");
      }
      Scaffold.of(context).showSnackBar(SnackBar(content: Text(snackBarText)));
    }).catchError((onError) {
      setState(() {
        _connected = false;
      });
      String snackBarText = "Error connecting! Is the server running and do you have the correct url?";
      Scaffold.of(context).showSnackBar(SnackBar(content: Text(snackBarText + " " + onError.toString())));
    });
  }

  /// Send message with sensor data
  void sendMessage(double x, double y, double z, Op operation) {
    Operation message = Operation(Vector(x, y, z), operation);
    channel.sink.add(jsonEncode(message));
  }

  /// Disconnect from the websocket
  void disconnect() {
    channel.sink.close();
    setState(() {
      _connected = false;
    });
  }

  void onSort() {
    if (_connected) {
      sendMessage(_sensorValues[0], _sensorValues[1], _sensorValues[2], Op.SORT);
    }
  }

  void onDecimate() {
    if (_connected) {
      sendMessage(_sensorValues[0], _sensorValues[1], _sensorValues[2], Op.DECIMATE);
    }
  }

  void onShuffle() {
    if (_connected) {
      sendMessage(_sensorValues[0], _sensorValues[1], _sensorValues[2], Op.SHUFFLE);
    }
  }

  void onRestore() {
    if (_connected) {
      // even though with restore, no sensor data are needed, websocket can't have multiple forms of incoming messages
      sendMessage(0, 0, 0, Op.RESTORE);
    }
  }

  void sendZeros() {
    if (_connected) {
      sendMessage(0, 0, 0, Op.NONE);
    }
  }

  /// Set desired sensor data stream
  void setStreamSubscription(Sensor sensor) {
    if (_streamSubscription != null) {
      _streamSubscription.cancel();
    }
    if (sensor == Sensor.Gyroscope) {
      _streamSubscription = gyroscopeEvents.listen((GyroscopeEvent event) {
        setState(() {
          _sensorValues = <double>[event.x, event.y, event.z];
        });
      });
    } else if (sensor == Sensor.Accelerometer) {
      _streamSubscription = userAccelerometerEvents.listen((UserAccelerometerEvent event) {
        setState(() {
          _sensorValues = <double>[event.x, event.y, event.z];
        });
      });
    }
  }
}
