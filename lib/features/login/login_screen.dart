import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:oepinion/common/extensions.dart';
import 'package:oepinion/main.dart';
import 'package:oepinion/routes/routes.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final passwordNotifier = ValueNotifier<String>('');
  final emailNotifier = ValueNotifier<String>('');

  late bool isSignUp;

  @override
  void initState() {
    isSignUp = false;
    super.initState();
  }

  @override
  void dispose() {
    passwordNotifier.dispose();
    emailNotifier.dispose();
    super.dispose();
  }

  String get password => passwordNotifier.value;

  String get email => emailNotifier.value;

  void login() async {
    try {
      final result = await supabase.auth.signInWithPassword(
        password: password,
        email: email,
      );
      if (result.user != null) {
        appRouter.replace('/dashboard');
      }
    } on AuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: context.colors.error,
          content: Text(e.message),
        ),
      );
    }
  }

  void signUp() async {
    try {
      await supabase.auth.signUp(
        password: password,
        email: email,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.greenAccent,
          content: Text(
            'Account created successfully. Please verify your email.',
          ),
        ),
      );

      setState(() {
        isSignUp = false;
      });
    } on AuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: context.colors.error,
          content: Text(e.message),
        ),
      );
    }
  }

  void oAuthSignIn(OAuthProvider provider) async {
    await supabase.auth.signInWithOAuth(provider);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (context.isLarge)
            Expanded(
              child: ColoredBox(color: context.colors.primary),
            ),
          Expanded(
            child: Center(
              child: Container(
                color: context.colors.surface,
                width: 500,
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      "Welcome to Öpinion",
                      style: context.typography.headlineLarge,
                    ),
                    12.vSpacing,
                    Text(
                      isSignUp
                          ? "Please create an account"
                          : "Please login to continue",
                      style: context.typography.titleLarge,
                    ),
                    32.vSpacing,
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        prefixIcon: Icon(
                          Icons.email,
                          size: 18,
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      autocorrect: false,
                      onChanged: (value) => emailNotifier.value = value,
                      validator: (_) {},
                    ),
                    12.vSpacing,
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        prefixIcon: Icon(
                          FontAwesomeIcons.key,
                          size: 16,
                        ),
                      ),
                      keyboardType: TextInputType.visiblePassword,
                      autocorrect: false,
                      onChanged: (value) => passwordNotifier.value = value,
                    ),
                    12.vSpacing,
                    if (!isSignUp)
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            context.push('/recover-password');
                          },
                          child: const Text('Forgot Password?'),
                        ),
                      ),
                    12.vSpacing,
                    ElevatedButton(
                      onPressed: isSignUp ? signUp : login,
                      style: ElevatedButton.styleFrom(
                        fixedSize: const Size.fromHeight(48),
                      ),
                      child: Text(
                        isSignUp ? 'Sign Up' : 'Sign In',
                      ),
                    ),
                    48.vSpacing,
                    Row(
                      children: [
                        const Expanded(child: Divider()),
                        16.hSpacing,
                        Text(
                          'or',
                          style: context.typography.labelLarge,
                        ),
                        16.hSpacing,
                        const Expanded(child: Divider()),
                      ],
                    ),
                    48.vSpacing,
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              fixedSize: const Size.fromHeight(48),
                              backgroundColor: Colors.white,
                            ),
                            onPressed: () => oAuthSignIn(OAuthProvider.apple),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  FontAwesomeIcons.apple,
                                  color: Colors.black,
                                ),
                                8.hSpacing,
                                const Text(
                                  'Apple',
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        24.hSpacing,
                        Expanded(
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              backgroundColor: Colors.white,
                              fixedSize: const Size.fromHeight(48),
                            ),
                            onPressed: () => oAuthSignIn(OAuthProvider.google),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  FontAwesomeIcons.google,
                                  color: Colors.black,
                                ),
                                8.hSpacing,
                                const Text(
                                  'Google',
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    48.vSpacing,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          isSignUp
                              ? "Already have an account?"
                              : "Don't have an account?",
                          style: context.typography.labelLarge,
                        ),
                        8.hSpacing,
                        TextButton(
                          onPressed: () {
                            setState(() {
                              isSignUp = !isSignUp;
                            });
                          },
                          child: Text(
                            isSignUp ? 'Sign In' : 'Sign Up',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
