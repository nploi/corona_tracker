class Latest {
  int confirmed;
  int deaths;
  int recovered;

  Latest({this.confirmed, this.deaths, this.recovered});

  Latest.fromJson(Map<String, dynamic> json) {
    confirmed = json['confirmed'];
    deaths = json['deaths'];
    recovered = json['recovered'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['confirmed'] = confirmed;
    data['deaths'] = deaths;
    data['recovered'] = recovered;
    return data;
  }
}
