import 'package:flutter/material.dart';

class RecommendedSpecialists extends StatelessWidget {
  const RecommendedSpecialists({super.key});

  void _showPopup(BuildContext context, String specialist) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Specialist Selected'),
            content: Text('You have selected $specialist as your specialist.'),
            actions: <Widget>[
              SizedBox(
                height: 30.0,
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recommended Specialists'),
      ),
      body: ListView(
        children: [
          InkWell(
              onTap: () {
                _showPopup(context, 'Dr. John Doe');
              },
              child: Card(
                  child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                        flex: 4,
                        child: Padding(
                          padding:
                              const EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0.0),
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
                              Padding(
                                  padding: EdgeInsets.symmetric(vertical: 2.0)),
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
              onTap: () {
                _showPopup(context, 'Dr. Jane Ronaldo');
              },
              child: Card(
                  child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                        flex: 4,
                        child: Padding(
                          padding:
                              const EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0.0),
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
                              Padding(
                                  padding: EdgeInsets.symmetric(vertical: 2.0)),
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
            onTap: () {
              _showPopup(context, 'Dr. Michael Johnson');
            },
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
                            Padding(
                                padding: EdgeInsets.symmetric(vertical: 2.0)),
                            Text(
                              'Surgeon',
                              style: TextStyle(fontSize: 14.0),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              // Add your logic here for when the button is pressed
            },
            child: const Text('Press on specialist to choose'),
          ),
        ),
      ),
    );
  }
}
