import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
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

void precacheAssets(BuildContext context) {
  final assetsPaths = [
    "$illustrationPath/i1.png",
    "$illustrationPath/i2.png",
    "$illustrationPath/i3.png",
    "$illustrationPath/i4.png",
    "$illustrationPath/i5.png",
    "$illustrationPath/i6.png",
    "$illustrationPath/i7.png",
    "$illustrationPath/fh.png",
    "$illustrationPath/fenzl.png",
  ];

  for (final path in assetsPaths) {
    precacheImage(AssetImage(path), context);
  }

  const loader = SvgAssetLoader('images/logo.svg');
  svg.cache.putIfAbsent(loader.cacheKey(null), () => loader.loadBytes(null));
}

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void didChangeDependencies() {
    precacheAssets(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
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
          primary: Colors.red,
          secondary: Colors.redAccent,
        ),
      ),
      themeMode: ThemeMode.light,
      supportedLocales: const [Locale('en', 'US')],
      routerConfig: appRouter,
    );
  }
}
