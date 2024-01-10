import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'connection.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _usernameControler = TextEditingController();
  late String username;

  SizedBox verticle = SizedBox(height: 20);
  late final IO.Socket _socket = IO.io('http://localhost:3000', IO.OptionBuilder().setTransports(['websocket']).setQuery({'username': username}).build());

  _connectSocket() {
    _socket.onConnect((data) {
      print('Connected to the Server');
      Navigator.push(context, MaterialPageRoute(builder: (context) => Connection(socket: _socket, username: _usernameControler.text)));
    });
    _socket.onConnectError((data) => print('Connection Error: $data'));
    _socket.onDisconnect((data) => print('Socket.IO server disconnected'));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _usernameControler.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Container(
        width: 500,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.person, color: Colors.black, size: 80),
            verticle,
            Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a username';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Username',
                      ),
                      controller: _usernameControler,
                    ),
                    verticle,
                    SizedBox(
                      width: double.infinity,
                      height: 40,
                      child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.blue),
                          ),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              username = _usernameControler.text;
                              setState(() {
                                _usernameControler.text = "";
                              });
                              _connectSocket();
                            }
                          },
                          child: const Text('Submit',
                              style: TextStyle(color: Colors.white))),
                    ),
                  ],
                ))
          ],
        ),
      ),
    ));
  }
}
