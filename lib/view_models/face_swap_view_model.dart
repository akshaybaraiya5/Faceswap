import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import '../api/api_call.dart';

import '../models/result_model.dart';
import '../models/swap_response.dart';
import '../util/common_util.dart';
import '../util/enum.dart';

class FaceSwapViewModel extends ChangeNotifier {
  ResultResponse? resultResponse;
  SwapResponse? swapResponse;
  String? _jobId;
  String? _imageUrl;
  String? _imageJobId;


  // List<Users>? users = [];

  ResultResponse? get homeImageResponse => resultResponse;

  SwapResponse? get swapImageResponse => swapResponse;

  String? get jobId => _jobId;

  String? get imageUrl => _imageUrl;
  String? get imageJobId => _imageJobId;

  Status _status = Status.none;

  Status get status => _status;

  Status _swapStatus = Status.none;

  Status get swapStatus => _swapStatus;

  clearStatus() {
    _status = Status.none;
  }

  clearSwapStatus() {
    _swapStatus = Status.none;
  }

  Future<void> swapImage(File? firstImage, File? secondImage) async {
    CheckInternetUtil().checkInternetConnection().then((value) {

      if (value) {
        _status = Status.loading;
        notifyListeners();
        APICall().setSwapImage(firstImage, secondImage).then((response) {
          log('RESPONSE ::::' + response.body);

          if (response.statusCode == 200) {
            clearStatus();
            resultResponse =
                ResultResponse.fromJson(json.decode(response.body));
            _jobId = resultResponse!.result!.jobId;

            _status = Status.success;
            print(resultResponse!.result!.jobId.toString());

            notifyListeners();
          } else {
            _status = Status.failed;
            notifyListeners();
          }
        }).onError((error, stackTrace) {});
      } else {
        _status = Status.noInternet;
        notifyListeners();
      }
    });
  }

  Future<void> getSwapImage(String jobId) async {
    CheckInternetUtil().checkInternetConnection().then((value) {
      if (value) {
        _swapStatus = Status.loading;
        notifyListeners();
        APICall().getSwapImage(jobId).then((response) {
          log('RESPONSE ::::' + response.body);

          if (response.statusCode == 200) {
            clearSwapStatus();

            swapResponse = SwapResponse.fromJson(json.decode(response.body));
            _imageUrl = swapResponse!.result!.outputImageUrl.toString();
            _imageJobId = swapResponse!.result!.jobId.toString();

            print('job id is${swapResponse!.result!.jobId.toString()}');

            _swapStatus = Status.success;
            notifyListeners();
          } else {
            _swapStatus = Status.failed;
            notifyListeners();
          }
        }).onError((error, stackTrace) {});
      } else {
        _swapStatus = Status.noInternet;
        notifyListeners();
      }
    });
  }
}
