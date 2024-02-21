import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:web_mvp/routes/routes.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

final supabase = Supabase.instance.client;

const supabaseUrl = 'https://lguvgarjtlziaeblgnxi.supabase.co';
const supabaseKey = String.fromEnvironment('supabase_api_key');

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
    return MaterialApp.router(
      theme: FlexThemeData.light(
        scheme: FlexScheme.deepOrangeM3,
        textTheme: GoogleFonts.interTextTheme(),
        useMaterial3: true,
      ),
      darkTheme: FlexThemeData.dark(
        scheme: FlexScheme.outerSpace,
        textTheme: GoogleFonts.interTextTheme(),
      ),
      themeMode: ThemeMode.light,
      supportedLocales: const [Locale('en', 'US')],
      routerConfig: appRouter,
    );
  }
}
