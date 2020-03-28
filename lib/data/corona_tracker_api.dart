import 'package:corona_tracker/models/models.dart';
import 'package:dio/dio.dart';

class CoronaTrackerApi {
  static const String url = "https://coronavirus-tracker-api.herokuapp.com";
  const CoronaTrackerApi();

  static bool debug = true;

  Dio makeDio() {
    return Dio()
      ..interceptors.add(
        LogInterceptor(requestBody: debug, responseBody: debug),
      );
  }

  Future<LocationsResponse> getLocations() async {
    try {
      var dio = makeDio();
      var response = await dio.get(url + "/v2/locations");
      dio.close();
      dio.clear();
      return LocationsResponse.fromJson(response.data);
    } on DioError catch (e) {
      var error = Error.fromJson(e.response.data);
      throw Exception(error.detail[0].msg);
    }
  }

  Future<Location> getLocation({int id}) async {
    try {
      var dio = makeDio();
      var response = await dio.get(url + "/v2/locations/$id");
      dio.close();
      dio.clear();
      if (response.data["location"] != null) {
        return Location.fromJson(response.data["location"]);
      }
      return Location();
    } on DioError catch (e) {
      var error = Error.fromJson(e.response.data);
      throw Exception(error.detail[0].msg);
    }
  }
}
