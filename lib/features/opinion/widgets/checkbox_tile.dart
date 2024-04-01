import 'package:flutter/material.dart';
import 'package:oepinion/common/colors.dart';
import 'package:oepinion/common/extensions.dart';

class CheckBoxTile extends StatelessWidget {
  final String title;
  final String? subTitle;
  final ValueNotifier<bool?> valueNotifier;

  const CheckBoxTile({
    super.key,
    required this.title,
    this.subTitle,
    required this.valueNotifier,
  });

  void onSelected(bool? value) async {
    if (value == null) return;

    valueNotifier.value = value;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: valueNotifier,
        builder: (context, _, snapshot) {
          final isSelected = valueNotifier.value ?? false;
          return SizedBox(
            height: 56,
            child: Material(
              color: isSelected ? kGreen : kGray3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
                side: BorderSide(
                  color: isSelected ? kGreen : kGray2,
                  width: 1,
                ),
              ),
              child: InkWell(
                onTap: () => onSelected(!isSelected),
                borderRadius: BorderRadius.circular(4),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              title,
                              style: context.typography.bodyMedium?.copyWith(
                                color: isSelected
                                    ? Colors.white
                                    : subTitle == null
                                        ? kGray
                                        : Colors.black,
                              ),
                            ),
                            if (subTitle != null) ...[
                              4.vSpacing,
                              Text(
                                "($subTitle)",
                                style: context.typography.bodySmall?.copyWith(
                                  color: isSelected ? Colors.white : kGray,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      Checkbox(
                        value: isSelected,
                        onChanged: onSelected,
                        checkColor: Colors.black54,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        visualDensity: VisualDensity.comfortable,
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
