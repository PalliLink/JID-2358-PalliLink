import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:pallinet/components/scheduler.dart';
import 'package:pallinet/constants.dart';
import 'package:pallinet/firestore/firestore.dart';
import 'package:pallinet/models/patient_model.dart';
import 'package:pallinet/models/session_manager.dart';
import 'package:pallinet/utils.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class CreateConversation extends StatelessWidget {
  const CreateConversation({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Create chat room')),
        body: const Center(
            child: SingleChildScrollView(child: ConversationContent())));
  }
}

class ConversationContent extends StatefulWidget {
  const ConversationContent({Key? key}) : super(key: key);

  @override
  State<ConversationContent> createState() => ConversationContentState();
}

class ConversationContentState extends State<ConversationContent> {
  late final SessionManager _prefs;

  @override
  void initState() {
    _prefs = SessionManager();
    super.initState();
  }

  bool isPasswordVisible = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  PatientID? patient;
  List? practitioners = [];
  DateTime appointmentDate = DateTime.now();
  DateTime appointmentStart = DateTime.now();
  DateTime appointmentEnd = DateTime.now();
  String? desc = "";
  ServiceType? serviceType;



  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>?>(
      // future: retrieveAppointmentCreationInfo(),
      future:
          _prefs.getUid().then((uid) => retrieveChatCreationInfo(uid)),
      builder: ((context, snapshot) {
        // List of physician's patients
        List<PatientID> list = snapshot.data == null
            ? []
            : snapshot.data?["patients"] as List<PatientID>;
        return Stack(children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 1000),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    DropdownButtonFormField(
                        validator: (value) => requiredValue(value),
                        decoration: const InputDecoration(
                          hintText: 'Patient',
                          prefixIcon: Icon(Icons.person),
                        ),
                        items: list.map((e) {
                          return DropdownMenuItem<PatientID>(
                              value: e, child: Text(e.name));
                        }).toList(),
                        onChanged: (PatientID? value) {
                          debugPrint("temmp");
                        },
                        onSaved: (value) => {patient = value},
                        value: patient),
                    gap(),
                    TextFormField(
                      keyboardType: TextInputType.multiline,
                      validator: (value) => requiredValue(value),
                      maxLines: null,
                      minLines: 3,
                      onSaved: (value) => {desc = value},
                      decoration: const InputDecoration(
                        hintText: 'initial message',
                        prefixIcon: Icon(Icons.description),
                      ),
                    ),
                    
                    ElevatedButton(
                        onPressed: () {
                          _formKey.currentState?.save();
                            Map<String, dynamic> payload = {
                              "patient": patient!.name,
                              "patient_id": patient!.id,
                              "practitioner": practitioners,
                              "description": desc,
                            };
                            _prefs.getUid().then(
                                (value) => createConversation(payload, value));
                            // CreateConversation(payload);

                            Navigator.pop(context);
                          
                        },
                        child: const Text("Create Appointment"))
                  ],
                ),
              ),
            ),
          ),
        ]);
      }),
    );
  }

  Widget gap() => const SizedBox(height: 16);
}

