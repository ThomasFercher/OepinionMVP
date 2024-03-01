import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:oepinion/common/extensions.dart';
import 'package:oepinion/main.dart';

class RecoverPasswordScreen extends StatefulWidget {
  const RecoverPasswordScreen({Key? key}) : super(key: key);

  @override
  State<RecoverPasswordScreen> createState() => _RecoverPasswordScreenState();
}

class _RecoverPasswordScreenState extends State<RecoverPasswordScreen> {
  final emailNotifier = ValueNotifier<String>('');

  String get email => emailNotifier.value;

  void recoverPassword() async {
    try {
      await supabase.auth.resetPasswordForEmail(
        email,
        redirectTo: '/amk',
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.greenAccent,
          content: Text(
            "Password recovery email sent to $email",
          ),
        ),
      );
    } on AuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: context.colors.error,
          content: Text(e.message),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Container(
              width: 500,
              decoration: BoxDecoration(
                color: context.colors.surface,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "Reset your password",
                    style: context.typography.headlineLarge,
                  ),
                  16.vSpacing,
                  Text(
                    "Please enter your email address. You will receive a link to create a new password via email.",
                    style: context.typography.bodyLarge,
                  ),
                  48.vSpacing,
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      emailNotifier.value = value;
                    },
                  ),
                  48.vSpacing,
                  Divider(),
                  16.vSpacing,
                  ElevatedButton(
                    onPressed: recoverPassword,
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size.fromHeight(42),
                    ),
                    child: const Text("Recover Password"),
                  ),
                  32.vSpacing,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Already have an account?"),
                      8.hSpacing,
                      TextButton(
                        onPressed: () {
                          context.push('/login');
                        },
                        child: const Text("Login"),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          Positioned(
            top: 16,
            left: 16,
            child: OutlinedButton(
              onPressed: () {
                context.pop();
              },
              style: OutlinedButton.styleFrom(
                shape: const CircleBorder(),
                backgroundColor: context.colors.surface,
                fixedSize: Size.fromHeight(56),
              ),
              child: const Icon(Icons.arrow_back),
            ),
          ),
        ],
      ),
    );
  }
}
