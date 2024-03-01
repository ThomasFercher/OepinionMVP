import 'package:flutter/material.dart';
import 'package:oepinion/common/extensions.dart';

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
                side: BorderSide(
                  color: isSelected ? Color(0xFF34C759) : Color(0xFFD9D9D9),
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
                      Text(
                        title,
                        style: context.typography.bodyMedium?.copyWith(
                          color: isSelected ? Colors.white : null,
                        ),
                      ),
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
