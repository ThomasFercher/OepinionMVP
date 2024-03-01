import 'package:flutter/material.dart';
import 'package:web_mvp/common/extensions.dart';
import 'package:web_mvp/common/widgets/footer.dart';
import 'package:web_mvp/common/widgets/screen_scaffold.dart';
import 'package:web_mvp/features/opinion/questions/yes_no_question_page.dart';
import 'package:web_mvp/features/opinion/widgets/partner_footer.dart';

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
      child: Column(
        children: [
          32.vSpacing,
          Image.asset("images/logo.png"),
          16.vSpacing,
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
          32.vSpacing,
          Image.asset("images/illustration_7.png"),
          32.vSpacing,
          Text(
            "Hier beginnt der Wandel in deiner akademischen Arbeit! Öpinion wird der Schlüssel zu deiner erfolgreichen Abschlussarbeit – schneller, effektiver, besser. ",
            style: context.typography.bodyLarge,
            textAlign: TextAlign.center,
          ),
          32.vSpacing,
          button,
          64.vSpacing,
          Image.asset("images/illustration_5.png"),
          32.vSpacing,
          Text(
            "Vergiss stundenlange Recherche und schlaflose Nächte. Mit Öpinion findest du das perfekte Thema, erstellst starke Umfragen und führst präzise Analysen durch. Zeit sparen, Qualität steigern, Spitzenleistungen erreichen – das ist unser Versprechen an dich.",
            style: context.typography.bodyLarge,
            textAlign: TextAlign.center,
          ),
          64.vSpacing,
          Image.asset("images/illustration_6.png"),
          64.vSpacing,
          Text(
            "Außerdem, 🤫 nimm teil und sichere dir die Chance auf einen 100€ Amazon-Gutschein! Teile diese Umfrage und erhöhe deine Gewinnchancen auf einen zusätzlichen 50€ Amazon-Gutschein!",
            style: context.typography.bodyLarge,
            textAlign: TextAlign.center,
          ),
          96.vSpacing,
          const PartnerFooter(),
          96.vSpacing,
          button,
          32.vSpacing,
          const Footer(),
        ],
      ),
    );
  }
}
