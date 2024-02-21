import 'dart:math';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:web_mvp/common/entities/survey.dart';
import 'package:web_mvp/common/entities/survey_with_answer.dart';
import 'package:web_mvp/common/extensions.dart';
import 'package:web_mvp/features/opinion/questions/multiple_choice_question_page.dart';
import 'package:web_mvp/features/opinion/questions/radio_question_page.dart';
import 'package:web_mvp/features/opinion/questions/range_question_page.dart';
import 'package:web_mvp/features/opinion/questions/text_question_page.dart';
import 'package:web_mvp/features/opinion/questions/yes_no_question_page.dart';
import 'package:web_mvp/main.dart';

class OpinionNotifier extends ChangeNotifier {
  Survey? survey;

  void loadSurvey(String id) async {
    final query = supabase.from('surveys').select().eq('id', id).limit(1);

    final result = await query;

    if (result.isEmpty) return;

    survey = Survey.fromJSON(result.first);

    notifyListeners();
  }
}

class OpinionScreen extends StatefulWidget {
  final String? id;

  const OpinionScreen({Key? key, this.id}) : super(key: key);

  @override
  State<OpinionScreen> createState() => _OpinionScreenState();
}

class _OpinionScreenState extends State<OpinionScreen> {
  late final OpinionNotifier notifier;

  @override
  void initState() {
    notifier = OpinionNotifier();
    if (widget.id != null) {
      notifier.loadSurvey(widget.id!);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: notifier,
      builder: (context, child) {
        if (notifier.survey == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return SurveyScreen(survey: notifier.survey!);
      },
    );
  }
}

class SurveyScreen extends StatefulWidget {
  final Survey survey;

  const SurveyScreen({
    required this.survey,
    super.key,
  });

  @override
  State<SurveyScreen> createState() => _SurveyScreenState();
}

class _SurveyScreenState extends State<SurveyScreen> {
  late final PageController _pageController;
  late final ValueNotifier<int> currentPage;

  final SurveyValidator validator = SurveyValidator();
  final SurveyValidationNotifier validationNotifier =
      SurveyValidationNotifier();

  late bool captchaSolved;
  late bool showResult;

  Survey get survey => widget.survey;

  @override
  void initState() {
    _pageController = PageController(initialPage: 0);
    currentPage = ValueNotifier(0)..addListener(onIndexChange);
    validator.addListener(fieldChanged);
    captchaSolved = false;
    showResult = false;
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    currentPage
      ..removeListener(onIndexChange)
      ..dispose();
    validator
      ..removeListener(fieldChanged)
      ..dispose();
    super.dispose();
  }

  void answerSurvey() async {
    final answers = validator._answers.values;

    await supabase.from('survey_answers').insert({
      'answers': answers.map((e) => e.toJson()).toList(),
      'survey_id': survey.id,
    });

    setState(() {
      showResult = true;
    });
    Future.delayed(const Duration(seconds: 3), () {
      GoRouter.of(context).go("/opinion/${survey.id}/result");
    });
  }

  void fieldChanged() {
    final valid = validator.answerIsValid(currentQuestion);

    final nextIndex = currentPage.value + 1;

    if (nextIndex >= survey.questions.length) {
      answerSurvey();
      return;
    }

    if (valid) {
      currentPage.value = currentPage.value + 1;
    }
  }

  void onIndexChange() {
    _pageController.animateToPage(
      currentPage.value,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Question get currentQuestion => survey.questions[currentPage.value];

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

    if (showResult) {
      return Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: ConfettiController()..play(),
              numberOfParticles: 5,
              emissionFrequency: 0.05,
              blastDirectionality: BlastDirectionality.explosive,
              blastDirection: .5 * pi,
              shouldLoop: true,
            ),
          ),
          Align(
            alignment: const Alignment(0, -0.5),
            child: Material(
              type: MaterialType.transparency,
              child: Text(
                "Danke für deine Teilnahme!",
                style: context.typography.headlineLarge,
              ),
            ),
          )
        ],
      );
    }

    return SurveyInfo(
      validator: validator,
      validationNotifier: validationNotifier,
      child: Scaffold(
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
                    if (index == survey.questions.length) {
                      return const SizedBox.shrink();
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "${survey.getPercentage(index)}%",
                        ),
                        4.vSpacing,
                        LinearProgressIndicator(
                          value: survey.getProgress(index),
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
                      final question = survey.questions[index];

                      return switch (question) {
                        MultipleChoiceQuestion question =>
                          MultipleChoiceQuestionPage(question: question),
                        YesNoQuestion question =>
                          YesNoQuestionPage(question: question),
                        RangeQuestion question =>
                          RangeQuestionPage(question: question),
                        TextQuestion question =>
                          TextQuestionPage(question: question),
                        RadioQuestion question =>
                          RadioQuestionPage(question: question),
                      };
                    },
                  ),
                ),
                32.vSpacing,
                ValueListenableBuilder(
                  valueListenable: currentPage,
                  builder: (context, index, child) {
                    if (currentQuestion.handlesNav) {
                      return const SizedBox.shrink();
                    }
                    return child!;
                  },
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: () {
                        validationNotifier.validate(currentQuestion);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          "Weiter",
                          style: context.typography.bodyLarge?.copyWith(
                            color: context.colors.primary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                32.vSpacing,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SurveyInfo extends InheritedWidget {
  final SurveyValidator validator;
  final SurveyValidationNotifier validationNotifier;

  const SurveyInfo({
    required super.child,
    required this.validator,
    required this.validationNotifier,
    super.key,
  });

  static SurveyInfo of(BuildContext context) {
    final resutl = context.dependOnInheritedWidgetOfExactType<SurveyInfo>();
    assert(resutl != null, "No SurveyInfo found in context");
    return resutl!;
  }

  @override
  bool updateShouldNotify(SurveyInfo oldWidget) {
    return false;
  }
}

class SurveyValidator extends ChangeNotifier {
  final Map<Question, Answer> _answers = {};
  final Map<Question, bool> _validQuestions = {};

  void validateField(
    Question question,
    bool valid,
  ) {
    _validQuestions[question] = valid;
    notifyListeners();
  }

  bool answerIsValid(Question question) {
    return _validQuestions[question]!;
  }

  void answer(Question question, Answer answer) {
    _answers[question] = answer;
  }
}

class SurveyValidationNotifier extends ChangeNotifier {
  Question? current;

  void validate(Question question) {
    current = question;
    notifyListeners();
  }
}
