import 'package:flutter/material.dart';

import 'package:pallinet/components/custom_button.dart';
import 'package:pallinet/components/loading.dart';
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
    return FutureBuilder<Patient?>(
      future: _prefs.getUid().then((uid) => retrievePatientProfile(uid)),
      builder: ((context, snapshot) {
        Widget gap() => const SizedBox(height: 30);
        if (snapshot.hasData) {
          Patient? patientData = snapshot.data;
          String patientName = patientData!.name.text;
          return Scaffold(
            appBar: AppBar(title: Text(patientName)),
            body: ListView(
              padding: const EdgeInsets.all(15),
              children: [
                CustomButton(
                  icon: Icons.calendar_month_rounded,
                  iconColor: const Color.fromRGBO(64, 192, 251, 1),
                  route: '/patient/calendar',
                  text: 'Calendar',
                ),
                gap(),
                const SizedBox(height: 300, child: PainDiary()),
                gap(),
                CustomButton(
                  icon: Icons.schedule,
                  iconColor: const Color.fromRGBO(64, 192, 251, 1),
                  route: '/patient/appointments',
                  text: 'Appointments',
                ),
                gap(),
                CustomButton(
                  icon: Icons.people,
                  iconColor: Colors.pink,
                  route: '/contacts',
                  text: 'Messages',
                ),
                gap(),
                CustomButton(
                  icon: Icons.health_and_safety_outlined,
                  iconColor: Colors.red,
                  route: '/patient/treatments',
                  text: 'Treatments',
                ),
                gap(),
                CustomButton(
                  icon: Icons.medication,
                  iconColor: Colors.purpleAccent,
                  route: '/patient/medications',
                  text: 'Medications',
                ),
                gap(),
                CustomButton(
                  icon: Icons.person_search,
                  iconColor: Colors.green,
                  route: '/patient/recommendedspecialists',
                  text: 'Recommended Specialists',
                ),
                gap(),
                CustomButton(
                  icon: Icons.list_alt_sharp,
                  iconColor: Colors.redAccent,
                  route: '/patient/endoflifeplans',
                  text: 'End of Life Plans',
                ),
                gap(),
                CustomButton(
                  icon: Icons.local_hospital,
                  iconColor: Colors.green,
                  route: '/facilities',
                  text: 'Facilities',
                ),
              ],
            ),
          );
        } else {
          return const LoadingScreen("Loading Home");
        }
      }),
    );
  }
}
