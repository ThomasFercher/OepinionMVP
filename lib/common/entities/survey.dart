import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

typedef Json = Map<String, dynamic>;

class Survey {
  final String title;
  final String description;
  final String id;

  final List<Question> questions;

  int get length => questions.length;

  List<List<String>> getPath(String id) {
    final question = questions.firstWhere((element) => element.id == id);
    final index = questions.indexOf(question);

    if (question.end) {
      return [
        [id]
      ];
    }

    if (question is YesNoQuestion && question.skipToQuestion != null) {
      final next1 = question.skipToQuestion!(true) ?? questions[index + 1].id;
      final next2 = question.skipToQuestion!(false) ?? questions[index + 1].id;

      return [
        for (final path in getPath(next1)) [id, ...path],
        for (final path in getPath(next2)) [id, ...path]
      ];
    }

    final nextId = question.destination ?? questions[index + 1].id;

    final nextPath = getPath(nextId);

    return [
      for (final path in nextPath) [id, ...path]
    ];
  }

  double getProgress(Iterable<String> history) {
    if (history.isEmpty) {
      return 0;
    }
    final paths = getPath(questions.first.id);

    for (final path in paths) {
      final diff = path.length - history.length;
      if (diff < 0) continue;
      final subList = path.sublist(0, history.length);
      if (listEquals(subList, history.toList())) {
        return history.length / path.length;
      }
    }

    return 0;
  }

  int getPercentage(Iterable<String> history) {
    return (getProgress(history.toList()) * 100).toInt();
  }

  Survey({
    required this.title,
    required this.description,
    required this.questions,
  }) : id = const Uuid().v4();

  Survey.withId({
    required this.title,
    required this.description,
    required this.id,
    required this.questions,
  });

  Json toJson() {
    return {
      'name': title,
      'description': description,
      'id': id,
      'questions': questions.map((e) => e.toJson()).toList(),
    };
  }

  factory Survey.fromJSON(Json json) {
    try {
      return Survey.withId(
          title: json['title'] as String,
          description: json['description'] as String,
          id: json['id'] as String,
          questions: (json['questions'] as List).map((e) {
            return Question.fromJson(e as Json);
          }).toList());
    } catch (e, s) {
      rethrow;
    }
  }
}

sealed class Question {
  final String question;
  final String? destination;
  final bool end;
  final String id;

  const Question({
    required this.question,
    required this.end,
    this.destination,
    required this.id,
  });

  bool get handlesNav => false;

  Json toJson();

  factory Question.fromJson(Json json) {
    final type = json['type'] as String;
    return switch (type) {
      'yesno' => YesNoQuestion.fromJson(json),
      'multiplechoice' => MultipleChoiceQuestion.fromJson(json),
      'range' => RangeQuestion.fromJson(json),
      'text' => TextQuestion.fromJson(json),
      'radio' => RadioQuestion.fromJson(json),
      'dropdown' => DropDownQuestion.fromJson(json),
      'placeholder' => PlaceHolderQuestion.fromJson(json),
      _ => throw Exception('Unknown question type'),
    };
  }

  @override
  int get hashCode =>
      id.hashCode ^ question.hashCode ^ destination.hashCode ^ end.hashCode;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Question &&
        other.id == id &&
        other.question == question &&
        other.destination == destination &&
        other.end == end;
  }
}

final class YesNoQuestion extends Question {
  ///
  /// If null is returned, the survey will continue as normal.
  /// Else, the survey will skip to the question with the given index.
  ///
  final String? Function(bool answer)? skipToQuestion;

  const YesNoQuestion({
    required super.question,
    this.skipToQuestion,
    super.end = false,
    required super.id,
  });

  @override
  bool get handlesNav => true;

  @override
  Json toJson() {
    return {
      'type': 'yesno',
      'question': question,
    };
  }

  @override
  factory YesNoQuestion.fromJson(Json json) {
    return YesNoQuestion(
      question: json['question'] as String,
      id: json['id'] as String,
    );
  }
}

final class MultipleChoiceQuestion extends Question {
  final List<(String, String?)> choices;
  final bool allowMultiple;

  const MultipleChoiceQuestion({
    required super.question,
    required this.choices,
    required this.allowMultiple,
    super.destination,
    super.end = false,
    required super.id,
  });

