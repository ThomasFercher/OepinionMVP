import 'package:flutter/material.dart';
import 'package:web_mvp/common/entities/survey.dart';
import 'package:web_mvp/common/extensions.dart';

class TextQuestionPage extends StatelessWidget {
  final TextQuestion question;

  const TextQuestionPage({
    super.key,
    required this.question,
  });

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
        TextFormField(
          scrollPhysics: const NeverScrollableScrollPhysics(),
          maxLength: 256,
          maxLines: 8,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }
}
