import "dart:async";
import 'dart:math';
import "package:bloc/bloc.dart";
import 'package:corona_tracker/blocs/home/home_bloc.dart';
import 'package:corona_tracker/models/locations_response.dart';
import 'package:corona_tracker/models/models.dart';
import 'package:corona_tracker/ui/common/cluster_marker.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:corona_tracker/repositories/filtered_repository.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

part 'filtered_event.dart';

part 'filtered_state.dart';

class FilteredBloc extends Bloc<FilteredEvent, FilteredState> {
  final Set<Marker> markers = <Marker>{};
  Filtered _filtered = Filtered.confirmed;

  final FilteredRepository filteredRepository;
  HomeBloc homeBloc;
  StreamSubscription homeStreamSubscription;

  FilteredBloc(
      {this.filteredRepository = const FilteredRepository(), this.homeBloc}) {
    if (homeBloc != null) {
      homeStreamSubscription = homeBloc.listen((state) {
        if (state is HomeLoadedLocationsState) {
          add(FilteredLocationsEvent(state.response, filtered: _filtered));
        }
      });
    }
  }

  Filtered get filtered => _filtered;

  @override
  FilteredState get initialState => FilteredInitState();

  @override
  Stream<FilteredState> mapEventToState(
    FilteredEvent event,
  ) async* {
    if (event is FilteredLocationsEvent) {
      yield* _handleFilteredLocationsEvent(event);
      return;
    }
  }

  Stream<FilteredState> _handleFilteredLocationsEvent(
      FilteredLocationsEvent event) async* {
    yield FilteredLoadingState();
    try {
      _filtered = event.filtered;
      markers.clear();
      markers.addAll(await makeMarkers(event.response.locations,
          filtered: event.filtered, onPressed: (location) {
        homeBloc.add(HomeLoadLocationEvent(location.id));
      }));
      yield FilteredLocationsState(markers);
    } catch (exception) {
      yield FilteredErrorState(exception.message);
    }
  }

  static Future<Set<Marker>> makeMarkers(List<Location> locations,
      {Function(Location) onPressed,
      Filtered filtered = Filtered.confirmed}) async {
    Set<Marker> markers = {};

    for (int index = 0;
        locations != null && index < locations.length;
        index++) {
      var location = locations[index];

      Color color = getColor(location.latest.confirmed, filtered: filtered);

      var icon = await getClusterMarker(
        location.latest.confirmed,
        color,
        Colors.white,
        max(150, location.latest.confirmed ~/ 150),
      );

      markers.add(
        Marker(
          markerId: MarkerId(location.id.toString()),
          icon: icon,
          anchor: const Offset(0.5, 0.5),
          onTap: () {
            if (onPressed != null) {
              onPressed(location);
            }
          },
          position: LatLng(
            double.parse(location.coordinates.latitude),
            double.parse(location.coordinates.longitude),
          ),
        ),
      );
    }
    return markers;
  }

  static Color getColor(int number, {Filtered filtered = Filtered.confirmed}) {
    if (filtered == Filtered.deaths) {
      return Colors.red;
    }

    if (filtered == Filtered.recovered) {
      return Colors.green;
    }

    var color = const Color(0xffFFA07A);

    if (number > 10 && number <= 100) {
      color = const Color(0xffF08080);
    } else if (number > 100 && number <= 1000) {
      color = const Color(0xffCD5C5C);
    } else if (number > 1000 && number <= 10000) {
      color = const Color(0xffDC143C);
    } else if (number > 10000 && number <= 50000) {
      color = const Color(0xffFF0000);
    } else if (number > 50000) {
      color = const Color(0xff8B0000);
    }
    return color;
  }

  @override
  Future<void> close() {
    homeStreamSubscription?.cancel();
    return super.close();
  }
}
