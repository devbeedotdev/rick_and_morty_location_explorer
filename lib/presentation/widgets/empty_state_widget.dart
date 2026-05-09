import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../core/constants/app_theme.dart';

class EmptyStateWidget extends StatelessWidget {
  final VoidCallback? onRetry;
  const EmptyStateWidget({super.key, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Text('🛸', style: TextStyle(fontSize: 64)),
          const SizedBox(height: 16),
          Text(AppStrings.noResults,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppTheme.textPrimary)),
          const SizedBox(height: 8),
          Text(AppStrings.noResultsSubtitle,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppTheme.textSecondary),
              textAlign: TextAlign.center),
          if (onRetry != null) ...[
            const SizedBox(height: 24),
            OutlinedButton.icon(onPressed: onRetry, icon: const Icon(Icons.refresh_rounded),
                label: const Text(AppStrings.retry)),
          ],
        ]),
      ),
    );
  }
}
