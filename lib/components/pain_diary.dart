import 'package:flutter/material.dart';

import '../firestore/firestore.dart';
import '../models/session_manager.dart';
import 'package:collection/collection.dart';

class PainDiary extends StatefulWidget {
  const PainDiary({super.key});

  @override
  State<PainDiary> createState() => _PainDiary();
}

class _PainDiary extends State<PainDiary> {
  late final SessionManager _prefs;

  @override
  void initState() {
    _prefs = SessionManager();
    super.initState();
  }

  List<DataColumn> getCol(List<String> col) {
    col.sort(compareNatural);
    List<DataColumn> dataColumns =
        col.map((string) => DataColumn(label: Text(string))).toList();
    return dataColumns;
  }

  DataRow getRow(Map<String, dynamic> map, int length) {
    List<DataCell> entries = [];
    // map.forEach((key, value) {
    //   String? s = value.toString();
    //   entries.add(DataCell(Text(s)));
    // });
    for (var i = 0; i < length - 1; i++) {
      if (map["q$i"] != null) {
        String s = map["q$i"].toString();
        entries.add(DataCell(Text(s)));
      } else {
        entries.add(const DataCell(Text("NULL")));
      }
    }
    entries.add(DataCell(Text(map["timestamp"].toDate().toString())));

    return DataRow(cells: entries);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>?>(
      future: _prefs.getUid().then((uid) => retrieveEntries(uid)),
      builder: ((context, snapshot) {
        if (!snapshot.hasData) {
          return const Text("Loading pain diary");
        }

        final list = snapshot.data as List;

        return Scaffold(
            appBar: AppBar(
              title: const Text("Pain Diary"),
              automaticallyImplyLeading: false,
            ),
            body: Container(
              color: const Color.fromARGB(255, 211, 211, 211),
              child: Column(children: [
                const Text("Recent Entries", style: TextStyle(fontSize: 16.0)),
                if (list.isNotEmpty)
                  Expanded(
                      flex: 5,
                      child: SizedBox(
                        height: 170,
                        child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: DataTable(
                                  columns: getCol(list[0].keys.toList()),
                                  rows: List.generate(
                                      list.length,
                                      (index) =>
                                          getRow(list[index], list[0].length))),
                            )),
                      )),
                Expanded(
                    flex: 1,
                    child: Row(
                      children: [
                        const Spacer(),
                        Padding(
                            padding:
                                const EdgeInsets.only(right: 10, bottom: 5),
                            child: OutlinedButton(
                                onPressed: () => {
                                      if (list.isEmpty)
                                        {
                                          showDialog(
                                              context: context,
                                              builder: (context) =>
                                                  const AlertDialog(
                                                      title: Text(
                                                          textAlign:
                                                              TextAlign.center,
                                                          "Error"),
                                                      content: Text(
                                                          textAlign:
                                                              TextAlign.center,
                                                          "No Pain Diary entries logged")))
                                        }
                                      else
                                        {Navigator.pushNamed(context, "/chart")}
                                    },
                                child: const Text("View Entries"))),
                        Padding(
                            padding:
                                const EdgeInsets.only(right: 10, bottom: 5),
                            child: OutlinedButton(
                                onPressed: () => {
                                      Navigator.pushNamed(
                                        context,
                                        "/patient/diary/new",
                                      ).then((_) => setState(() {})),
                                    },
                                child: const Text("New Entry")))
                      ],
                    ))
              ]),
            ));
      }),
    );
  }
}
