import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:oepinion/common/colors.dart';
import 'package:oepinion/common/entities/survey.dart';
import 'package:oepinion/common/entities/survey_with_answer.dart';
import 'package:oepinion/common/extensions.dart';
import 'package:oepinion/common/widgets/screen_scaffold.dart';
import 'package:oepinion/features/opinion/notifiers.dart';
import 'package:oepinion/features/opinion/questions/dropdown_question_page.dart';
import 'package:oepinion/features/opinion/questions/multiple_choice_question_page.dart';
import 'package:oepinion/features/opinion/questions/radio_question_page.dart';
import 'package:oepinion/features/opinion/questions/range_question_page.dart';
import 'package:oepinion/features/opinion/questions/text_question_page.dart';
import 'package:oepinion/features/opinion/questions/yes_no_question_page.dart';
import 'package:oepinion/features/opinion/screens/captcha_screen.dart';
import 'package:oepinion/features/opinion/screens/opinion_result_screen.dart';
import 'package:oepinion/features/opinion/screens/welcome_screen.dart';
import 'package:oepinion/features/opinion/validation.dart';
import 'package:oepinion/main.dart';
import 'package:collection/collection.dart';

String? getReferalCode(BuildContext context) {
  return GoRouterState.of(context).uri.queryParameters['referal'];
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

class SurveyScreen extends ConsumerStatefulWidget {
  final Survey survey;

  const SurveyScreen({
    required this.survey,
    super.key,
  });

  @override
  ConsumerState<SurveyScreen> createState() => _SurveyScreenState();
}

class _SurveyScreenState extends ConsumerState<SurveyScreen> {
  late final ValueNotifier<int> currentPage;

  final SurveyValidator validator = SurveyValidator();
  final SurveyValidationNotifier validationNotifier =
      SurveyValidationNotifier();

  late bool captchaSolved;
  late bool showStart;
  late bool showResult;

  Survey get survey => widget.survey;

  String? referalCode;

  bool? interview;

  Set<String> questionHistory = {};

  @override
  void initState() {
    currentPage = ValueNotifier(0);
    validator.addListener(fieldChanged);
    captchaSolved = false;
    showResult = false;
    showStart = true;
    super.initState();
  }

  @override
  void dispose() {
    currentPage.dispose();
    validator
      ..removeListener(fieldChanged)
      ..dispose();
    ref
      ..invalidate(textAnswerNotifier)
      ..invalidate(mcAnswerNotifier)
      ..invalidate(rangeAnswerNotifier);
    super.dispose();
  }

  void answerSurvey() async {
    final answers = validator.answers.entries.toList();

    final interviewAnswer = answers.singleWhereOrNull((e) => e.key.id == "k");
    interview = interviewAnswer?.value is TextAnswer &&
        (interviewAnswer?.value as TextAnswer).answer.toLowerCase() == 'ja';

    referalCode = getReferalCode(context);

    Future<void> answer() async {
      ref
        ..invalidate(textAnswerNotifier)
        ..invalidate(mcAnswerNotifier)
        ..invalidate(rangeAnswerNotifier);
      try {
        await supabase.from('survey_answers').insert({
          'answers': answers.map((e) => e.value.toJson(e.key)).toList(),
          'survey_id': survey.id,
        });

        setState(() {
          showResult = true;
        });
      } catch (e, s) {
        print(e);
        print(s);
        rethrow;
      }
    }

    bool hasError;
    int i = 0;
    const maxRetries = 3;
    do {
      hasError = false;
      try {
        await answer();
      } catch (e) {
        hasError = true;
        await Future.delayed(const Duration(seconds: 3));
      }
      i++;
    } while (hasError && i < maxRetries);
  }

  void fieldChanged() {
    final valid = validator.answerIsValid(currentQuestion);
    String? nextPage;
    if (currentQuestion is YesNoQuestion) {
      final yesNoQuestion = currentQuestion as YesNoQuestion;
      final answer = validator.getAnswer(currentQuestion);
      if (answer is TextAnswer) {
        final text = answer.answer.toLowerCase();
        final yes = text == 'ja' || text == 'yes';
        nextPage = yesNoQuestion.skipToQuestion?.call(yes);
      }
    }

    nextPage ??= currentQuestion.destination;
    final nextIndex = nextPage == null
        ? currentPage.value + 1
        : survey.questions.indexWhere((q) => q.id == nextPage);

    final nextQuestion = survey.questions[nextIndex];
    if (nextQuestion is PlaceHolderQuestion) {
      context.go("/declined");
      return;
    }

    if (valid) {
      if (nextIndex >= survey.questions.length || currentQuestion.end) {
        questionHistory.add(currentQuestion.id);
        answerSurvey();
        return;
      }

      questionHistory.add(currentQuestion.id);
      currentPage.value = nextIndex;
    }
  }

  Question get currentQuestion => survey.questions[currentPage.value];

  @override
  Widget build(BuildContext context) {
    if (showStart) {
      return WelcomeScreen(
        onContinue: () {
          setState(() {
            showStart = false;
          });
        },
      );
    }

    if (showResult) {
      return OpinionResultScreen(
        referalCode: referalCode,
        interview: interview ?? false,
      );
    }

    return SurveyInfo(
      validator: validator,
      validationNotifier: validationNotifier,
      child: Scaffold(
        body: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 960),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                context.dyn(16, 16, 24).vSpacing,
                Expanded(
                  child: ValueListenableBuilder(
                    valueListenable: currentPage,
                    builder: (context, index, child) {
                      if (index == survey.questions.length) {
                        return const SizedBox.shrink();
                      }
                      final page = switch (currentQuestion) {
                        MultipleChoiceQuestion question =>
                          MultipleChoiceQuestionPage(
                            question: question,
                            validationNotifier: validationNotifier,
                            validator: validator,
                          ),
                        YesNoQuestion question =>
                          YesNoQuestionPage(question: question),
                        RangeQuestion question =>
                          RangeQuestionPage(question: question),
                        TextQuestion question =>
                          TextQuestionPage(question: question),
                        RadioQuestion question =>
                          RadioQuestionPage(question: question),
                        DropDownQuestion question =>
                          DropdownQuestionPage(question: question),
                        CaptchaQuestion question => CaptchaScreen(
                            question: question,
                          ),
                        PlaceHolderQuestion _ => throw UnimplementedError(),
                      };

                      final pageWidget = ScreenScaffold(
                        maxWidth: 940,
                        scrollable: switch (currentQuestion) {
                          TextQuestion _ || MultipleChoiceQuestion _ => true,
                          _ => false,
                        },
                        padding: EdgeInsets.symmetric(
                          horizontal: context.dyn(16, 24, 32),
                        ),
                        child: page,
                      );

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: context.dyn(16, 24, 32),
                            ),
                            child: Text(
                              "${survey.getPercentage(questionHistory)}%",
                              style: context.typography.bodySmall?.copyWith(
                                color: kGray,
                              ),
                            ),
                          ),
                          4.vSpacing,
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: context.dyn(16, 24, 32),
                            ),
                            child: LinearProgressIndicator(
                              value: survey.getProgress(questionHistory),
                              borderRadius: BorderRadius.circular(8),
                              minHeight: 12,
                              color: kBlue,
                              backgroundColor: kGray.withOpacity(0.1),
                            ),
                          ),
                          context.dyn(16, 24, 32).vSpacing,
                          Expanded(
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 200),
                              switchInCurve: Curves.easeInOut,
                              switchOutCurve: Curves.easeInOut,
                              transitionBuilder: (child, animation) {
                                return FadeTransition(
                                  opacity: animation,
                                  child: child,
                                );
                              },
                              child: Align(
                                alignment: Alignment.topCenter,
                                child: pageWidget,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                4.vSpacing,
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.dyn(16, 24, 32),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ValueListenableBuilder(
                        valueListenable: currentPage,
                        builder: (context, index, child) {
                          if (index < 2) {
                            return const SizedBox.shrink();
                          }
                          return child!;
                        },
                        child: TextButton(
                          onPressed: () {
                            final index = survey.questions.indexWhere(
                              (element) => element.id == questionHistory.last,
                            );
                            questionHistory.remove(questionHistory.last);

                            currentPage.value = index;
                          },
                          style: TextButton.styleFrom(primary: kBlue),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text(
                              "Zurück",
                              style: context.typography.bodyLarge?.copyWith(
                                color: kBlue,
                              ),
                            ),
                          ),
                        ),
                      ),
                      ValueListenableBuilder(
                        valueListenable: currentPage,
                        builder: (context, index, child) {
                          if (currentQuestion.handlesNav) {
                            return const SizedBox.shrink();
                          }
                          return child!;
                        },
                        child: TextButton(
                          onPressed: () {
                            validationNotifier.validate(currentQuestion);
                          },
                          style: TextButton.styleFrom(primary: kBlue),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text(
                              "Weiter",
                              style: context.typography.bodyLarge?.copyWith(
                                color: kBlue,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                context.dyn(8, 16, 24).vSpacing,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

extension Dyn on BuildContext {
  T dyn<T>(T small, T medium, T large) {
    final width = MediaQuery.of(this).size.width;
    if (width < 600) {
      return small;
    } else if (width < 960) {
      return medium;
    } else {
      return large;
    }
  }
}
