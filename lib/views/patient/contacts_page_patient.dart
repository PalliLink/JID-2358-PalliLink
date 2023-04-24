import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pallinet/components/contacts_card.dart';
import 'package:pallinet/firestore/firestore.dart';
import 'package:pallinet/models/session_manager.dart';

class ContactsPagePatient extends StatefulWidget {
  const ContactsPagePatient({super.key});

  @override
  State<ContactsPagePatient> createState() => _ContactsPagePatientState();
}

class _ContactsPagePatientState extends State<ContactsPagePatient> {
  late final SessionManager _prefs;

  @override
  void initState() {
    _prefs = SessionManager();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    refresh() {
      setState(() {});
    }

    return Column(children: [
      Expanded(
        flex: 8,
        child: FutureBuilder<List<dynamic>>(
          future: _prefs
              .getUid()
              .then((uid) => retrieveMessagesPatients(uid)),
          builder: ((context, snapshot) {
            final list = snapshot.data == null
                ? []
                : (snapshot.data as List)
                    .map((e) => e as Map<String, dynamic>)
                    .toList();
            return Scaffold(
              appBar: AppBar(title: const Text("Current Chats")),
              body: ListView.builder(
                itemCount: list.length,
                itemBuilder: (BuildContext context, int index) {
                  final data = list[index];
                  Timestamp t = data["time_sent"];
                  DateTime lastSent = t.toDate();
                  return ContactsCard(
                    name: data["user2_name"],
                    otherName: data["user1_name"],
                    id: data["chatID"],
                    lastMessage: data["lastMessage"],
                    timeSent: lastSent,
                    user: "p",
                    refresh: () => refresh(),
                  );
                },
              ),
            );
          }),
        ),
      ),
    ]);
  }
}
