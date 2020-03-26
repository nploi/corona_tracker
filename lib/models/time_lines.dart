import 'package:corona_tracker/models/time_line.dart';

class TimeLines {
  TimeLine confirmed;
  TimeLine deaths;
  TimeLine recovered;

  TimeLines({this.confirmed, this.deaths, this.recovered});

  TimeLines.fromJson(Map<String, dynamic> json) {
    confirmed = json['confirmed'] != null
        ? new TimeLine.fromJson(json['confirmed'])
        : null;
    deaths =
        json['deaths'] != null ? new TimeLine.fromJson(json['deaths']) : null;
    recovered = json['recovered'] != null
        ? new TimeLine.fromJson(json['recovered'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.confirmed != null) {
      data['confirmed'] = this.confirmed.toJson();
    }
    if (this.deaths != null) {
      data['deaths'] = this.deaths.toJson();
    }
    if (this.recovered != null) {
      data['recovered'] = this.recovered.toJson();
    }
    return data;
  }
}
