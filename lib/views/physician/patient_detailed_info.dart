import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pallinet/components/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pallinet/firestore/firestore.dart';

class PatientDetails extends StatelessWidget {
  const PatientDetails({super.key});
  Widget gap() => const SizedBox(
        height: 10,
        // color: Colors.black,
      );

  Widget buildInfo(dynamic name, dynamic sex, dynamic age, dynamic mrn) =>
      Column(children: [
        Text(
          name,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        const SizedBox(height: 4),
        Text(
            '$sex | ${((DateTime.now().difference(age).inDays) ~/ 365.0)} years old'),
        const SizedBox(height: 10),
        Container(
          height: 200,
          width: 350,
          color: Colors.transparent,
          child: Container(
              decoration: BoxDecoration(
                  color: Colors.lightBlue[200],
                  borderRadius: const BorderRadius.all(Radius.circular(20.0))),
              alignment: const Alignment(-.8, -.3),
              child: Text('MRN:'
                  '$mrn'
                  '\n'
                  '\nDOB:'
                  '\n${DateFormat('MM-dd-yyyy').format(age)}'
                  '\n'
                  '\nPain Regiment:'
                  '\n N/A'
                  '\n'
                  '\nPain Scores:'
                  '\n80, 70, 60')),
        )
      ]);

  Widget buildButtons() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Material(
            borderRadius: BorderRadius.circular(20),
            color: Colors.lightBlue[200],
            child: InkWell(
              onTap: () {
                debugPrint('Medical');
              },
              borderRadius: BorderRadius.circular(20),
              child: Container(
                  width: 150,
                  height: 100,
                  alignment: Alignment.center,
                  child: const Text(
                    "Medical History",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 26,
                    ),
                  )),
            ),
          ),
          Material(
            borderRadius: BorderRadius.circular(20),
            color: Colors.lightBlue[200],
            child: InkWell(
              onTap: () {
                debugPrint('Surgical');
              },
              borderRadius: BorderRadius.circular(20),
              child: Container(
                  width: 150,
                  height: 100,
                  alignment: Alignment.center,
                  child: const Text(
                    "Surgical History",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 26,
                    ),
                  )),
            ),
          ),
        ],
      );

  @override
  Widget build(BuildContext context) {
    debugPrint(ModalRoute.of(context)?.settings.arguments.toString());
    final arguments = ModalRoute.of(context)?.settings.arguments ?? '';
    debugPrint(arguments.toString());
    return FutureBuilder<Map<dynamic, dynamic>>(
      future: retrievePatientDetails(arguments),
      builder: ((context, snapshot) {
        if (snapshot.hasData) {
          Map<String, dynamic> datas = snapshot.data as Map<String, dynamic>;
          Timestamp t;
          t = datas["birthdate"] as Timestamp;
          DateTime birthdate = t.toDate();
          return Scaffold(
              appBar: AppBar(title: const Text('Detailed Patient View')),
              // appBar: AppBar(title: Text(datas['name']['text'])),
              body: ListView(
                children: [
                  const Icon(
                    Icons.account_circle,
                    size: 80,
                  ),
                  // const SizedBox(height: 24),
                  buildInfo(datas['name']['text'], datas['gender'], birthdate,
                      datas['id']),
                  gap(),
                  buildButtons(),
                  const SizedBox(height: 30),
                  Center(
                    child: Material(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.lightBlue[200],
                      child: InkWell(
                        onTap: () {
                          Navigator.pushNamed(
                              context, "/physician/patient/edit_details",
                              arguments: arguments);
                        },
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                            width: 350,
                            height: 100,
                            alignment: Alignment.center,
                            child: const Text(
                              "Edit Details",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 26,
                              ),
                            )),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Material(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.lightBlue[200],
                    child: InkWell(
                      onTap: () {
                        // debugPrint(arguments.toString());
                        Navigator.pushNamed(
                          context,
                          "/chart",
                          arguments: arguments,
                        );
                      },
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                          width: 350,
                          height: 100,
                          alignment: Alignment.center,
                          child: const Text(
                            "Pain Charts",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 26,
                            ),
                          )),
                    ),
                  ),
                ],
              ));
        } else {
          return const LoadingScreen('Loading Patient Details');
        }
      }),
    );
  }
}
