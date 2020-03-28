class ErrorDetail {
  List<String> loc;
  String msg;
  String type;

  ErrorDetail({this.loc, this.msg, this.type});

  ErrorDetail.fromJson(Map<String, dynamic> json) {
    loc = json['loc'].cast<String>();
    msg = json['msg'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['loc'] = loc;
    data['msg'] = msg;
    data['type'] = type;
    return data;
  }
}
