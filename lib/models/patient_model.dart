import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pallinet/constants.dart';
import 'package:pallinet/models/name_model.dart';

class Patient {
  late bool active;
  late DateTime birthdate;
  late Gender gender;
  // late String generalPractitioner;
  late String id;
  late String identifier;
  late String description;
  late Name name;

  Patient(this.active, this.birthdate, this.gender, this.id, this.identifier,
      this.description, this.name);

  Patient.fromJson(Map<dynamic, dynamic> json) {
    active = json['active'];
    birthdate = (json['birthdate'] as Timestamp).toDate();
    gender = json["gender"] == "Male" ? Gender.male : Gender.female;
    // generalPractitioner = json['generalPractitioner'];
    id = json['id'];
    identifier = json['identifier'];
    description = json['description'];
    name = Name.fromJson(json['name']);
  }
}

class PatientID {
  final String name;
  final Gender gender;
  final String id;
  final DateTime birthdate;

  PatientID(this.name, this.gender, this.id, this.birthdate);

  @override
  String toString() {
    String bdate = birthdate.toString();
    return 'PatientID: $name $gender $id $bdate';
  }
}
