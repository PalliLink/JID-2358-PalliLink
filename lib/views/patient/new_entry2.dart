import 'package:flutter/material.dart';
import 'package:pallinet/components/loading.dart';
import 'package:pallinet/firestore/firestore.dart';
import 'package:pallinet/models/entry_model.dart';
import 'package:provider/provider.dart';

import '../../models/session_manager.dart';

class NewPainDiaryEntry extends StatefulWidget {
  const NewPainDiaryEntry({super.key});

  @override
  State<NewPainDiaryEntry> createState() => NewPainDiaryEntryState();
}

class NewPainDiaryEntryState extends State<NewPainDiaryEntry> {
  late final SessionManager _prefs;
  String? uid = "";

  @override
  void initState() {
    _prefs = SessionManager();
    _prefs.getUid().then(
          (value) => uid = value,
        );
    super.initState();
  }

  int questionNum = 0;
  double input = 0;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<dynamic, dynamic>>(
      future: retrieveQuestions(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const LoadingScreen("Loading questions");
        }
        List<String> painDiaryQuestions =
            List<String>.from(snapshot.data!["questions"]);
        List<String> questionTypes = List<String>.from(snapshot.data!["type"]);

        int length = questionTypes.length;

        PageController pc = PageController();
        return Scaffold(
            appBar: AppBar(
              title: const Text("New Pain Diary Entry"),
              backgroundColor: Colors.blue,
            ),
            body: ChangeNotifierProvider(
                create: (context) => EntryModel(),
                child: PageView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: pc,
                  itemCount: questionTypes.length,
                  itemBuilder: (BuildContext context, int index) {
                    Widget question;
                    switch (questionTypes[index]) {
                      case "slider":
                      case "slider4":
                        int div = questionTypes[index] == "slider4" ? 4 : 10;
                        question = Consumer<EntryModel>(
                            builder: (context, model, child) {
                          return Slider(
                            value: model.entries[index]?.toDouble() ?? 0,
                            onChanged: (val) =>
                                model.update(index, val.toInt()),
                            divisions: div,
                            label: "${model.entries[index]}",
                            max: div.toDouble(),
                          );
                        });
                        break;
                      case "mc":
                        question = Consumer<EntryModel>(
                          builder: (context, model, child) {
                            return ListView.separated(
                                padding: const EdgeInsets.all(10),
                                itemCount: 10,
                                itemBuilder: (BuildContext context, int ind) {
                                  return InkWell(
                                    child: Container(
                                        height: 60,
                                        color: model.entries[index] == ind
                                            ? Colors.purpleAccent
                                            : Colors.white,
                                        child: Center(
                                          child: Text('$ind',
                                              style: const TextStyle(
                                                  fontSize: 25)),
                                        )),
                                    onTap: () {
                                      model.update(index, ind);
                                    },
                                  );
                                },
                                separatorBuilder: (BuildContext context,
                                        int index) =>
                                    const Divider(
                                      thickness: 2,
                                      color: Color.fromARGB(255, 95, 95, 95),
                                    ));
                          },
                        );
                        break;
                      default:
                        question = const Text("unhandled");
                    }
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Text(
                            painDiaryQuestions[index],
                            style: Theme.of(context).textTheme.headline5,
                          ),
                          Expanded(child: question),
                          Row(
                            children: [
                              OutlinedButton(
                                  onPressed: index != 0
                                      ? () => pc.previousPage(
                                          duration:
                                              const Duration(milliseconds: 300),
                                          curve: Curves.ease)
                                      : null,
                                  child: const Text("Previous Question")),
                              const Spacer(),
                              Consumer<EntryModel>(
                                builder: (context, model, child) {
                                  return index != length - 1
                                      ? OutlinedButton(
                                          onPressed: () {
                                            pc.nextPage(
                                                duration: const Duration(
                                                    milliseconds: 300),
                                                curve: Curves.ease);
                                            // debugPrint(model.entries.toString());
                                          },
                                          child: const Text("Next Question"))
                                      : OutlinedButton(
                                          onPressed: () {
                                            // debugPrint(uid);
                                            model.submit(uid);
                                            Navigator.pop(context);
                                          },
                                          child: const Text("Submit"));
                                },
                              )
                            ],
                          )
                        ],
                      ),
                    );
                  },
                )));
      },
    );
  }
}
