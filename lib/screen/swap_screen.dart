import 'dart:async';
import 'dart:core';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:io' as io;
import 'package:before_after/before_after.dart';
import 'package:dio/dio.dart';

import 'package:face_ai/models/swap_model.dart';
import 'package:face_ai/screen/full_screen_image.dart';
import 'package:face_ai/services/face_database_helper.dart';
import 'package:face_ai/util/string_utils.dart';
import 'package:face_ai/util/widget_util.dart';
import 'package:face_ai/view_models/face_swap_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:http/http.dart' as http;
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_watermark/image_watermark.dart';
import 'package:matrix_gesture_detector/matrix_gesture_detector.dart';

import 'package:path_provider/path_provider.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/shared_pref_list.dart';
import '../util/app_colors.dart';
import '../util/enum.dart';

class SwapScreen extends StatefulWidget {
  File faceImage;
  File bodyImage;
  File swappedImage;
  String? jobId;
  bool notRecentFace;

  SwapScreen({
    required this.faceImage,
    required this.bodyImage,
    required this.swappedImage,
    this.jobId,
    required this.notRecentFace,
  });

  @override
  State<SwapScreen> createState() => _SwapScreenState();
}

class _SwapScreenState extends State<SwapScreen> {
  WidgetUtil widgetUtil = WidgetUtil();
  bool isLoading = false;
  bool faceSwaped = false;
  bool loadSwapImage = false;
  var random = Random();
  int swapCredit = 0;
  ValueNotifier downloadProgressNotifier = ValueNotifier(0);
  List<Map<String, dynamic>> data = [];
  List _imageFiles = [];

  // String jobId = 'fjdsifbhdsbuhfbdshbfhbdshfbhdsb';

  bool _isLoading = true;
  late FaceSwapViewModel _swapViewModel;
  SharedPreferences? _prefs;
  List<String> myStringList = [];
  //
  // String imageUrl =
  //    'https://encrypted-tbn2.gstatic.com/licensed-image?q=tbn:ANd9GcQRt_0WRr8Mc016RGaTK8eaiv6dSHKuNjIwdUrnF_7Xa_GdQL9YX9f4le5qucuyVUpKxbo7gqIGC0pZo14';

