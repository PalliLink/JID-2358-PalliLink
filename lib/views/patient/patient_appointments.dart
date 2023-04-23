import 'package:flutter/material.dart';
import 'package:pallinet/components/appointment_card.dart';
import 'package:pallinet/components/loading.dart';
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
        child: FutureBuilder<Map<String, dynamic>>(
          future:
              _prefs.getUid().then((uid) => retrieveAppointmentsPatients(uid)),
          builder: ((context, snapshot) {
            if (!snapshot.hasData) {
              return const LoadingScreen("Loading appointments");
            }
            // final list = snapshot.data == null
            //     ? []
            //     : (snapshot.data as List)
            //         .map((e) => e as Map<String, dynamic>)
            //         .toList();
            // List past = snapshot.data!['past'];
            Map<String, dynamic> data = snapshot.data as Map<String, dynamic>;
            List past = data['past'];
            List future = data['future'];
            debugPrint('past ${past.toString()}');
            return Scaffold(
                appBar: AppBar(title: const Text("Appointments")),
                body: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        "Upcoming Appointments",
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: future.length,
                      itemBuilder: (BuildContext context, int index) {
                        final data = future[index];
                        return AppointmentCard(
                          name: data["practitioner"],
                          date: data["scheduledTimeStart"],
                          appointmentType: data["appointmentType"],
                          id: data["appointmentID"],
                          refresh: () => refresh(setState),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        "Past Appointments",
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: past.length,
                      itemBuilder: (BuildContext context, int index) {
                        final data = past[index];
                        return AppointmentCard(
                          name: data["practitioner"],
                          date: data["scheduledTimeStart"],
                          appointmentType: data["appointmentType"],
                          id: data["appointmentID"],
                          refresh: () => refresh(setState),
                        );
                      },
                    ),
                  ],
                ));
          }),
        ),
      ),
    ]);
  }
}
