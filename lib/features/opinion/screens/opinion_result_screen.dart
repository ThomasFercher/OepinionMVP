import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:oepinion/common/colors.dart';
import 'package:oepinion/common/extensions.dart';
import 'package:oepinion/common/widgets/footer.dart';
import 'package:oepinion/common/widgets/screen_scaffold.dart';
import 'package:oepinion/features/opinion/questions/text_question_page.dart';
import 'package:oepinion/features/opinion/questions/yes_no_question_page.dart';
import 'package:oepinion/features/opinion/screens/welcome_screen.dart';
import 'package:oepinion/features/opinion/widgets/partner_footer.dart';
import 'package:oepinion/main.dart';
import 'package:oepinion/routes/routes.dart';
import 'package:confetti/confetti.dart';
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

class OpinionResultScreen extends StatefulWidget {
  final String? referalCode;
  final bool interview;

  const OpinionResultScreen({
    Key? key,
    required this.referalCode,
    required this.interview,
  }) : super(key: key);

  @override
  State<OpinionResultScreen> createState() => _OpinionResultScreenState();
}

class _OpinionResultScreenState extends State<OpinionResultScreen> {
  final ConfettiController _confettiController = ConfettiController();
  final TextEditingController _feedbackController = TextEditingController();
  final ValueNotifier<String?> _feedBackError = ValueNotifier(null);

  @override
  void initState() {
    _confettiController.play();

    Future.delayed(const Duration(seconds: 5), () {
      _confettiController.stop();
    });
    super.initState();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _feedbackController.dispose();
    super.dispose();
  }

  void giveFeedback() async {
    final feedback = _feedbackController.text;

    if (feedback.isEmpty) {
      _feedBackError.value = "Bitte gib dein Feedback ein";
      return;
    }
    _feedBackError.value = null;

    final result = await supabase.from("feedback").insert({
      "text": feedback,
    });

    _feedbackController.clear();

    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ScreenScaffold(
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
              32.vSpacing,
              BetterButton(
                text: "Feedback zur Umfrage",
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Container(
                              constraints: const BoxConstraints(
                                maxWidth: 600,
                                minWidth: 400,
                              ),
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Feedback",
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      CloseButton(),
                                    ],
                                  ),
                                  24.vSpacing,
                                  ValueListenableBuilder(
                                      valueListenable: _feedBackError,
                                      builder: (context, error, _) {
                                        return TextField(
                                          maxLength: 512,
                                          maxLines: 6,
                                          style: context.typography.bodyMedium
                                              ?.copyWith(
                                            color: kText,
                                          ),
                                          controller: _feedbackController,
                                          inputFormatters: [
                                            MaxLinesTextInputFormatter(
                                                maxLines: 8),
                                          ],
                                          decoration: InputDecoration(
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                              horizontal: 16,
                                              vertical: 22,
                                            ),
                                            fillColor: kGray3,
                                            errorText: error,
                                            hintText: "Feedback zur Umfrage",
                                            hintStyle: context
                                                .typography.bodyMedium
                                                ?.copyWith(color: kGray),
                                            border: OutlineInputBorder(
                                              borderSide: BorderSide.none,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                          ),
                                        );
                                      }),
                                  24.vSpacing,
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: BetterButton(
                                      height: 48,
                                      text: "Absenden",
                                      onPressed: giveFeedback,
                                      color: kBlue,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
                height: 48,
                width: 240,
                color: kBlue,
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
                48.vSpacing,
                BetterButton(
                  text: "Zum ReferalCode",
                  onPressed: () {
                    appRouter.go("/referal");
                  },
                  color: context.colors.primary,
                  width: 240,
                ),
                96.vSpacing,
                const PartnerFooter(),
                96.vSpacing,
                const SupportLink(),
              ] else ...[
                Image.asset("$illustrationPath/i5.png"),
                RaffleContainer(
                  referalCode: widget.referalCode,
                  interview: widget.interview,
                ),
              ],
            ],
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: ConfettiWidget(
            confettiController: _confettiController,
            numberOfParticles: 5,
            emissionFrequency: 0.05,
            blastDirectionality: BlastDirectionality.explosive,
            blastDirection: .5 * pi,
            shouldLoop: true,
          ),
        ),
      ],
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Bitte gib deine E-Mail Adresse ein"),
        ),
      );
      return;
    }
    final messenger = ScaffoldMessenger.of(context);

    try {
      final nickname = await supabase.rpc("get_random_value", params: {});
      await supabase.auth.signInWithOtp(
        email: email,
        shouldCreateUser: true,
        data: {
          "referal": widget.referalCode,
          "nickname": nickname,
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
                  "Ich bestätige dass ich die Datenschutz- und Gewinnspielteilnahmebedingungen vollständig gelesen und verstanden habe und erkläre mich mit diesen einverstanden.",
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
