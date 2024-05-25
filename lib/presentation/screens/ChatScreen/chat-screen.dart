import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:users/data/message_model/message.dart';
import 'package:users/presentation/app_manager/color_manager/color_manager.dart';
import 'package:users/presentation/widgets/my_text_style/my_text_style.dart';

import '../../../buisenisse_logic/chatProvider/chat_provider.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: maincolor,
        title: MyDefaultTextStyle(
          text: "Chat Room",
          height: 20,
          bold: true,
          color: Colors.white,
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: FirebaseDatabase.instance
                  .ref()
                  .child('message_room')
                  .child(Provider.of<ChatProvider>(context)
                      .messageRoom!
                      .key
                      .toString())
                  .orderByChild("time")
                  .onValue,
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data != null) {
                  DataSnapshot dataSnapshot = snapshot.data!.snapshot;
                  print(
                      "---------------------------------------------------------");

                  Map<dynamic, dynamic>? messagesData =
                      dataSnapshot.value as Map?;
                  List<Message> messagesList = [];

                  messagesData!.forEach((key, value) {
                    Message message = Message(
                        message: value["message"],
                        isSender: value["sender"],
                        dateTime: value["time"]);
                    messagesList.add(message);
                  });

                  if (messagesData != null) {
                    return ListView.builder(
                      itemCount: messagesList.length,
                      itemBuilder: (context, index) {
                        bool isSender = messagesList[index].isSender == 'user';

                        return Align(
                          alignment: isSender
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Container(
                            padding: const EdgeInsets.all(10.0),
                            margin: const EdgeInsets.symmetric(
                                vertical: 5.0, horizontal: 10.0),
                            decoration: BoxDecoration(
                              color: isSender ? maincolor : black,
                              borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(15.0),
                                topLeft: Radius.circular(15.0),
                                bottomLeft: Radius.circular(15.0),
                              ),
                            ),
                            child: Text(
                              messagesList[index].message,
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return const Text('No messages found');
                  }
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'Type your message...',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    Provider.of<ChatProvider>(context, listen: false)
                        .sendMessage(_messageController.text);
                    _messageController.clear();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
