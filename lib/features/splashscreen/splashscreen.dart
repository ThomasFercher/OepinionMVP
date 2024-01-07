import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:web_mvp/features/dashboard/dashboard_screen.dart';
import 'package:web_mvp/features/login/login_screen.dart';
import 'package:web_mvp/main.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: supabase.auth.onAuthStateChange,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final state = snapshot.data?.event;

          return switch (state) {
            AuthChangeEvent.signedIn => const DashboardScreen(),
            AuthChangeEvent.signedOut ||
            AuthChangeEvent.initialSession =>
              const LoginScreen(),
            _ => Center(
                child: Text('Unknown state: $state'),
              ),
          };
        });
  }
}
