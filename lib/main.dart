import 'package:flutter/material.dart';
import 'package:nomo_ui_kit/app/nomo_app.dart';
import 'package:nomo_ui_kit/theme/nomo_theme.dart';
import 'package:nomo_ui_kit/utils/layout_extensions.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:web_mvp/common/auth/auth_service.dart';
import 'package:web_mvp/features/dashboard/dashboard_screen.dart';
import 'package:web_mvp/features/login/login_screen.dart';
import 'package:web_mvp/routes/routes.dart';
import 'package:web_mvp/theme/theme.dart';

final appRouter = AppRouter();
final supabase = Supabase.instance.client;

const supabaseUrl = 'https://lguvgarjtlziaeblgnxi.supabase.co';
const supabaseKey = String.fromEnvironment('supasebase_api_key');

void main() {
  runApp(const Slashscreen());
}

class Slashscreen extends StatefulWidget {
  const Slashscreen({super.key});

  @override
  State<Slashscreen> createState() => _SlashscreenState();
}

class _SlashscreenState extends State<Slashscreen> {
  // future
  Future<void> init() async {
    await Supabase.initialize(
      url: 'https://lguvgarjtlziaeblgnxi.supabase.co',
      anonKey: 'YOUR_SUPABASE_ANON_KEY',
    );
  }

  late Future<void> _value;

  @override
  void initState() {
    _value = init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _value,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return const App();
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: AuthService.onAuthStateChange,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        final state = snapshot.data?.event;

        final home = switch (state) {
          AuthChangeEvent.signedIn => const DashboardScreen(),
          AuthChangeEvent.signedOut ||
          AuthChangeEvent.initialSession =>
            const LoginScreen(),
          _ => Center(
              child: Text('Unknown state: $state'),
            ),
        };

        return NomoApp(
          sizingThemeBuilder: (width) {
            final sorted = SizingMode.sortedValues
                .firstWhere((mode) => mode.width >= width);
            return sorted.theme;
          },
          theme: NomoThemeData(
            colorTheme: ColorMode.LIGHT.theme,
            sizingTheme: SizingMode.LARGE.theme,
            textTheme: typography,
            constants: constants,
          ),
          home: home,
          supportedLocales: const [Locale('en', 'US')],
          appRouter: appRouter,
        );
      },
    );
  }
}
