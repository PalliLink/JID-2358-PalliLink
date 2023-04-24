import 'package:flutter/material.dart';
import 'package:pallinet/components/appointment_card.dart';
import 'package:pallinet/components/chat_card.dart';
import 'package:pallinet/models/session_manager.dart';
import 'package:pallinet/firestore/firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pallinet/utils.dart';
import 'package:pallinet/components/loading.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});
  
  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late final SessionManager _prefs;
  List<QueryDocumentSnapshot> listMessages = [];
    @override
    void initState() {
      _prefs = SessionManager();
      super.initState();
    }

    @override
    void dispose() {
      super.dispose();
    }
  Widget gap() => const Divider(
          height: 10,
          color: Colors.white,
        );
  @override
  Widget build(BuildContext context) {
    String newMessage = "";
    TextEditingController messageController = TextEditingController();
    List<dynamic> arguments = ModalRoute.of(context)?.settings.arguments as List<dynamic>;
    String otherUser = arguments[1].split(" ")[0];
    return Scaffold(
        appBar: AppBar(title:  Text("Chat with $otherUser")),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              child:StreamBuilder<QuerySnapshot>(
              stream: retrieveMessagesFromChat(arguments[0]),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  listMessages = snapshot.data!.docs;
                    return ListView.builder(
                      shrinkWrap: true,
                      padding: const EdgeInsets.all(10),
                      itemCount: snapshot.data?.docs.length,
                      reverse: true,
                      itemBuilder: (BuildContext context, int index) {
                        final data = snapshot.data?.docs[index];
                        
                        if (data != null) {
                          return ChatCard(
                            name:data["SenderName"],
                            lastMessage:data["message"],
                            timeSent: data["time_sent"].toDate(),
                            refresh: () => refresh(setState),
                          );
                        } else {
                          return const LoadingScreen("Loading Messages");
                        }
                      }
                    );
                } else {
                  return const LoadingScreen("Loading Messages");
                }
              }
            )
          ),
          gap(),
          gap(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextFormField(
                validator: (value) => requiredValue(value),
                controller: messageController,
                minLines: 1,
                maxLines: 20,
                decoration: InputDecoration(
                    labelText: 'Message',
                    hintText: 'Enter a message',
                    
                    border: const UnderlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.send),
                      onPressed: () {
                        setState(() {
                          newMessage = messageController.text;
                        });
                        debugPrint(newMessage);
                        if (newMessage.isNotEmpty) {
                          sendMessage(arguments, newMessage);
                        }
                      },
                    )
                      
                    ),
              ),
          ),
          const SizedBox(height: 20),
        //   const Divider(
        //   height: 80,
        //   color: Colors.white,
        // )
        ],
        ));
  }

}
