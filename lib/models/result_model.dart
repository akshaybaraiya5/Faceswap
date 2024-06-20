class ResultResponse {
  int? code;
  Result? result;
  Message? message;

  ResultResponse({this.code, this.result, this.message});

  ResultResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    result =
    json['result'] != null ? new Result.fromJson(json['result']) : null;
    message =
    json['message'] != null ? new Message.fromJson(json['message']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    if (this.result != null) {
      data['result'] = this.result!.toJson();
    }
    if (this.message != null) {
      data['message'] = this.message!.toJson();
    }
    return data;
  }
}

class Result {
  String? jobId;

  Result({this.jobId});

  Result.fromJson(Map<String, dynamic> json) {
    jobId = json['job_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['job_id'] = this.jobId;
    return data;
  }
}

class Message {
  String? en;

  Message({this.en});

  Message.fromJson(Map<String, dynamic> json) {
    en = json['en'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['en'] = this.en;
    return data;
  }
}
