
import 'dart:io';

import 'dart:math';
import 'dart:typed_data';

import 'package:face_ai/models/FaceModel.dart';
import 'package:face_ai/screen/progress_screen.dart';
import 'package:face_ai/screen/swap_screen.dart';
import 'package:face_ai/util/ad_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'package:http/http.dart' as http;
import 'package:image_cropping/image_cropping.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';


import '../services/face_database_helper.dart';
import '../services/shared_pref_list.dart';
import '../util/app_colors.dart';
import '../util/string_utils.dart';
import '../util/widget_util.dart';

class CustomScreen extends StatefulWidget {
  bool showButton;
  String image;

  CustomScreen({required this.showButton, required this.image});

  @override
  State<CustomScreen> createState() => _CustomScreenState();
}

class _CustomScreenState extends State<CustomScreen> {
  int? currentIndex;

  double s = 10.h / 10.w;
  WidgetUtil widgetUtil = WidgetUtil();
  final picker = ImagePicker();
  File? _bodyImage;
  File? _faceImage;
  bool imageSelected = false;
  bool showButton = false;
  bool isBodyImage = true;
  var r = Random();
  List files = [];
  List recentFaces = [];
  bool deleteFace = false;
  File? croppedFace;
  File? _body;


  List<Map<String, dynamic>> data = [];

  bool _isLoading = true;
  RewardedAd? _rewardedAd;
  int _numRewardedLoadAttempts = 0;
  bool _isAdReady = false;





  void getData() async {
    var userData = await DatabaseHelper.getFace();
    setState(() {
      data = userData;
      _isLoading = false;
    });

    print('your data is ${userData.toString()}');
  }

  @override
  void initState() {

    // TODO: implement initState
    super.initState();


    getData();

    if (widget.image != '') {
      _fileFromImageUrl();
      print('::::::::::::api called');
    }

    setState(() {
      showButton = widget.showButton;
    });
  }

  _fileFromImageUrl() async {
    final response = await http.get(Uri.parse(widget.image));

    final documentDirectory = await getApplicationDocumentsDirectory();

    final file = File(join(documentDirectory.path, '${r.nextInt(100)}.png'));

    file.writeAsBytesSync(response.bodyBytes);

    setState(() {
      _body = file;
    });
  }

