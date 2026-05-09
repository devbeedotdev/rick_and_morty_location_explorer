import 'dart:async';
import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../core/constants/app_theme.dart';

const _kLocationTypes = [
  'Planet', 'Space station', 'Microverse', 'TV', 'Resort',
  'Fantasy town', 'Dream', 'Dimension', 'Unknown',
];

class SearchFilterBar extends StatefulWidget {
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<String?> onTypeChanged;
  final String? currentType;
  final String? currentSearch;

  const SearchFilterBar({
    super.key,
    required this.onSearchChanged,
    required this.onTypeChanged,
    this.currentType,
    this.currentSearch,
  });

  @override
  State<SearchFilterBar> createState() => _SearchFilterBarState();
}

class _SearchFilterBarState extends State<SearchFilterBar> {
  late final TextEditingController _controller;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.currentSearch);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onSearchChanged(String val) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () => widget.onSearchChanged(val.trim()));
  }

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      TextField(
        controller: _controller,
        decoration: InputDecoration(
          hintText: AppStrings.searchHint,
          prefixIcon: const Icon(Icons.search_rounded, color: AppTheme.textSecondary),
          suffixIcon: _controller.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear_rounded, color: AppTheme.textSecondary),
                  onPressed: () { _controller.clear(); widget.onSearchChanged(''); })
              : null,
        ),
        onChanged: _onSearchChanged,
      ),
      const SizedBox(height: 10),
      SizedBox(
        height: 36,
        child: ListView(scrollDirection: Axis.horizontal, children: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: const Text(AppStrings.allTypes),
              selected: widget.currentType == null,
              onSelected: (_) => widget.onTypeChanged(null),
              selectedColor: AppTheme.rickGreen.withOpacity(0.2),
              checkmarkColor: AppTheme.rickGreen,
            ),
          ),
          ..._kLocationTypes.map((t) => Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(t),
              selected: widget.currentType == t,
              onSelected: (selected) => widget.onTypeChanged(selected ? t : null),
              selectedColor: AppTheme.rickGreen.withOpacity(0.2),
              checkmarkColor: AppTheme.rickGreen,
            ),
          )),
        ]),
      ),
    ]);
  }
}
