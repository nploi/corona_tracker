import 'package:corona_tracker/generated/l10n.dart';
import 'package:corona_tracker/models/filtered.dart';
import 'package:flutter/material.dart';

void showFilterWithModalBottomSheet(BuildContext context, Filtered current,
    {Function(Filtered) onSelected}) {
  List<Widget> widgets = [];

  Map<Filtered, String> filterPopupRoutes = {
    Filtered.confirmed: S.of(context).confirmedTitle,
    Filtered.deaths: S.of(context).deathsTitle,
    Filtered.recovered: S.of(context).recoveredTitle,
  };

  filterPopupRoutes.keys.forEach((key) {
    widgets.add(Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ListTile(
            title: Text(filterPopupRoutes[key]),
            selected: key == current,
            trailing: current == key ? Icon(Icons.check) : null,
            onTap: () {
              if (onSelected != null && key != current) {
                onSelected(key);
              }
              Navigator.of(context).pop();
            }),
        const Divider(
          height: 1,
        )
      ],
    ));
  });
  showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Material(
          child: Wrap(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Text(S.of(context).filterWithTitle),
                ),
              ),
              const Divider(
                height: 1,
              ),
            ]..addAll(widgets),
          ),
        );
      });
}
