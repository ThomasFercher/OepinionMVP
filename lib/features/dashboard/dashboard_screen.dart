import 'package:flutter/material.dart';
import 'package:oepinion/routes/routes.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Center(child: Text('Dashboard')),
          TextButton(
            onPressed: () {
              appRouter.go("/opinion/123");
            },
            child: Text("Go to Survey"),
          ),
        ],
      ),
    );
  }
}
