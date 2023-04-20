import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../firestore/firestore.dart';
import '../models/session_manager.dart';
import 'package:collection/collection.dart';

class PainChart extends StatefulWidget {
  final String id;

  const PainChart({Key? key, this.id = ''}) : super(key: key);

  @override
  State<PainChart> createState() => _PainChart();
}

List<LineChartBarData> getChartData(
    List<dynamic> list, int length, String dropdown) {
  List<dynamic> colors = [
    Colors.pink,
    Colors.red,
    Colors.orange,
    Colors.green,
    Colors.teal,
    Colors.blue,
    Colors.indigo,
    Colors.purple,
    Colors.black
  ];
  // debugPrint(list.toString());
  list.sort(
      (a, b) => a["timestamp"].toDate().compareTo(b["timestamp"].toDate()));

  List<LineChartBarData> out = [];
  Map<DateTime, int> temp = {};
  debugPrint("start");
  debugPrint(dropdown);
  int i = 0;
  int end = length;
  // HARD-CODED
  if (dropdown == "additional") {
    i = 10;
    debugPrint("additional");
  } else {
    end = 9;
  }
  // if drop == "additional"
  for (i; i < end; i++) {
    for (var j = 0; j < list.length; j++) {
      // debugPrint(temp.toString());

      DateTime d = list[j]["timestamp"].toDate();
      d.millisecondsSinceEpoch;
      temp[d] = list[j]["q$i"];
    }
    debugPrint(temp.toString());

    out.add(LineChartBarData(
        color: colors[i % 9],
        spots: temp.entries.map((e) {
          return FlSpot(
              e.key.millisecondsSinceEpoch.toDouble(), e.value.toDouble());
        }).toList()));
  }
  debugPrint(out[0].spots.toString());
  return out;
}

class _PainChart extends State<PainChart> {
  late final SessionManager _prefs;
  List<String> itemList = <String>["main", "additional"];
  late String dropdownValue = itemList.first;

  @override
  void initState() {
    _prefs = SessionManager();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint(widget.id.toString());
    return FutureBuilder<List<dynamic>?>(
        future: widget.id != ''
            ? retrieveEntries2(widget.id)
            : _prefs.getUid().then((uid) => retrieveEntries(uid)),
        builder: ((context, snapshot) {
          if (snapshot.data == null) {
            return const SizedBox.shrink();
          }

          final list = snapshot.data as List;
          if (list.isEmpty) {
            return Scaffold(
                appBar: AppBar(title: const Text("Pain Chart")),
                body: const Text("No Pain Diary entries to show"));
          }
          debugPrint(list.toString());
          debugPrint(list[0]["timestamp"].runtimeType.toString());
          return Scaffold(
              appBar: AppBar(title: const Text("Pain Chart")),
              body: Column(children: <Widget>[
                DropdownButton(
                  value: dropdownValue,
                  icon: const Icon(Icons.arrow_downward),
                  style: const TextStyle(color: Colors.deepPurple),
                  underline: Container(
                    height: 2,
                    color: Colors.deepPurpleAccent,
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      dropdownValue = value!;
                    });
                  },
                  items: itemList.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                Padding(
                    padding: const EdgeInsets.only(right: 13.0),
                    child: AspectRatio(
                        aspectRatio: 3 / 4,
                        child: LineChart(LineChartData(
                            minY: 0,
                            maxY: 10,
                            titlesData: title(getChartData(
                                list, list[0].length - 1, dropdownValue)),
                            lineTouchData: LineTouchData(
                                touchTooltipData: LineTouchTooltipData(
                              // getTooltipItems: (value) => LineTooltipItem(value.y) as List<LineTooltipItem>),
                              getTooltipItems: (List<LineBarSpot> spots) {
                                List<LineTooltipItem> out =
                                    spots.map((barSpot) {
                                  final spot = barSpot;
                                  // debugPrint(flSpot.barIndex.toString());
                                  return LineTooltipItem(
                                    'q${dropdownValue == "main" ? spot.barIndex.toInt() : spot.barIndex.toInt() + 9}: ',
                                    const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: spot.y.toString(),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                    ],
                                    textAlign: TextAlign.center,
                                  );
                                }).toList();
                                // debugPrint(out.toString());
                                out.sort(
                                    (a, b) => compareNatural(a.text, b.text));
                                return out;
                              },
                            )),
                            lineBarsData: getChartData(
                                list, list[0].length - 1, dropdownValue)))))
              ]));
        }));
  }
}

FlTitlesData title(List<LineChartBarData> list) {
  return FlTitlesData(
      show: true,
      topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      leftTitles: AxisTitles(
          sideTitles: SideTitles(
        showTitles: true,
        getTitlesWidget: (value, meta) {
          if (value.runtimeType == int) {
            return Text(style: const TextStyle(fontSize: 18), value.toString());
          }
          return const SizedBox.shrink();
        },
      )),
      bottomTitles: AxisTitles(
          sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 70,
              getTitlesWidget: ((value, meta) {
                DateTime date =
                    DateTime.fromMillisecondsSinceEpoch(value.toInt());
                date.toString();
                String label =
                    "${date.year}-${date.month}-${_twoDigits(date.day)}\n${date.hour}:${_twoDigits(date.minute)}";

                return Text(style: const TextStyle(fontSize: 14), label);
              }),
              // interval: (Duration.millisecondsPerDay / 2).toDouble()
              interval: list[0].spots.length != 1
                  ? (list[0].spots.last.x - list[0].spots.first.x) / 2
                  : (Duration.millisecondsPerDay / 2).toDouble())));
}

String _twoDigits(int n) {
  if (n >= 10) return "$n";
  return "0$n";
}
