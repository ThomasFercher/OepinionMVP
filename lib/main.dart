import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:oepinion/common/colors.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:oepinion/routes/routes.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

import 'common/entities/survey.dart';

final supabase = Supabase.instance.client;

const supabaseUrl = 'https://lguvgarjtlziaeblgnxi.supabase.co';
const supabaseKey = String.fromEnvironment('supabase_api_key');

const illustrationPath = 'images/illustrations';
const iconPath = 'images/icons';

void main() async {
  setUrlStrategy(PathUrlStrategy());

  await Supabase.initialize(
    url: 'https://dgrjnxiesxkgbyujipzy.supabase.co',
    anonKey: supabaseKey,
  );
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RootRestorationScope(
      restorationId: 'root',
      child: MaterialApp.router(
        theme: FlexThemeData.light(
          scheme: FlexScheme.redWine,
          textTheme: GoogleFonts.interTextTheme(
            const TextTheme(
              bodyMedium: TextStyle(color: kText, fontSize: 14),
              bodyLarge: TextStyle(color: kText, fontSize: 16),
              bodySmall: TextStyle(color: kText, fontSize: 12),
              headlineLarge: TextStyle(color: kText, fontSize: 34),
              headlineSmall: TextStyle(color: kText, fontSize: 24),
              headlineMedium: TextStyle(color: kText, fontSize: 28),
            ),
          ),
          colors: const FlexSchemeColor(
            primary: Colors.green,
            secondary: Colors.green,
          ),
        ),
        themeMode: ThemeMode.light,
        supportedLocales: const [Locale('en', 'US')],
        routerConfig: appRouter,
      ),
    );
  }
}
