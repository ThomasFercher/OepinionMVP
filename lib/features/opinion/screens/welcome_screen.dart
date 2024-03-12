import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mailto/mailto.dart';
import 'package:oepinion/common/colors.dart';
import 'package:oepinion/common/extensions.dart';
import 'package:oepinion/common/widgets/footer.dart';
import 'package:oepinion/common/widgets/screen_scaffold.dart';
import 'package:oepinion/features/opinion/questions/yes_no_question_page.dart';
import 'package:oepinion/features/opinion/widgets/partner_footer.dart';
import 'package:oepinion/main.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class WelcomeScreen extends StatelessWidget {
  final void Function() onContinue;

  const WelcomeScreen({
    Key? key,
    required this.onContinue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final button = BetterButton(
      text: "Umfrage starten",
      onPressed: onContinue,
      color: Colors.green,
      width: 240,
    );

    return ScreenScaffold(
      scrollable: true,
      padding: const EdgeInsets.symmetric(horizontal: 32),
      maxWidth: 960,
      child: Column(
        children: [
          32.vSpacing,
          SvgPicture.asset(
            "images/logo.svg",
            width: 280,
            fit: BoxFit.fitWidth,
          ),
          8.vSpacing,
          Text(
            "Herzlich Willkommen zur Marktforschung",
            style: context.typography.headlineLarge,
            textAlign: TextAlign.center,
          ),
          16.vSpacing,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.timer,
                color: Colors.blueAccent,
              ),
              4.hSpacing,
              Text(
                "~2m 30s",
                style: context.typography.headlineSmall
                    ?.copyWith(color: Colors.blueAccent),
              )
            ],
          ),
          16.vSpacing,
          Image.asset(
            "$illustrationPath/i1.png",
            width: 400,
          ),
          16.vSpacing,
          Text(
            "Hier beginnt der Wandel in deiner akademischen Arbeit! Öpinion wird der Schlüssel zu deiner erfolgreichen Abschlussarbeit – schneller, effektiver, besser. ",
            style: context.typography.bodyLarge,
            textAlign: TextAlign.center,
          ),
          48.vSpacing,
          button,
          96.vSpacing,
          Image.asset(
            "$illustrationPath/i2.png",
            width: 360,
          ),
          32.vSpacing,
          Text(
            """Vergiss stundenlange Recherche und schlaflose Nächte. Mit Öpinion findest du das perfekte Thema, erstellst starke Umfragen und führst präzise Analysen durch.
           
Zeit sparen, Qualität steigern, Spitzenleistungen erreichen – das ist unser Versprechen an dich.""",
            style: context.typography.bodyLarge,
            textAlign: TextAlign.center,
          ),
          96.vSpacing,
          Image.asset(
            "$illustrationPath/i3.png",
            width: 420,
          ),
          32.vSpacing,
          Text(
            """Außerdem, 🤫 nimm teil und sichere dir die Chance auf einen 100€ Amazon-Gutschein! 

Teile diese Umfrage und erhöhe deine Gewinnchancen auf einen zusätzlichen 50€ Amazon-Gutschein!""",
            style: context.typography.bodyLarge,
            textAlign: TextAlign.center,
          ),
          164.vSpacing,
          const PartnerFooter(),
          96.vSpacing,
          button,
          64.vSpacing,
          const SupportLink(),
          32.vSpacing,
          const Footer(),
        ],
      ),
    );
  }
}

class SupportLink extends StatelessWidget {
  const SupportLink({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "Wir sind gerne unter",
          style: context.typography.bodyMedium,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              style: ButtonStyle(
                overlayColor: MaterialStateProperty.all(
                  kBlue.withOpacity(0.06),
                ),
              ),
              onPressed: () {
                launchUrlString(Mailto(to: ["support@oepinion.at"]).toString());
              },
              child: Text(
                "support@oepinion.at",
                style: context.typography.bodyMedium?.copyWith(
                  color: kBlue,
                ),
              ),
            ),
            Text(
              "für dich da",
              style: context.typography.bodyMedium,
            )
          ],
        ),
      ],
    );
  }
}
