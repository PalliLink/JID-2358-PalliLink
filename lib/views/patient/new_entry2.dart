import 'package:flutter/material.dart';
import 'package:pallinet/components/loading.dart';
import 'package:pallinet/firestore/firestore.dart';

import '../../models/session_manager.dart';

class NewPainDiaryEntry extends StatefulWidget {
  const NewPainDiaryEntry({super.key});

  @override
  State<NewPainDiaryEntry> createState() => NewPainDiaryEntryState();
}

class NewPainDiaryEntryState extends State<NewPainDiaryEntry> {
  late final SessionManager _prefs;
  String? uid = "";

  @override
  void initState() {
    _prefs = SessionManager();
    _prefs.getUid().then(
          (value) => uid = value,
        );
    super.initState();
  }

  int questionNum = 0;
  double input = 0;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<dynamic, dynamic>>(
      future: retrieveQuestions(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const LoadingScreen("Loading questions");
        }
        List<String> painDiaryQuestions =
            List<String>.from(snapshot.data!["questions"]);
        List<String> questionTypes = List<String>.from(snapshot.data!["type"]);
        return Scaffold(
            appBar: AppBar(
              title: const Text("New Pain Diary Entry"),
              // automaticallyImplyLeading: false,
              backgroundColor: Colors.blue,
            ),
            body: PageView.builder(
              itemCount: questionTypes.length,
              itemBuilder: (BuildContext context, int index) {
                return Text(
                    "${painDiaryQuestions[index]}\n${questionTypes[index]}");
              },
            ));
      },
    );
  }
}
