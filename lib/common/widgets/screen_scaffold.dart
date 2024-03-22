import 'package:flutter/material.dart';
import 'package:oepinion/common/colors.dart';

class ScreenScaffold extends StatelessWidget {
  final Widget child;
  final double maxWidth;
  final bool scrollable;
  final EdgeInsetsGeometry padding;

  const ScreenScaffold({
    Key? key,
    required this.child,
    this.maxWidth = 600,
    this.scrollable = false,
    this.padding = const EdgeInsets.all(16),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _child = Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Padding(
          padding: padding,
          child: child,
        ),
      ),
    );
    final scrollController = ScrollController();
    return Scaffold(
      body: scrollable
          ? ScrollbarTheme(
              data: ScrollbarThemeData(
                thumbColor: MaterialStateProperty.all(kGray),
                trackVisibility: const MaterialStatePropertyAll(true),
                trackColor: const MaterialStatePropertyAll(Colors.transparent),
                thumbVisibility: const MaterialStatePropertyAll(true),
                thickness: const MaterialStatePropertyAll(8),
                trackBorderColor:
                    const MaterialStatePropertyAll(Colors.transparent),
              ),
              child: Scrollbar(
                controller: scrollController,
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: _child,
                ),
              ),
            )
          : _child,
    );
  }
}
