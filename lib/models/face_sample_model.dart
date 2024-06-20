class FaceSampleResponse {
  List<HDWALLPAPERAPP>? hDWALLPAPERAPP;
  int? totalRecords;
  int? statusCode;

  FaceSampleResponse({this.hDWALLPAPERAPP, this.totalRecords, this.statusCode});

  FaceSampleResponse.fromJson(Map<String, dynamic> json) {
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
  int? categoryId;
  String? categoryName;
  List<Wallpapers>? wallpapers;

  HDWALLPAPERAPP({this.categoryId, this.categoryName, this.wallpapers});

  HDWALLPAPERAPP.fromJson(Map<String, dynamic> json) {
    categoryId = json['category_id'];
    categoryName = json['category_name'];
    if (json['wallpapers'] != null) {
      wallpapers = <Wallpapers>[];
      json['wallpapers'].forEach((v) {
        wallpapers!.add(new Wallpapers.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['category_id'] = this.categoryId;
    data['category_name'] = this.categoryName;
    if (this.wallpapers != null) {
      data['wallpapers'] = this.wallpapers!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Wallpapers {
  int? wallpaperId;
  String? wallpaperTitle;
  String? wallpaperImage;

  Wallpapers({this.wallpaperId, this.wallpaperTitle, this.wallpaperImage});

  Wallpapers.fromJson(Map<String, dynamic> json) {
    wallpaperId = json['wallpaper_id'];
    wallpaperTitle = json['wallpaper_title'];
    wallpaperImage = json['wallpaper_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['wallpaper_id'] = this.wallpaperId;
    data['wallpaper_title'] = this.wallpaperTitle;
    data['wallpaper_image'] = this.wallpaperImage;
    return data;
  }
}
