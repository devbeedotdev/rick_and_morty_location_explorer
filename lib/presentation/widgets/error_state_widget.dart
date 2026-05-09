import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../core/constants/app_theme.dart';

class ErrorStateWidget extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;
  final bool compact;

  const ErrorStateWidget({super.key, required this.message, this.onRetry, this.compact = false});

  @override
  Widget build(BuildContext context) {
    if (compact) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text(message, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppTheme.errorRed)),
          if (onRetry != null) TextButton(onPressed: onRetry, child: const Text(AppStrings.retry)),
        ]),
      );
    }
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Icon(Icons.wifi_off_rounded, size: 64, color: AppTheme.textSecondary),
          const SizedBox(height: 16),
          Text(message,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppTheme.textSecondary),
              textAlign: TextAlign.center),
          if (onRetry != null) ...[
            const SizedBox(height: 24),
            FilledButton.icon(onPressed: onRetry, icon: const Icon(Icons.refresh_rounded),
                label: const Text(AppStrings.retry)),
          ],
        ]),
      ),
    );
  }
}
