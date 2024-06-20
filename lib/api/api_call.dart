import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import 'api_const.dart';

class APICall {
  Future<http.Response> getCategoryList() async {
    Map<String, String> headers = {
      "Access-Control-Allow-Origin": "*",
      'Content-Type': 'application/json',
      'Accept': '*/*',
    };
    return await http.post(Uri.parse(APIConst.faceCategory), headers: headers);
  }




  Future<http.Response> getFaceWallpaperList(String categoryId) async {
    Map<String, String> headers = {
      "Access-Control-Allow-Origin": "*",
      'Content-Type': 'application/json',
      'Accept': '*/*',
    };

    var body = jsonEncode({'cat_id': categoryId});

    return await http.post(Uri.parse(APIConst.faceWallpaper),
        headers: headers, body: body);
  }






  Future<http.Response> setSwapImage(File? faceImage,File? bodyImage) async {
    Map<String, String> headers =  {
      "accept": "application/json",
      'Authorization': APIConst.apiKey
    };
    var stream1= http.ByteStream(faceImage!.openRead());
    var stream2 =  http.ByteStream(bodyImage!.openRead());

    var length = await faceImage.length();
    var length2 = await bodyImage.length();

    var req = http.MultipartRequest('POST',Uri.parse(APIConst.createJobUrl));
    var image1 = http.MultipartFile('target_image',stream1,length,  filename: faceImage.path.split('/').last);
    var image2 = http.MultipartFile('swap_image',stream2,length2,filename: bodyImage.path.split('/').last);

    req.headers.addAll(headers);

    req.files.add(image1);
    req.files.add(image2);

    var res = await req.send();
    var response = await http.Response.fromStream(res);

    return response;

  }


  Future<http.Response> getSwapImage(String jobId) async{
    Map<String, String> headers =  {
      "accept": "application/json",
      'Authorization': APIConst.apiKey
    };
    return await http.get(Uri.parse(APIConst.swapBaseUrl+jobId),headers: headers);
  }



  Future<void> test()async {
    Timer(Duration(seconds: 5),
            ()=> print(':::::::::::::test api called')
    );
  }


  Future<void> testSwap()async {
    Timer(Duration(seconds: 5),
            ()=> print('::::::::::::::::test swap api called')
    );
  }



}
