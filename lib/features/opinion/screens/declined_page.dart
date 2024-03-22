import 'package:flutter/widgets.dart';
import 'package:oepinion/common/extensions.dart';
import 'package:oepinion/common/widgets/footer.dart';
import 'package:oepinion/common/widgets/screen_scaffold.dart';
import 'package:oepinion/features/opinion/screens/welcome_screen.dart';
import 'package:oepinion/main.dart';

class DeclinedScreen extends StatelessWidget {
  const DeclinedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
      scrollable: true,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          Image.asset(
            "$illustrationPath/i12.png",
            width: 400,
            fit: BoxFit.fitWidth,
          ),
          Text(
            "Tut uns leid!",
            style: context.typography.headlineSmall,
            textAlign: TextAlign.center,
          ),
          32.vSpacing,
          Text(
            "Vielen Dank für dein Interesse und den Versuch, an unserem Gewinnspiel teilzunehmen. Wir schätzen dein Engagement sehr!",
            style: context.typography.bodyMedium,
            textAlign: TextAlign.center,
          ),
          32.vSpacing,
          Text(
            "Leider müssen wir dir mitteilen, dass diese spezielle Umfrage ausschließlich für derzeit Studierende konzipiert ist. Da du nach unseren Aufzeichnungen nicht zu dieser Gruppe gehörst, können wir deine Anmeldung für das Gewinnspiel leider nicht berücksichtigen. Dies ist ein wesentlicher Bestandteil unserer Teilnahmebedingungen, da die Umfrage speziell auf die Erfahrungen und Meinungen von Studierenden ausgerichtet ist. Wir verstehen, dass dies enttäuschend sein kann, möchten dir jedoch versichern, dass es viele andere Gelegenheiten geben wird, an unseren Aktionen teilzunehmen. Behalte gerne unsere Website und sozialen Medien im Auge für zukünftige Umfragen und Gewinnspiele, die für eine breitere Zielgruppe zugänglich sind.",
            style: context.typography.bodyMedium,
            textAlign: TextAlign.center,
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
