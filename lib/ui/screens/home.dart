import 'dart:async';

import 'package:corona_tracker/blocs/blocs.dart';
import 'package:corona_tracker/blocs/home/home_bloc.dart';
import 'package:corona_tracker/generated/l10n.dart';
import 'package:corona_tracker/models/models.dart';
import 'package:corona_tracker/ui/common/bottom_sheets.dart';
import 'package:corona_tracker/ui/widgets/widgets.dart';
import 'package:corona_tracker/utils/map_styles/map_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        drawer: CustomDrawer(),
        body: CustomOffline(
          child: BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              var response =
                  BlocProvider.of<HomeBloc>(context).locationsResponse;
              var location = BlocProvider.of<HomeBloc>(context).location;
              var locationsGroup =
                  BlocProvider.of<HomeBloc>(context).locationsGroup;
              List<Widget> charts = [];
              bool isLoading = state is HomeLoadingState;

              if (response != null && locationsGroup != null) {
                charts = [
                  Container(
                    height: ScreenUtil().setHeight(500),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DonutChart(response.latest),
                    ),
                  ),
                  const Divider(),
                  Container(
                    height: ScreenUtil().setHeight(500),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TopCountriesChart(
                        animate: true,
                        locationsGroup: locationsGroup,
                      ),
                    ),
                  ),
                ];
              }

              if (location != null) {
                charts = [
                  Container(
                    height: ScreenUtil().setHeight(500),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DonutChart(location.latest),
                    ),
                  ),
                  const Divider(),
                  SizedBox(
                    height: ScreenUtil().setHeight(600),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DashPatternTimeLineChart(location.timeLines),
                    ),
                  ),
                ];
              }

              return BlocBuilder<FilteredBloc, FilteredState>(
                  bloc: _filteredBloc,
                  builder: (context, filteredState) {
                    var markers = _filteredBloc.markers;
                    bool isFilteredLoading = false;

                    if (filteredState is FilteredLoadingState) {
                      isFilteredLoading = true;
                    }

                    return Stack(
                      children: <Widget>[
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
                              myLocationButtonEnabled: true,
                              onMapCreated: _onMapCreated,
                              padding: EdgeInsets.only(
                                top: MediaQuery.of(context).padding.top + 40,
                                bottom: ScreenUtil().setHeight(400),
                              ),
                            ),
                            panelBuilder: (controller) {
                              return buildCard(isLoading, isFilteredLoading,
                                  location, controller, response, charts);
                            },
                          ),
                        ),
                        Align(
                          alignment: Alignment.topCenter,
                          child: Padding(
                            padding: EdgeInsets.only(
                                top: MediaQuery.of(context).padding.top),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                buildDrawerButton(),
                                buildFilterButton(response),
                              ],
                            ),
                          ),
                        )
                      ],
                    );
                  });
            },
          ),
        ),
      ),
    );
  }

  Widget buildCard(
      bool isLoading,
      bool isFilteredLoading,
      Location location,
      ScrollController controller,
      LocationsResponse response,
      List<Widget> charts) {
    if (isLoading || isFilteredLoading) {
      return Container(
        alignment: Alignment.topCenter,
        padding: const EdgeInsets.only(top: 10),
        child: const CircularProgressIndicator(),
      );
    }
    bool isWorldwide = location == null;
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Icon(Icons.remove),
        Row(
          children: <Widget>[
            !isWorldwide
                ? IconButton(
                    icon: Icon(Icons.arrow_back_ios),
                    onPressed: () {
                      BlocProvider.of<HomeBloc>(context)
                          .add(const HomeLoadLocationEvent(-1));
                    })
                : const SizedBox(
                    width: 48,
                  ),
            Expanded(
              child: Center(
                child: Text(
                  isWorldwide
                      ? S.of(context).worldwide
                      : (location.province.isNotEmpty
                              ? "${location.province}, "
                              : "") +
                          location.country,
                  style: Theme.of(context).textTheme.title,
                ),
              ),
            ),
            const SizedBox(
              width: 48,
            )
          ],
        ),
        const Divider(),
        buildExpanded(controller,
            isWorldwide ? response.latest : location.latest, charts),
      ],
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

  Widget buildFilterButton(LocationsResponse locationsResponse) {
    return Builder(
        builder: (context) => IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () {
              showFilterWithModalBottomSheet(context, _filteredBloc.filtered,
                  onSelected: (filtered) {
                _filteredBloc.add(FilteredLocationsEvent(locationsResponse,
                    filtered: filtered));
              });
            }));
  }

  Widget buildDrawerButton() {
    return Builder(
        builder: (context) => IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            }));
  }

  void _onMapCreated(GoogleMapController controller) {
    if (!_controller.isCompleted) {
      _controller.complete(controller);
      var style = getMapStyle(ThemeMode
          .values[BlocProvider.of<SettingsBloc>(context).settings.themeMode]);
      _controller.future.then((controller) => controller.setMapStyle(style));
    }
  }

  Future<bool> _onWillPop() async {
    final DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > const Duration(seconds: 2)) {
      currentBackPressTime = now;
      await Fluttertoast.showToast(msg: S.of(context).backAgainToLeaveMessage);
      return Future.value(false);
    }
    return Future.value(true);
  }

  @override
  void dispose() {
    _filteredBloc?.close();
    super.dispose();
  }
}
