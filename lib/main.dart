import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:web_mvp/routes/routes.dart';

final supabase = Supabase.instance.client;

const supabaseUrl = 'https://lguvgarjtlziaeblgnxi.supabase.co';
const supabaseKey = String.fromEnvironment('supasebase_api_key');

void main() async {
  await Supabase.initialize(
    url: 'https://dgrjnxiesxkgbyujipzy.supabase.co',
    anonKey: const String.fromEnvironment('supasebase_api_key'),
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
