import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:web_mvp/common/entities/survey.dart';
import 'package:web_mvp/common/extensions.dart';
import 'package:web_mvp/features/opinion/questions/question_page.dart';

const testSurvey = Survey(
  name: "Oepinion",
  description: "lorem",
  questions: [
    MultipleChoiceQuestion(
      question: "In welchen Studienabschnitt befindest du dich?",
      allowMultiple: false,
      choices: [
        "Bachelor",
        "Master",
        "Doktor",
      ],
    ),
    YesNoQuestion(question: "Arbeitest du aktuell an deiner Abschlussarbeit?"),
    MultipleChoiceQuestion(
      question:
          "Gibt es Aspekte bei deiner Abschlussarbeit, bei denen du dir zusätzliche Unterstützung wünschen würdest?",
      allowMultiple: true,
      choices: [
        "Themenausarbeitung",
        "Hyposethenbildung",
        "Forschungsstrategie",
        "Datenerhebung (z.B. Umfragen)",
        "Datenanalyse",
        "Schreibprozess",
      ],
    ),
    YesNoQuestion(
      question:
          "Hast du bereits Erfahrungen mit der Erstellung von Umfragen für deine Abschlussarbeit gemacht?",
    ),
    RangeQuestion(
      question:
          "Wie würdest du den Aufwand der Erstellung deiner Umfrage bewerten",
      choices: {
        1: "Sehr gering",
        2: "Gering",
        3: "Mittelmäßig",
        4: "Groß",
        5: "Sehr groß",
      },
    ),
    RangeQuestion(
      question:
          "Wie würdest du die Schwierigkeit bei der Auswertung deiner Umfrage bewerten?",
      choices: {
        1: "Sehr gering",
        2: "Gering",
        3: "Mittelmäßig",
        4: "Groß",
        5: "Sehr groß",
      },
    ),
    TextQuestion(
      question:
          "Welche spezifischen Herausforderungen sind dir bei der Erstellung und Auswertung deiner Umfrage begegnet? ",
    ),
    YesNoQuestion(
      question:
          "Wenn du noch keine Erfahrung mit Meinungsumfragen und deren Auswertung gemacht hast, siehst du das als potenzielles Problem für deine zukünftige Abschlussarbeit?",
    ),
    RangeQuestion(
      question:
          "Wie wichtig wäre es für dich, Zugang zu einer Plattform zu bekommen, die dich durch den Prozess deiner Abschlussarbeit führt?",
      choices: {
        1: "Sehr gering",
        2: "Gering",
        3: "Mittelmäßig",
        4: "Groß",
        5: "Sehr groß",
      },
    ),
    TextQuestion(
      question: "Welche Funktionen sollte dieses ideale Tool für dich haben?",
    ),
    RadioQuestion(
      question:
          "Würdes DU für das Tool bezahlen, oder sollte das dein Institut übernehmen?",
      choices: ["Ich", "Institut"],
    ),
  ],
);

class OpinionScreen extends StatefulWidget {
  final String? id;

  const OpinionScreen({
    required this.id,
    super.key,
  });

  @override
  State<OpinionScreen> createState() => _OpinionScreenState();
}

class _OpinionScreenState extends State<OpinionScreen> {
  late final PageController _pageController;
  late final ValueNotifier<int> currentPage;

  late bool captchaSolved;

  @override
  void initState() {
    _pageController = PageController(initialPage: 0);
    currentPage = ValueNotifier(0)..addListener(onIndexChange);
    captchaSolved = false;
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    currentPage
      ..removeListener(onIndexChange)
      ..dispose();
    super.dispose();
  }

  void onIndexChange() {
    _pageController.animateToPage(
      currentPage.value,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: Implement captcha
    // if (!captchaSolved) {
    //   return Scaffold(
    //     body: Checkbox(
    //       value: false,
    //       onChanged: (value) {
    //         setState(() {
    //           captchaSolved = true;
    //         });
    //       },
    //     ),
    //   );
    // }

    return Scaffold(
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 800),
          padding: const EdgeInsets.all(32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              16.vSpacing,
              ValueListenableBuilder(
                valueListenable: currentPage,
                builder: (context, index, child) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "${testSurvey.getPercentage(index)}%",
                      ),
                      4.vSpacing,
                      LinearProgressIndicator(
                        value: testSurvey.getProgress(index),
                        borderRadius: BorderRadius.circular(8),
                        minHeight: 16,
                      ),
                    ],
                  );
                },
              ),
              32.vSpacing,
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemBuilder: (context, index) {
                    final question = testSurvey.questions[index];
                    return QuestionPage(
                      question: question,
                    );
                  },
                ),
              ),
              32.vSpacing,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      currentPage.value = currentPage.value - 1;
                    },
                    child: const Text("Zurück"),
                  ),
                  TextButton(
                    onPressed: () {
                      currentPage.value = currentPage.value + 1;
                    },
                    child: const Text("Weiter"),
                  ),
                ],
              ),
              32.vSpacing,
            ],
          ),
        ),
      ),
    );
  }
}
