import 'dart:async';

import 'package:corona_tracker/blocs/blocs.dart';
import 'package:corona_tracker/blocs/home/home_bloc.dart';
import 'package:corona_tracker/generated/l10n.dart';
import 'package:corona_tracker/models/models.dart';
import 'package:corona_tracker/ui/widgets/widgets.dart';
import 'package:corona_tracker/utils/map_styles/map_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = "/";

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime currentBackPressTime;
  final Completer<GoogleMapController> _controller = Completer();
  Location location;
  FilteredBloc _filteredBloc;
  final CameraPosition _cameraPosition = const CameraPosition(
    target: LatLng(10.7622028, 106.6786009),
    zoom: 1,
  );

  @override
  void initState() {
    _filteredBloc = FilteredBloc(homeBloc: BlocProvider.of<HomeBloc>(context));
    BlocProvider.of<HomeBloc>(context).add(const HomeLoadLocationsEvent());
    BlocProvider.of<SettingsBloc>(context).listen((state) {
      if (_controller.isCompleted && state is SettingsUpdatedState) {
        var style = getMapStyle(ThemeMode.values[state.settings.themeMode]);
        _controller.future.then((controller) => controller.setMapStyle(style));
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Scaffold(
      drawer: CustomDrawer(),
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          var response = BlocProvider.of<HomeBloc>(context).locationsResponse;
          var location = BlocProvider.of<HomeBloc>(context).location;
          List<Widget> charts;
          bool isLoading = state is HomeLoadingState;

          if (state is HomeLoadedLocationsState) {
            charts = [
              Container(
                height: ScreenUtil().setHeight(500),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DonutChart(state.response.latest),
                ),
              ),
            ];
          }

          if (state is HomeLoadedLocationState) {
            charts = [
              Container(
                height: ScreenUtil().setHeight(500),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DonutChart(state.location.latest),
                ),
              ),
              const Divider(),
              SizedBox(
                height: ScreenUtil().setHeight(600),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DashPatternTimeLineChart(state.location.timeLines),
                ),
              ),
            ];
          }

          return BlocBuilder<FilteredBloc, FilteredState>(
              bloc: _filteredBloc,
              builder: (context, filteredState) {
                var markers = _filteredBloc.markers;
                if (!isLoading && isLoading is FilteredLoadingState) {
                  isLoading = true;
                }
                return Stack(
                  children: <Widget>[
                    isLoading
                        ? Align(
                            alignment: Alignment.topCenter,
                            child: Padding(
                              padding: EdgeInsets.only(
                                  top: MediaQuery.of(context).padding.top),
                              child: const LinearProgressIndicator(),
                            ),
                          )
                        : Container(),
                    Align(
                      alignment: Alignment.center,
                      child: SlidingUpPanel(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                        minHeight: ScreenUtil().setHeight(400),
                        body: GoogleMap(
                          initialCameraPosition: _cameraPosition,
                          markers: markers,
                          myLocationEnabled: true,
                          mapToolbarEnabled: false,
                          compassEnabled: true,
                          onMapCreated: _onMapCreated,
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).padding.top),
                        ),
                        panelBuilder: (controller) {
                          if (isLoading) {
                            return Container();
                          }
                          bool isWorldwide = location == null;
                          return Column(
                            children: <Widget>[
                              Icon(Icons.remove),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  isWorldwide
                                      ? S.of(context).worldwide
                                      : location.country +
                                          (location.province.isNotEmpty
                                              ? " - ${location.province}"
                                              : ""),
                                  style: Theme.of(context).textTheme.title,
                                ),
                              ),
                              const Divider(),
                              buildExpanded(
                                  controller,
                                  isWorldwide
                                      ? response.latest
                                      : location.latest,
                                  charts),
                            ],
                          );
                        },
                      ),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        height: 56,
                        child: AppBar(
                          backgroundColor: Colors.transparent,
                          actions: <Widget>[
                            buildFilteredPopup(response),
                          ],
                        ),
                      ),
                    )
                  ],
                );
              });
        },
      ),
    );
  }

  Widget buildExpanded(
      ScrollController controller, Latest latest, List<Widget> charts) {
    return Expanded(
      child: ListView(
        controller: controller,
        padding: EdgeInsets.zero,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                buildColumn(S.of(context).confirmedTitle, latest?.confirmed,
                    Colors.yellow),
                buildColumn(
                    S.of(context).deathsTitle, latest?.deaths, Colors.red),
                buildColumn(S.of(context).recoveredTitle, latest?.recovered,
                    Colors.green),
              ],
            ),
          ),
          const Divider(),
        ]..addAll(charts),
      ),
    );
  }

  Column buildColumn(String title, int number, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(title),
        const SizedBox(
          height: 5,
        ),
        Text(
          number.toString(),
          style: Theme.of(context)
              .textTheme
              .title
              .copyWith(color: color, fontWeight: FontWeight.w300),
        ),
      ],
    );
  }

  Widget buildFilteredPopup(LocationsResponse locationsResponse) {
    var popupFiltered = {
      Filtered.confirmed: S.of(context).confirmedTitle,
      Filtered.deaths: S.of(context).deathsTitle,
      Filtered.recovered: S.of(context).recoveredTitle,
    };

    return PopupMenuButton<Filtered>(
      onSelected: (Filtered result) {
        _filteredBloc
            .add(FilteredLocationsEvent(locationsResponse, filtered: result));
      },
      icon: Icon(Icons.filter_list),
      itemBuilder: (context) => popupFiltered.keys
          .map(
            (key) => PopupMenuItem<Filtered>(
              value: key,
              child: ListTile(
                title: Text(popupFiltered[key]),
                selected: _filteredBloc.filtered == key,
                trailing:
                    _filteredBloc.filtered == key ? Icon(Icons.check) : null,
              ),
            ),
          )
          .toList(),
    );
  }
  Widget buildSettingsMenuPopup(LocationsResponse locationsResponse) {
    var popupFiltered = {
      Filtered.confirmed: S.of(context).confirmedTitle,
      Filtered.deaths: S.of(context).deathsTitle,
      Filtered.recovered: S.of(context).recoveredTitle,
    };

    return PopupMenuButton<Filtered>(
      onSelected: (Filtered result) {
        _filteredBloc
            .add(FilteredLocationsEvent(locationsResponse, filtered: result));
      },
      icon: Icon(Icons.filter_list),
      itemBuilder: (context) => popupFiltered.keys
          .map(
            (key) => PopupMenuItem<Filtered>(
              value: key,
              child: ListTile(
                title: Text(popupFiltered[key]),
                selected: _filteredBloc.filtered == key,
                trailing:
                    _filteredBloc.filtered == key ? Icon(Icons.check) : null,
              ),
            ),
          )
          .toList(),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    if (!_controller.isCompleted) {
      _controller.complete(controller);
      var style = getMapStyle(ThemeMode
          .values[BlocProvider.of<SettingsBloc>(context).settings.themeMode]);
      _controller.future.then((controller) => controller.setMapStyle(style));
    }
  }

  @override
  void dispose() {
    _filteredBloc?.close();
    super.dispose();
  }
}
