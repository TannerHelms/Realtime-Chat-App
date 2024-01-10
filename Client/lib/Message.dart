import 'dart:convert';

class Message {
  final String message;
  final String senderUsername;
  final String sentAt;

  Message(
      {required this.message,
      required this.senderUsername,
      required this.sentAt});

  factory Message.fromJson(String message) {
    List<String> messageSplit = message.split(': ');
    String date = messageSplit[3].replaceFirst('}', '');
    return Message(
        message: messageSplit[1].split(', senderUsername')[0],
        senderUsername: messageSplit[2].split(',')[0],
        sentAt: date,
    );
  }
}
