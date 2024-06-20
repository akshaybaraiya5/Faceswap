import 'dart:convert';
import 'dart:developer';

import 'package:face_ai/models/face_sample_model.dart';
import 'package:flutter/material.dart';

import '../api/api_call.dart';
import '../models/face_cetegory_model.dart';
import '../util/common_util.dart';
import '../util/enum.dart';


class HomeViewModel extends ChangeNotifier {
  FaceSampleResponse? faceSampleResponse;
  List<HDWALLPAPERAPP>? faceList = [];

  FaceSampleResponse? get  _faceSampleResponse=> faceSampleResponse;

  Status get status => _status;
  Status _status = Status.none;
  clearStatus() {
    _status = Status.none;
  }

  Future<void> getCategoryList() async {
    CheckInternetUtil().checkInternetConnection().then((value) {
      if (value) {
        _status = Status.loading;
        notifyListeners();
        APICall().getCategoryList().then((response) {
          log('RESPONSE ::::' + response.body);
          if (response.statusCode == 200) {
            faceSampleResponse = FaceSampleResponse.fromJson(json.decode(response.body));
            faceList = faceSampleResponse!.hDWALLPAPERAPP;
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