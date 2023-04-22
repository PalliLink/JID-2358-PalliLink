import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      constraints: const BoxConstraints.expand(),
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/naturebackground.jpg"),
              fit: BoxFit.cover,
              opacity: 0.35)),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Text(
                'PalliLink',
                style: Theme.of(context).textTheme.headline2,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 80.0),
              child: Text(
                'Care for the living',
                style: Theme.of(context).textTheme.headline5,
              ),
            ),
            OutlinedButton(
              onPressed: () {
                Navigator.pushNamed(context, "/login");
              },
              child: const Text("Get Started"),
            )
          ],
        ),
      ),
    ));
  }
}
