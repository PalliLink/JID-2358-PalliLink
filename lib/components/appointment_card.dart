import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:pallinet/components/appointment_cancel_dialog.dart';

class AppointmentCard extends StatelessWidget {
  const AppointmentCard(
      {super.key,
      required this.name,
      required this.date,
      required this.appointmentType,
      required this.id,
      required this.refresh});

  final String name;
  final DateTime date;
  final String appointmentType;
  final String id;
  final Function refresh;
  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () => {
              Navigator.pushNamed(context, "/appointments/details",
                      arguments: id)
                  .then((_) => refresh())
            },
        child: Card(
            child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Expanded(
                flex: 1,
                child: Icon(Icons.account_circle, size: 48),
              ),
              Expanded(
                flex: 4,
                child: _AppointmentDescription(
                    name: name, date: date, appointmentType: appointmentType),
              ),
              PopupMenuButton(
                icon: const Icon(
                  Icons.more_vert,
                  size: 16.0,
                ),
                itemBuilder: (context) => const [
                  PopupMenuItem(value: 0, child: Text("Details")),
                  PopupMenuItem(value: 1, child: Text("Reschedule")),
                  PopupMenuItem(value: 2, child: Text("Remove"))
                ],
                onSelected: (value) {
                  if (value == 0) {
                    Navigator.pushNamed(context, "/appointments/details",
                        arguments: id);
                  } else if (value == 1) {
                  } else if (value == 2) {
                    cancelDialog(context, id, name, date, refresh);
                  }
                },
              ),
            ],
          ),
        )));
  }
}

class _AppointmentDescription extends StatelessWidget {
  const _AppointmentDescription({
    required this.name,
    required this.date,
    required this.appointmentType,
  });

  final String name;
  final DateTime date;
  final String appointmentType;

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting('en,', null);
    return Padding(
      padding: const EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            name,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 18.0,
            ),
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 2.0)),
          Text(
            'Appointment type: $appointmentType',
            style: const TextStyle(fontSize: 14.0),
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 1.0)),
          Text(
            'Time: ${DateFormat('hh:mm a').format(date)}',
            style: const TextStyle(fontSize: 14.0),
          ),
          Text(
            'Date ${DateFormat('MM-dd-yyyy').format(date)}',
            style: const TextStyle(fontSize: 14.0),
          ),
        ],
      ),
    );
  }
}
