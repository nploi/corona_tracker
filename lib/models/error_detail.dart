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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['loc'] = this.loc;
    data['msg'] = this.msg;
    data['type'] = this.type;
    return data;
  }
}