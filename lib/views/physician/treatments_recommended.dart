import 'package:flutter/material.dart';

class TreatmentsRecommended extends StatelessWidget {
  const TreatmentsRecommended({super.key});

  @override
  Widget build(BuildContext context) {
    // double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(title: const Text("Reccomended Treatments")),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: const [Text("testing")],
      ),
    );
  }
}
