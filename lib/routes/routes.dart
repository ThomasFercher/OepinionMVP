import 'package:go_router/go_router.dart';
import 'package:web_mvp/features/dashboard/dashboard_screen.dart';
import 'package:web_mvp/features/login/login_screen.dart';
import 'package:web_mvp/features/login/recover_password_screen.dart';
import 'package:web_mvp/features/opinion/opinion_screen.dart';
import 'package:web_mvp/features/splashscreen/splashscreen.dart';
import 'package:web_mvp/main.dart';

final GoRouter appRouter = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      redirect: (context, state) {
        final user = supabase.auth.currentUser;
        if (user == null) {
          return '/login';
        }
        return '/dashboard';
      },
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: "/login",
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: "/recover-password",
      builder: (context, state) => const RecoverPasswordScreen(),
    ),
    GoRoute(
      path: '/dashboard',
      redirect: (context, state) {
        final user = supabase.auth.currentUser;
        if (user == null) {
          return '/login';
        }
        return null;
      },
      builder: (context, state) => const DashboardScreen(),
    ),
    GoRoute(
      path: '/opinion/:id',
      builder: (context, state) {
        final id = state.pathParameters['id'];
        return OpinionScreen(
          id: id,
        );
      },
    ),
  ],
);