  @override
  Widget build(BuildContext ctx) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.white,
            //change your color here
          ),
          backgroundColor: AppColors.backgroundColor,
          centerTitle: true,
          title: Text(
            widget.showButton ? StringUtils.customText : '',
            style: TextStyle(
              color: Colors.white,
              fontSize: 10 * s,
              fontFamily: StringUtils.manropeFonts,
              fontWeight: FontWeight.w600,
              height: 0,
            ),
          ),
          // actions: [
          //   Column(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: [
          //       Text(StringUtils.creditText ,
          //         style: TextStyle(
          //           color: Colors.white,
          //           fontSize: 6 * s,
          //           fontFamily: StringUtils.manropeFonts,
          //           fontWeight: FontWeight.w600,
          //           height: 0,
          //         ),
          //       ),
          //       Text(_numRewardedLoadAttempts.toString() ,
          //         style: TextStyle(
          //           color: Colors.red,
          //           fontSize: 6 * s,
          //           fontFamily: StringUtils.manropeFonts,
          //           fontWeight: FontWeight.w600,
          //           height: 0,
          //         ),
          //       ),
          //
          //     ],
          //
          //   ),
          //   widgetUtil.horizontalSpace(5.w)
          // ],
        ),

        backgroundColor: AppColors.backgroundColor,
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                widgetUtil.verticalSpace(2.h),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Stack(
                    children: [
                      Container(
                          width: double.infinity,
                          height: 50.h,
                          decoration: ShapeDecoration(
                            color: Color(0xFF262626),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Stack(
                            children: [
                              widget.showButton
                                  ? Container(
                                child: imageSelected
                                    ? SizedBox(
                                    width: double.infinity,
                                    height: double.infinity,
                                    child: ClipRRect(
                                        borderRadius:
                                        BorderRadius.circular(10),
                                        child: Image.file(
                                          _body!,
                                          fit: BoxFit.cover,
                                        )))
                                    : Container(),
                              )
                                  : SizedBox(
                                  width: double.infinity,
                                  height: double.infinity,
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: _body == null
                                          ? Center(
                                          child:
                                          CircularProgressIndicator())
                                          : Image.file(
                                        _body!,
                                        fit: BoxFit.cover,
                                      ))),
                              Visibility(
                                visible: showButton,
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      widgetUtil.customSqureIconButton(
                                        StringUtils.loadText,
                                        Icons.add,
                                            () {
                                          setState(() {
                                            isBodyImage = true;
                                          });
                                          _showBottomSheet(ctx);
                                        },
                                      ),
                                      widgetUtil.horizontalSpace(10.w),
                                      widgetUtil.customSqureIconButton(
                                          StringUtils.exploreText,
                                          Icons.explore_outlined,
                                              () => Navigator.pop(ctx)),
                                    ],
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: imageSelected,
                                child: Positioned(
                                    bottom: 10,
                                    right: 10,
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          showButton = true;
                                          imageSelected = false;
                                          _body = null;
                                        });
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(8),
                                        width: 50,
                                        height: 50,
                                        decoration: ShapeDecoration(
                                          color:
                                          Color(0xFF1B1B1B).withOpacity(0.7),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(10),
                                          ),
                                        ),
                                        child: Icon(
                                          Icons.delete,
                                          color: Colors.white,
                                          size: 30,
                                        ),
                                      ),
                                    )),
                              )
                            ],
                          )),
                    ],
                  ),
                ),
                widgetUtil.verticalSpace(1.h),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        StringUtils.resentText,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 5 * s,
                          fontFamily: StringUtils.poppinsFonts,
                          fontWeight: FontWeight.w500,
                          height: 0,
                        ),
                      ),
                      Text(
                        StringUtils.manageText,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 5 * s,
                          fontFamily: StringUtils.poppinsFonts,
                          fontWeight: FontWeight.w500,
                          height: 0,
                        ),
                      )
                    ],
                  ),
                ),
                widgetUtil.verticalSpace(2.h),
                recentFaces == null
                    ? Container()
                    : SizedBox(
                    width: 100.w,
                    height: 14.h,
                    child: ListView.builder(
                        padding: EdgeInsets.only(left: 20),
                        scrollDirection: Axis.horizontal,
                        itemCount: data.length + 1,
                        itemBuilder: (ctx, index) {
                          if (index == data.length) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10.0),
                              child: widgetUtil.customCircleIconButton(
                                  StringUtils.addFacesText,
                                  Icons.person_add_alt,10, () {
                                _showBottomSheet(ctx);
                                setState(() {
                                  isBodyImage = false;
                                });
                              }),
                            );
                          }
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                currentIndex = index;

                                print(index);
                                // _faceImage = File(recentFaces[index].toString().replaceAll('[', '').replaceAll(']', ''));
                                _faceImage = File(
                                    data[index][DatabaseHelper.facePath]);
                                print(currentIndex);
                              });
                              getData();
                            },
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 5.0),
                                  child: Container(
                                    height: 10.h,
                                    width: 10.h,
                                    child: Stack(
                                      children: [
                                        Container(
                                          height: 10.h,
                                          width: 10.h,
                                          decoration: (currentIndex == index)
                                              ? BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: Color(0xFF00FFE0),
                                              width:
                                              2.0, // Adjust border width as needed
                                            ),
                                          )
                                              : BoxDecoration(),
                                          child: Padding(
                                            padding:
                                            const EdgeInsets.all(3.0),
                                            child: ClipRRect(
                                              borderRadius:
                                              BorderRadius.circular(60),
                                              child: Image.file(
                                                File(data[index][
                                                DatabaseHelper.facePath]),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                            top: 0.01,
                                            left: 0.01,
                                            child: GestureDetector(
                                                onTap: () async {
                                                  await _showDeleteFaceDialog(
                                                      ctx);
                                                  if (deleteFace) {
                                                    await DatabaseHelper
                                                        .deleteFace(
                                                        data[index][
                                                        DatabaseHelper
                                                            .faceId]);
                                                    await deleteFile(
                                                        data[index][
                                                        DatabaseHelper
                                                            .facePath]);
                                                    getData();
                                                  }
                                                },
                                                child: Icon(
                                                  Icons.cancel_sharp,
                                                  color: Colors.red,
                                                  size: 20,
                                                )))
                                      ],
                                    ),
                                  ),
                                ),
                                widgetUtil.verticalSpace(3.h)
                              ],
                            ),
                          );
                        })),
                widgetUtil.verticalSpace(2.h),
                GestureDetector(
                    onTap: () {
                      if (_body == null || _body!.path.toString().isEmpty) {
                        ScaffoldMessenger.of(ctx).showSnackBar(
                          const SnackBar(
                              duration: Duration(milliseconds: 1000),
                              backgroundColor: Colors.red,
                              content:
                              Center(child: Text('Please select Body Image '))),
                        );
                      } else {
                        if (_faceImage == null ||
                            _faceImage!.path.toString().isEmpty) {
                          ScaffoldMessenger.of(ctx).showSnackBar(
                            const SnackBar(
                                backgroundColor: Colors.red,
                                duration: Duration(milliseconds: 1000),
                                content: Center(
                                    child: Text('Please select Face Image '))),
                          );
                        } else {
                          showLoaderDialog(ctx);
                          _createRewardedAd(ctx);
                        }
                      }
                    },

                    child:    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                        width: double.infinity,
                        height: 7.h,
                        decoration: ShapeDecoration(
                          color: Color(0xFF00FFE0),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                          shadows: [
                            BoxShadow(
                              color: Color(0x99000000),
                              blurRadius: 4.70,
                              offset: Offset(4, 6),
                              spreadRadius: 0,
                            )
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.videocam_outlined,
                                  size: 4.h,
                                ),
                                widgetUtil.horizontalSpace(1.h),
                                Text(
                                  StringUtils.watchAdText,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 6 * s,
                                    fontFamily: StringUtils.poppinsFonts,
                                    fontWeight: FontWeight.bold,
                                    height: 0,
                                  ),
                                ),
                              ],
                            ),
                            widgetUtil.horizontalSpace(20.w),
                            Text(
                              StringUtils.faceSwapText,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 6 * s,
                                fontFamily: StringUtils.poppinsFonts,
                                fontWeight: FontWeight.bold,
                                height: 0,
                              ),
                            ),
                            Icon(
                              Icons.last_page_sharp,
                              size: 5.h,
                            )
                          ],
                        ),
                      ),
                    )
                ),
                widgetUtil.verticalSpace(4.h),
                Text(
                  StringUtils.customBottomText,
                  style: TextStyle(
                    color: Color(0xFF7B7878),
                    fontSize: 9,
                    fontFamily: StringUtils.poppinsFonts,
                    fontWeight: FontWeight.w300,
                    height: 0,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> getImage(ImageSource source, BuildContext context) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    // final InputImage inputImage = InputImage.fromFile(File(pickedFile!.path));
    // final List<Face> faces = await faceDetector.processImage(inputImage);
    if (pickedFile != null) {
      if (isBodyImage) {
        setState(() {
          _body = File(pickedFile.path);
          showButton = false;
          imageSelected = true;
          print(pickedFile.path);
          print(
              ';;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;you picked body image ;;;;;;;;;;;;;;;;;;;;;;;;');
        });
      } else {
        print(
            ';;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;you picked face image ;;;;;;;;;;;;;;;;;;;;;;;;');

        ImageCropping.cropImage(
            context: context,
            imageBytes: File(pickedFile.path).readAsBytesSync(),
            onImageDoneListener: (data) async {
              var image = await File(
                  await saveUint8ListAsFile(data, '${r.nextInt(100)}.png'));
              setState(() {
                croppedFace = image;
              });
              await saveImage();
              getData();
            });
      }
    }
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return Container(
          height: 25.h,
          decoration: BoxDecoration(
            color: Color(0xFF262626),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              widgetUtil.customSqureIconButton(
                StringUtils.galleryText,
                Icons.image,
                    () {
                  getImage(ImageSource.gallery, context);
                  Navigator.pop(context);
                },
              ),
              widgetUtil.horizontalSpace(15.w),
              widgetUtil.customSqureIconButton(
                  StringUtils.cameraText, Icons.camera_alt_outlined, () {
                getImage(ImageSource.camera, context);
                Navigator.pop(context);
              }),
            ],
          ),
        );
      },
    );
  }

  Future<Uint8List> fileToUint8List(File file) async {
    // Read the image file as bytes
    List<int> bytes = await file.readAsBytes();

    // Convert the bytes to Uint8List
    Uint8List uint8List = Uint8List.fromList(bytes);

    return uint8List;
  }

  Future<String> saveUint8ListAsFile(
      Uint8List uint8List, String fileName) async {
    // Get the directory where you want to save the file
    Directory directory = await getApplicationDocumentsDirectory();
    String filePath = '${directory.path}/$fileName';

    // Write the Uint8List data to a file
    await File(filePath).writeAsBytes(uint8List);

    return filePath;
  }

  saveImage() async {
    var status = await Permission.storage.request();
    if(status.isGranted){
      Directory duplicateFilePath = await getApplicationDocumentsDirectory();

// Step 4: Copy the file to a application document directory.
      print(duplicateFilePath.path);
      String dirPath = '${duplicateFilePath.path}/FaceSwap';
      Directory dir = Directory(dirPath);
      if (recentFaces.isEmpty) {
        await dir.create();
      }
      // String imagePath = '$dirPath/${DateTime.now().millisecond.toString()}${DateTime.now().second.toString()}${DateTime.now().minute.toString()}${DateTime.now().hour.toString()}${DateTime.now().day.toString()}.png';
      String imagePath =
          '$dirPath/${DateTime.now().millisecond}${DateTime.now().toString()}.png';
      File savedImage = File(imagePath);
      // databaseHelper.insertMart(FaceModel( facePath: savedImage.path));
      await DatabaseHelper.insertFace(FaceModel(facePath: savedImage.path));
      getData();
      savedImage.writeAsBytesSync(await croppedFace!.readAsBytesSync());
      print('filed saved at $savedImage');
      setState(() {});
    }

  }

  // getFile()async {
  //   final directory = await getApplicationDocumentsDirectory();
  //   var file  =  io.Directory("${directory.path}/faces").listSync().map((item) => item.path)
  //       .where((item) => item.toString().endsWith(".png"));
  //
  //
  //  setState(() {
  //    recentFaces = file.toList();
  //  });
  //
  //
  //
  // }

  Future<void> _showDeleteFaceDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xFF1B1B1B),
          content: Text(
            'Do you want to remove this face?',
            style: TextStyle(color: Colors.white, fontSize: 8 * s),
          ),
          actions: [
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                    onPressed: () {
                      // setState(() {
                      //   deleteFace = false;
                      // });
                      Navigator.of(context).pop(); // Close the dialog
                    },
                    child: Text(
                      'No',
                      style: TextStyle(fontSize: 8 * s),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        deleteFace = true;
                      });
                      Navigator.of(context).pop();
                      // Close the dialog
                    },
                    child: Text(
                      'Yes',
                      style: TextStyle(fontSize: 8 * s),
                    ),
                  ),
                ],
              ),
            )
          ],
        );
      },
    );
  }
  // Future<void> _showAddDialog(BuildContext context) async {
  //   return showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return SizedBox(
  //         height: 1,
  //         child: AlertDialog(
  //
  //           backgroundColor: Color(0xFF1B1B1B),
  //           content: Text(
  //             'Do you want to see add to earn credit ?',
  //             style: TextStyle(color: Colors.white, fontSize: 8 * s),
  //           ),
  //           actions: [
  //             Container(
  //               child: Row(
  //                 mainAxisAlignment: MainAxisAlignment.spaceAround,
  //                 children: [
  //                   TextButton(
  //                     onPressed: () {
  //                       // setState(() {
  //                       //   deleteFace = false;
  //                       // });
  //                       Navigator.of(context).pop(); // Close the dialog
  //                     },
  //                     child: Text(
  //                       'No',
  //                       style: TextStyle(fontSize: 8 * s),
  //                     ),
  //                   ),
  //                   TextButton(
  //
  //                     onPressed: () {
  //                       Navigator.pop(context);
  //                   showLoaderDialog(context);
  //
  //
  //                      _createRewardedAd();
  //
  //
  //
  //
  //
  //
  //
  //
  //                       // Close the dialog
  //                     },
  //                     child: Text(
  //                       'Yes',
  //                       style: TextStyle(fontSize: 8 * s),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             )
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }

  Future<void> deleteFile(String filePath) async {
    try {
      File file = File(filePath);
      if (await file.exists()) {
        await file.delete();
        print('File deleted successfully');
      } else {
        print('File does not exist');
      }
    } catch (e) {
      print('Error deleting file: $e');
    }
  }



  void _createRewardedAd(BuildContext context)  {

    setState(() {
      _isAdReady= true;

    });
    RewardedAd.load(
        adUnitId: AdsUtils.rewardAdsIds,
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(

          onAdLoaded: (RewardedAd ad) {

            print('$ad loaded.');




            setState(() {
              _rewardedAd = ad;
              _isAdReady= false;
            });
            _showRewardedAd(context);
            Navigator.pop(context);




          },
          onAdFailedToLoad: (LoadAdError error) {
            Navigator.pop(context);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (ctx) => ProgressScreen(
                      faceImage: _faceImage!,
                      bodyImage: _body!,
                      notRecentFace: true,
                    )));
            print('RewardedAd failed to load: $error');
            _rewardedAd = null;
            setState(() {
              _isAdReady= false;
            });


          },
        ));


  }


  void _showRewardedAd(BuildContext context) {


    if (_rewardedAd == null) {
      print('Warning: attempt to show rewarded before loaded.');
      return;
    }
    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(

      onAdShowedFullScreenContent: (RewardedAd ad) =>
          print('loaded on full screen'),


      onAdDismissedFullScreenContent: (RewardedAd ad) {


        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (ctx) => ProgressScreen(
                  faceImage: _faceImage!,
                  bodyImage: _body!,
                  notRecentFace: true,
                )));


        ad.dispose();

      },
      onAdWillDismissFullScreenContent: (RewardedAd ad) {

          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (ctx) => ProgressScreen(
                    faceImage: _faceImage!,
                    bodyImage: _body!,
                    notRecentFace: true,
                  )));


        print('$ad onAdDismissedFullScreenContent.');

        ad.dispose();




      },

      onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (ctx) => ProgressScreen(
                  faceImage: _faceImage!,
                  bodyImage: _body!,
                  notRecentFace: true,
                )));
        ad.dispose();


      },
    );


    _rewardedAd!.setImmersiveMode(true);
    _rewardedAd!.show(
        onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {

          print('$ad with reward $RewardItem(${reward.amount}, ${reward.type})');
        });
    _rewardedAd = null;
  }




  showLoaderDialog(BuildContext context){
    AlertDialog alert=AlertDialog(
      backgroundColor: Color(0xFF1B1B1B),
      content:  Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            widgetUtil.verticalSpace(1.h),
            Container(margin: EdgeInsets.only(left: 7),child:Text("Loading Ad..." ,style:  TextStyle(color: Colors.white, fontSize: 8 * s))),
          ],),
      ),
    );
    showDialog(barrierDismissible: true,
      context:context,
      builder:(BuildContext context){
        return alert;
      },
    );
  }
// Future<void> loadCounter() async {
//
//   int? savedCounter = await MySharedPreferences.getCounter();
//   print(savedCounter);
//   if (savedCounter != null) {
//     setState(() {
//       _numRewardedLoadAttempts = savedCounter;
//     });
//   }
// }

// Function to increment the counter and save it to shared preferences
// Future<void> incrementCounter() async {
//   setState(() {
//     _numRewardedLoadAttempts+=2;
//   });
//   await MySharedPreferences.saveCounter(_numRewardedLoadAttempts);
// }
//
// Future<void> decrementCounter() async {
//   setState(() {
//      if( _numRewardedLoadAttempts==0||_numRewardedLoadAttempts>0){
//        _numRewardedLoadAttempts-=2;
//      }
//   });
//   await MySharedPreferences.saveCounter(_numRewardedLoadAttempts);
// }
}
