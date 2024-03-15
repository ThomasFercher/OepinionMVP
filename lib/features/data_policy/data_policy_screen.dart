import 'package:flutter/widgets.dart';
import 'package:oepinion/common/extensions.dart';
import 'package:oepinion/common/widgets/footer.dart';
import 'package:oepinion/common/widgets/screen_scaffold.dart';
import 'package:oepinion/features/opinion/screens/welcome_screen.dart';

class DataPolicyScreen extends StatelessWidget {
  const DataPolicyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
      child: Column(
        children: [
          16.vSpacing,
          Text(
            "Datenschutzerklärung",
            style: context.typography.headlineMedium,
          ),
          16.vSpacing,
          Text(
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.",
            style: context.typography.bodyMedium,
            textAlign: TextAlign.center,
          ),
          64.vSpacing,
          const SupportLink(),
          32.vSpacing,
          const Footer(),
        ],
      ),
    );
  }
}
