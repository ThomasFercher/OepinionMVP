import 'dart:html';
import 'dart:ui_web' as ui;
import 'package:flutter/material.dart';
import 'package:oepinion/main.dart';

class IFramePage extends StatefulWidget {
  final void Function(bool value) onCaptchaResult;

  const IFramePage({Key? key, required this.onCaptchaResult}) : super(key: key);

  @override
  State<IFramePage> createState() => _IFramePageState();
}

class _IFramePageState extends State<IFramePage> {
  final IFrameElement _iFrameElement = IFrameElement();

  @override
  void initState() {
    _iFrameElement.src = 'https://oepinion.at/captcha.html';
    _iFrameElement.style.border = 'none';
    _iFrameElement.style.height = '100%';
    _iFrameElement.style.width = '100%';
    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(
      'iframeElement',
      (int viewId) => _iFrameElement,
    );

    // Get message from iframe
    window.addEventListener("message", onEvent);
    super.initState();
  }

  void onEvent(Event event) async {
    var data = (event as MessageEvent).data;

    if (data is String) {
      final result = await verifyCaptcha(data);
      widget.onCaptchaResult(result);
    }
  }

  @override
  void dispose() {
    window.removeEventListener("message", onEvent);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return HtmlElementView(
      key: UniqueKey(),
      viewType: 'iframeElement',
    );
  }
}

Future<bool> verifyCaptcha(String captcha) async {
  print("Calling captcha function");
  try {
    final result = await supabase.functions.invoke(
      'captcha',
      body: {'token': captcha},
    );

    final success = result.data['success'];
    if (success is! bool) throw Exception('Invalid response');
    return success;
  } catch (e) {
    return false;
  }
}
