import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:oepinion/common/colors.dart';
import 'package:oepinion/common/extensions.dart';
import 'package:oepinion/common/widgets/footer.dart';
import 'package:oepinion/common/widgets/screen_scaffold.dart';
import 'package:oepinion/features/opinion/screens/welcome_screen.dart';
import 'package:oepinion/main.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
      scrollable: true,
      child: Column(
        children: [
          16.vSpacing,
          Text(
            "Willkommen bei Öpinion -",
            style: context.typography.headlineMedium
                ?.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          Text(
            "wo wir gemeinsam die Zukunft deiner Forschung gestalten.",
            style: context.typography.headlineMedium,
            textAlign: TextAlign.center,
          ),
          64.vSpacing,
          Text(
            "“",
            style: context.typography.displayLarge?.copyWith(
              color: kText,
              fontSize: 80,
            ),
          ),
          Text(
            "Bei Öpinion glauben wir an die Kraft der Gemeinschaft. Wir sind überzeugt, dass wir gemeinsam mit dir die akademische Forschung neu gestalten können. Unsere Mission ist es, dir zuzuhören, von dir zu lernen und dir Werkzeuge an die Hand zu geben, die dich in deinem akademischen Streben voranbringen.",
            textAlign: TextAlign.center,
            style: context.typography.bodyMedium,
          ),
          64.vSpacing,
          Image.asset(
            "$illustrationPath/i8.png",
            width: 400,
          ),
          32.vSpacing,
          Text(
            "In unserer Marktforschung nutzen wir die Chance, um herauszufinden, welche Herausforderungen du bei Fragebogenstudien und deiner Abschlussarbeit erlebst. Es ist uns ein Anliegen, dass du nicht nur gehört wirst, sondern auch die Chance erhältst, für dein wertvolles Feedback belohnt zu werden.",
            textAlign: TextAlign.center,
            style: context.typography.bodyMedium,
          ),
          64.vSpacing,
          Image.asset(
            "$illustrationPath/i9.png",
            width: 400,
          ),
          32.vSpacing,
          Text(
            "Wir vom Team Öpinion, stehen dir zur Seite. Als leidenschaftliche Jungunternehmer aus Klagenfurt sind wir fest verwurzelt in der studentischen Gemeinschaft Österreichs. Wir verstehen deine Bedürfnisse und setzen uns dafür ein, dass du die bestmögliche Unterstützung in deiner Forschungsarbeit erhältst.",
            textAlign: TextAlign.center,
            style: context.typography.bodyMedium,
          ),
          64.vSpacing,
          Image.asset(
            "$illustrationPath/i10.png",
            width: 400,
          ),
          32.vSpacing,
          Text(
            "Unser Ziel ist es, ein SaaS-Tool zu entwickeln, das dich in jedem Schritt deiner Forschungsreise begleitet. Wir unterstützen dich bei der Themenfindung, der Hypothesenbildung, der Entwicklung deiner Forschungsstrategie, dem Erstellen von Umfragen, der Datenanalyse und beim akademischen Schreiben.",
            textAlign: TextAlign.center,
            style: context.typography.bodyMedium,
          ),
          64.vSpacing,
          Image.asset(
            "$illustrationPath/i11.png",
            width: 400,
          ),
          32.vSpacing,
          Text(
            "In Kooperation mit der FH Kärnten und geleitet von Herrn Mag. Dr. Fenzl, gewährleisten wir, dass unsere Marktforschung den höchsten akademischen Standards entspricht und dir praktischen Nutzen bietet.",
            textAlign: TextAlign.center,
            style: context.typography.bodyMedium,
          ),
          64.vSpacing,
          const SupportLink(),
          32.vSpacing,
          const Footer(),
        ],
      ),
    );
  }
}
