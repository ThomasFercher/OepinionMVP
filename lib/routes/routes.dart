import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:oepinion/features/about/about_screen.dart';
import 'package:oepinion/features/data_policy/data_policy_screen.dart';
import 'package:oepinion/features/data_policy/raffle_screen.dart';
import 'package:oepinion/features/opinion/opinion_screen.dart';
import 'package:oepinion/features/opinion/screens/declined_page.dart';
import 'package:oepinion/features/opinion/screens/opinion_result_screen.dart';
import 'package:oepinion/features/opinion/screens/ranking_screen.dart';
import 'package:oepinion/features/opinion/screens/referal_screen.dart';
import 'package:oepinion/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
    GoRoute(path: "/about", builder: (context, state) => const AboutScreen()),
    GoRoute(
        path: "/data-policy",
        builder: (context, state) => const DataPolicyScreen()),
    GoRoute(
        path: "/raffle",
        builder: (context, state) => const RafflePolicyScreen()),

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
            final interviewS = state.uri.queryParameters['interview'];
            final interview = interviewS == "true";
            return OpinionResultScreen(
              referalCode: referalCode,
              interview: interview,
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
      path: "/declined",
      builder: (context, state) {
        return const DeclinedScreen();
      },
    ),
    GoRoute(
      path: "/verify",
      redirect: (context, state) async {
        final code = state.uri.queryParameters['token'];
        final email = state.uri.queryParameters['email'];

        if (email == null || code == null) {
          return "/";
        }

        final decodedEmail = Uri.decodeComponent(email);

        if (supabase.auth.currentUser == null) {
          final AuthResponse result;
          try {
            result = await supabase.auth.verifyOTP(
              token: code,
              email: decodedEmail,
              type: OtpType.email,
            );
          } catch (e) {
            return "/";
          }

          if (result.user == null) {
            return "/";
          }
        }

        final referal = state.uri.queryParameters['referal'];

        if (referal != null && referal != "null") {
          await supabase.rpc(
            "update_referals",
            params: {"id": referal},
          );
        }

        return "/referal";
      },
    ),
  ],
);
