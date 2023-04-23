import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pallinet/components/appointment_card.dart';
import 'package:pallinet/components/contacts_card.dart';
import 'package:pallinet/firestore/firestore.dart';
import 'package:pallinet/models/session_manager.dart';

class ContactsPagePhysician extends StatefulWidget {
  const ContactsPagePhysician({super.key});

  @override
  State<ContactsPagePhysician> createState() => _ContactsPagePhysicianState();
}

class _ContactsPagePhysicianState extends State<ContactsPagePhysician> {
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
              .then((uid) => retrieveMessagesPhysicians(uid)),
          builder: ((context, snapshot) {
            final list = snapshot.data == null
                ? []
                : (snapshot.data as List)
                    .map((e) => e as Map<String, dynamic>)
                    .toList();
            return Scaffold(
              appBar: AppBar(title: const Text("Chats")),
              body: ListView.builder(
                itemCount: list.length,
                itemBuilder: (BuildContext context, int index) {
                  final data = list[index];
                  Timestamp t = data["time_sent"];
                  DateTime lastSent = t.toDate();
                  return ContactsCard(
                    name: data["user1_name"],
                    id: data["chatID"],
                    lastMessage: data["lastMessage"],
                    timeSent: lastSent,
                    refresh: () => refresh(),
                  );
                },
              ),
            );
          }),
        ),
      ),
      Expanded(
        flex: 2,
        child: ElevatedButton(
            onPressed: () => {
                  Navigator.pushNamed(context, "/physician/chat/new")
                      .then((_) => setState(() {}))
                },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white, // Background color
            ),
            child: Row(
              children: const [
                Icon(
                  Icons.schedule,
                  color: Colors.pink,
                  size: 40,
                ),
                SizedBox(
                  width: 20,
                ),
                Text(
                  'Start conversation',
                  style: TextStyle(fontSize: 20, color: Colors.black),
                )
              ],
            )),
      )
    ]);
  }
}
