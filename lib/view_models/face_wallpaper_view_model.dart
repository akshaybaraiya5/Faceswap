import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';

import '../api/api_call.dart';
import '../models/face_wallpaper_model.dart';
import '../util/common_util.dart';
import '../util/enum.dart';


class FaceWallpaperViewModel extends ChangeNotifier {
  FaceWallpaperResponse? _faceWallpaperResponse;
  List<HDWALLPAPERAPP>? wallpaperList = [];

  FaceWallpaperResponse? get  faceWallpaperViewModel=> _faceWallpaperResponse;

  Status get status => _status;
  Status _status = Status.none;
  clearStatus() {
    _status = Status.none;
  }

  Future<void> getWallpaperList(String categoryId) async {
    CheckInternetUtil().checkInternetConnection().then((value) {
      if (value) {
        _status = Status.loading;
        notifyListeners();
        APICall().getFaceWallpaperList(categoryId).then((response) {
          log('RESPONSE ::::' + response.body);
          if (response.statusCode == 200) {
            _faceWallpaperResponse = FaceWallpaperResponse.fromJson(json.decode(response.body));
            wallpaperList = _faceWallpaperResponse!.hDWALLPAPERAPP;
            _status=Status.success;
            notifyListeners();
          } else {
            _status = Status.failed;
            notifyListeners();
          }
        }).onError((error, stackTrace) {

        });
      } else {
        _status = Status.noInternet;
        notifyListeners();
      }
    });
  }


}