import 'package:flutter/material.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        body: Center(
      child: Column(
        children: [
          Text("ChatPage"),
        ],
      ),
    ));
  }
}
