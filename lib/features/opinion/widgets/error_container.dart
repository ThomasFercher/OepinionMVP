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
        color: context.colors.errorContainer.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline,
            color: context.colors.error,
          ),
          8.hSpacing,
          Expanded(
            child: Text(
              message,
              style: context.typography.bodySmall?.copyWith(
                color: context.colors.error,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
