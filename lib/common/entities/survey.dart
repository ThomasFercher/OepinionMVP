import 'package:uuid/uuid.dart';

typedef Json = Map<String, dynamic>;

class Survey {
  final String title;
  final String description;
  final String id;

  final List<Question> questions;

  int get length => questions.length;

  double getProgress(int index) {
    return (index) / length;
  }

  int getPercentage(int index) {
    return ((index) / length * 100).round();
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
      _ => throw Exception('Unknown question type'),
    };
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
  final List<String> choices;
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
  bool get handlesNav => allowMultiple == false;

  @override
  Json toJson() {
    return {
      'type': 'multiplechoice',
      'question': question,
      'choices': choices,
      'allowMultiple': allowMultiple,
    };
  }

  @override
  factory MultipleChoiceQuestion.fromJson(Json json) {
    return MultipleChoiceQuestion(
      question: json['question'] as String,
      choices: (json['choices'] as List).cast<String>(),
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
