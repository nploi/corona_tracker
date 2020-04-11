import 'package:corona_tracker/blocs/blocs.dart';
import 'package:corona_tracker/generated/l10n.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info/package_info.dart';

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          var settings = BlocProvider.of<SettingsBloc>(context).settings;

          return Column(
            children: <Widget>[
              Expanded(
                child: ListView(
                  children: <Widget>[
                    DrawerHeader(
                      child: Center(
                          child: Text(
                        S.of(context).appName,
                        style: Theme.of(context).textTheme.title,
                      )),
                    ),
                    ListTile(
                      leading: Icon(Icons.brightness_2),
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
                    ),
                    ListTile(
                      leading: Icon(Icons.info),
                      title: Text(S.of(context).openSourceLicensesTitle),
                      trailing: Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        showLicensePage(context: context);
                      },
                    ),
                  ],
                ),
              ),
              FutureBuilder<PackageInfo>(
                  future: PackageInfo.fromPlatform(),
                  builder: (context, snapshot) {
                    var version = "0.0.1";
                    if (snapshot.hasData) {
                      version = snapshot.data.version;
                    }
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(S.of(context).versionLabel(version)),
                    );
                  })
            ],
          );
        },
      ),
    );
  }
}
