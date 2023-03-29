import 'package:flutter/material.dart';

import 'package:pallinet/components/custom_button.dart';
import 'package:pallinet/components/pain_diary.dart';
import 'package:pallinet/firestore/firestore.dart';
import 'package:pallinet/models/patient_model.dart';
import 'package:pallinet/models/session_manager.dart';

class PatientHome extends StatefulWidget {
  const PatientHome({super.key});

  @override
  State<PatientHome> createState() => _PatientHomeState();
}

class _PatientHomeState extends State<PatientHome> {
  late final SessionManager _prefs;

  @override
  void initState() {
    _prefs = SessionManager();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PatientID?>(
      future: _prefs.getUid().then((uid) => retrievePatientProfile(uid)),
      builder: ((context, snapshot) {
        Widget gap() => const SizedBox(height: 30);

        String patientName = snapshot.data == null
            ? "Loading..."
            : (snapshot.data as PatientID).name;
        return Scaffold(
          appBar: AppBar(title: Text(patientName)),
          body: ListView(
            padding: const EdgeInsets.all(15),
            children: [
              const CustomButton(
                icon: Icons.calendar_month_rounded,
                iconColor: Color.fromRGBO(64, 192, 251, 1),
                route: '/patient/calendar',
                text: 'Calendar',
              ),
              gap(),
              const SizedBox(height: 300, child: PainDiary()),
              gap(),
              const CustomButton(
                icon: Icons.schedule,
                iconColor: Color.fromRGBO(64, 192, 251, 1),
                route: '/patient/appointments',
                text: 'Appointments',
              ),
              gap(),
              const CustomButton(
                icon: Icons.health_and_safety_outlined,
                iconColor: Colors.red,
                route: '/patient/treatments',
                text: 'Treatments',
              ),
              gap(),
              const CustomButton(
                icon: Icons.medication,
                iconColor: Colors.purpleAccent,
                route: '/patient/medications',
                text: 'Medications',
              ),
              gap(),
              const CustomButton(
                icon: Icons.local_hospital,
                iconColor: Colors.green,
                route: '/patient/recommendedspecialists',
                text: 'Recommended Specialists',
              ),
              gap(),
              const CustomButton(
                icon: Icons.list_alt_sharp,
                iconColor: Colors.redAccent,
                route: '/patient/endoflifeplans',
                text: 'End of Life Plans',
              ),
            ],
          ),
        );
      }),
    );
  }
}
