import 'package:flutter/material.dart';
import 'package:oepinion/common/entities/survey.dart';
import 'package:oepinion/common/entities/survey_with_answer.dart';
import 'package:oepinion/common/extensions.dart';
import 'package:oepinion/features/opinion/validation.dart';
import 'package:oepinion/features/opinion/widgets/checkbox_tile.dart';
import 'package:oepinion/features/opinion/widgets/error_container.dart';

typedef MultipleChoiceQuestionState = Map<String, bool>;

class MultipleChoiceQuestionPage extends StatefulWidget {
  final MultipleChoiceQuestion question;

  const MultipleChoiceQuestionPage({
    super.key,
    required this.question,
  });

  @override
  State<MultipleChoiceQuestionPage> createState() =>
      _MultipleChoiceQuestionPageState();
}

class _MultipleChoiceQuestionPageState
    extends State<MultipleChoiceQuestionPage> {
  late SurveyValidator validator;
  late SurveyValidationNotifier validationNotifier;

  late Map<String, ValueNotifier<bool>> valueNotifiers;
  late ValueNotifier<bool?> validNotifier;

  Map<String, bool> get values => {
        for (final entry in valueNotifiers.entries)
          entry.key: entry.value.value,
      };

  List<String> get choices {
    return values.entries
        .where((entry) => entry.value == true)
        .map((entry) => entry.key)
        .toList();
  }

  @override
  void didChangeDependencies() {
    validNotifier = ValueNotifier(null);
    validationNotifier = SurveyInfo.of(context).validationNotifier
      ..addListener(validate);
    validator = SurveyInfo.of(context).validator;
    valueNotifiers = {
      for (final option in widget.question.choices)
        option: ValueNotifier(false)
          ..addListener(
            () => answerChanged(option),
          ),
    };
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    validator.removeListener(validate);
    for (final notifier in valueNotifiers.values) {
      notifier.dispose();
    }
    super.dispose();
  }

  bool get isValid {
    final valid = values.values.every((val) => val == false) == false;
    validNotifier.value = valid;
    return valid;
  }

  void validate() {
    if (validationNotifier.current != widget.question) return;

    final valid = isValid;

    validator.validateField(widget.question, valid);

    if (valid) {
      validator.answer(widget.question, MultipleChoiceAnswer(choices: choices));
    }
  }

  void answerChanged(String option) async {
    if (widget.question.allowMultiple) return;

    final valid = isValid;

    await Future.delayed(const Duration(milliseconds: 100));

    validator.validateField(widget.question, valid);

    if (valid) {
      validator.answer(widget.question, MultipleChoiceAnswer(choices: choices));
    }
    // if (valueNotifiers[option]!.value == false) return;

    // for (final entry in valueNotifiers.entries) {
    //   if (entry.key == option) continue;
    //   entry.value.value = false;
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.question.question,
          style: context.typography.headlineSmall,
        ),
        32.vSpacing,
        Column(
          children: [
            for (final option in widget.question.choices)
              Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: CheckBoxTile(
                  title: option,
                  valueNotifier: valueNotifiers[option]!,
                ),
              )
          ],
        ),
        16.vSpacing,
        ValueListenableBuilder(
          valueListenable: validNotifier,
          builder: (context, value, child) {
            if (value == null || value == true) return const SizedBox.shrink();

            return const ErrorContainer(message: "Please select one option");
          },
        ),
      ],
    );
  }
}
