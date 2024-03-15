import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:oepinion/common/auth/auth_service.dart';
import 'package:oepinion/common/colors.dart';
import 'package:oepinion/common/extensions.dart';
import 'package:oepinion/common/widgets/footer.dart';
import 'package:oepinion/common/widgets/screen_scaffold.dart';
import 'package:oepinion/features/opinion/screens/welcome_screen.dart';
import 'package:oepinion/main.dart';

class ReferalScreen extends StatelessWidget {
  const ReferalScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = AuthService.user;
    final emailConfirmed = user?.emailConfirmedAt != null;

    return emailConfirmed
        ? const VerficationSuccessfullScreen()
        : const VerifcationOutstandingScreen();
  }
}

class VerifcationOutstandingScreen extends StatelessWidget {
  const VerifcationOutstandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
      scrollable: true,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          32.vSpacing,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                FontAwesomeIcons.clock,
                size: 36,
                color: kBlue,
              ),
              16.hSpacing,
              Text(
                "Verifizierung ausstehend",
                style: context.typography.headlineMedium?.copyWith(
                  color: kBlue,
                ),
              )
            ],
          ),
          32.vSpacing,
          Image.asset("$illustrationPath/i6.png", height: 400),
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
          ),
          32.vSpacing,
          const SupportLink(),
          32.vSpacing,
          const Footer(),
        ],
      ),
    );
  }
}

class VerficationSuccessfullScreen extends StatelessWidget {
  const VerficationSuccessfullScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final referallLink = "https://oepinion.at/referal/${AuthService.user?.id}";

    return ScreenScaffold(
      scrollable: true,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Image.asset(
              "$illustrationPath/i7.png",
              width: 400,
            ),
          ),
          Text(
            "Herzlichen Glückwunsch!",
            style: context.typography.headlineSmall,
            textAlign: TextAlign.center,
          ),
          8.vSpacing,
          Text(
            "Deine E-Mail-Adresse wurde erfolgreich verifiziert.",
            style: context.typography.bodyMedium,
            textAlign: TextAlign.center,
          ),
          32.vSpacing,
          Text(
            "Dein Persönlicher Empfehlungslink",
            style: context.typography.headlineSmall,
            textAlign: TextAlign.center,
          ),
          8.vSpacing,
          Text(
            "Mit deiner Verifizierung hast du nun Zugang zu einem einzigartigen Link. Dieser ist speziell mit deiner E-Mail-Adresse verknüpft, sodass wir deine Empfehlungen nachvollziehen können",
            style: context.typography.bodyMedium,
            textAlign: TextAlign.center,
          ),
          32.vSpacing,
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    referallLink,
                    style: context.typography.bodyMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: referallLink))
                        .then((value) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Link kopiert"),
                        ),
                      );
                    });
                  },
                  icon: const Icon(
                    FontAwesomeIcons.copy,
                    color: kBlue,
                  ),
                ),
              ],
            ),
          ),
          32.vSpacing,
          TextButton(
            onPressed: () {
              context.go("/ranking");
            },
            style: TextButton.styleFrom(
              foregroundColor: kBlue,
            ),
            child: const Text("Zur Rangliste"),
          ),
          96.vSpacing,
          const SupportLink(),
          32.vSpacing,
          const Footer(),
        ],
      ),
    );
  }
}
