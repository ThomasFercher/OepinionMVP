import 'package:flutter/material.dart';
import 'package:oepinion/common/entities/survey.dart';
import 'package:oepinion/common/entities/survey_with_answer.dart';
import 'package:oepinion/common/extensions.dart';
import 'package:oepinion/features/opinion/validation.dart';

class YesNoQuestionPage extends StatelessWidget {
  final YesNoQuestion question;

  const YesNoQuestionPage({
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
            BetterButton(
              text: "JA",
              color: Colors.green,
              onPressed: () => answer("JA", context),
            ),
            BetterButton(
              text: "NEIN",
              color: Colors.red,
              onPressed: () => answer("NEIN", context),
            ),
          ],
        ),
      ],
    );
  }
}

class BetterButton extends StatelessWidget {
  final BorderRadius borderRadius;
  final String text;
  final VoidCallback onPressed;
  final Color color;
  final Color foregroundColor;
  final double width;
  final double height;
  final bool enabled;

  const BetterButton({
    super.key,
    this.borderRadius = const BorderRadius.all(Radius.circular(8)),
    required this.text,
    required this.onPressed,
    required this.color,
    this.foregroundColor = Colors.white,
    this.width = 128,
    this.height = 48,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Material(
        color: color,
        borderRadius: borderRadius,
        child: InkWell(
          onTap: enabled ? onPressed : null,
          borderRadius: borderRadius,
          enableFeedback: enabled,
          mouseCursor:
              enabled ? SystemMouseCursors.click : SystemMouseCursors.forbidden,
          child: Center(
            child: Text(
              text,
              style: context.typography.bodyLarge?.copyWith(
                color: foregroundColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
