class SwapResponse {
  int? code;
  Result? result;
  Message? message;

  SwapResponse({this.code, this.result, this.message});

  SwapResponse.fromJson(Map<String, dynamic> json) {
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
  List<String>? outputImageUrl;
  List<String>? inputImageUrl;
  String? jobId;
  String? message;

  Result({this.outputImageUrl, this.inputImageUrl, this.jobId, this.message});

  Result.fromJson(Map<String, dynamic> json) {
    outputImageUrl = json['output_image_url'].cast<String>();
    inputImageUrl = json['input_image_url'].cast<String>();
    jobId = json['job_id'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['output_image_url'] = this.outputImageUrl;
    data['input_image_url'] = this.inputImageUrl;
    data['job_id'] = this.jobId;
    data['message'] = this.message;
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
