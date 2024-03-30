import 'package:flutter/widgets.dart';
import 'package:oepinion/common/entities/survey.dart';
import 'package:oepinion/main.dart';

class OpinionNotifier extends ChangeNotifier {
  Survey? survey;

  void loadSurvey(String id) async {
    survey = testSurvey;
    notifyListeners();
    return;

    final query = supabase.from('surveys').select().eq('id', id).limit(1);

    final result = await query;

    if (result.isEmpty) return;

    survey = Survey.fromJSON(result.first);

    notifyListeners();
  }
}

final testSurvey = Survey.withId(
  id: "2096122e-162e-4880-9ef6-7aeb56faf2ab",
  title: "Öpinion Market Research",
  description: "Öpinion Market Research",
  questions: [
    const CaptchaQuestion(
      id: "A",
    ),
    YesNoQuestion(
      question:
          "Bist du aktuell als Student/in an einer österreichischen Hochschule eingeschrieben?",
      id: "a",
      skipToQuestion: (answer) => switch (answer) {
        false => "a4",
        _ => null,
      },
    ),
    const MultipleChoiceQuestion(
      id: "b",
      question: "In welchem Studienabschnitt befindest du dich?",
      choices: [
        "Bachelor",
        "Master",
        "Doktor",
      ],
      allowMultiple: false,
    ),
    YesNoQuestion(
      id: "c",
      question:
          "Hast du bereits eigene Fragebogenstudien für Studienzwecke erstellt?",
      skipToQuestion: (answer) => switch (answer) {
        false => "a2",
        _ => null,
      },
    ),
    const RangeQuestion(
      id: "d",
      question: "Wie schwierig war es für dich, den Fragebogen zu erstellen?",
      choices: {
        1: "Sehr leicht",
        2: "Leicht",
        3: "Mittelmäßig",
        4: "Schwer",
        5: "Sehr schwer",
        6: "Außergewöhnlich schwer",
      },
    ),
    const RangeQuestion(
      id: "e",
      question:
          "Wie schwierig war es für dich, die Ergebnisse aussagekräftig auszuwerten?",
      choices: {
        1: "Sehr leicht",
        2: "Leicht",
        3: "Mittelmäßig",
        4: "Schwer",
        5: "Sehr schwer",
        6: "Außergewöhnlich schwer",
      },
    ),
    const TextQuestion(
      id: "f",
      question:
          "Welche spezifischen Herausforderungen sind dir bei der Durchführung deiner Fragebogenstudie begegnet?",
    ),
    YesNoQuestion(
      id: "g",
      question: "Arbeitest du aktuell an deiner Abschlussarbeit?",
      skipToQuestion: (answer) => switch (answer) {
        false => "a3",
        _ => null,
      },
    ),
    const MultipleChoiceQuestion(
      id: "h",
      question:
          "Wo würdest du dir durch ein KI-gestütztes Tool bei deiner Abschlussarbeit Unterstützung wünschen?",
      choices: [
        "Themenausarbeitung",
        "Hypothesenbildung",
        "Forschungsstrategie",
        "Fragebogenerstellung",
        "Datenerhebung",
        "Datenanalyse und Auswertung",
        "Schreibprozess",
      ],
      allowMultiple: true,
    ),
    const RangeQuestion(
      id: "i",
      question:
          "Wie wichtig wäre es für dich, Zugang zu einer Plattform zu bekommen, die dich beim gesamten Prozess deiner Abschlussarbeit unterstützt?",
      choices: {
        1: "Ganz und gar nicht wichtig",
        2: "Nicht sehr wichtig",
        3: "Etwas wichtig",
        4: "Wichtig",
        5: "Sehr wichtig",
        6: "Äußerst wichtig",
      },
    ),
    const TextQuestion(
      id: "j",
      question:
          "Welche konkreten Funktionen sollte dieses Tool bieten, um dich optimal zu unterstützen?",
    ),
    const YesNoQuestion(
      id: "k",
      question:
          "Würdest du an einem persönlichen Gespräch teilnehmen, um deine Erfahrungen und Sichtweisen noch tiefer zu teilen und zu erläutern? ☕️",
    ),
    const DropDownQuestion(
      id: "l",
      question:
          "Bitte wähle noch deinen Studienbereich aus der folgenden Liste:",
      choices: [
        "Sprachen, Geistes- und Kulturwissenschaften (z.B.: Bildungs- und Sozialwissenschaften, Germanistik, Romanistik)",
        "Informatik, IT & Ingenieurwissenschaften (z.B.: Data Science, Architektur, Bauwesen oder Informatik)",
        "Design, Kunst & Medien",
        "Lehramtsstudien",
        "Medizin",
        "Psychologie",
        "Gesundheit & Sport (z.B. Physiotherapie, Ernährungswissenschaften)",
        "Naturwissenschaften (z.B. Chemie, Physik)",
        "Rechtswissenschaften (z.B. Jus, Wirtschaftsrecht)",
        "Sozial- und Wirtschaftswissenschaften (z.B. Betriebswirtschaft, Volkswirtschaftslehre)",
        "Theologische Studien",
        "Umwelt- und Agrarwissenschaften (z.B. Agrartechnologie)",
      ],
      end: true,
    ),

    ///
    /// First No PATH
    ///
    const RangeQuestion(
      id: "a2",
      question:
          "Wenn du eine Fragebogenstudie durchführen müsstest, wie schwierig schätzt du den Prozess ein?",
      choices: {
        1: "Sehr gering",
        2: "Gering",
        3: "Mittelmäßig",
        4: "Hoch",
        5: "Sehr groß",
        6: "Außergewöhnlich groß",
      },
    ),
    const MultipleChoiceQuestion(
      id: "b2",
      question:
          "Mal angenommen, du müsstet nun deine Abschlussarbeit schreiben, in welchen Bereichen siehst du die größten Herausforderungen?",
      choices: [
        "Themenausarbeitung",
        "Hypothesenbildung",
        "Forschungsstrategie",
        "Fragebogenerstellung",
        "Datenerhebung",
        "Datenanalyse und Auswertung",
        "Schreibprozess",
      ],
      allowMultiple: true,
      end: true,
    ),

    ///
    /// Second No PATH
    ///
    const MultipleChoiceQuestion(
      id: "a3",
      question:
          "In welchen der folgenden Bereiche hättest du dir mehr Unterstützung bei der Planung und Durchführung von Fragebogenstudien gewünscht?",
      choices: [
        "Fragebogendesign und -entwicklung",
        "Teilnehmerakquise",
        "Datenerhebung und -management",
        "Datenanalyse und Interpretation",
      ],
      allowMultiple: true,
    ),
    const TextQuestion(
      id: "b3",
      question:
          "Welche Unterstützung oder Ressourcen hätten dir bei deinen früheren Fragebogenstudien geholfen und warum?",
      destination: "i",
    ),

    ///
    /// Third No PATH
    ///
    const PlaceHolderQuestion("a4", true),
  ],
);
