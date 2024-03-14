import 'package:flutter/material.dart';
import 'package:oepinion/common/colors.dart';
import 'package:oepinion/common/entities/survey.dart';
import 'package:oepinion/common/entities/survey_with_answer.dart';
import 'package:oepinion/common/extensions.dart';
import 'package:oepinion/features/opinion/questions/yes_no_question_page.dart';
import 'package:oepinion/features/opinion/validation.dart';

class RadioQuestionPage extends StatelessWidget {
  final RadioQuestion question;

  const RadioQuestionPage({
    super.key,
    required this.question,
  });

  void answer(String answer, BuildContext context) {
    final validator = SurveyInfo.of(context).validator;
    validator.answer(question, TextAnswer(answer: answer));
    validator.validateField(question, true);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          question.question,
          style: context.typography.headlineSmall,
        ),
        96.vSpacing,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            for (final choice in question.choices)
              BetterButton(
                text: choice,
                color: kBlue,
                onPressed: () => answer(choice, context),
              ),
          ],
        ),
      ],
    );
  }
}
