// final testSurvey = Survey(
//   name: "Oepinion",
//   description: "lorem",
//   questions: [
//     const MultipleChoiceQuestion(
//       question: "In welchen Studienabschnitt befindest du dich?",
//       allowMultiple: false,
//       choices: [
//         "Bachelor",
//         "Master",
//         "Doktor",
//       ],
//     ),
//     const YesNoQuestion(
//         question: "Arbeitest du aktuell an deiner Abschlussarbeit?"),
//     const MultipleChoiceQuestion(
//       question:
//           "Gibt es Aspekte bei deiner Abschlussarbeit, bei denen du dir zusätzliche Unterstützung wünschen würdest?",
//       allowMultiple: true,
//       choices: [
//         "Themenausarbeitung",
//         "Hyposethenbildung",
//         "Forschungsstrategie",
//         "Datenerhebung (z.B. Umfragen)",
//         "Datenanalyse",
//         "Schreibprozess",
//       ],
//     ),
//     const YesNoQuestion(
//       question:
//           "Hast du bereits Erfahrungen mit der Erstellung von Umfragen für deine Abschlussarbeit gemacht?",
//     ),
//     const RangeQuestion(
//       question:
//           "Wie würdest du den Aufwand der Erstellung deiner Umfrage bewerten",
//       choices: {
//         1: "Sehr gering",
//         2: "Gering",
//         3: "Mittelmäßig",
//         4: "Groß",
//         5: "Sehr groß",
//       },
//     ),
//     const RangeQuestion(
//       question:
//           "Wie würdest du die Schwierigkeit bei der Auswertung deiner Umfrage bewerten?",
//       choices: {
//         1: "Sehr gering",
//         2: "Gering",
//         3: "Mittelmäßig",
//         4: "Groß",
//         5: "Sehr groß",
//       },
//     ),
//     const TextQuestion(
//       question:
//           "Welche spezifischen Herausforderungen sind dir bei der Erstellung und Auswertung deiner Umfrage begegnet? ",
//     ),
//     const YesNoQuestion(
//       question:
//           "Wenn du noch keine Erfahrung mit Meinungsumfragen und deren Auswertung gemacht hast, siehst du das als potenzielles Problem für deine zukünftige Abschlussarbeit?",
//     ),
//     const RangeQuestion(
//       question:
//           "Wie wichtig wäre es für dich, Zugang zu einer Plattform zu bekommen, die dich durch den Prozess deiner Abschlussarbeit führt?",
//       choices: {
//         1: "Sehr gering",
//         2: "Gering",
//         3: "Mittelmäßig",
//         4: "Groß",
//         5: "Sehr groß",
//       },
//     ),
//     const TextQuestion(
//       question: "Welche Funktionen sollte dieses ideale Tool für dich haben?",
//     ),
//     const RadioQuestion(
//       question:
//           "Würdes DU für das Tool bezahlen, oder sollte das dein Institut übernehmen?",
//       choices: ["Ich", "Institut"],
//     ),
//   ],
// );