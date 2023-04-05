import 'package:flutter/material.dart';
import 'package:pallinet/firestore/firestore.dart';
import 'package:pallinet/models/entry_model.dart';
// import 'package:pallinet/pain_index.dart';
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

  List<dynamic> painDiaryQuestions = [""];
  List<dynamic> questionTypes = [""];
  bool init = true;

  int questionNum = 0;
  double input = 0;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    final arguments = ModalRoute.of(context)?.settings.arguments ?? '';
    debugPrint(arguments.toString());
    double screenheight = MediaQuery.of(context).size.height;

    return Scaffold(
        appBar: AppBar(
          title: const Text("New Pain Diary Entry"),
          // automaticallyImplyLeading: false,
          backgroundColor: Colors.blue,
        ),
        body: ChangeNotifierProvider(
            create: (context) => EntryModel(),
            child: PageView(
              children: [
                Container(
                  color: const Color.fromARGB(
                      255, 211, 211, 211), //255, 211, 211, 211
                  width: screenWidth,
                  height: screenheight,
                  child: SizedBox(
                      child: Column(
                    children: [
                      FutureBuilder(
                        future: retrieveQuestions(),
                        builder: ((context, snapshot) {
                          final list = snapshot.data;
                          // .map((e) => e as Map<String, dynamic>)
                          // .toList();
                          if (list == null) {
                            // return Scaffold(body: Text("null"));
                          } else {
                            painDiaryQuestions = list["questions"];
                            questionTypes = list["type"];
                            if (init) {
                              Future.delayed(Duration.zero, () async {
                                setState(() {});
                              });
                              init = false;
                            }
                            debugPrint("list set");
                            debugPrint(painDiaryQuestions.toString());
                            debugPrint(questionTypes.toString());
                            // return Scaffold(body: Text(list?.elementAt(questionNum)));
                          }
                          return const SizedBox.shrink();
                        }),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            bottom: 5, top: 5, right: 20, left: 20),
                        child: SizedBox(
                            height: 100,
                            child: Text(
                              painDiaryQuestions[questionNum],
                              style: const TextStyle(
                                fontSize: 20,
                              ),
                            )),
                      ),

                      if (questionTypes[questionNum] == "slider")
                        Slider(
                          value: input,
                          onChanged: (newVal) {
                            setState(() {
                              input = newVal;
                              // context.update(questionNum, d);
                            });
                          },
                          divisions: 10,
                          label: "$input",
                          min: 0.0,
                          max: 10.0,
                        ),
                      if (questionTypes[questionNum] == "slider4")
                        Slider(
                          value: input,
                          onChanged: (newVal) {
                            setState(() {
                              input = newVal;
                              // context.update(questionNum, d);
                            });
                          },
                          divisions: 4,
                          label: "$input",
                          min: 0.0,
                          max: 4.0,
                        ),
                      if (questionTypes[questionNum] == "mc")
                        Expanded(
                          child: ListView.separated(
                              padding: const EdgeInsets.all(10),
                              itemCount: 10,
                              itemBuilder: (BuildContext context, int index) {
                                return Consumer<EntryModel>(
                                    builder: (context, model, child) =>
                                        GestureDetector(
                                            child: Container(
                                                height: 60,
                                                color: model.entries[
                                                                questionNum] ==
                                                            index ||
                                                        ((model.entries[
                                                                    questionNum] ==
                                                                null) &&
                                                            input == index)
                                                    ? const Color.fromARGB(
                                                        255, 116, 72, 213)
                                                    : Colors.white,
                                                child: Center(
                                                  child: Text('$index',
                                                      style: const TextStyle(
                                                          fontSize: 25)),
                                                )),
                                            onTap: () => {
                                                  if (model.entries[
                                                          questionNum] !=
                                                      index)
                                                    {
                                                      model.update(
                                                          questionNum, index)
                                                    },
                                                  input = index.toDouble()
                                                }));
                              },
                              separatorBuilder:
                                  (BuildContext context, int index) =>
                                      const Divider(
                                        thickness: 2,
                                        color: Color.fromARGB(255, 95, 95, 95),
                                      )),
                        ),
                      // const Expanded(child: SizedBox.shrink()),
                      Row(
                        children: [
                          Padding(
                              padding:
                                  const EdgeInsets.only(left: 10, bottom: 5),
                              child: OutlinedButton(
                                  onPressed: () => {
                                        setState(() {
                                          if (questionNum > 0) {
                                            questionNum -= 1;
                                          }
                                          input = 0;
                                        }),
                                      },
                                  child: const Text("Previous Question"))),
                          const Spacer(),
                          Consumer<EntryModel>(
                              builder: (context, model, child) => Padding(
                                  padding: const EdgeInsets.only(
                                      right: 10, bottom: 5),
                                  child: questionNum !=
                                          painDiaryQuestions.length - 1
                                      ? OutlinedButton(
                                          onPressed: () => {
                                                model.update(
                                                    questionNum, input.round()),
                                                input = 0,
                                                setState(() {
                                                  questionNum += 1;
                                                }),
                                              },
                                          child: const Text("Next Question"))
                                      : OutlinedButton(
                                          onPressed: () => {
                                                model.update(
                                                    questionNum, input.round()),
                                                model.submit(uid),
                                                Navigator.pushNamed(
                                                    context, "/patient/home")
                                              },
                                          child: const Text("Submit"))))
                        ],
                      )
                    ],
                  )),
                )
              ],
            )));
  }
}
