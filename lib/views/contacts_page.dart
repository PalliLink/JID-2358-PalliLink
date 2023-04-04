import 'package:flutter/material.dart';

class ContactsPage extends StatelessWidget {
  const ContactsPage({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(title: const Text("Messages")),
        body: Center(
      child: Column(
        children: [
          Text("contacts"),
        ],
      ),
    ));
  }
}
