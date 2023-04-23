import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pallinet/components/appointment_cancel_dialog.dart';
import 'package:pallinet/components/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pallinet/firestore/firestore.dart';

class AppointmentPage extends StatelessWidget {
  const AppointmentPage({super.key});
  Widget gap() => const Divider(
        height: 10,
        color: Colors.black,
      );

  @override
  Widget build(BuildContext context) {
    debugPrint(ModalRoute.of(context)?.settings.arguments.toString());
    final arguments = ModalRoute.of(context)?.settings.arguments ?? '';
    debugPrint(arguments.toString());
    return FutureBuilder<Map<dynamic, dynamic>>(
      future: retrieveAppointment(arguments),
      builder: ((context, snapshot) {
        if (snapshot.hasData) {
          Map<String, dynamic> datas = snapshot.data as Map<String, dynamic>;
          Timestamp timeStart;
          Timestamp timeEnd;
          timeStart = datas["scheduledTimeStart"] as Timestamp;
          timeEnd = datas["scheduledTimeEnd"] as Timestamp;
          DateTime start = timeStart.toDate();
          DateTime end = timeEnd.toDate();

          String name = datas['patient'];
          String id = arguments.toString();

          return Scaffold(
              appBar: AppBar(title: const Text("Appointment")),
              body: ListView(
                children: [
                  Text('Appointment Type: ${datas['appointmentType']}',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20)),
                  gap(),
                  Text(
                      'Start Time: ${DateFormat('MM-dd-yyyy hh:mm a').format(start)}',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20)),
                  gap(),
                  Text(
                      'End Time: ${DateFormat('MM-dd-yyyy hh:mm a').format(end)}',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20)),
                  gap(),
                  Text('Patient: ${datas['patient']}',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20)),
                  gap(),
                  Text('Practitioner ID: ${datas['practitioner']}',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20)),
                  gap(),
                  ElevatedButton(
                      onPressed: () => {debugPrint("reschedule")},
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
                            'Reschedule Appointment',
                            style: TextStyle(fontSize: 20, color: Colors.black),
                          )
                        ],
                      )),
                  gap(),
                  ElevatedButton(
                      onPressed: () => {
                            cancelDialog(context, id, name, start,
                                () => Navigator.pop(context))
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
                            'Cancel Appointment',
                            style: TextStyle(fontSize: 20, color: Colors.black),
                          )
                        ],
                      )),
                ],
              ));
        } else {
          return const LoadingScreen('Loading Appointment Details');
        }
      }),
    );
  }
}
