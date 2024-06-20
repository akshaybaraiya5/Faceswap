class FaceWallpaperResponse {
  List<HDWALLPAPERAPP>? hDWALLPAPERAPP;
  int? totalRecords;
  int? statusCode;

  FaceWallpaperResponse(
      {this.hDWALLPAPERAPP, this.totalRecords, this.statusCode});

  FaceWallpaperResponse.fromJson(Map<String, dynamic> json) {
    if (json['HD_WALLPAPER_APP'] != null) {
      hDWALLPAPERAPP = <HDWALLPAPERAPP>[];
      json['HD_WALLPAPER_APP'].forEach((v) {
        hDWALLPAPERAPP!.add(new HDWALLPAPERAPP.fromJson(v));
      });
    }
    totalRecords = json['total_records'];
    statusCode = json['status_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.hDWALLPAPERAPP != null) {
      data['HD_WALLPAPER_APP'] =
          this.hDWALLPAPERAPP!.map((v) => v.toJson()).toList();
    }
    data['total_records'] = this.totalRecords;
    data['status_code'] = this.statusCode;
    return data;
  }
}

class HDWALLPAPERAPP {
  int? postId;
  String? postTitle;
  String? postImage;
  String? type;
  int? views;
  int? downloads;
  int? totalRate;
  bool? favourite;

  HDWALLPAPERAPP(
      {this.postId,
        this.postTitle,
        this.postImage,
        this.type,
        this.views,
        this.downloads,
        this.totalRate,
        this.favourite});

  HDWALLPAPERAPP.fromJson(Map<String, dynamic> json) {
    postId = json['post_id'];
    postTitle = json['post_title'];
    postImage = json['post_image'];
    type = json['type'];
    views = json['views'];
    downloads = json['downloads'];
    totalRate = json['total_rate'];
    favourite = json['favourite'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['post_id'] = this.postId;
    data['post_title'] = this.postTitle;
    data['post_image'] = this.postImage;
    data['type'] = this.type;
    data['views'] = this.views;
    data['downloads'] = this.downloads;
    data['total_rate'] = this.totalRate;
    data['favourite'] = this.favourite;
    return data;
  }
}
