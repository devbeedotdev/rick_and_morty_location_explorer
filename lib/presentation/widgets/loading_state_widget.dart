import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../core/constants/app_theme.dart';

class LoadingStateWidget extends StatelessWidget {
  const LoadingStateWidget({super.key});
  @override
  Widget build(BuildContext context) => ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 8,
        itemBuilder: (_, __) => Shimmer.fromColors(
          baseColor: AppTheme.darkCard,
          highlightColor: AppTheme.darkSurface,
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            height: 88,
            decoration: BoxDecoration(color: AppTheme.darkCard, borderRadius: BorderRadius.circular(12)),
          ),
        ),
      );
}

class LoadingStateGridWidget extends StatelessWidget {
  const LoadingStateGridWidget({super.key});
  @override
  Widget build(BuildContext context) => GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(8),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, crossAxisSpacing: 8, mainAxisSpacing: 8),
        itemCount: 6,
        itemBuilder: (_, __) => Shimmer.fromColors(
          baseColor: AppTheme.darkCard,
          highlightColor: AppTheme.darkSurface,
          child: Container(
            decoration: BoxDecoration(color: AppTheme.darkCard, borderRadius: BorderRadius.circular(12)),
          ),
        ),
      );
}

class LoadingMoreIndicator extends StatelessWidget {
  const LoadingMoreIndicator({super.key});
  @override
  Widget build(BuildContext context) =>
      const Padding(padding: EdgeInsets.symmetric(vertical: 24),
          child: Center(child: CircularProgressIndicator()));
}
