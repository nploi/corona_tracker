import 'package:corona_tracker/models/error_detail.dart';

class Error {
  List<ErrorDetail> detail;

  Error({this.detail});

  Error.fromJson(Map<String, dynamic> json) {
    if (json['detail'] != null) {
      detail = new List<ErrorDetail>();
      json['detail'].forEach((v) {
        detail.add(new ErrorDetail.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.detail != null) {
      data['detail'] = this.detail.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