  @override
  bool get handlesNav => false;

  @override
  Json toJson() {
    return {
      'type': 'multiplechoice',
      'question': question,
      'choices': choices
          .map((e) => jsonEncode({
                'choice': e.$1,
                'description': e.$2,
              }))
          .toList(),
      'allowMultiple': allowMultiple,
    };
  }

  @override
  factory MultipleChoiceQuestion.fromJson(Json json) {
    return MultipleChoiceQuestion(
      question: json['question'] as String,
      choices: (json['choices'] as List)
          .map((e) => jsonDecode(e as String))
          .map((e) => (e['choice'] as String, e['description'] as String?))
          .toList(),
      allowMultiple: json['allowMultiple'] as bool,
      id: json['id'] as String,
    );
  }
}

final class RangeQuestion extends Question {
  final Map<int, String> choices;

  int get min => choices.keys.reduce(
        (value, element) => value > element ? element : value,
      );

  int get middle => choices.length ~/ 2;

  int get max => choices.keys.reduce(
        (value, element) => value < element ? element : value,
      );

  const RangeQuestion({
    required super.question,
    required this.choices,
    super.end = false,
    required super.id,
  });

  @override
  Json toJson() {
    return {
      'type': 'range',
      'question': question,
      'choices': choices.toJSON(),
    };
  }

  @override
  factory RangeQuestion.fromJson(Json json) {
    return RangeQuestion(
      question: json['question'] as String,
      choices: (json['choices'] as Json).toRangeMap(),
      id: json['id'] as String,
    );
  }
}

extension on Map<int, String> {
  Map<String, String> toJSON() {
    return map((key, value) => MapEntry(key.toString(), value));
  }
}

extension on Map<String, dynamic> {
  Map<int, String> toRangeMap() {
    return map((key, value) => MapEntry(int.parse(key), value as String));
  }
}

final class TextQuestion extends Question {
  const TextQuestion({
    required super.question,
    super.destination,
    super.end = false,
    required super.id,
  });

  @override
  Json toJson() {
    return {
      'type': 'text',
      'question': question,
    };
  }

  @override
  factory TextQuestion.fromJson(Json json) {
    return TextQuestion(
      question: json['question'] as String,
      id: json['id'] as String,
    );
  }
}

final class RadioQuestion extends Question {
  final List<String> choices;

  const RadioQuestion({
    required super.question,
    required this.choices,
    super.destination,
    super.end = false,
    required super.id,
  });

  @override
  Json toJson() {
    return {
      'type': 'radio',
      'question': question,
      'choices': choices,
    };
  }

  @override
  bool get handlesNav => true;

  @override
  factory RadioQuestion.fromJson(Json json) {
    return RadioQuestion(
      question: json['question'] as String,
      choices: (json['choices'] as List).cast<String>(),
      id: json['id'] as String,
    );
  }
}

final class DropDownQuestion extends Question {
  final List<String> choices;

  const DropDownQuestion({
    required super.question,
    required this.choices,
    super.destination,
    super.end = false,
    required super.id,
  });

  @override
  Json toJson() {
    return {
      'type': 'dropdown',
      'question': question,
      'choices': choices,
    };
  }

  @override
  factory DropDownQuestion.fromJson(Json json) {
    return DropDownQuestion(
      question: json['question'] as String,
      choices: (json['choices'] as List).cast<String>(),
      id: json['id'] as String,
    );
  }
}

final class PlaceHolderQuestion extends Question {
  const PlaceHolderQuestion(String id, bool end)
      : super(question: '', end: end, id: id, destination: null);

  @override
  Json toJson() {
    return {
      'type': 'placeholder',
    };
  }

  @override
  factory PlaceHolderQuestion.fromJson(Json json) {
    return PlaceHolderQuestion(json['id'] as String, json['end'] as bool);
  }
}

final class CaptchaQuestion extends Question {
  const CaptchaQuestion({
    required super.id,
  }) : super(question: 'Bist du ein Roboter?', end: false, destination: null);

  @override
  Json toJson() {
    return {
      'type': 'captcha',
    };
  }

  @override
  bool get handlesNav => true;

  @override
  factory CaptchaQuestion.fromJson(Json json) {
    return CaptchaQuestion(
      id: json['id'] as String,
    );
  }
}
