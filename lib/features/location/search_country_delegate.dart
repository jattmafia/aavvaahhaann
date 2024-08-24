import 'dart:developer';

import 'package:avahan/core/models/loc_obj.dart';
import 'package:avahan/features/components/async_widget.dart';
import 'package:avahan/features/location/providers/countries_provider.dart';
import 'package:avahan/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SearchCountryDelegate extends SearchDelegate<LocObj?> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          color: context.scheme.onSurface,
          icon: const Icon(Icons.clear),
          onPressed: () {
            showSuggestions(context);
            query = "";
          },
        ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return BackButton(
      color: context.scheme.onSurface,
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    return super.appBarTheme(context).copyWith(
        appBarTheme: super.appBarTheme(context).appBarTheme.copyWith(
            backgroundColor: context.scheme.surfaceTint.withOpacity(0.1)));
  }

  Widget view(BuildContext context) {
    return HookConsumer(
      builder: (context, ref, child) {
        return AsyncWidget(
          value: ref.watch(countriesProvider),
          data: (countries) {
            countries.sort((a, b) => a.name.compareTo(b.name));
            return ListView(
            children: countries
                .where((element) =>
                    element.name.toLowerCase().contains(query.trim().toLowerCase()))
                .map(
                  (e) => ListTile(
                    title: Text(e.name),
                    onTap: () {
                      close(context, e);
                    },
                  ),
                )
                .toList(),
          );
          }
        );
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return view(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return view(context);
  }
}
