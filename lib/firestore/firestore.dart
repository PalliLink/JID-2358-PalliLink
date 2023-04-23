import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'dart:collection';
import 'package:flutter/foundation.dart';
import 'package:pallinet/constants.dart';
import 'package:pallinet/models/medication_model.dart';
import 'package:pallinet/models/treatment_model.dart';
import 'package:pallinet/models/patient_model.dart';
import '../models/physician_model.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

// Pain Diary
void addData(UnmodifiableMapView<int, int> entries, uid, int length) async {
  // Create a new user with a first and last name
  final storedEntries = <String, dynamic>{};

  DateTime timeSubmitted = DateTime.now();
  storedEntries["timestamp"] = timeSubmitted;

  for (int i = 0; i < length; i++) {
    if (!entries.containsKey(i)) {
      storedEntries["q$i"] = 0;
    } else {
      storedEntries["q$i"] = entries[i];
    }
  }
  debugPrint("entries: ${storedEntries.toString()}");

  //add entry into patient database
  db
      .collection("Patient")
      .doc(uid)
      .collection("PainDiary")
      .add(storedEntries)
      .then((DocumentReference doc) =>
          debugPrint('patient entry added with ID: ${doc.id}'));
}

Future<Map<dynamic, dynamic>>? retrieveQuestions() async {
  debugPrint("============Retrieve Questions");

  Map<dynamic, dynamic> list = await db
      .collection("Pain Diary Questions")
      .doc("S3tecvHL4Vivoe2EomXj")
      .get()
      .then((DocumentSnapshot doc) {
    debugPrint(doc.data().toString());
    return doc.data() as Map<String, dynamic>;
  }, onError: (e) => debugPrint("Error getting document: $e"));

  return list;
}

Future<List<dynamic>>? retrieveEntries(uid) async {
  debugPrint("Retrieve entries");
  QuerySnapshot querySnapshot =
      await db.collection("Patient").doc(uid).collection("PainDiary").get();
  List<dynamic> list = querySnapshot.docs.map((doc) => doc.data()).toList();

  // debugPrint("out");
  // debugPrint(list.toString());
  return list;
}

Future<List<dynamic>>? retrieveEntries2(id) async {
  //used from practitioner end
  debugPrint("Retrieve entries");

  final patientRef = await db
      .collection("Patient")
      .where('id', isEqualTo: id)
      .get()
      .then((res) {
    return res.docs.single.reference;
  });

  QuerySnapshot querySnapshot = await patientRef.collection("PainDiary").get();
  List<dynamic> list = querySnapshot.docs.map((doc) => doc.data()).toList();

  // debugPrint("out");
  // debugPrint(list.toString());
  return list;
}

Future<List<dynamic>>? retrievePatients(uid) async {
  debugPrint("retrievePatients");

  Map<dynamic, dynamic> list = await db
      .collection("Practitioner")
      .doc(uid)
      .get()
      .then((DocumentSnapshot doc) {
    return doc.data() as Map<String, dynamic>;
  }, onError: (e) => debugPrint("Error getting document: $e"));

  List<dynamic> patients = list["patients"];
  debugPrint(patients.toString());

  return patients;
}

Future<List<Medication>>? retrieveMedications(uid) async {
  List<QueryDocumentSnapshot<Map<dynamic, dynamic>>> medicationsQuery = await db
      .collection("Patient")
      .doc(uid)
      .collection("Medication")
      .get()
      .then((res) {
    return res.docs;
  }, onError: (e) => debugPrint("Error getting document: $e"));

  List<Medication> medications = medicationsQuery.map((e) {
    return Medication(e["medication"], List<String>.from(e["brands"]),
        e["dosage"], e["orderDetail"], e["precautions"]);
  }).toList();

  return medications;
}

//testing treatments
Future<List<Treatment>>? retrieveTreatments(uid) async {
  List<QueryDocumentSnapshot<Map<dynamic, dynamic>>> treatmentsQuery = await db
      .collection("Patient")
      .doc(uid)
      .collection("Treatment")
      .get()
      .then((res) {
    return res.docs;
  }, onError: (e) => debugPrint("Error getting document: $e"));

  List<Treatment> treatments = treatmentsQuery.map((e) {
    return Treatment(
      e["treatmentType"],
      e["schedule"],
      e["durationToComplete"],
      e["detailedInstructions"],
    );
  }).toList();

  return treatments;
}

Future<Map<String, dynamic>>? retrieveAppointmentCreationInfo(uid) async {
  debugPrint("retrieveAppointmentCreationInfo");
  // debugPrint(uid);

  //retrieving patients
  final pracRef = db.collection("Practitioner").doc(uid);

  Map<dynamic, dynamic> list = await pracRef.get().then((DocumentSnapshot doc) {
    return doc.data() as Map<String, dynamic>;
  }, onError: (e) => debugPrint("Error getting document: $e"));

  String physID = list["id"];

  // parsing patient list
  List<dynamic> data = list["patients"];
  List<PatientID> patients = data.map((e) {
    Gender gender = e["gender"] == "M" ? Gender.male : Gender.female;
    Timestamp t = e["birthdate"] as Timestamp;
    DateTime birthdate = t.toDate();

    return PatientID(e["name"], gender, e["id"], birthdate);
  }).toList();

  // retrieving physcian availability
  final apptRef =
      db.collection("Appointment").where("practitioner", isEqualTo: physID);
  List<QueryDocumentSnapshot<Map<dynamic, dynamic>>> availability =
      await apptRef.get().then((res) {
    return res.docs;
  }, onError: (e) => debugPrint("Error getting document: $e"));

  // parsing physician availability
  List<Map<String, dynamic>> appointmentTime = availability.map((e) {
    Map<String, dynamic> times = {};

    Timestamp timestampStart = e["scheduledTimeStart"] as Timestamp;
    Timestamp timestampEnd = e["scheduledTimeEnd"] as Timestamp;

    DateTime timeStart = timestampStart.toDate();
    DateTime timeEnd = timestampEnd.toDate();

    times["timeStart"] = timeStart;
    times["timeEnd"] = timeEnd;
    times["appointmentType"] = e["appointmentType"];
    times["patient"] = e["patient"];

    return times;
  }).toList();

  Map<String, dynamic> map = {};
  map["patients"] = patients;
  map["appointmentTimes"] = appointmentTime;
  return map;
}

