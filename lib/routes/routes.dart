import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:web_mvp/features/login/login_screen.dart';
import 'package:web_mvp/features/login/recover_password_screen.dart';
import 'package:web_mvp/features/splashscreen/splashscreen.dart';

final GoRouter appRouter = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: "/login",
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
        path: "/recover-password",
        builder: (context, state) => RecoverPasswordScreen()),
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const SplashScreen();
      },
    ),
  ],
);
