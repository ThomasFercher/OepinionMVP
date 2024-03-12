import 'package:flutter/widgets.dart';
import 'package:oepinion/common/extensions.dart';
import 'package:oepinion/main.dart';

class PartnerFooter extends StatelessWidget {
  const PartnerFooter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 48),
          child: Image.asset(
            "$illustrationPath/fh.png",
            width: 424,
          ),
        ),
        42.vSpacing,
        Text(
          "In stolzer Kooperation mit der FH Kärnten unter der Leitung von Herrn Mag. Dr. Thomas Fenzl",
          style: context.typography.bodyLarge,
          textAlign: TextAlign.center,
        ),
        32.vSpacing,
        Image.asset(
          "$illustrationPath/fenzl.png",
          width: 128,
        ),
      ],
    );
  }
}
