import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/constants/app_constants.dart';
import '../../core/constants/app_theme.dart';
import '../../core/utils/date_utils.dart' as du;
import '../bloc/location_list_bloc.dart';
import '../widgets/empty_state_widget.dart';
import '../widgets/error_state_widget.dart';
import '../widgets/loading_state_widget.dart';
import '../widgets/location_card.dart';
import '../widgets/search_filter_bar.dart';
import 'location_detail_page.dart';

class LocationListPage extends StatefulWidget {
  const LocationListPage({super.key});

  @override
  State<LocationListPage> createState() => _LocationListPageState();
}

class _LocationListPageState extends State<LocationListPage> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
    context.read<LocationListBloc>().add(const LocationListFetchRequested());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      context.read<LocationListBloc>().add(const LocationListNextPageRequested());
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.sizeOf(context).width >= AppConstants.desktopBreakpoint;
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.appName),
        actions: [
          BlocBuilder<LocationListBloc, LocationListState>(
            buildWhen: (p, c) => p.lastUpdated != c.lastUpdated,
            builder: (_, state) => Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Center(
                child: Text(
                  '${AppStrings.lastUpdated}: ${du.DateUtils.formatTimestamp(state.lastUpdated)}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ),
          ),
        ],
      ),
      body: isDesktop
          ? _DesktopLayout(scrollController: _scrollController)
          : _MobileLayout(scrollController: _scrollController),
    );
  }
}

class _MobileLayout extends StatelessWidget {
  final ScrollController scrollController;
  const _MobileLayout({required this.scrollController});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocationListBloc, LocationListState>(
      builder: (context, state) => Column(children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: SearchFilterBar(
            onSearchChanged: (q) => context.read<LocationListBloc>()
                .add(LocationListFilterChanged(name: q)),
            onTypeChanged: (t) => context.read<LocationListBloc>()
                .add(LocationListFilterChanged(type: t ?? '')),
            currentType: state.typeFilter,
            currentSearch: state.nameFilter,
          ),
        ),
        const SizedBox(height: 8),
        Expanded(child: _LocationBody(scrollController: scrollController)),
      ]),
    );
  }
}

class _DesktopLayout extends StatelessWidget {
  final ScrollController scrollController;
  const _DesktopLayout({required this.scrollController});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: AppConstants.maxContentWidth),
        child: BlocBuilder<LocationListBloc, LocationListState>(
          builder: (context, state) => Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 300,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 24, 12, 24),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('Search & Filter', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 16),
                    SearchFilterBar(
                      onSearchChanged: (q) => context.read<LocationListBloc>()
                          .add(LocationListFilterChanged(name: q)),
                      onTypeChanged: (t) => context.read<LocationListBloc>()
                          .add(LocationListFilterChanged(type: t ?? '')),
                      currentType: state.typeFilter,
                      currentSearch: state.nameFilter,
                    ),
                  ]),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 24),
                  child: _LocationBody(scrollController: scrollController),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LocationBody extends StatelessWidget {
  final ScrollController scrollController;
  const _LocationBody({required this.scrollController});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocationListBloc, LocationListState>(
      builder: (context, state) {
        switch (state.status) {
          case LocationListStatus.initial:
          case LocationListStatus.loading:
            return const LoadingStateWidget();
          case LocationListStatus.failure:
            return ErrorStateWidget(
              message: state.errorMessage ?? AppStrings.errorGeneric,
              onRetry: () => context.read<LocationListBloc>().add(const LocationListFetchRequested()),
            );
          case LocationListStatus.empty:
            return EmptyStateWidget(
              onRetry: () => context.read<LocationListBloc>().add(const LocationListRefreshRequested()),
            );
          case LocationListStatus.success:
            return RefreshIndicator(
              color: AppTheme.rickGreen,
              onRefresh: () async =>
                  context.read<LocationListBloc>().add(const LocationListRefreshRequested()),
              child: ListView.builder(
                controller: scrollController,
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                itemCount: state.locations.length + (state.isLoadingMore ? 1 : 0),
                itemBuilder: (ctx, i) {
                  if (i == state.locations.length) return const LoadingMoreIndicator();
                  final loc = state.locations[i];
                  return LocationCard(
                    location: loc,
                    onTap: () => Navigator.push(
                      ctx,
                      MaterialPageRoute(builder: (_) => LocationDetailPage(location: loc)),
                    ),
                  );
                },
              ),
            );
        }
      },
    );
  }
}
