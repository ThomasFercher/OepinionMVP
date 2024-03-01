import 'package:flutter/cupertino.dart';

import 'package:oepinion/common/entities/survey.dart';
import 'package:oepinion/common/entities/survey_with_answer.dart';
import 'package:oepinion/common/extensions.dart';
import 'package:oepinion/features/opinion/validation.dart';

class RangeQuestionPage extends StatefulWidget {
  final RangeQuestion question;

  const RangeQuestionPage({
    super.key,
    required this.question,
  });

  @override
  State<RangeQuestionPage> createState() => _RangeQuestionPageState();
}

class _RangeQuestionPageState extends State<RangeQuestionPage> {
  late final ValueNotifier<double> valueNotifier;
  late SurveyValidationNotifier validatorNotifier;
  late SurveyValidator validator;

  @override
  void initState() {
    valueNotifier = ValueNotifier(widget.question.middle.toDouble());
    super.initState();
  }

  @override
  void dispose() {
    valueNotifier.dispose();
    validatorNotifier.removeListener(validate);
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    validatorNotifier = SurveyInfo.of(context).validationNotifier
      ..addListener(validate);
    validator = SurveyInfo.of(context).validator;
    super.didChangeDependencies();
  }

  void validate() {
    if (validatorNotifier.current != widget.question) return;

    validator.validateField(widget.question, true);

    validator.answer(
      widget.question,
      RangeAnswer(
        answer: valueNotifier.value.toInt(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          widget.question.question,
          style: context.typography.headlineSmall,
        ),
        96.vSpacing,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (final option in widget.question.choices.keys)
                Text(
                  option.toString(),
                  style: context.typography.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),
        ),
        24.vSpacing,
        ValueListenableBuilder(
          valueListenable: valueNotifier,
          builder: (context, val, snapshot) {
            return CupertinoSlider(
              value: val,
              divisions: widget.question.max - widget.question.min,
              min: widget.question.min.toDouble(),
              max: widget.question.max.toDouble(),
              onChanged: (value) {
                valueNotifier.value = value;
              },
            );
          },
        ),
      ],
    );
  }
}
