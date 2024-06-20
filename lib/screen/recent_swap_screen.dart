import 'dart:io';
import 'package:face_ai/screen/swap_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:path_provider/path_provider.dart';


import '../models/face_wallpaper_model.dart';
import '../services/face_database_helper.dart';
import '../util/ad_utils.dart';
import '../util/app_colors.dart';
import '../util/enum.dart';
import '../util/string_utils.dart';
import '../util/widget_util.dart';

class ResentSwapScreen extends StatefulWidget {

  ResentSwapScreen({Key? key});

  @override
  State<ResentSwapScreen> createState() => _ResentSwapScreenState();
}

class _ResentSwapScreenState extends State<ResentSwapScreen> {
  List<Map<String, dynamic>> data =[];
  late BannerAd _bannerAd;
  bool _isBannerAdReady = false;
  List _imageFiles =[];



  bool _isLoading = true;


  void getData() async {
    var userData = await DatabaseHelper.getSwapFace();
    setState(() {
      data =userData ;
      _isLoading = false;
    });
    loadAdd(data.length);
    print(data.length);
    // print('your data is ${userData.toString()}');
  }



  double s = 10.h / 10.w;
  WidgetUtil widgetUtil = WidgetUtil();






  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
    // _loadImages();

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
          //change your color here
        ),
        // actions: [
        //   SizedBox(
        //     height: 45,
        //       child: Image.asset('assets/images/crown.png')),
        //   widgetUtil.horizontalSpace(10)
        //
        // ],
        backgroundColor: AppColors.backgroundColor,
        centerTitle: true,

        title:  Text(
          StringUtils.resent,
          style: TextStyle(
            color: Colors.white,
            fontSize: 10*s,
            fontFamily: StringUtils.manropeFonts,
            fontWeight: FontWeight.w600,
            height: 0,
          ),
        ),
      ),
      body:
      _isLoading?Center(child: CircularProgressIndicator(),):
      data.isEmpty? Center(child:  Text(
        StringUtils.noResentImages,
        style: TextStyle(
          color: Colors.white,
          fontSize: 10*s,
          fontFamily: StringUtils.manropeFonts,
          fontWeight: FontWeight.w600,
          height: 0,
        ),
      ),):

      Column(
        children: [
          SizedBox(
            height: 80.h,
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: 2 / 2.3,
                crossAxisCount: 2, // number of items in each row
                mainAxisSpacing: 15.0, // spacing between rows
                crossAxisSpacing: 15.0, // spacing between columns
              ),

              padding: EdgeInsets.all(8.0), // padding around the grid
              itemCount: data.length, // total number of items
              itemBuilder: (context, index) {
                return Container(


                  height: 25.h,
                  child: Stack(


                    children: [
                      Container(
                        height: double.infinity,

                        padding: EdgeInsets.all(3),




                        width: double.infinity,
                        child: GestureDetector(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (ctx)=>SwapScreen(faceImage: File(data[index][DatabaseHelper.swapFacePath]), bodyImage: File(data[index][DatabaseHelper.swapBodyPath]),swappedImage: File(data[index][DatabaseHelper.swapPath]),notRecentFace: false,jobId: data[index][DatabaseHelper.jobId],)));

                          },
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.file(File(data[index][DatabaseHelper.swapPath]),fit: BoxFit.cover,)

                          ),
                        ),
                        decoration: BoxDecoration(

                            borderRadius: BorderRadius.circular(10)

                        ),
                      ),
                      Positioned(
                        bottom: 10,
                        right: 10,
                        child: GestureDetector(
                          onTap: (){
                            _showDeleteDialog(context,index);




                          },
                          child: Container(
                            padding: EdgeInsets.all(8),
                            width: 35,
                            height: 35,
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
                              size: 20,
                            ),
                          ),
                        ),
                      ),



                    ],

                  ),
                );
              },
            ),
          ),
          Container(color: Colors.black,
            height: 7.h,
            width: double.infinity,
            child: _isBannerAdReady
                ? Container(
                width: double.infinity,
                height: _bannerAd.size.height.toDouble(),
                child: AdWidget(ad: _bannerAd))
                : Container(),
          )
        ],
      ),

    );
  }

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

  Future<void> _showDeleteDialog(BuildContext context ,int index) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xFF1B1B1B),
          content: Text(
            'Do you want to remove this recent swap?',
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
                      Navigator.of(context).pop();
                        DatabaseHelper.deleteSwap(data[index][DatabaseHelper.swapId]);
                        deleteFile(data[index][DatabaseHelper.swapPath]);
                        deleteFile(data[index][DatabaseHelper.swapFacePath]);
                        deleteFile(data[index][DatabaseHelper.swapBodyPath]);
                        getData();

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

  void _loadBannerAd() {
    _bannerAd = BannerAd(
      adUnitId: AdsUtils.bannerAdsIds,
      request: AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            _isBannerAdReady = true;
          });
        },
        onAdFailedToLoad: (ad, err) {
          _isBannerAdReady = false;
          ad.dispose();
        },
      ),
    );

    _bannerAd.load();
  }


  loadAdd(int recentCount){
    if(recentCount>10){
      _loadBannerAd();
    }

  }






}
