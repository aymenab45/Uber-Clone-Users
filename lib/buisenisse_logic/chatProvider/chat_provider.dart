import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class ChatProvider with ChangeNotifier {
  DatabaseReference? messageRoom;
  DatabaseReference? newMessage;

  startChatRoom() async {
    messageRoom = FirebaseDatabase.instance.ref().child("message_room").push();
    DatabaseReference fireBaseRef = FirebaseDatabase.instance
        .ref()
        .child("message_room")
        .child(messageRoom!.key.toString());
    fireBaseRef.set({
      '-NxA4bdPrDCUW-3gWUWl': {
        'message': "hello",
        'senderID': FirebaseAuth.instance.currentUser!.uid,
        'sender': "user",
        'time': DateTime.now().toUtc().toIso8601String()
      }
    });
  }

  sendMessage(message) {
    newMessage = FirebaseDatabase.instance
        .ref()
        .child("message_room")
        .child(messageRoom.toString())
        .push();
    DatabaseReference fireBaseRef = FirebaseDatabase.instance
        .ref()
        .child("message_room")
        .child(messageRoom!.key.toString())
        .child(newMessage!.key.toString());

    fireBaseRef.set({
      'message': message,
      'senderID': FirebaseAuth.instance.currentUser!.uid,
      'sender': "user",
      'time': DateTime.now().toUtc().toIso8601String()
    });
  }
}
