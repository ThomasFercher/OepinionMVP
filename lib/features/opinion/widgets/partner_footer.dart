import 'package:flutter/widgets.dart';
import 'package:web_mvp/common/extensions.dart';

class PartnerFooter extends StatelessWidget {
  const PartnerFooter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset("images/logo_2.png"),
        32.vSpacing,
        Text(
          "In stolzer Kooperation mit der FH Kärnten unter der Leitung von Herrn Mag. Dr. Thomas Fenzl",
          style: context.typography.bodyLarge,
          textAlign: TextAlign.center,
        ),
        32.vSpacing,
        Image.asset("images/prof.png"),
      ],
    );
  }
}
