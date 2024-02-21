import 'package:web_mvp/common/entities/survey.dart';

sealed class Answer {
  const Answer();

  Json toJson();

  Answer fromJson(Json json);
}

final class TextAnswer extends Answer {
  final String answer;

  const TextAnswer({
    required this.answer,
  });

  @override
  Json toJson() {
    return {
      'answer': answer,
    };
  }

  @override
  Answer fromJson(Json json) {
    return TextAnswer(
      answer: json['answer'] as String,
    );
  }
}

final class MultipleChoiceAnswer extends Answer {
  final List<String> choices;

  const MultipleChoiceAnswer({
    required this.choices,
  });

  @override
  Json toJson() {
    return {
      'choices': choices,
    };
  }

  @override
  Answer fromJson(Json json) {
    return MultipleChoiceAnswer(
      choices: json['choices'] as List<String>,
    );
  }
}

final class RangeAnswer extends Answer {
  final int answer;

  const RangeAnswer({
    required this.answer,
  });

  @override
  Json toJson() {
    return {
      'answer': answer,
    };
  }

  @override
  Answer fromJson(Json json) {
    return RangeAnswer(
      answer: json['answer'] as int,
    );
  }
}
