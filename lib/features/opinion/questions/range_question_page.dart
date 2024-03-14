import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oepinion/common/colors.dart';

import 'package:oepinion/common/entities/survey.dart';
import 'package:oepinion/common/entities/survey_with_answer.dart';
import 'package:oepinion/common/extensions.dart';
import 'package:oepinion/features/opinion/validation.dart';

class RangeQuestionPage extends StatefulWidget {
  final RangeQuestion question;

  const RangeQuestionPage({
    super.key,
    required this.question,
  });

  @override
  State<RangeQuestionPage> createState() => _RangeQuestionPageState();
}

class _RangeQuestionPageState extends State<RangeQuestionPage> {
  late final ValueNotifier<double> valueNotifier;
  late SurveyValidationNotifier validatorNotifier;
  late SurveyValidator validator;

  @override
  void initState() {
    valueNotifier = ValueNotifier(widget.question.middle.toDouble());
    super.initState();
  }

  @override
  void dispose() {
    valueNotifier.dispose();
    validatorNotifier.removeListener(validate);
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    validatorNotifier = SurveyInfo.of(context).validationNotifier
      ..addListener(validate);
    validator = SurveyInfo.of(context).validator;
    super.didChangeDependencies();
  }

  void validate() {
    if (validatorNotifier.current != widget.question) return;
    validator.answer(
      widget.question,
      RangeAnswer(
        answer: valueNotifier.value.toInt(),
      ),
    );
    validator.validateField(widget.question, true);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.max,
      children: [
        Text(
          widget.question.question,
          style: context.typography.headlineSmall,
        ),
        48.vSpacing,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (final option in widget.question.choices.keys)
                Text(
                  option.toString(),
                  style: context.typography.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),
        ),
        16.vSpacing,
        ValueListenableBuilder(
          valueListenable: valueNotifier,
          builder: (context, val, snapshot) {
            return SliderTheme(
              data: SliderThemeData(
                trackHeight: 4,
                activeTrackColor: kGray1,
                inactiveTrackColor: kGray2,
                tickMarkShape: SliderTickMarkShape.noTickMark,
                thumbShape: const CustomSliderThumbShape(),
                overlayShape: const CustomSliderOverlayShape(),
                trackShape: const CustomSliderTrackShape(),
              ),
              child: Slider(
                thumbColor: kGreen,
                value: val,
                divisions: widget.question.max - widget.question.min,
                min: widget.question.min.toDouble(),
                max: widget.question.max.toDouble(),
                onChanged: (value) {
                  valueNotifier.value = value;
                },
              ),
            );
          },
        ),
        const Spacer(),
        Column(
          children: [
            for (final MapEntry(key: int i, value: String text)
                in widget.question.choices.entries)
              Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "$i = ",
                      style: context.typography.bodySmall?.copyWith(
                        color: kGray,
                      ),
                    ),
                    Text(
                      text,
                      style: context.typography.bodySmall?.copyWith(
                        color: kGray,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        )
      ],
    );
  }
}

class CustomSliderTrackShape extends SliderTrackShape {
  const CustomSliderTrackShape();
  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final trackHeight = sliderTheme.trackHeight;
    final trackLeft = offset.dx;
    final trackTop = offset.dy + (parentBox.size.height - trackHeight!) / 2;
    final trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }

  @override
  void paint(
    PaintingContext context,
    Offset offset, {
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required Animation<double> enableAnimation,
    required Offset thumbCenter,
    Offset? secondaryOffset,
    bool isEnabled = false,
    bool isDiscrete = false,
    required TextDirection textDirection,
  }) {
    if (sliderTheme.trackHeight == 0) {
      return;
    }

    final trackRect = getPreferredRect(
      parentBox: parentBox,
      offset: offset,
      sliderTheme: sliderTheme,
      isEnabled: isEnabled,
      isDiscrete: isDiscrete,
    );

    final trackPaint = Paint()
      ..color = kGray1
      ..style = PaintingStyle.fill;

    context.canvas.drawRRect(
      RRect.fromRectAndRadius(trackRect, const Radius.circular(8)),
      trackPaint,
    );
  }
}

class CustomSliderThumbShape extends RoundSliderThumbShape {
  const CustomSliderThumbShape({super.enabledThumbRadius = 16.0});

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    super.paint(context,
        center.translate(-(value - 0.5) / 0.5 * enabledThumbRadius, 0.0),
        activationAnimation: activationAnimation,
        enableAnimation: enableAnimation,
        isDiscrete: isDiscrete,
        labelPainter: labelPainter,
        parentBox: parentBox,
        sliderTheme: sliderTheme,
        textDirection: textDirection,
        value: value,
        textScaleFactor: textScaleFactor,
        sizeWithOverflow: sizeWithOverflow);
  }
}

class CustomSliderOverlayShape extends RoundSliderOverlayShape {
  final double thumbRadius;
  const CustomSliderOverlayShape({this.thumbRadius = 10.0});

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    super.paint(
      context,
      center.translate(-(value - 0.5) / 0.5 * thumbRadius, 0.0),
      activationAnimation:
          Tween(begin: 0.0, end: 0.0).animate(activationAnimation),
      enableAnimation: Tween(begin: 0.0, end: 0.0).animate(enableAnimation),
      isDiscrete: isDiscrete,
      labelPainter: labelPainter,
      parentBox: parentBox,
      sliderTheme: sliderTheme,
      textDirection: textDirection,
      value: value,
      textScaleFactor: textScaleFactor,
      sizeWithOverflow: sizeWithOverflow,
    );
  }
}
