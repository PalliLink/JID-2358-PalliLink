import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pallinet/firestore/firestore.dart';

Future<void> cancelDialog(BuildContext context, String id, String name,
    DateTime date, Function callback) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Cancel Appointment Confirmation'),
        content: Text(
            'Are you sure you want to cancel appointment with $name at ${DateFormat('MM-dd-yyyy').format(date)}?'),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            child: const Text('Continue'),
            onPressed: () {
              cancelAppointment(id);
              Navigator.of(context).pop();
              callback();
            },
          ),
        ],
      );
    },
  );
}
