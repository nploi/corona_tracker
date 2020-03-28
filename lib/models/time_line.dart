class TimeLine {
  int latest;
  Map<dynamic, dynamic> timeline;

  TimeLine({this.latest, this.timeline});

  TimeLine.fromJson(Map<String, dynamic> json) {
    latest = json['latest'];
    timeline = json['timeline'] != null ? json['timeline'] : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['latest'] = latest;
    if (timeline != null) {
      data['timeline'] = timeline;
    }
    return data;
  }
}
