import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rick_and_morty_location_explorer/core/errors/failures.dart';
import 'package:rick_and_morty_location_explorer/domain/entities/location.dart';
import 'package:rick_and_morty_location_explorer/domain/usecases/location_usecases.dart';
import 'package:rick_and_morty_location_explorer/presentation/bloc/location_list_bloc.dart';


class MockGetLocationsUseCase extends Mock implements GetLocationsUseCase {}
class MockGetLastUpdatedUseCase extends Mock implements GetLastUpdatedUseCase {}

final _location = Location(
  id: 1, name: 'Earth (C-137)', type: 'Planet',
  dimension: 'Dimension C-137', residentUrls: [],
  url: 'https://rickandmortyapi.com/api/location/1',
  created: '2017-11-10T12:42:04.162Z',
);

final _paginated = PaginatedLocations(locations: [_location], totalPages: 3, totalCount: 1);

void main() {
  late MockGetLocationsUseCase mockGetLocations;
  late MockGetLastUpdatedUseCase mockGetLastUpdated;

  setUp(() {
    mockGetLocations = MockGetLocationsUseCase();
    mockGetLastUpdated = MockGetLastUpdatedUseCase();
    when(() => mockGetLastUpdated()).thenAnswer((_) async => null);
  });

  LocationListBloc buildBloc() => LocationListBloc(
      getLocations: mockGetLocations, getLastUpdated: mockGetLastUpdated);

  group('LocationListBloc', () {
    test('initial state is correct', () {
      expect(buildBloc().state, const LocationListState());
    });

    blocTest<LocationListBloc, LocationListState>(
      'emits [loading, success] when fetch succeeds',
      build: buildBloc,
      setUp: () {
        when(() => mockGetLocations(
          page: any(named: 'page'),
          name: any(named: 'name'),
          type: any(named: 'type'),
        )).thenAnswer((_) async => (_paginated, null));
      },
      act: (b) => b.add(const LocationListFetchRequested()),
      expect: () => [
        const LocationListState(status: LocationListStatus.loading),
        LocationListState(
          status: LocationListStatus.success,
          locations: [_location],
          currentPage: 1,
          totalPages: 3,
          hasReachedMax: false,
        ),
      ],
    );

    blocTest<LocationListBloc, LocationListState>(
      'emits [loading, failure] on network error',
      build: buildBloc,
      setUp: () {
        when(() => mockGetLocations(
          page: any(named: 'page'),
          name: any(named: 'name'),
          type: any(named: 'type'),
        )).thenAnswer((_) async => (null, const NetworkFailure()));
      },
      act: (b) => b.add(const LocationListFetchRequested()),
      expect: () => [
        const LocationListState(status: LocationListStatus.loading),
        const LocationListState(
          status: LocationListStatus.failure,
          errorMessage: 'No internet connection',
        ),
      ],
    );

    blocTest<LocationListBloc, LocationListState>(
      'emits [loading, empty] when results empty',
      build: buildBloc,
      setUp: () {
        when(() => mockGetLocations(
          page: any(named: 'page'),
          name: any(named: 'name'),
          type: any(named: 'type'),
        )).thenAnswer((_) async => (
          const PaginatedLocations(locations: [], totalPages: 1, totalCount: 0), null));
      },
      act: (b) => b.add(const LocationListFetchRequested()),
      expect: () => [
        const LocationListState(status: LocationListStatus.loading),
        const LocationListState(status: LocationListStatus.empty),
      ],
    );

    blocTest<LocationListBloc, LocationListState>(
      'does not load next page when hasReachedMax',
      build: buildBloc,
      seed: () => const LocationListState(
          status: LocationListStatus.success, hasReachedMax: true, currentPage: 3),
      act: (b) => b.add(const LocationListNextPageRequested()),
      expect: () => <LocationListState>[],
    );

    blocTest<LocationListBloc, LocationListState>(
      'resets list on filter change',
      build: buildBloc,
      setUp: () {
        when(() => mockGetLocations(
          page: any(named: 'page'),
          name: any(named: 'name'),
          type: any(named: 'type'),
        )).thenAnswer((_) async => (_paginated, null));
      },
      seed: () => LocationListState(
          status: LocationListStatus.success, locations: [_location], currentPage: 2),
      act: (b) => b.add(const LocationListFilterChanged(name: 'earth', type: 'Planet')),
      expect: () => [
        isA<LocationListState>()
            .having((s) => s.status, 'status', LocationListStatus.loading)
            .having((s) => s.locations, 'locations', isEmpty),
        isA<LocationListState>()
            .having((s) => s.status, 'status', LocationListStatus.success)
            .having((s) => s.nameFilter, 'nameFilter', 'earth'),
      ],
    );
  });
}
