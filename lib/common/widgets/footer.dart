import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
              onPressed: () {
                context.go("/data-policy");
              },
              child: const Text("Datenschutz"),
            ),
            TextButton(
              onPressed: () {
                context.go("/raffle");
              },
              child: const Text("Gewinnspiel"),
            ),
            TextButton(
              onPressed: () {
                context.go("/about");
              },
              child: const Text("Über Öpinion"),
            ),
          ],
        ),
      ),
    );
  }
}
