import 'package:flutter/widgets.dart';
import 'package:oepinion/common/entities/survey.dart';
import 'package:oepinion/common/entities/survey_with_answer.dart';

class SurveyInfo extends InheritedWidget {
  final SurveyValidator validator;
  final SurveyValidationNotifier validationNotifier;

  const SurveyInfo({
    required super.child,
    required this.validator,
    required this.validationNotifier,
    super.key,
  });

  static SurveyInfo of(BuildContext context) {
    final resutl = context.dependOnInheritedWidgetOfExactType<SurveyInfo>();
    assert(resutl != null, "No SurveyInfo found in context");
    return resutl!;
  }

  @override
  bool updateShouldNotify(SurveyInfo oldWidget) {
    return false;
  }
}

class SurveyValidator extends ChangeNotifier {
  final Map<Question, Answer> _answers = {};
  final Map<Question, bool> _validQuestions = {};

  Map<Question, Answer> get answers => _answers;

  void validateField(
    Question question,
    bool valid,
  ) {
    _validQuestions[question] = valid;
    notifyListeners();
  }

  bool answerIsValid(Question question) {
    return _validQuestions[question]!;
  }

  Answer getAnswer(Question question) {
    return _answers[question]!;
  }

  void answer(Question question, Answer answer) {
    _answers[question] = answer;
  }
}

class SurveyValidationNotifier extends ChangeNotifier {
  Question? current;

  void validate(Question question) {
    current = question;
    notifyListeners();
  }
}
