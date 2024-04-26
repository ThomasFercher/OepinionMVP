import 'dart:convert';

import 'package:oepinion/common/entities/survey.dart';

sealed class Answer {
  const Answer();

  Json toJson(Question question);

  Answer fromJson(Json json);
}

final class TextAnswer extends Answer {
  final String answer;

  const TextAnswer({
    required this.answer,
  });

  @override
  Json toJson(Question question) {
    return {
      'answer': answer,
      'id': question.id,
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
  final List<(String, String?)> choices;

  const MultipleChoiceAnswer({
    required this.choices,
  });

  @override
  Json toJson(Question question) {
    return {
      'choices': choices
          .map((e) => {
                'choice': e.$1,
                'description': e.$2,
              })
          .toList(),
      'id': question.id,
    };
  }

  @override
  Answer fromJson(Json json) {
    return MultipleChoiceAnswer(
      choices: (json['choices'] as List)
          .map((e) => jsonDecode(e) as Map<String, dynamic>)
          .map((e) => (e['choice'] as String, e['description'] as String?))
          .toList(),
    );
  }
}

final class RangeAnswer extends Answer {
  final int answer;

  const RangeAnswer({
    required this.answer,
  });

  @override
  Json toJson(Question question) {
    return {
      'answer': answer,
      'id': question.id,
    };
  }

  @override
  Answer fromJson(Json json) {
    return RangeAnswer(
      answer: json['answer'] as int,
    );
  }
}
