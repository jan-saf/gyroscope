import 'package:flutter/material.dart';

class ConnectForm extends StatefulWidget {
  ConnectForm({Key key, this.connected, this.onSubmit}) : super(key: key);

  final bool connected;
  final Function onSubmit;

  @override
  _ConnectFormState createState() => _ConnectFormState();
}

/// Widget displaying a TextFormField taking a websocket URL and Button to connect to the URL
class _ConnectFormState extends State<ConnectForm> {

  TextEditingController myController;

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: TextFormField(
              decoration: const InputDecoration(
                hintText: 'WebSocket URL',
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
              controller: myController,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(25, 10, 25, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                if (widget.connected) Text('Connected'),
                ElevatedButton(
                  onPressed: () {
                    widget.onSubmit(myController.text);
                  },
                  child: Text(widget.connected ? 'Disconnect' : 'Connect'),
                ),
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
    myController = new TextEditingController(text: 'ws://192.168.0.:8080/gyroscope');
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

}
