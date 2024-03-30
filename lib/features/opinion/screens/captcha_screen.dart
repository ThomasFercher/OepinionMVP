import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:oepinion/common/entities/survey.dart';
import 'package:oepinion/common/entities/survey_with_answer.dart';
import 'package:oepinion/common/widgets/footer.dart';
import 'package:oepinion/common/widgets/iframe.dart';
import 'package:oepinion/common/widgets/screen_scaffold.dart';
import 'package:oepinion/features/opinion/validation.dart';

class CaptchaScreen extends StatelessWidget {
  final CaptchaQuestion question;

  const CaptchaScreen({Key? key, required this.question}) : super(key: key);

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
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        Expanded(
          child: IFramePage(
            onCaptchaResult: (value) {
              if (value == false) {
                Navigator.of(context).pop();
                return;
              }
              answer("YES", context);
            },
          ),
        ),
      ],
    );
  }
}
