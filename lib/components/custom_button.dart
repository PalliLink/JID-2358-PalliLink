import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  CustomButton(
      {super.key,
      required this.icon,
      required this.iconColor,
      required this.route,
      required this.text,
      this.update = false,
      this.refresh});

  final IconData icon;
  final Color iconColor;
  final String route;
  final String text;
  bool update;
  final Function? refresh;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () {
          if (!update) {
            Navigator.pushNamed(context, route);
          }
          Navigator.pushNamed(context, route).then((_) => refresh!());
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white, // Background color
        ),
        child: Row(
          children: [
            Expanded(
              flex: 5,
              child: Icon(
                icon,
                color: iconColor,
                size: 100,
              ),
            ),
            const Expanded(
              flex: 1,
              child: SizedBox(
                height: 10,
              ),
            ),
            Expanded(
                flex: 9,
                child: Text(
                  text,
                  style: const TextStyle(fontSize: 30, color: Colors.black),
                )),
          ],
        ));
  }
}
