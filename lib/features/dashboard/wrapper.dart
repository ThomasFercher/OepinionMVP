import 'package:flutter/material.dart';
import 'package:nomo_ui_kit/components/app/app.dart';
import 'package:nomo_ui_kit/theme/nomo_theme.dart';
import 'package:nomo_ui_kit/theme/theme_provider.dart';
import 'package:web_mvp/features/dashboard/sider/sider.dart';
import 'package:web_mvp/theme/theme.dart';

Widget wrapper(Widget nav) => Wrapper(nav: nav);

class Wrapper extends StatelessWidget {
  final Widget nav;

  const Wrapper({Key? key, required this.nav}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = ThemeProvider.of(context);
    return NomoScaffold(
      child: nav,
      sider: Sider(),
    );
  }
}
