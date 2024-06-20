import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:face_ai/screen/swap_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:path_provider/path_provider.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../models/swap_model.dart';
import '../services/face_database_helper.dart';
import '../services/shared_pref_list.dart';
import '../util/enum.dart';
import '../view_models/face_swap_view_model.dart';

class ProgressScreen extends StatefulWidget {
  File faceImage;
  File bodyImage;
  bool notRecentFace;

  ProgressScreen(
      {required this.faceImage,
      required this.bodyImage,
      required this.notRecentFace});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  late FaceSwapViewModel _swapViewModel;

  String jobId = '';
  File? swapImage;

  var random = Random();

  void initState() {
    super.initState();

    _swapViewModel = Provider.of<FaceSwapViewModel>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _swapViewModel.swapImage(widget.bodyImage, widget.faceImage);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black, // Set the background color to black
        body: Consumer<FaceSwapViewModel>(builder: (context, item, child) {
          if (item.status == Status.loading) {
            item.clearStatus();
            WidgetsBinding.instance.addPostFrameCallback((timeStamp) {});
          } else if (item.status == Status.success) {
            item.clearStatus();
            Timer(Duration(seconds: 5),
                () => item.getSwapImage(item.jobId.toString()));
          } else if (item.status == Status.failed) {
            item.clearStatus();
            print("Failerd");
          } else if (item.status == Status.noInternet) {
            item.clearStatus();
            print("no internet ");
          }

          //after image swaped api

          if (item.swapStatus == Status.loading) {
            item.clearSwapStatus();
          } else if (item.swapStatus == Status.success) {
            item.clearSwapStatus();
            WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              setState(() {
                jobId = item.imageJobId.toString();
              });
            });
            saveImage(item.imageUrl
                .toString()
                .replaceAll('[', '')
                .replaceAll(']', ''));


            print('::::::::::::::::face swapedd');
          } else if (item.swapStatus == Status.failed) {
            item.clearSwapStatus();
            print("Failerd");
          } else if (item.swapStatus == Status.noInternet) {
            item.clearSwapStatus();
            print("no internet ");
          }
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Swapping face...',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.w),
                  child: LinearPercentIndicator(
                    animation: true,
                    lineHeight: 7.0,
                    barRadius: Radius.circular(10),
                    animationDuration: 12000,
                    percent: 0.9,
                    linearStrokeCap: LinearStrokeCap.roundAll,
                    progressColor: Colors.blue,
                  ),
                ), // Show the circular progress indicator
              ],
            ),
          );
        }));
  }

  Future<void> downloadAndSaveImage() async {
    var directory = await getApplicationSupportDirectory();
    String dirPath = '${directory.path}/${random.nextInt(10000)}';

    Directory dir = Directory(dirPath);
    print('my directory is ::::::::::::::::::::::::::::::::::::${dir.path}');
    await dir.create();

    String imagePath = '$dirPath/FaceAi${random.nextInt(10000)}.jpg';
    String faceImage = '$dirPath/FaceAi${random.nextInt(10000)}.png';
    String bodyImage = '$dirPath/FaceAi${random.nextInt(10000)}.jpeg';
    File savedImage = File(imagePath);
    File savedFaceImage = File(faceImage);
    File savedBodyImage = File(bodyImage);

    await savedImage.writeAsBytes(await swapImage!.readAsBytesSync());
    await savedFaceImage.writeAsBytes(await widget.faceImage.readAsBytesSync());
    await savedBodyImage.writeAsBytes(await widget.bodyImage.readAsBytesSync());

    await DatabaseHelper.insertSwapFace(SwapModel(
        swapPath: imagePath,
        swapFacePath: faceImage,
        swapBodyPath: bodyImage,
        jobId: jobId));

    print('Image saved at: $savedImage');
  }

  Future<void> saveImage(String imageUrl) async {
    // Send an HTTP GET request to the URL
    var response = await http.get(Uri.parse(imageUrl));

    // Get the app's documents directory to save the image
    var appDocumentsDirectory = await getTemporaryDirectory();
    String filePath = '${appDocumentsDirectory.path}/tempImage.jpeg';

    // Write the image to a file
    File imageFile = File(filePath);
    await imageFile.writeAsBytes(response.bodyBytes);
    setState(() {
      swapImage = imageFile;
    });

    downloadAndSaveImage().then((value) => Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => SwapScreen(
              faceImage: widget.faceImage,
              bodyImage: widget.bodyImage,
              swappedImage: swapImage!,
              notRecentFace: widget.notRecentFace,
              jobId: jobId,
            ),
          ),
        ));

    // Show a message to indicate success
    print(
        'Image downloaded and saved to: :::::::::::::::::::::::::::::::::::::::::$filePath');
  }
}
