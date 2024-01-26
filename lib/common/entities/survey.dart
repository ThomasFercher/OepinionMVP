typedef Json = Map<String, dynamic>;

class Survey {
  final String name;
  final String description;
  final List<Question> questions;

  int get length => questions.length;

  double getProgress(int index) {
    return (index + 1) / length;
  }

  int getPercentage(int index) {
    return ((index + 1) / length * 100).round();
  }

  const Survey({
    required this.name,
    required this.description,
    required this.questions,
  });
}

sealed class Question {
  final String question;

  const Question({
    required this.question,
  });

  bool get handlesNav => false;

  Json toJson();

  Question fromJson(Json json);
}

final class YesNoQuestion extends Question {
  const YesNoQuestion({
    required super.question,
  });

  @override
  bool get handlesNav => true;

  @override
  Json toJson() {
    return {
      'question': question,
    };
  }

  @override
  Question fromJson(Json json) {
    return YesNoQuestion(
      question: json['question'] as String,
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
  });

  @override
  bool get handlesNav => allowMultiple == false;

  @override
  Json toJson() {
    return {
      'question': question,
      'choices': choices,
      'allowMultiple': allowMultiple,
    };
  }

  @override
  Question fromJson(Json json) {
    return MultipleChoiceQuestion(
      question: json['question'] as String,
      choices: (json['choices'] as List).cast<String>(),
      allowMultiple: json['allowMultiple'] as bool,
    );
  }
}

final class RangeQuestion extends Question {
  final Map<int, String> choices;

  int get min => choices.keys.reduce(
        (value, element) => value > element ? element : value,
      );

  int get middle => choices.keys.toList()[((choices.length + 1) / 2).round()];

  int get max => choices.keys.reduce(
        (value, element) => value < element ? element : value,
      );

  const RangeQuestion({
    required super.question,
    required this.choices,
  });

  @override
  Json toJson() {
    return {
      'question': question,
      'choices': choices,
    };
  }

  @override
  Question fromJson(Json json) {
    return RangeQuestion(
      question: json['question'] as String,
      choices: (json['choices'] as Map).cast<int, String>(),
    );
  }
}

final class TextQuestion extends Question {
  const TextQuestion({
    required super.question,
  });

  @override
  Json toJson() {
    return {
      'question': question,
    };
  }

  @override
  Question fromJson(Json json) {
    return TextQuestion(
      question: json['question'] as String,
    );
  }
}

final class RadioQuestion extends Question {
  final List<String> choices;

  const RadioQuestion({
    required super.question,
    required this.choices,
  });

  @override
  Json toJson() {
    return {
      'question': question,
      'choices': choices,
    };
  }

  @override
  Question fromJson(Json json) {
    return RadioQuestion(
      question: json['question'] as String,
      choices: (json['choices'] as List).cast<String>(),
    );
  }
}
