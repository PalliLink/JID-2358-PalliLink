import 'package:flutter/material.dart';

class ContactsPage extends StatelessWidget {
  const ContactsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Messages")),
        body: Center(
          child: Column(
            children: const [
              Text("contacts"),
            ],
          ),
        ));
  }
}
