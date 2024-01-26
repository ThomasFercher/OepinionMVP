import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:web_mvp/common/entities/survey.dart';
import 'package:web_mvp/common/extensions.dart';

class MultipleChoiceQuestionPage extends StatelessWidget {
  final MultipleChoiceQuestion question;

  const MultipleChoiceQuestionPage({super.key, required this.question});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          question.question,
          style: context.typography.headlineSmall,
        ),
        48.vSpacing,
        Column(
          children: [
            for (final option in question.choices)
              Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: CheckBoxTile(
                  title: option,
                  valueNotifier: ValueNotifier(false),
                ),
              )
          ],
        ),
      ],
    );
  }
}

class CheckBoxTile extends StatelessWidget {
  final String title;
  final ValueNotifier<bool> valueNotifier;

  const CheckBoxTile({
    super.key,
    required this.title,
    required this.valueNotifier,
  });

  void onSelected(bool? value) {
    if (value == null) return;
    valueNotifier.value = value;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: valueNotifier,
        builder: (context, isSelected, snapshot) {
          return SizedBox(
            height: 48,
            child: Material(
              color: isSelected
                  ? const Color(0xFF34C759)
                  : const Color(0xFFF2F2F7),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
                side: const BorderSide(
                  color: Color(0xFFE5E5EA),
                  width: 1,
                ),
              ),
              child: InkWell(
                onTap: () => onSelected(!valueNotifier.value),
                borderRadius: BorderRadius.circular(4),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(title),
                      Checkbox(
                        value: isSelected,
                        onChanged: onSelected,
                        checkColor: const Color(0xFF8E8E93),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        side: BorderSide.none,
                        fillColor: MaterialStateProperty.resolveWith((states) {
                          if (states.contains(MaterialState.selected)) {
                            return Colors.white;
                          }
                          return const Color(0xFFD9D9D9);
                        }),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}
