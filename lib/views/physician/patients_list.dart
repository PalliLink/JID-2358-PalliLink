import 'package:age_calculator/age_calculator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pallinet/components/loading.dart';
import 'package:pallinet/components/patient_card.dart';
import 'package:pallinet/firestore/firestore.dart';
import 'package:pallinet/models/session_manager.dart';

class PatientList extends StatefulWidget {
  const PatientList({super.key});

  @override
  State<PatientList> createState() => _PatientListState();
}

class _PatientListState extends State<PatientList> {
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
    return FutureBuilder<List<dynamic>?>(
      future: _prefs.getUid().then((uid) => retrievePatients(uid)),
      builder: ((context, snapshot) {
        if (!snapshot.hasData) {
          return const LoadingScreen("Loading Patients");
        }

        final list = snapshot.data ?? [];

        return Scaffold(
          appBar: AppBar(title: const Text("Patients")),
          body: ListView.builder(
            itemCount: list.length,
            itemBuilder: (BuildContext context, int index) {
              final data = list[index];
              Timestamp t = data["birthdate"] as Timestamp;
              DateTime birthdate = t.toDate();
              return PatientCard(
                name: data["name"],
                id: data["id"],
                age: AgeCalculator.age(birthdate).years,
                sex: data["gender"],
                birthdate: birthdate,
              );
            },
          ),
        );
      }),
    );
  }
}
