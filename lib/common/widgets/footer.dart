import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Footer extends StatelessWidget {
  const Footer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButtonTheme(
      data: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: Colors.grey,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TextButton(
              onPressed: () {},
              child: const Text("Datenschutz"),
            ),
            TextButton(
              onPressed: () {},
              child: const Text("Gewinnspiel"),
            ),
            TextButton(
              onPressed: () {},
              child: const Text("Über Öpinion"),
            ),
          ],
        ),
      ),
    );
  }
}
