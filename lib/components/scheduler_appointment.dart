import 'package:flutter/material.dart';

class SchedulerAppointments extends StatelessWidget {
  const SchedulerAppointments({
    super.key,
    required this.physicianAppointments,
    required this.dateNotifier,
  });

  final ValueNotifier<DateTime> dateNotifier;
  final List<Map> physicianAppointments;

  final String name = "temp";

  @override
  Widget build(BuildContext context) {
    // debugPrint("Inside scheduler appointment");
    return Positioned.fill(
        child: AnimatedBuilder(
      animation: dateNotifier,
      builder: (context, child) {
        return Container(
            color: Colors.transparent,
            child: LayoutBuilder(
              builder: (context, constraints) {
                double unitWidth = constraints.biggest.width / 8.0;
                double unitHeight = constraints.biggest.height /
                    9.0; // 9.0 is hardcoded for timerange of 8-5
                return Stack(
                  children: getChildren(
                      dateNotifier.value, unitWidth, unitHeight, context),
                );
              },
            ));
      },
    ));
  }

  getChildren(date, unitWidth, unitHeight, context) {
    List<Positioned> children = [];

    for (var appointment in physicianAppointments) {
      DateTime start = appointment["timeStart"];
      DateTime end = appointment["timeEnd"];
      if (start.isAfter(date) &&
          start.isBefore(date.add(const Duration(days: 7)))) {
        children.add(Positioned(
            top: unitHeight * topOffsetFactor(start),
            left: unitWidth * leftOffsetFactor(start),
            child: Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).primaryColorLight,
                  border: Border.all(
                    color: Theme.of(context).primaryColorLight,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(4))),
              height: unitHeight *
                  lengthFactor(
                      start, end), // depends on appointment length needs math
              width: unitWidth - 2,
              child: Column(
                children: [
                  Text(
                    appointment["patient"],
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  Text(appointment["appointmentType"],
                      style: Theme.of(context).textTheme.labelMedium)
                ],
              ),
            )));
      }
    }
    return children;
  }
}

int leftOffsetFactor(DateTime date) => date.weekday + 1;
int topOffsetFactor(DateTime date) =>
    date.subtract(const Duration(hours: 8)).hour; //hardcoded for 8-5
double lengthFactor(DateTime start, DateTime end) =>
    end.difference(start).inMinutes / 60.0;
