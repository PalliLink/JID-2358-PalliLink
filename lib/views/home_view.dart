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
              opacity: 0.2)),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const FractionallySizedBox(
              widthFactor: .80,
              child: Image(
                  image: AssetImage("assets/images/pallilink.png"),
                  fit: BoxFit.fitWidth),
            ),
            const SizedBox(height: 10),
            Text(
              'Care for the living',
              style: Theme.of(context).textTheme.headline6,
            ),
            const SizedBox(height: 30),
            ElevatedButton(
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
