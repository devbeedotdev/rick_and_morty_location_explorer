import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../core/constants/app_theme.dart';
import '../../domain/entities/location.dart';

class LocationCard extends StatelessWidget {
  final Location location;
  final VoidCallback onTap;

  const LocationCard({super.key, required this.location, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: AppTheme.darkCard,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(children: [
            _LocationIcon(type: location.type),
            const SizedBox(width: 14),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(location.name, style: Theme.of(context).textTheme.titleMedium,
                    maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                _InfoRow(icon: Icons.category_outlined,
                    label: location.type.isEmpty ? AppStrings.unknown : location.type),
                const SizedBox(height: 2),
                _InfoRow(icon: Icons.explore_outlined,
                    label: location.dimension.isEmpty ? AppStrings.unknown : location.dimension),
              ]),
            ),
            const Icon(Icons.chevron_right_rounded, color: AppTheme.textSecondary),
          ]),
        ),
      ),
    );
  }
}

class _LocationIcon extends StatelessWidget {
  final String type;
  const _LocationIcon({required this.type});
  IconData get _icon {
    final t = type.toLowerCase();
    if (t.contains('planet')) return Icons.public_rounded;
    if (t.contains('space')) return Icons.rocket_launch_rounded;
    if (t.contains('microverse') || t.contains('dimension')) return Icons.blur_on_rounded;
    if (t.contains('fluid') || t.contains('liquid')) return Icons.water_drop_rounded;
    return Icons.location_on_rounded;
  }
  @override
  Widget build(BuildContext context) => Container(
        width: 48, height: 48,
        decoration: BoxDecoration(color: AppTheme.rickGreen.withOpacity(0.15),
            borderRadius: BorderRadius.circular(12)),
        child: Icon(_icon, color: AppTheme.rickGreen, size: 24),
      );
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  const _InfoRow({required this.icon, required this.label});
  @override
  Widget build(BuildContext context) => Row(children: [
        Icon(icon, size: 13, color: AppTheme.textSecondary),
        const SizedBox(width: 4),
        Expanded(child: Text(label, style: Theme.of(context).textTheme.bodySmall,
            maxLines: 1, overflow: TextOverflow.ellipsis)),
      ]);
}
