import 'package:flutter/material.dart';
import 'package:web_mvp/common/entities/survey.dart';
import 'package:web_mvp/common/entities/survey_with_answer.dart';
import 'package:web_mvp/common/extensions.dart';
import 'package:web_mvp/features/opinion/questions/yes_no_question_page.dart';
import 'package:web_mvp/features/opinion/validation.dart';

class RadioQuestionPage extends StatelessWidget {
  final RadioQuestion question;

  const RadioQuestionPage({
    super.key,
    required this.question,
  });

  void answer(String answer, BuildContext context) {
    final validator = SurveyInfo.of(context).validator;

    validator.validateField(question, true);
    validator.answer(question, TextAnswer(answer: answer));
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
                color: Colors.blueAccent,
                onPressed: () => answer(choice, context),
              ),
          ],
        ),
      ],
    );
  }
}
