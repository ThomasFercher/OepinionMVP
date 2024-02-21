import 'package:go_router/go_router.dart';
import 'package:web_mvp/features/opinion/screens/opinion_result_screen.dart';
import 'package:web_mvp/features/opinion/opinion_screen.dart';
import 'package:web_mvp/features/opinion/screens/ranking_screen.dart';
import 'package:web_mvp/features/opinion/screens/referal_screen.dart';

final GoRouter appRouter = GoRouter(
  routes: <RouteBase>[
    // GoRoute(
    //   path: '/',
    //   redirect: (context, state) {
    //     final user = supabase.auth.currentUser;
    //     if (user == null) {
    //       return '/login';
    //     }
    //     return '/dashboard';
    //   },
    //   builder: (context, state) => const SplashScreen(),
    // ),
    // GoRoute(
    //   path: "/login",
    //   builder: (context, state) => const LoginScreen(),
    // ),
    // GoRoute(
    //   path: "/recover-password",
    //   builder: (context, state) => const RecoverPasswordScreen(),
    // ),
    // GoRoute(
    //   path: '/dashboard',
    //   redirect: (context, state) {
    //     final user = supabase.auth.currentUser;
    //     if (user == null) {
    //       return '/login';
    //     }
    //     return null;
    //   },
    //   builder: (context, state) => const DashboardScreen(),
    // ),
    GoRoute(
      path: "/",
      redirect: (context, state) {
        return "/opinion/2096122e-162e-4880-9ef6-7aeb56faf2ab";
      },
    ),
    GoRoute(
      path: '/opinion/:id',
      builder: (context, state) {
        final id = state.pathParameters['id'];
        return OpinionScreen(
          id: id,
        );
      },
      routes: [
        GoRoute(
          path: 'result',
          builder: (context, state) {
            final id = state.pathParameters['id'];
            return OpinionResultScreen();
          },
        ),
      ],
    ),
    GoRoute(
      path: "/referal",
      builder: (context, state) => const ReferalScreen(),
    ),
    GoRoute(
      path: "/ranking",
      builder: (context, state) => const RankingScreen(),
    ),
    GoRoute(
      path: "/verifiy",
      redirect: (context, state) async {
        final code = state.uri.queryParameters['code'];

        if (code == null) {
          return "/";
        }

        return "/referal";
      },
    ),
  ],
);
