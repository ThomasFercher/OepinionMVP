import 'package:flutter/material.dart';
import 'package:oepinion/common/colors.dart';
import 'package:oepinion/common/entities/survey.dart';
import 'package:oepinion/common/entities/survey_with_answer.dart';
import 'package:oepinion/common/extensions.dart';
import 'package:oepinion/features/opinion/validation.dart';
import 'package:oepinion/features/opinion/widgets/error_container.dart';

class DropdownQuestionPage extends StatefulWidget {
  final DropDownQuestion question;

  const DropdownQuestionPage({
    super.key,
    required this.question,
  });

  @override
  State<DropdownQuestionPage> createState() => _DropdownQuestionPageState();
}

class _DropdownQuestionPageState extends State<DropdownQuestionPage> {
  final ValueNotifier<String?> valueNotifier = ValueNotifier(null);
  final ValueNotifier<bool?> validNotifier = ValueNotifier(null);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    SurveyInfo.of(context).validationNotifier.addListener(validate);
  }

  void validate() {
    final validator = SurveyInfo.of(context).validator;

    final isValid = valueNotifier.value?.isNotEmpty ?? false;

    validNotifier.value = isValid;

    validator.answer(
      widget.question,
      TextAnswer(answer: valueNotifier.value ?? ""),
    );
    validator.validateField(widget.question, isValid);
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
        LayoutBuilder(builder: (context, constraints) {
          return DropdownMenu(
            width: constraints.maxWidth,
            textStyle: context.typography.bodyMedium,
            enableFilter: true,
            menuHeight: 400,
            hintText: "Studienrichtung auswählen",
            inputDecorationTheme: InputDecorationTheme(
              fillColor: kGray3,
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: kGray1, width: 1),
              ),
              outlineBorder: const BorderSide(color: kGray1),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: kGray1, width: 1),
              ),
            ),
            trailingIcon: const Icon(
              Icons.arrow_drop_down,
              color: kGray1,
            ),
            onSelected: (value) {
              valueNotifier.value = value;
            },
            dropdownMenuEntries: [
              for (final choice in widget.question.choices)
                DropdownMenuEntry(
                  label: choice,
                  labelWidget: Text(
                    choice,
                    style: context.typography.bodyMedium,
                  ),
                  value: choice,
                ),
            ],
          );
        }),
        32.vSpacing,
        ValueListenableBuilder(
          valueListenable: validNotifier,
          builder: (context, valid, child) {
            if (valid == false) return child!;
            return const SizedBox.shrink();
          },
          child: const ErrorContainer(
            message: "Bitte wählen Sie eine Antwort",
          ),
        ),
      ],
    );
  }
}
