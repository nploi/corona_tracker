import 'package:corona_tracker/models/error_detail.dart';

class Error {
  List<ErrorDetail> detail;

  Error({this.detail});

  Error.fromJson(Map<String, dynamic> json) {
    if (json['detail'] != null) {
      detail = [];
      json['detail'].forEach((v) {
        detail.add(ErrorDetail.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (detail != null) {
      data['detail'] = detail.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
