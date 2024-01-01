import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:nomo_ui_kit/components/app/app.dart';
import 'package:nomo_ui_kit/components/buttons/link/nomo_link_button.dart';
import 'package:nomo_ui_kit/components/buttons/primary/nomo_primary_button.dart';
import 'package:nomo_ui_kit/components/buttons/text/nomo_text_button.dart';
import 'package:nomo_ui_kit/components/card/nomo_card.dart';
import 'package:nomo_ui_kit/components/input/textInput/nomo_input.dart';
import 'package:nomo_ui_kit/components/text/nomo_text.dart';
import 'package:nomo_ui_kit/theme/nomo_theme.dart';
import 'package:nomo_ui_kit/utils/layout_extensions.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:web_mvp/theme/theme.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: context.colors.background1,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 6,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      NomoText(
                        'Welcome to Oepinion',
                        style: context.typography.h3,
                        fit: true,
                        maxLines: 1,
                      ),
                      12.vSpacing,
                      NomoText(
                        'Start your journey by logging in.',
                        style: context.typography.h1,
                        minFontSize: 24,
                      ),
                      24.vSpacing,
                      NomoInput(
                        placeHolder: "Email",
                        usePlaceholderAsTitle: true,
                        placeHolderStyle: context.typography.b2,
                        titleStyle: context.typography.b1,
                      ),
                      16.vSpacing,
                      NomoInput(
                        usePlaceholderAsTitle: true,
                        placeHolder: "Password",
                        placeHolderStyle: context.typography.b2,
                        titleStyle: context.typography.b1,
                      ),
                      16.vSpacing,
                      Align(
                        alignment: Alignment.centerRight,
                        child: NomoLinkButton(
                          text: 'Forgot Password?',
                          // textStyle: context.typography.b2,

                          selectionColor: context.colors.secondary,
                          onPressed: () {},
                          padding: EdgeInsets.all(4),
                        ),
                      ),
                      32.vSpacing,
                      PrimaryNomoButton(
                        onPressed: () {},
                        borderRadius: BorderRadius.circular(12),
                        height: 48,
                        text: "Login",
                        textStyle: context.typography.b3,
                        foregroundColor: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
