import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rick_and_morty_location_explorer/core/constants/app_theme.dart';
import 'package:rick_and_morty_location_explorer/domain/entities/location.dart';
import 'package:rick_and_morty_location_explorer/presentation/widgets/location_card.dart';


void main() {
  const testLocation = Location(
    id: 1, name: 'Earth (C-137)', type: 'Planet',
    dimension: 'Dimension C-137', residentUrls: [],
    url: 'https://rickandmortyapi.com/api/location/1',
    created: '2017-11-10T12:42:04.162Z',
  );

  Widget buildCard({VoidCallback? onTap}) => MaterialApp(
        theme: AppTheme.darkTheme,
        home: Scaffold(body: LocationCard(location: testLocation, onTap: onTap ?? () {})),
      );

  testWidgets('displays location name', (tester) async {
    await tester.pumpWidget(buildCard());
    expect(find.text('Earth (C-137)'), findsOneWidget);
  });

  testWidgets('displays location type', (tester) async {
    await tester.pumpWidget(buildCard());
    expect(find.text('Planet'), findsOneWidget);
  });

  testWidgets('displays location dimension', (tester) async {
    await tester.pumpWidget(buildCard());
    expect(find.text('Dimension C-137'), findsOneWidget);
  });

  testWidgets('calls onTap when tapped', (tester) async {
    var tapped = false;
    await tester.pumpWidget(buildCard(onTap: () => tapped = true));
    await tester.tap(find.byType(InkWell));
    expect(tapped, isTrue);
  });

  testWidgets('shows Unknown for empty type', (tester) async {
    const emptyLoc = Location(
      id: 2, name: 'Mysterious', type: '', dimension: 'Unknown',
      residentUrls: [], url: '', created: '',
    );
    await tester.pumpWidget(MaterialApp(
      theme: AppTheme.darkTheme,
      home: Scaffold(body: LocationCard(location: emptyLoc, onTap: () {})),
    ));
    expect(find.text('Unknown'), findsWidgets);
  });
}
