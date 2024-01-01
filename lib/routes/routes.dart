import 'package:flutter/material.dart';
import 'package:nomo_router/nomo_router.dart';
import 'package:nomo_router/router/entities/route.dart';
import 'package:nomo_ui_kit/components/app/app.dart';
import 'package:nomo_ui_kit/theme/nomo_theme.dart';
import 'package:nomo_ui_kit/theme/theme_provider.dart';
import 'package:route_gen/anotations.dart';
import 'package:web_mvp/features/dashboard/dashboard_screen.dart';
import 'package:web_mvp/features/dashboard/wrapper.dart';
import 'package:web_mvp/features/login/login_screen.dart';
import 'package:web_mvp/theme/theme.dart';

part 'routes.g.dart';

@AppRoutes()
const _routes = [
  MenuNestedPageRouteInfo(
    wrapper: wrapper,
    path: "/",
    page: DashboardScreen,
    title: "Home",
    children: [],
  ),
  PageRouteInfo(
    path: "/login",
    page: LoginScreen,
  ),
];
