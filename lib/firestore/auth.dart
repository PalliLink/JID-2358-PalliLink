
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pallinet/constants.dart';
import 'package:pallinet/models/session_manager.dart';

import 'firestore.dart';

SessionManager prefs = SessionManager();

Future<bool> createPatient(payload) async {
  List<String> birthdate = payload["birthdate"].split("/");
  //maximum number the ID can reach. Can be changed if all the IDs are occupied 
  const int maxID = 9000000;
  try {
    final credential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: payload['email'],
      password: payload['password'],
    );
    String uid = credential.user!.uid;
    bool check = true;
    String id = "";
    Random rand = Random();
    int loopError = 0;
    //continually loops until it creates a unique ID for the patient
    while(check && loopError < maxID + 1000000) {
      int randID = rand.nextInt(maxID) + 1000000;
      //Query database for IDs matching the randomly generated one.
      QuerySnapshot result = (await db.collection("Patient")
        .where('id', isEqualTo: randID.toString()).get());
      List<QueryDocumentSnapshot<Object?>> newResult = result.docs;
      int count = newResult.length;
      if (count == 0) {
        id = randID.toString();
        break;
      }
      //If it loops for too long, then we've either created the max number of possible patients with
      //this length of ID or there was just an error and we must break out of it
      loopError++;
    }
    if (loopError >= maxID + 1000000) {
      debugPrint("Error assigning ID. Maximum number of patients reached");
      return false;
    }
    // Create patient
    db.collection("Patient").doc(uid).set({
      "active": true,
      "birthdate": DateTime(int.parse(birthdate[2]), int.parse(birthdate[0]),
          int.parse(birthdate[1])),
      "deceasedBoolean": false,
      "gender": payload["gender"].value,
      "id": id, 
      "name": {
        "family": payload["lastName"],
        "given": payload["firstName"],
        "text": payload["firstName"] + " " + payload["lastName"],
      }
    });

    prefs.setUid(uid);

    // Add phone number if included
    if (!payload["phoneNumber"]?.isEmpty && payload["type"] != null) {
      db.collection("Patient").doc(uid).collection("ContactPoint").add({
        "system": "phone",
        "use": payload["type"]?.value,
        "value": payload["phoneNumber"]
      });
    }
  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      debugPrint('The password provided is too weak.');
    } else if (e.code == 'email-already-in-use') {
      debugPrint('The account already exists for that email.');
    }
    return false;
  } catch (e) {
    debugPrint(e.toString());
    return false;
  }

  return true;
}

Future<AuthStatus> signIn(payload) async {
  try {
    final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: payload["email"], password: payload["password"]);
    debugPrint("Signed in: $credential.user!.uid");

    var snapshot = await db
        .collection(payload["userType"].value)
        .doc(credential.user!.uid)
        .get();
    if (!snapshot.exists) {
      return AuthStatus.incorrectAccountType;
    }

    await prefs.setUid(credential.user!.uid);

    return AuthStatus.success;
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      debugPrint('No user found for that email.');
      return AuthStatus.unknownEmail;
    } else if (e.code == 'wrong-password') {
      debugPrint('Wrong password provided for that user.');
      return AuthStatus.incorrectPassword;
    }
  }

  return AuthStatus.unknownError;
}

Future<bool> debugPhysician() async {
  await prefs.setUid("5nsl8S4wXoeNLc6OzVgwJGRBmv62");
  return true;
}

Future<bool> debugPatient() async {
  await prefs.setUid("mpMQADgfZqMPo25LQkw8ZcgKmTw2");
  return true;
}

Future<AuthStatus> resetPassword(payload) async {
  AuthStatus status = AuthStatus.success;
  String email = payload["email"];
  await FirebaseAuth.instance
      .sendPasswordResetEmail(email: email)
      .then((value) => status = AuthStatus.success)
      .catchError((e) => status = AuthStatus.unknownEmail);
  return status;
}