  var value = 0.2;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initPrefs();
    _swapViewModel = Provider.of<FaceSwapViewModel>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {});
  }

  Future<Uint8List> covertToWaterMark(Uint8List image) async {
    var watermarkedImgBytes = await ImageWatermark.addImageWatermark(
      originalImageBytes: image,
      //image bytes
      waterkmarkImageBytes: await convert(),
      //watermark img bytes
      imgHeight: 60,
      //watermark img height
      imgWidth: 60,
      //watermark img width
      dstY: 930,
      //watermark position Y
      dstX: 40, //watermark position X
    );
    return watermarkedImgBytes;
  }

  Future<Uint8List> convert() async {
    final ByteData bytes = await rootBundle.load('assets/images/FaceLogo.png');
    final Uint8List list = bytes.buffer.asUint8List();
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
          //change your color here
        ),
        backgroundColor: AppColors.backgroundColor,
        centerTitle: true,
      ),
      backgroundColor: AppColors.backgroundColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                widget.faceImage == null
                    ? Container(
                        width: 10.h,
                        height: 10.h,
                        decoration: ShapeDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/noImage.png'),
                            fit: BoxFit.fill,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      )
                    : Container(
                        width: 10.h,
                        height: 10.h,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.file(
                              widget.faceImage,
                              fit: BoxFit.cover,
                            )),
                      ),

                // Icon(
                //   Icons.arrow_forward,
                //   color: Colors.white,
                // ),
                widgetUtil.horizontalSpace(5.w),
                Icon(
                  Icons.arrow_forward_rounded,
                  color: Colors.white,
                  size: 35,
                ),
                // widgetUtil.customSqureIconButton(
                //     'Swap', Icons.arrow_forward, () async {
                //   showSwappingDialog(context);
                //   // //
                //   // //
                //   // //
                //   // // first api called
                //   // if (swapCredit == 0) {
                //   //   ScaffoldMessenger.of(context).showSnackBar(
                //   //     const SnackBar(
                //   //
                //   //         backgroundColor: Colors.red,
                //   //         content: Center(
                //   //             child:
                //   //             Text('You have\'t more credit'))),
                //   //   );
                //   // } else {
                //   //   decrementCounter();
                //   //   await item.swapImage(
                //   //       widget.bodyImage, widget.faceImage);
                //   //
                //   //   print(
                //   //       '::::::::::::::::::::face swapped :::::::::::::::::::::::::::::');
                //   // }
                // }),
                widgetUtil.horizontalSpace(5.w),

                widget.faceImage == null
                    ? Container(
                        width: 10.h,
                        height: 10.h,
                        decoration: ShapeDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/noImage.png'),
                            fit: BoxFit.fill,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      )
                    : Container(
                        width: 10.h,
                        height: 10.h,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.file(
                              widget.bodyImage,
                              fit: BoxFit.cover,
                            )),
                      ),
              ],
            ),
          ),
          widgetUtil.verticalSpace(4.h),
          // before: ClipRRect(
          //     borderRadius: BorderRadius.circular(10),
          //     child: Image.file(widget.bodyImage,fit: BoxFit.cover,)),
          // after:

          Container(
            width: 90.w,
            height: 55.h,
            decoration: BoxDecoration(
                color: Color(0xFF262626),
                borderRadius: BorderRadius.circular(10)),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: BeforeAfter(
                thumbDecoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(60),
                ),
                trackColor: Colors.white,
                trackWidth: 2.0,
                value: value,
                after: Stack(
                  children: [
                    Container(
                        width: 90.w,
                        height: 60.h,
                        child: Image.file(
                          widget.bodyImage,
                          fit: BoxFit.cover,
                        )),
                    Positioned(
                      bottom: 2.h,
                      left: 2.h,
                      child: Container(
                        height: 3.h,
                        width: 3.h,
                        child: Image.asset('assets/images/FaceLogo.png'),
                      ),
                    )
                  ],
                ),
                before: Stack(
                  children: [
                    Container(
                        width: 90.w,
                        height: 60.h,
                        child: Image.file(
                          widget.swappedImage!,
                          fit: BoxFit.cover,
                        )),
                    Positioned(
                      bottom: 2.h,
                      left: 2.h,
                      child: Container(
                        height: 3.h,
                        width: 3.h,
                        child: Image.asset('assets/images/FaceLogo.png'),
                      ),
                    )
                  ],
                ),
                direction: SliderDirection.horizontal,
                onValueChanged: (value) {
                  setState(() => this.value = value);
                },
              ),
            ),
          ),
          widgetUtil.verticalSpace(5.h),
          Container(
            width: double.infinity,

            // decoration: BoxDecoration(color: Color(0xFF262626)),
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                widgetUtil.customCircleIconButton(StringUtils.shareText,
                    Icons.share, 13, () => _shareImageFromUrl(context)),
                widgetUtil.customCircleIconButton(
                  StringUtils.saveText,
                  Icons.save_outlined,
                  13,
                  () => _downloadImage(context),
                ),
                // widgetUtil.customBottomItems(
                //     Icons.delete_outline, StringUtils.deleteText,(){
                //
                // }),
                widgetUtil.customCircleIconButton(
                    StringUtils.viewText,
                    Icons.crop_free,
                    13,
                    () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => FullScreenImage(
                                  image: widget.swappedImage!.path,
                                  fileImage: true,
                                )))),
              ],
            ),
          )
        ],
      ),
    );
  }

  Future<void> _shareImageFromUrl(BuildContext ctx) async {
    try {
      await Share.shareFiles([widget.swappedImage.path],
          text: 'Check out this image!');
    } catch (e) {
      print('Error sharing image: $e');
    }
  }

  Future<void> _downloadImage(BuildContext context) async {
    var status = await Permission.storage.request();
    if (status.isGranted) {
      if (myStringList.contains(widget.jobId.toString())) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              duration: Duration(milliseconds: 1000),
              backgroundColor: Colors.red,
              content: Center(child: Text('Image Already Downloaded'))),
        );
      } else {
        var waterMarkImage =
            await covertToWaterMark(widget.swappedImage.readAsBytesSync());
        ImageGallerySaver.saveImage(
            Uint8List.fromList(waterMarkImage),
            name: widget.jobId);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              duration: Duration(milliseconds: 1000),
              content: Center(child: Text('Image  Downloaded'))),
        );

        // StringUtils.path.add(widget.jobId);
        _addItemToList(widget.jobId.toString());
        print(
            '${StringUtils.path.toString()}::;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;');
      }

      // Navigator.pop(context);
    }
  }




  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    _loadList();
  }

  void _loadList() {
    if (_prefs!.containsKey('myList')) {
      setState(() {
        myStringList = _prefs!.getStringList('myList')!;
      });
      print(':::::::::::::::::::::::${myStringList.toString()}');
    }
  }

  void _saveList() {
    _prefs!.setStringList('myList', myStringList);
  }

  void _addItemToList(String newItem) {
    setState(() {
      myStringList.add(newItem);
    });
    _saveList();
  }


}
