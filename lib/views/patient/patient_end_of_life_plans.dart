import 'package:flutter/material.dart';
import 'package:pallinet/components/loading.dart';
import 'package:pallinet/firestore/firestore.dart';
import 'package:pallinet/models/patient_model.dart';
import 'package:pallinet/models/session_manager.dart';

class EndOfLifePlansView extends StatelessWidget {
  const EndOfLifePlansView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('End of Life Plans')),
        body:
            const Padding(padding: EdgeInsets.all(16.0), child: PlanContent()));
    // );
  }
}

class PlanContent extends StatefulWidget {
  const PlanContent({Key? key}) : super(key: key);

  @override
  State<PlanContent> createState() => PlanContentState();
}

class PlanContentState extends State<PlanContent> {
  late final SessionManager _prefs;

  @override
  void initState() {
    _prefs = SessionManager();
    super.initState();
  }

  bool isPasswordVisible = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? desc = "gkyhuiadfsss";

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Patient?>(
        future: _prefs.getUid().then((uid) => retrievePatientProfile(uid)),
        builder: ((context, snapshot) {
          if (snapshot.hasData) {
            Patient? patData = snapshot.data;
            desc = patData!.description;
            // debugPrint("4");
            // debugPrint(desc);
            return Container(
              constraints: const BoxConstraints(maxWidth: 1000),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // gap(),
                    // gap(),
                    // const Text(
                    //   'Update End of Life Plans',
                    //   textAlign: TextAlign.left,
                    //   style:
                    //       TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    // ),
                    gap(),
                    TextFormField(
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      minLines: 5,
                      initialValue: desc,
                      onSaved: (value) => {desc = value},
                      decoration: const InputDecoration(
                        hintText: 'Enter here',
                        prefixIcon: Icon(Icons.description),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                      ),
                    ),
                    gap(),
                    ElevatedButton(
                        onPressed: () {
                          _formKey.currentState?.save();
                          Map<String, dynamic> payload = {
                            "description": desc,
                          };
                          // debugPrint("3");
                          // debugPrint(desc);
                          _prefs.getUid().then(
                              (uid) => {updateEndOfLifePlans(payload, uid!)});
                          Navigator.pushNamed(context, "/patient/home");
                        },
                        child: const Text("Change End of Life Plans"))
                  ],
                ),
              ),
            );
          } else {
            return const LoadingScreen("Loading End of Life Plans");
          }
        }));
  }

  Widget gap() => const SizedBox(height: 16);
}
