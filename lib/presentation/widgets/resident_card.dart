import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../core/constants/app_theme.dart';
import '../../domain/entities/location.dart';

class ResidentCard extends StatelessWidget {
  final Resident resident;
  const ResidentCard({super.key, required this.resident});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: AppTheme.darkCard, borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      child: Column(children: [
        Expanded(
          child: Stack(fit: StackFit.expand, children: [
            CachedNetworkImage(
              imageUrl: resident.image,
              fit: BoxFit.cover,
              placeholder: (_, __) => const _Placeholder(),
              errorWidget: (_, __, ___) => const _Placeholder(),
            ),
            Positioned(
              top: 6, right: 6,
              child: Container(
                width: 10, height: 10,
                decoration: BoxDecoration(
                  color: AppTheme.statusColor(resident.status),
                  shape: BoxShape.circle,
                  border: Border.all(color: AppTheme.darkCard, width: 1.5),
                ),
              ),
            ),
          ]),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
          child: Column(children: [
            Text(resident.name,
                style: Theme.of(context).textTheme.bodySmall
                    ?.copyWith(fontWeight: FontWeight.w600, color: AppTheme.textPrimary),
                maxLines: 1, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center),
            Text(resident.status,
                style: Theme.of(context).textTheme.bodySmall
                    ?.copyWith(fontSize: 10, color: AppTheme.statusColor(resident.status)),
                textAlign: TextAlign.center),
          ]),
        ),
      ]),
    );
  }
}

class _Placeholder extends StatelessWidget {
  const _Placeholder();
  @override
  Widget build(BuildContext context) => Container(
        color: AppTheme.darkSurface,
        child: const Icon(Icons.person_rounded, size: 40, color: AppTheme.textSecondary),
      );
}
