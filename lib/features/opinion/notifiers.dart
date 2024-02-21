import 'package:flutter/widgets.dart';
import 'package:web_mvp/common/entities/survey.dart';
import 'package:web_mvp/main.dart';

class OpinionNotifier extends ChangeNotifier {
  Survey? survey;

  void loadSurvey(String id) async {
    final query = supabase.from('surveys').select().eq('id', id).limit(1);

    final result = await query;

    if (result.isEmpty) return;

    survey = Survey.fromJSON(result.first);

    notifyListeners();
  }
}
