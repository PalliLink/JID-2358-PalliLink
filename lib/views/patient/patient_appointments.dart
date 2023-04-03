import 'package:flutter/material.dart';
import 'package:pallinet/components/appointment_card.dart';
import 'package:pallinet/models/session_manager.dart';
import 'package:pallinet/firestore/firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pallinet/utils.dart';

class PatientAppointments extends StatefulWidget {
  const PatientAppointments({super.key});

  @override
  State<PatientAppointments> createState() => _PatientAppointmentsState();
}

class _PatientAppointmentsState extends State<PatientAppointments> {
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
    return Column(children: [
      Expanded(
        flex: 8,
        child: FutureBuilder<List<dynamic>>(
          future:
              _prefs.getUid().then((uid) => retrieveAppointmentsPatients(uid)),
          builder: ((context, snapshot) {
            final list = snapshot.data == null
                ? []
                : (snapshot.data as List)
                    .map((e) => e as Map<String, dynamic>)
                    .toList();
            return Scaffold(
              appBar: AppBar(title: const Text("Appointments")),
              body: ListView.builder(
                itemCount: list.length,
                itemBuilder: (BuildContext context, int index) {
                  final data = list[index];
                  Timestamp t = data["scheduledTimeStart"] as Timestamp;
                  DateTime startTime = t.toDate();
                  return AppointmentCard(
                    name: data["practitioner"],
                    date: startTime,
                    appointmentType: data["appointmentType"],
                    id: data["appointmentID"],
                    refresh: () => refresh(setState),
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
