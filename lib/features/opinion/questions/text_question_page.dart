import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oepinion/common/colors.dart';
import 'package:oepinion/common/entities/survey.dart';
import 'package:oepinion/common/entities/survey_with_answer.dart';
import 'package:oepinion/common/extensions.dart';
import 'package:oepinion/features/opinion/validation.dart';
import 'package:oepinion/features/opinion/widgets/error_container.dart';

class TextQuestionPage extends StatefulWidget {
  final TextQuestion question;

  const TextQuestionPage({
    super.key,
    required this.question,
  });

  @override
  State<TextQuestionPage> createState() => _TextQuestionPageState();
}

class _TextQuestionPageState extends State<TextQuestionPage> {
  late SurveyValidator validator;
  late SurveyValidationNotifier validationNotifier;
  late TextEditingController controller;
  late ValueNotifier<bool?> validNotifier;

  String get text => controller.text;

  bool get isValid {
    return text.length >= 16;
  }

  @override
  void initState() {
    controller = TextEditingController();
    validNotifier = ValueNotifier(null);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    validationNotifier = SurveyInfo.of(context).validationNotifier
      ..addListener(validate);
    validator = SurveyInfo.of(context).validator;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    validationNotifier.removeListener(validate);
    controller.dispose();
    super.dispose();
  }

  void validate() {
    if (validationNotifier.current != widget.question) return;

    validNotifier.value = isValid;
    validator.answer(widget.question, TextAnswer(answer: text));
    validator.validateField(widget.question, isValid);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          widget.question.question,
          style: context.typography.headlineSmall,
        ),
        48.vSpacing,
        TextField(
          // scrollPhysics: const NeverScrollableScrollPhysics(),
          maxLength: 512,
          maxLines: 6,
          style: context.typography.bodyMedium?.copyWith(
            color: kText,
          ),

          controller: controller,
          inputFormatters: [
            MaxLinesTextInputFormatter(maxLines: 8),
          ],
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 22,
            ),
            fillColor: kGray3,
            hintText: "Was denkst du dazu?",
            hintStyle: context.typography.bodyMedium?.copyWith(color: kGray),
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        32.vSpacing,
        ValueListenableBuilder<bool?>(
          valueListenable: validNotifier,
          builder: (context, valid, child) {
            if (valid == null || valid == true) {
              return const SizedBox.shrink();
            }

            return const ErrorContainer(
              message: "Bitte gib mindestens 16 Zeichen ein.",
            );
          },
        ),
        128.vSpacing,
      ],
    );
  }
}

class MaxLinesTextInputFormatter extends TextInputFormatter {
  final int maxLines;

  MaxLinesTextInputFormatter({required this.maxLines});

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final regExp = RegExp('\n');
    final match = regExp.allMatches(newValue.text).length;
    if (match >= maxLines) {
      return oldValue;
    }
    return newValue;
  }
}
