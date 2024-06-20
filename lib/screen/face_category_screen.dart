import 'package:cached_network_image/cached_network_image.dart';
import 'package:face_ai/api/api_const.dart';
import 'package:face_ai/screen/custom_screen.dart';
import 'package:face_ai/util/ad_utils.dart';

import 'package:face_ai/view_models/face_wallpaper_view_model.dart';
import 'package:face_ai/view_models/home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../models/face_wallpaper_model.dart';
import '../util/app_colors.dart';
import '../util/enum.dart';
import '../util/string_utils.dart';
import '../util/widget_util.dart';

class FaceCategoryScreen extends StatefulWidget {
  String categoryId;
  String categoryName;

  FaceCategoryScreen({required this.categoryId, required this.categoryName});

  @override
  State<FaceCategoryScreen> createState() => _FaceCategoryScreenState();
}

class _FaceCategoryScreenState extends State<FaceCategoryScreen> {
  List<HDWALLPAPERAPP> wallpaperList = [];
  late FaceWallpaperViewModel _faceWallpaperViewModel;
  double s = 10.h / 10.w;
  WidgetUtil widgetUtil = WidgetUtil();
  late BannerAd _bannerAd;
  bool _isBannerAdReady = false;

  @override
  void initState() {
    _loadBannerAd();
    internetChecker();
    // TODO: implement initState
    _faceWallpaperViewModel =
        Provider.of<FaceWallpaperViewModel>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _faceWallpaperViewModel.getWallpaperList(widget.categoryId);
      print(APIConst.faceWallpaper);
    });
    super.initState();
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

        title: Text(
          capitalizeFirstLetter( widget.categoryName)
         ,
          style: TextStyle(
            color: Colors.white,
            fontSize: 10 * s,
            fontFamily: StringUtils.manropeFonts,
            fontWeight: FontWeight.w600,
            height: 0,
          ),
        ),
      ),
      body: Consumer<FaceWallpaperViewModel>(
        builder: (context, item, child) {
          if (item.status == Status.loading) {
            item.clearStatus();
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (item.status == Status.success) {
            item.clearStatus();
            WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              setState(() {
                wallpaperList = item.wallpaperList!;
              });
            });
          } else if (item.status == Status.failed) {
            item.clearStatus();
            print("Failerd");
          } else if (item.status == Status.noInternet) {
            item.clearStatus();
          }
          return SizedBox(
            height: 90.h,
            child: Column(
              children: [
                Container(
                  height: 80.h,
                  child: RefreshIndicator(
                    onRefresh: () {
                      return Future.delayed(Duration(seconds: 1),(){
                        internetChecker();
                        _faceWallpaperViewModel.getWallpaperList(widget.categoryId);

                      });
                    },
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        childAspectRatio: 2 / 2.3,
                        crossAxisCount: 2, // number of items in each row
                        mainAxisSpacing: 20.0, // spacing between rows
                        crossAxisSpacing: 20.0, // spacing between columns
                      ),

                      padding: EdgeInsets.all(8.0), // padding around the grid
                      itemCount: wallpaperList.length, // total number of items
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (ctx) => CustomScreen(
                                      showButton: false,
                                      image: wallpaperList[index]
                                          .postImage
                                          .toString()))),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: CachedNetworkImage(
                              fit: BoxFit.cover,
                              imageUrl: wallpaperList[index].postImage.toString(),
                              placeholder: (context, url) => Shimmer.fromColors(
                                enabled: false,
                                baseColor: Color(0xFF1B1B1B),
                                highlightColor: Color(0xFF1B1B1B),
                                child: Container(
                                  color: Color(0xFF1B1B1B),
                                ),
                              ),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                            ),
                          ),
                        );
                      },
                    ),
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
        },
      ),
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

  String capitalizeFirstLetter(String input) {
    if (input == null || input.isEmpty) {
      return input;
    }
    return input.substring(0, 1).toUpperCase() + input.substring(1);
  }


  internetChecker() async{
    bool result = await InternetConnectionChecker().hasConnection;
    if(result == true) {
      print('connected ');
    } else {
      _showAlertDialog(context);

    }
  }

  void _showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xFF1B1B1B),
          title:  Center(child: Text('No Internet Connection',style:  TextStyle(color: Colors.white, fontSize: 8*s))),
          actions: <Widget>[
            GestureDetector(
              child:  Center(child: Text('ok',style:  TextStyle(color: Colors.blueAccent, fontSize: 8*s))),
              onTap: () {
                Navigator.of(context).pop();
              },
            ),

          ],
        );
      },
    );
  }

}
