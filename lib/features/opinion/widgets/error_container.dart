import 'package:flutter/material.dart';
import 'package:oepinion/common/extensions.dart';

class ErrorContainer extends StatelessWidget {
  final String message;

  const ErrorContainer({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.colors.errorContainer,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: context.colors.error,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline,
            color: context.colors.error,
          ),
          8.hSpacing,
          Text(
            message,
            style: context.typography.bodyMedium?.copyWith(
              color: context.colors.error,
            ),
          ),
        ],
      ),
    );
  }
}
