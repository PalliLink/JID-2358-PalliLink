import 'package:flutter/material.dart';

class RecommendedSpecialists extends StatelessWidget {
  const RecommendedSpecialists({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recommended Specialists'),
      ),
      body: ListView(children: [
        InkWell(
            child: Card(
                child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                  flex: 4,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const <Widget>[
                        Text(
                          "Dr. John Doe",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 18.0,
                          ),
                        ),
                        Padding(padding: EdgeInsets.symmetric(vertical: 2.0)),
                        Text(
                          'Neurologist',
                          style: TextStyle(fontSize: 14.0),
                        ),
                      ],
                    ),
                  )),
            ],
          ),
        ))),
        InkWell(
            child: Card(
                child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                  flex: 4,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const <Widget>[
                        Text(
                          "Dr. Jane Ronaldo",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 18.0,
                          ),
                        ),
                        Padding(padding: EdgeInsets.symmetric(vertical: 2.0)),
                        Text(
                          'Dermatologist',
                          style: TextStyle(fontSize: 14.0),
                        ),
                      ],
                    ),
                  )),
            ],
          ),
        ))),
        InkWell(
            child: Card(
                child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                  flex: 4,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const <Widget>[
                        Text(
                          "Dr. Michael Johnson",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 18.0,
                          ),
                        ),
                        Padding(padding: EdgeInsets.symmetric(vertical: 2.0)),
                        Text(
                          'Surgeon',
                          style: TextStyle(fontSize: 14.0),
                        ),
                      ],
                    ),
                  )),
            ],
          ),
        ))),
      ]),
    );
  }
}
