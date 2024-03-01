import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:web_mvp/common/extensions.dart';
import 'package:web_mvp/common/widgets/footer.dart';
import 'package:web_mvp/common/widgets/screen_scaffold.dart';
import 'package:web_mvp/features/opinion/questions/yes_no_question_page.dart';
import 'package:web_mvp/features/opinion/widgets/partner_footer.dart';
import 'package:web_mvp/main.dart';
import 'package:web_mvp/routes/routes.dart';

class OpinionResultScreen extends StatelessWidget {
  const OpinionResultScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
      scrollable: true,
      child: Column(
        children: [
          Image.asset("images/logo.png"),
          32.vSpacing,
          Text(
            "Vielen Dank!!!",
            style: context.typography.displayLarge,
          ),
          32.vSpacing,
          Image.asset("images/illustration_1.png"),
          32.vSpacing,
          Text(
            "Dein Feedback ist in die Entwicklung unseres Tools eingeflossen, das Studierenden das Leben leichter macht. Deine Stimme trägt dazu bei, echte Veränderungen zu bewirken.",
            style: context.typography.bodyMedium,
            textAlign: TextAlign.center,
          ),
          96.vSpacing,
          Text(
            "Gewinnspiel",
            style: context.typography.headlineMedium,
          ),
          12.vSpacing,
          Text(
            "Melde dich mit deiner Studienmail an. Bestätige anschließend deine Teilnahme über den Link in der Bestätigungsmail.",
            style: context.typography.bodyMedium,
            textAlign: TextAlign.center,
          ),
          Image.asset("images/illustration_2.png"),
          RaffleContainer(),
        ],
      ),
    );
  }
}

class RaffleContainer extends StatefulWidget {
  const RaffleContainer({Key? key}) : super(key: key);

  @override
  State<RaffleContainer> createState() => _RaffleContainerState();
}

class _RaffleContainerState extends State<RaffleContainer> {
  late final TextEditingController _controller;
  late final ValueNotifier<bool> _acceptedNotifier;

  @override
  void initState() {
    _controller = TextEditingController();
    _acceptedNotifier = ValueNotifier(false);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void participate() async {
    final email = _controller.text;
    if (email.isEmpty) {
      return;
    }
    final messenger = ScaffoldMessenger.of(context);

    try {
      await supabase.auth.signInWithOtp(
        email: email,
        shouldCreateUser: true,
        emailRedirectTo: "http://localhost:8080/verifiy",
      );

      appRouter.go("/referal");
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(
          content: Text("Fehler beim Teilnehmen: $e"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _controller,
          decoration: InputDecoration(
            fillColor: const Color(0xFFF2F2F7),
            filled: true,
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(8),
            ),
            prefixIcon: const Icon(Icons.email),
            hintText: "E-Mail",
          ),
        ),
        16.vSpacing,
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ValueListenableBuilder(
              valueListenable: _acceptedNotifier,
              builder: (context, value, child) {
                return Checkbox(
                  value: value,
                  onChanged: (value) {
                    _acceptedNotifier.value = value ?? false;
                  },
                );
              },
            ),
            8.hSpacing,
            const Padding(
              padding: EdgeInsets.only(top: 6),
              child: Text(
                "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed",
              ),
            ),
          ],
        ),
        48.vSpacing,
        ValueListenableBuilder(
          valueListenable: _acceptedNotifier,
          builder: (context, value, child) {
            return Align(
              alignment: Alignment.centerRight,
              child: BetterButton(
                text: "Jetzt teilnehmen",
                onPressed: participate,
                enabled: value,
                color: value ? Colors.green : Colors.grey,
                width: 240,
              ),
            );
          },
        ),
        96.vSpacing,
        const PartnerFooter(),
        96.vSpacing,
        const Footer(),
      ],
    );
  }
}
