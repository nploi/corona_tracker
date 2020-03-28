import 'package:corona_tracker/blocs/blocs.dart';
import 'package:corona_tracker/generated/l10n.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          var settings = BlocProvider.of<SettingsBloc>(context).settings;

          return ListView(
            children: <Widget>[
              DrawerHeader(
                child: Center(
                    child: Text(
                  S.of(context).appName,
                  style: Theme.of(context).textTheme.title,
                )),
              ),
              ListTile(
                title: Text(S.of(context).dartModeTitle),
                trailing: CupertinoSwitch(
                  value: settings.themeMode == 2,
                  onChanged: (value) {
                    if (value) {
                      settings.themeMode = 2;
                    } else {
                      settings.themeMode = 1;
                    }
                    BlocProvider.of<SettingsBloc>(context)
                        .add(SettingsUpdateEvent(settings));
                  },
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
