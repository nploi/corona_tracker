import 'package:corona_tracker/models/time_line.dart';

class TimeLines {
  TimeLine confirmed;
  TimeLine deaths;
  TimeLine recovered;

  TimeLines({this.confirmed, this.deaths, this.recovered});

  TimeLines.fromJson(Map<String, dynamic> json) {
    confirmed =
        json['confirmed'] != null ? TimeLine.fromJson(json['confirmed']) : null;
    deaths = json['deaths'] != null ? TimeLine.fromJson(json['deaths']) : null;
    recovered =
        json['recovered'] != null ? TimeLine.fromJson(json['recovered']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (confirmed != null) {
      data['confirmed'] = confirmed.toJson();
    }
    if (deaths != null) {
      data['deaths'] = deaths.toJson();
    }
    if (recovered != null) {
      data['recovered'] = recovered.toJson();
    }
    return data;
  }
}
