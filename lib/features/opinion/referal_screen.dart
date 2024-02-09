import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:web_mvp/common/auth/auth_service.dart';
import 'package:web_mvp/common/extensions.dart';
import 'package:web_mvp/common/widgets/screen_scaffold.dart';

class ReferalScreen extends StatelessWidget {
  const ReferalScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = AuthService.user;
    final emailConfirmed = user?.emailConfirmedAt != null;

    print(user);

    return emailConfirmed
        ? VerifcationOutstandingScreen()
        : VerifcationOutstandingScreen();
  }
}

class VerifcationOutstandingScreen extends StatelessWidget {
  const VerifcationOutstandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
      scrollable: true,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                FontAwesomeIcons.clock,
                size: 42,
                color: Colors.blueAccent,
              ),
              16.hSpacing,
              Text(
                "Verifizierung ausstehend",
                style: context.typography.headlineMedium?.copyWith(
                  color: Colors.blueAccent,
                ),
              )
            ],
          ),
          32.vSpacing,
          Image.asset("illustration_3.png"),
          32.vSpacing,
          Text(
            "Fast geschafft!",
            style: context.typography.headlineSmall,
            textAlign: TextAlign.center,
          ),
          16.vSpacing,
          Text(
            """Vielen Dank für deine Teilnahme am Gewinnspiel! Um deine Anmeldung abzuschließen, überprüfe bitte dein E-Mail-Postfach. Wir haben dir eine Bestätigungsmail gesendet. Klicke auf den darin enthaltenen Link, um deine E-Mail-Adresse zu verifizieren und deine Teilnahme zu bestätigen. 
Falls du die E-Mail nicht findest, schaue bitte auch in deinem Spam-Ordner nach. 

Sobald du verifiziert bist, nimmst du automatisch an der Verlosung des 100€ Amazon-Gutscheins teil. Wir wählen den Gewinner zufällig aus allen verifizierten Teilnehmern und kontaktieren diesen per Mail mit Ende der Laufzeit.

Wir freuen uns auf deine erfolgreiche Teilnahme!
""",
            style: context.typography.bodyMedium,
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}
