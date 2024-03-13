import 'package:go_router/go_router.dart';
import 'package:oepinion/features/opinion/opinion_screen.dart';
import 'package:oepinion/features/opinion/screens/opinion_result_screen.dart';
import 'package:oepinion/features/opinion/screens/ranking_screen.dart';
import 'package:oepinion/features/opinion/screens/referal_screen.dart';
import 'package:oepinion/main.dart';

const initalSurvey = "2096122e-162e-4880-9ef6-7aeb56faf2ab";

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
        return "/opinion/$initalSurvey";
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
            final referalCode = state.uri.queryParameters['referal'];
            return OpinionResultScreen(
              referalCode: referalCode,
            );
          },
        ),
      ],
    ),
    GoRoute(
      path: "/referal",
      builder: (context, state) => const ReferalScreen(),
    ),
    GoRoute(
      path: "/referal/:code",
      redirect: (context, state) {
        final code = state.pathParameters['code'];

        if (code != null) {
          return "/opinion/$initalSurvey?referal=$code";
        }

        return "/";
      },
    ),
    GoRoute(
      path: "/ranking",
      builder: (context, state) => const RankingScreen(),
    ),
    GoRoute(
      path: "/verifiy",
      redirect: (context, state) async {
        final code = state.uri.queryParameters['code'];
        final referal = state.uri.queryParameters['referal'];

        if (referal != null && referal != "null") {
          try {
            await supabase.rpc(
              "update_referals",
              params: {
                "id": '$referal',
              },
            );
          } catch (e) {
            print(e);
          }
        }

        //TODO: update supabase counter

        if (code == null) {
          return "/";
        }

        return "/referal";
      },
    ),
  ],
);
