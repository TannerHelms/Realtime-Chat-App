import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'Message.dart';

class Connection extends StatefulWidget {
  const Connection({super.key, required this.socket, required this.username});

  final String username;
  final IO.Socket socket;

  @override
  State<Connection> createState() => _ConnectionState();
}

class _ConnectionState extends State<Connection> {
  final _formKey = GlobalKey<FormState>();
  final _messageController = TextEditingController();
  SizedBox verticle = const SizedBox(height: 20);

  final List<Message> serverMessages = [];

  _sendMessage(message) {
    widget.socket
        .emit('message', {'sender': widget.username, 'message': message});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.socket.on('message', (data) {
      setState(() {
        serverMessages.add(Message.fromJson(data.toString()));
      });
    });
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
            Container(
              height: 500,
              width: double.infinity,
              color: Colors.black,
              child: ListView.builder(
                  itemCount: serverMessages.length,
                  itemBuilder: (context, index) {
                    var message = serverMessages[index];
                    return ListTile(
                        subtitle: Text(
                      '${message.senderUsername} : ${message.message}',
                      style: TextStyle(color: message.senderUsername == 'Server' ? Colors.red : Colors.white),
                    ));
                  }),
            ),
            verticle,
            Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a message';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Message',
                      ),
                      controller: _messageController,
                    ),
                    verticle,
                    SizedBox(
                      width: double.infinity,
                      height: 40,
                      child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.blue),
                          ),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _sendMessage(_messageController.text);
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
