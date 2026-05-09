import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/constants/app_constants.dart';
import '../../core/constants/app_theme.dart';
import '../../domain/entities/location.dart';
import '../../domain/repositories/location_repository.dart';
import '../../domain/usecases/location_usecases.dart';
import '../bloc/location_detail_bloc.dart';
import '../widgets/error_state_widget.dart';
import '../widgets/loading_state_widget.dart';
import '../widgets/resident_card.dart';

class LocationDetailPage extends StatelessWidget {
  final Location location;
  const LocationDetailPage({super.key, required this.location});

  @override
  Widget build(BuildContext context) {
    final repository = context.read<LocationRepository>();
    return BlocProvider(
      create: (_) =>
          LocationDetailBloc(getLocation: GetLocationUseCase(repository), getResident: GetResidentUseCase(repository))
            ..add(LocationDetailFetchRequested(location.id)),
      child: _DetailView(location: location),
    );
  }
}

class _DetailView extends StatelessWidget {
  final Location location;
  const _DetailView({required this.location});

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.sizeOf(context).width >= AppConstants.desktopBreakpoint;
    return Scaffold(
      appBar: AppBar(title: Text(location.name), leading: const BackButton()),
      body: BlocBuilder<LocationDetailBloc, LocationDetailState>(
        builder: (context, state) {
          switch (state.status) {
            case LocationDetailStatus.initial:
            case LocationDetailStatus.loading:
              return const Center(child: CircularProgressIndicator());
            case LocationDetailStatus.failure:
              return ErrorStateWidget(
                message: state.errorMessage ?? AppStrings.errorGeneric,
                onRetry: () => context.read<LocationDetailBloc>().add(LocationDetailFetchRequested(location.id)),
              );
            case LocationDetailStatus.success:
              final loc = state.location ?? location;
              return isDesktop
                  ? _DesktopDetail(location: loc, state: state)
                  : _MobileDetail(location: loc, state: state);
          }
        },
      ),
    );
  }
}

class _MobileDetail extends StatelessWidget {
  final Location location;
  final LocationDetailState state;
  const _MobileDetail({required this.location, required this.state});

  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.all(20),
    children: [
      _InfoCard(location: location),
      const SizedBox(height: 24),
      _ResidentsSection(state: state),
    ],
  );
}

class _DesktopDetail extends StatelessWidget {
  final Location location;
  final LocationDetailState state;
  const _DesktopDetail({required this.location, required this.state});

  @override
  Widget build(BuildContext context) => Center(
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: AppConstants.maxContentWidth),
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(width: 340, child: _InfoCard(location: location)),
            const SizedBox(width: 32),
            Expanded(child: _ResidentsSection(state: state)),
          ],
        ),
      ),
    ),
  );
}

class _InfoCard extends StatelessWidget {
  final Location location;
  const _InfoCard({required this.location});

  String _formatDate(String iso) {
    try {
      final dt = DateTime.parse(iso);
      return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';
    } catch (_) {
      return iso;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.darkCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.rickGreen.withOpacity(0.3), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _DetailRow(label: AppStrings.name, value: location.name),
          const Divider(height: 24, color: AppTheme.darkSurface),
          _DetailRow(label: AppStrings.type, value: location.type.isEmpty ? AppStrings.unknown : location.type),
          const SizedBox(height: 12),
          _DetailRow(
            label: AppStrings.dimension,
            value: location.dimension.isEmpty ? AppStrings.unknown : location.dimension,
          ),
          const SizedBox(height: 12),
          _DetailRow(label: 'Residents', value: '${location.residentUrls.length}'),
          const SizedBox(height: 12),
          _DetailRow(label: 'Created', value: _formatDate(location.created)),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(
        width: 90,
        child: Text(label, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppTheme.textSecondary)),
      ),
      Expanded(child: Text(value, style: Theme.of(context).textTheme.bodyMedium)),
    ],
  );
}

class _ResidentsSection extends StatelessWidget {
  final LocationDetailState state;
  const _ResidentsSection({required this.state});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppStrings.residents, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 12),
        if (state.residents.isEmpty && state.status == LocationDetailStatus.success)
          const LoadingStateGridWidget()
        else if (state.residents.isEmpty)
          Center(
            child: Text(
              'No residents',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppTheme.textSecondary),
            ),
          )
        else
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: AppConstants.residentGridCrossAxisCount,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.75,
            ),
            itemCount: state.residents.length,
            itemBuilder: (_, i) => ResidentCard(resident: state.residents[i]),
          ),
      ],
    );
  }
}
