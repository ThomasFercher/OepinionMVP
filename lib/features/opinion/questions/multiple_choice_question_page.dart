import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oepinion/common/entities/survey.dart';
import 'package:oepinion/common/entities/survey_with_answer.dart';
import 'package:oepinion/common/extensions.dart';
import 'package:oepinion/features/opinion/validation.dart';
import 'package:oepinion/features/opinion/widgets/checkbox_tile.dart';
import 'package:oepinion/features/opinion/widgets/error_container.dart';

class MCAnswerNotifier extends FamilyNotifier<MultipleChoiceQuestionState,
    MultipleChoiceQuestion> {
  @override
  MultipleChoiceQuestionState build(arg) => {
        for (final choice in arg.choices) choice: false,
      };

  void setChoice((String, String?) choice, bool value) {
    if (arg.allowMultiple) {
      state[choice] = value;
      state = {...state};
      return;
    }

    state.forEach((key, value) {
      state[key] = false;
    });
    state[choice] = value;
    state = {...state};
  }

  bool get isValid {
    return state.values.every((val) => val == false) == false;
  }
}

final mcAnswerNotifier = NotifierProvider.family<MCAnswerNotifier,
    MultipleChoiceQuestionState, MultipleChoiceQuestion>(
  MCAnswerNotifier.new,
);

typedef MultipleChoiceQuestionState = Map<(String, String?), bool>;

class MultipleChoiceQuestionPage extends ConsumerStatefulWidget {
  final MultipleChoiceQuestion question;
  final SurveyValidationNotifier validationNotifier;
  final SurveyValidator validator;

  const MultipleChoiceQuestionPage({
    super.key,
    required this.question,
    required this.validationNotifier,
    required this.validator,
  });

  @override
  ConsumerState<MultipleChoiceQuestionPage> createState() =>
      _MultipleChoiceQuestionPageState();
}

class _MultipleChoiceQuestionPageState
    extends ConsumerState<MultipleChoiceQuestionPage> {
  late ValueNotifier<bool?> validNotifier;

  @override
  void initState() {
    validNotifier = ValueNotifier(null);
    widget.validationNotifier.addListener(validate);
    super.initState();
  }

  @override
  void dispose() {
    widget.validator.removeListener(validate);
    super.dispose();
  }

  void validate() {
    if (widget.validationNotifier.current != widget.question) return;
    if (!mounted) return;

    final valid = ref.read(mcAnswerNotifier(widget.question).notifier).isValid;
    final choices = ref.read(mcAnswerNotifier(widget.question)).keys.toList();

    validNotifier.value = valid;

    widget.validator.answer(
      widget.question,
      MultipleChoiceAnswer(
        choices: choices,
      ),
    );
    widget.validator.validateField(widget.question, valid);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(mcAnswerNotifier(widget.question));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.question.question,
          style: context.typography.headlineSmall,
        ),
        16.vSpacing,
        if (widget.question.allowMultiple)
          Text(
            "Wähle eine oder mehrere Antworten",
            style: context.typography.bodySmall,
          )
        else
          Text(
            "Wähle eine Antwort",
            style: context.typography.bodySmall,
          ),
        32.vSpacing,
        Column(
          children: [
            for (final choice in widget.question.choices)
              Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: CheckBoxTile(
                  title: choice.$1,
                  subTitle: choice.$2,
                  value: state[choice] ?? false,
                  onChanged: (val) {
                    ref
                        .read(mcAnswerNotifier(widget.question).notifier)
                        .setChoice(choice, val);
                  },
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
