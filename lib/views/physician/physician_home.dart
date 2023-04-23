import 'package:flutter/material.dart';
import 'package:pallinet/components/custom_button.dart';
import 'package:pallinet/components/loading.dart';
import 'package:pallinet/models/physician_model.dart';
import 'package:pallinet/models/session_manager.dart';
import 'package:pallinet/firestore/firestore.dart';
import 'package:pallinet/utils.dart';

class PhysicianHome extends StatefulWidget {
  const PhysicianHome({super.key});

  @override
  State<PhysicianHome> createState() => _PhysicianHomeState();
}

class _PhysicianHomeState extends State<PhysicianHome> {
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
    Widget gap() => const SizedBox(height: 30);
    String name;

    return FutureBuilder<Physician>(
        future: _prefs.getUid().then((uid) => retrievePhysicianProfile(uid)),
        builder: ((context, snapshot) {
          if (snapshot.hasData) {
            Physician? physData = snapshot.data;
            name = physData!.name;

            return Scaffold(
              appBar: AppBar(title: Text("Dr. $name")),
              body: ListView(
                padding: const EdgeInsets.all(15),
                children: [
                  CustomButton(
                    icon: Icons.assignment_ind,
                    iconColor: Colors.pink,
                    route: '/patients',
                    text: 'Patients',
                  ),
                  gap(),
                  CustomButton(
                    icon: Icons.schedule,
                    iconColor: Colors.pink,
                    route: '/physician/appointments',
                    text: 'Appointments',
                  ),
                  gap(),
                  CustomButton(
                    icon: Icons.people,
                    iconColor: Colors.pink,
                    route: '/contacts/physicians',
                    text: 'Messages',
                  ),
                  gap(),
                  CustomButton(
                    icon: Icons.settings,
                    iconColor: Colors.pink,
                    route: '/physician/profile',
                    text: 'View Profile',
                    update: true,
                    refresh: () => refresh(setState),
                  ),
                ],
              ),
            );
          } else {
            return const LoadingScreen("Loading Home");
          }
        }));
  }
}