void createAppointment(Map<String, dynamic> payload, String? uid) async {
  debugPrint("createAppointment");

  final docRef = db.collection("Appointment").doc();

  Physician phys = await retrievePhysicianProfile(uid);

  await docRef.set({
    "appointmentID": docRef.id,
    "patient": payload["patient"],
    "practitioner": phys.id,
    "appointmentType": payload["type"],
    "description": payload["description"],
    "created": DateTime.now(),
    "serviceCategory": "appointment",
    "scheduledTimeStart": payload["scheduledTimeStart"],
    "scheduledTimeEnd": payload["scheduledTimeEnd"],
  });
}

void cancelAppointment(String id) async {
  debugPrint("Cancel Appointment $id");

  final docRef = db.collection("Appointment").doc(id);

  await docRef.delete();
}

void updateEndOfLifePlans(Map<String, dynamic> payload, String uid) async {
  debugPrint("updateEndOfLifePlans");
  var docRef = db.collection("Patient").doc(uid);
  await docRef.update({"description": payload["description"]});
}

// Retrieve patient profile given uid
Future<Patient>? retrievePatientProfile(uid) async {
  debugPrint("retrievePatientsProfile");
  // Retrieve patient using corresponding uid
  Map<dynamic, dynamic> patientInfo = await db
      .collection("Patient")
      .doc(uid)
      .get()
      .then((DocumentSnapshot doc) {
    return doc.data() as Map<String, dynamic>;
  }, onError: (e) => debugPrint("Error getting document: $e"));

  return Patient.fromJson(patientInfo);
}

Future<Physician> retrievePhysicianProfile(uid) async {
  // debugPrint("retrievePhysicianProfile");
  var docRef = db.collection("Practitioner").doc(uid);

  Map<dynamic, dynamic> list = await docRef.get().then((DocumentSnapshot doc) {
    return doc.data() as Map<String, dynamic>;
  }, onError: (e) => debugPrint("Error getting document: $e"));

  // Convert to Physician model and return
  Physician physician = Physician(
      list["name"]["text"],
      list["gender"] == "M" ? Gender.male : Gender.female,
      list["id"],
      list["description"],
      list["email"],
      list["phone"]);

  return physician;
}

void updatePhysicianProfile(String uid, Map<String, dynamic> payload) async {
  debugPrint("updatePhysicianProfile");
  var docRef = db.collection("Practitioner").doc(uid);

  await docRef.update({
    "description": payload["description"],
    "name.text": payload["name"],
    "email": payload["email"],
    "phone": payload["phone"]
  });
}

Future<Map<dynamic, dynamic>>? retrievePatientDetails(id) async {
  // debugPrint("retrievePatientDetails");

  Map<dynamic, dynamic> patientDetails = await db
      .collection("Patient")
      .where('id', isEqualTo: id)
      .get()
      .then((res) {
    return res.docs.single.data();
  });
  return patientDetails;
}

void updatePatientDetails(Map<dynamic, dynamic> data, id) async {
  debugPrint(id);
  final patientRef = await db
      .collection("Patient")
      .where('id', isEqualTo: id)
      .get()
      .then((res) {
    return res.docs.single.reference;
  });

  debugPrint("updateDetails");
  data.forEach((key, value) {
    debugPrint("$key . $value");

    if (value != null && value != "") {
      patientRef.update({"$key": value});
    }
  });
  // for-each loop over keys in data, update if not null

  // patientRef.update({"gender": data["gender"]});
}

//retreives the appointments specific to the physician using their id
//first accesses the entire appointments collection and then seperates out the ones specific to them
//currently hardcoded as I figure out how to pass the physician id into the appointments page
Future<List<dynamic>> retrieveAppointmentsPhysicians(uid) async {
  Map<dynamic, dynamic> physician = await db
      .collection("Practitioner")
      .doc(uid)
      .get()
      .then((DocumentSnapshot doc) {
    return doc.data() as Map<String, dynamic>;
  }, onError: (e) => debugPrint("Error getting document: $e"));

  QuerySnapshot appointments = await db
      .collection("Appointment")
      .where('practitioner', isEqualTo: physician["id"])
      .get();
  final allData = appointments.docs.map((doc) => doc.data()).toList();
  return allData;
}

Future<List<dynamic>> retrieveAppointmentsPatients(uid) async {
  Map<dynamic, dynamic> patient = await db
      .collection("Patient")
      .doc(uid)
      .get()
      .then((DocumentSnapshot doc) {
    return doc.data() as Map<String, dynamic>;
  }, onError: (e) => debugPrint("Error getting document: $e"));

  QuerySnapshot appointments = await db
      .collection("Appointment")
      .where('patient', isEqualTo: patient["name"]["text"])
      .get();
  final allData = appointments.docs.map((doc) => doc.data()).toList();
  return allData;
}

Future<Map<dynamic, dynamic>>? retrieveAppointment(id) async {
  Map<dynamic, dynamic> appointmentDetails = await db
      .collection("Appointment")
      .where('appointmentID', isEqualTo: id)
      .get()
      .then((res) {
    return res.docs.single.data();
  });
  return appointmentDetails;
}
