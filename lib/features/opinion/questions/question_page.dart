import 'package:flutter/widgets.dart';
import 'package:web_mvp/common/entities/survey.dart';
import 'package:web_mvp/features/opinion/questions/multiple_choice_question_page.dart';

class QuestionPage extends StatelessWidget {
  final Question question;

  const QuestionPage({super.key, required this.question});

  @override
  Widget build(BuildContext context) {
    return switch (question) {
      MultipleChoiceQuestion question =>
        MultipleChoiceQuestionPage(question: question),
      _ => throw UnimplementedError(),
    };
  }
}
