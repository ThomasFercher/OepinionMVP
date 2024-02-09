import 'package:flutter/material.dart';

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
    return Scaffold(
      body: scrollable
          ? SingleChildScrollView(
              child: _child,
            )
          : _child,
    );
  }
}
