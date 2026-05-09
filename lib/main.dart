import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/constants/app_constants.dart';
import 'core/constants/app_theme.dart';
import 'core/network/network_client.dart';
import 'data/datasources/location_local_datasource.dart';
import 'data/datasources/location_remote_datasource.dart';
import 'data/repositories/location_repository_impl.dart';
import 'domain/repositories/location_repository.dart';
import 'domain/usecases/location_usecases.dart';
import 'presentation/bloc/location_list_bloc.dart';
import 'presentation/pages/location_list_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  runApp(RickAndMortyApp(prefs: prefs));
}

class RickAndMortyApp extends StatelessWidget {
  final SharedPreferences prefs;
  const RickAndMortyApp({super.key, required this.prefs});

  @override
  Widget build(BuildContext context) {
    final networkClient = NetworkClient();
    final remote = LocationRemoteDataSourceImpl(networkClient);
    final local = LocationLocalDataSourceImpl(prefs);
    // Expose the repository directly so detail pages can create their own
    // fresh LocationDetailBloc without going through a shared/stale instance.
    final LocationRepository repository =
        LocationRepositoryImpl(remote: remote, local: local);

    return Provider<LocationRepository>.value(
      value: repository,
      child: BlocProvider(
        create: (_) => LocationListBloc(
          getLocations: GetLocationsUseCase(repository),
          getLastUpdated: GetLastUpdatedUseCase(repository),
        ),
        child: MaterialApp(
          title: AppStrings.appName,
          theme: AppTheme.darkTheme,
          debugShowCheckedModeBanner: false,
          home: const LocationListPage(),
        ),
      ),
    );
  }
}
