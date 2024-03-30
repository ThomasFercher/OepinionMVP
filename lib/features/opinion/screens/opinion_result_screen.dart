import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:oepinion/common/extensions.dart';
import 'package:oepinion/common/widgets/footer.dart';
import 'package:oepinion/common/widgets/screen_scaffold.dart';
import 'package:oepinion/features/opinion/questions/yes_no_question_page.dart';
import 'package:oepinion/features/opinion/screens/welcome_screen.dart';
import 'package:oepinion/features/opinion/widgets/partner_footer.dart';
import 'package:oepinion/main.dart';
import 'package:oepinion/routes/routes.dart';
import 'dart:html';

class IdRepository {
  final Storage _localStorage = window.localStorage;

  void save(bool v) {
    _localStorage['asdlasd'] = v ? "a" : "b";
  }

  bool? getId() {
    final val = _localStorage['asdlasd'];
    if (val == "a") return true;
    if (val == "b") return false;
    return null;
  }

  void invalidate() {
    _localStorage.remove('selected_id');
  }
}

final hasParticipated = HasParticipatedNotifier();

class HasParticipatedNotifier extends ChangeNotifier {
  late final IdRepository _idRepository;
  late bool _hasParticipated;

  HasParticipatedNotifier() {
    _idRepository = IdRepository();
    _hasParticipated = _idRepository.getId() ?? false;
    notifyListeners();
  }

  void setHasParticipated(bool value) {
    _hasParticipated = value;
    _idRepository.save(value);
    notifyListeners();
  }
}

class OpinionResultScreen extends StatelessWidget {
  final String? referalCode;
  final bool interview;

  const OpinionResultScreen({
    Key? key,
    required this.referalCode,
    required this.interview,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
      scrollable: true,
      child: Column(
        children: [
          SvgPicture.asset(
            "images/logo.svg",
            width: 320,
          ),
          32.vSpacing,
          Text(
            "Vielen Dank!!!",
            style: context.typography.headlineLarge?.copyWith(
              fontSize: 54,
            ),
            textAlign: TextAlign.center,
          ),
          32.vSpacing,
          Image.asset(
            "$illustrationPath/i4.png",
            width: 400,
          ),
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
          if (hasParticipated._hasParticipated) ...[
            32.vSpacing,
            BetterButton(
              text: "Zum ReferalCode",
              onPressed: () {
                appRouter.go("/referal");
              },
              color: context.colors.primary,
              width: 240,
            )
          ] else ...[
            Image.asset("$illustrationPath/i5.png"),
            RaffleContainer(
              referalCode: referalCode,
              interview: interview,
            ),
          ],
        ],
      ),
    );
  }
}

class RaffleContainer extends StatefulWidget {
  final String? referalCode;
  final bool interview;
  const RaffleContainer(
      {Key? key, required this.referalCode, required this.interview})
      : super(key: key);

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
        data: {
          "referal": widget.referalCode,
        },
        //   emailRedirectTo:
        //       "https://oepinion.at/verifiy${widget.referalCode != null ? "?referal=${widget.referalCode}" : ""}&email=${Uri.encodeComponent(email)}",
      );

      if (widget.interview) {
        await supabase.from("interviews").insert({
          "email": email,
        });
      }

      hasParticipated.setHasParticipated(true);
      appRouter.go("/referal");
    } catch (e, s) {
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
            const Expanded(
              child: Padding(
                padding: EdgeInsets.only(top: 6),
                child: Text(
                  "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed",
                ),
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
        const SupportLink(),
        32.vSpacing,
        const Footer(),
      ],
    );
  }
}
