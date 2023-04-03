import 'package:flutter/material.dart';
import 'package:pallinet/components/loading.dart';
import 'package:pallinet/components/medications_card.dart';
import 'package:pallinet/firestore/firestore.dart';
import 'package:pallinet/models/medication_model.dart';
import 'package:pallinet/models/session_manager.dart';

import '../components/pain_chart.dart';

class Chart extends StatefulWidget {
  const Chart({super.key});

  @override
  State<Chart> createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  late final SessionManager _prefs;

  @override
  void initState() {
    _prefs = SessionManager();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)?.settings.arguments ?? '';
    // debugPrint(arguments.toString());
    return Container(
        padding: const EdgeInsets.all(15),
        child: PainChart(id: arguments.toString()));
  }
}
