import 'package:flutter/material.dart';

class LoginLandingPage extends StatelessWidget {
  const LoginLandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: Text(
              'PalliLink',
              style: Theme.of(context).textTheme.headline5,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
            child: SizedBox(
              width: 200,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.pushNamed(context, "/login/patient");
                },
                child: const Text("Patient Login"),
              ),
            ),
          ),
          SizedBox(
            width: 200,
            child: OutlinedButton(
              onPressed: () {
                Navigator.pushNamed(context, "/login/physician");
              },
              child: const Text("Physician Login"),
            ),
          ),
        ],
      ),
    ));
  }
}
