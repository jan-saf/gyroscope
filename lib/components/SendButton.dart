import 'package:flutter/material.dart';

import 'Operation.dart';

class SendButton extends StatefulWidget {
  SendButton({Key key, @required this.icon, @required this.onHold, @required this.onLift, this.label}) : super(key: key);

  final IconData icon;
  final Function onHold;
  final Function onLift;
  final String label;

  @override
  _SendButtonState createState() => _SendButtonState();
}

/// https://stackoverflow.com/a/52132799
class _SendButtonState extends State<SendButton> {
  bool _buttonPressed = false;
  bool _loopActive = false;
  int _counter = 0;
  Color _buttonColor = Color.fromRGBO(200, 200, 200, 1);
  Color _defaultColor = Color.fromRGBO(200, 200, 200, 1);

  void _increaseCounterWhilePressed() async {
    // make sure that only one loop is active
    if (_loopActive) return;

    _loopActive = true;
    setState(() {
      _buttonColor = Color.fromRGBO(200, 215, 230, 1);
    });

    while (_buttonPressed) {
      widget.onHold();

      // wait a bit
      await Future.delayed(Duration(milliseconds: 1));
    }

    setState(() {
      _buttonColor = _defaultColor;
    });
    _loopActive = false;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Listener(
          onPointerDown: (details) {
            _buttonPressed = true;
            _increaseCounterWhilePressed();
          },
          onPointerUp: (details) {
            widget.onLift();
            _buttonPressed = false;
          },
          child: Container(
            decoration: BoxDecoration(
              color: _buttonColor,
              shape: BoxShape.circle,
              boxShadow: [BoxShadow(color: Colors.grey, offset: Offset(0, 3), blurRadius: 3)],
            ),
            padding: EdgeInsets.all(40.0),
            child: Icon(
              widget.icon,
              size: 20.0,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(10),
          child: widget.label != null ? Text(widget.label) : null,
        ),
      ],
    );
  }
}
