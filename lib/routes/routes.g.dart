// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'routes.dart';

// **************************************************************************
// RouteGenerator
// **************************************************************************

class AppRouter extends NomoAppRouter {
  AppRouter()
      : super(
          {
            DashboardScreenRoute.path: ([a]) => DashboardScreenRoute(),
            LoginScreenRoute.path: ([a]) => LoginScreenRoute(),
          },
          _routes.expanded.toList(),
        );
}

class DashboardScreenArguments {
  const DashboardScreenArguments();
}

class DashboardScreenRoute extends AppRoute
    implements DashboardScreenArguments {
  DashboardScreenRoute()
      : super(
          name: '/',
          page: DashboardScreen(),
        );
  static String path = '/';
}

class LoginScreenArguments {
  const LoginScreenArguments();
}

class LoginScreenRoute extends AppRoute implements LoginScreenArguments {
  LoginScreenRoute()
      : super(
          name: '/login',
          page: LoginScreen(),
        );
  static String path = '/login';
}
