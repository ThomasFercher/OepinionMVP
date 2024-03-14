import 'package:flutter/widgets.dart';

class CaptchaScreen extends StatelessWidget {
  const CaptchaScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SizedBox(
        width: 480,
        height: 640,
        child: HtmlElementView(
          viewType: 'captchaView',
        ),
      ),
    );
  }
}
