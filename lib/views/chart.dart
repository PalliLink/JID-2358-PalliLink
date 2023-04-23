import 'package:flutter/material.dart';

import '../components/pain_chart.dart';

class Chart extends StatefulWidget {
  const Chart({super.key});

  @override
  State<Chart> createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  // late final SessionManager _prefs;

  @override
  void initState() {
    // _prefs = SessionManager();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)?.settings.arguments ?? '';
    // debugPrint(arguments.toString());
    return PainChart(id: arguments.toString());
  }
}
