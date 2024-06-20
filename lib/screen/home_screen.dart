import 'package:cached_network_image/cached_network_image.dart';
import 'package:face_ai/api/api_const.dart';
import 'package:face_ai/models/face_sample_model.dart';
import 'package:face_ai/screen/face_category_screen.dart';
import 'package:face_ai/screen/recent_swap_screen.dart';
import 'package:face_ai/screen/subscription_screen.dart';
import 'package:face_ai/util/ad_utils.dart';
import 'package:face_ai/view_models/home_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shimmer/shimmer.dart';
import '../services/notifi_service.dart';

import '../util/app_colors.dart';
import '../util/enum.dart';
import '../util/string_utils.dart';
import '../util/widget_util.dart';
import 'custom_screen.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<HDWALLPAPERAPP> faceSampleList = [];
  late HomeViewModel _homeViewModel;
  WidgetUtil widgetUtil = WidgetUtil();
  double s = 10.h / 10.w;
  int tapCount = 0;
  InterstitialAd? _interstitialAd;
  bool _isInterstitialAdLoading =false;
  TimeOfDay _time = TimeOfDay.now();
  DateTime now = DateTime.now();








  @override
  void initState() {

    internetChecker();
    // TODO: implement initState
    _homeViewModel = Provider.of<HomeViewModel>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _homeViewModel.getCategoryList();
      print(APIConst.faceCategory);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.white,
            //change your color here
          ),
          backgroundColor: AppColors.backgroundColor,
          centerTitle: true,
          automaticallyImplyLeading: false,
          title:  Text(
            StringUtils.faceSwapText,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.sp,
              fontFamily: StringUtils.manropeFonts,
              fontWeight: FontWeight.w600,
              height: 0,
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 15),
              child:
              GestureDetector(
                onTap:shareApp,
                child: Icon(Icons.share),
              ),)
          ],
        ),
        body:Consumer<HomeViewModel>(builder: (context, item, child) {
          if (item.status == Status.loading) {
            item.clearStatus();
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (item.status == Status.success) {
            item.clearStatus();
            WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              setState(() {
                faceSampleList = item.faceList!;
                print(faceSampleList.toString());
              });
            });
          } else if (item.status == Status.failed) {
            item.clearStatus();
            print("Failerd");
          } else if (item.status == Status.noInternet) {
            item.clearStatus();
          }
          return Stack(
            children: [
              RefreshIndicator(
                onRefresh: () {
                  return Future.delayed(Duration(seconds: 1),(){
                    internetChecker();
                    _homeViewModel.getCategoryList();

                  });

                },
                child: ListView.builder(
                  itemCount: faceSampleList.length,
                      
                  itemBuilder: (ctx,index){
                    return Container(
                      width: double.infinity,
                      height: 32.h,
                      
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                      
                        children: [
                          widgetUtil.verticalSpace(1.h),
                          Padding(
                            padding:  EdgeInsets.only(left: 25,right: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                            capitalizeFirstLetter(faceSampleList[index].categoryName.toString())
                                  ,
                      
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 17.sp,
                                    fontFamily: StringUtils.SfProFonts,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (ctx)=>FaceCategoryScreen(categoryId: faceSampleList[index].categoryId.toString(), categoryName:faceSampleList[index].categoryName.toString(),))),
                                  child: Container(
                                    width: 20.w,
                                    height: 4.h,
                                    decoration: BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.circular(60)
                                    ),
                      
                                    child: Center(
                                      child: Text(
                                        'SEE ALL',
                                        style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: 11.sp,
                                          fontFamily: StringUtils.SfProFonts,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                      
                      
                              ],
                            ),
                          ),
                          SizedBox(
                      
                            width: 100.w,
                            height: 27.h,
                            child: Padding(
                              padding: const EdgeInsets.all(1.0),
                              child: ListView.builder(
                                  padding: EdgeInsets.only(left: 10.0),
                      
                                  scrollDirection: Axis.horizontal,
                                  itemCount:faceSampleList[index].wallpapers!.length ,
                                  itemBuilder: (context,i){
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                      
                                        width: 45.w,
                                        child: GestureDetector(
                                          onTap: (){
                                            setState(() {
                                              tapCount++;
                                            });
                                            if(tapCount>2){
                                              showLoaderDialog(context);
                                              _loadInterstitialAd(index,i);
                                              print(';;;;;;;;;;;;;;;;;;;;;;;;ad called;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;');
                                            }
                                            else{
                                              Navigator.push(context, MaterialPageRoute(builder: (ctx)=>CustomScreen(showButton: false, image:faceSampleList[index].wallpapers![i].wallpaperImage.toString(),)));
                      
                                            }
                      
                                          }
                      ,
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(7),
                                            child:   CachedNetworkImage(
                                              fit:BoxFit.cover ,
                      
                                              imageUrl: faceSampleList[index].wallpapers![i].wallpaperImage.toString(),
                                              placeholder: (context, url) => Shimmer.fromColors(
                                                enabled: false,
                                                baseColor:  Color(0xFF1B1B1B),
                                                highlightColor: Color(0xFF1B1B1B),
                                                child: Container(
                                                  color: Color(0xFF1B1B1B),
                                                ),
                                              ),
                                              errorWidget: (context, url, error) => Icon(Icons.error),
                                            ),
                      
                                          ),
                                        ),
                                      ),
                                    );
                      
                                  }),
                            ),
                          )
                        ],
                      ),
                      
                      
                    );
                  },
                ),
              ),
              Positioned(
                bottom: 3.h,
                left: 12.w,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    widgetUtil.logoIconButton(StringUtils.customText,
                        Icons.cloud_upload_outlined, () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => CustomScreen(showButton: true, image: '',)));
                        }),
                    widgetUtil.horizontalSpace(2.5.h),
                    widgetUtil.logoIconButton(StringUtils.resent,
                        Icons.restart_alt, () {
                Navigator.push(context, MaterialPageRoute(builder: (ctx)=>ResentSwapScreen()));

                        }),
                  ],
                ),
              )
            ],
          )
      ;
        },),
      
        ),
    );
  }




  String capitalizeFirstLetter(String input) {
    if (input == null || input.isEmpty) {
      return input;
    }
    return input.substring(0, 1).toUpperCase() + input.substring(1);
  }


  void _loadInterstitialAd(int firsIndex,int secondIndex )  {
    setState(() {
      _isInterstitialAdLoading= true;

    });
    InterstitialAd.load(
        adUnitId: AdsUtils.interstitialAdsIds,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          // Called when an ad is successfully received.
          onAdLoaded: (InterstitialAd ad) {
            Navigator.pop(context);

            ad.fullScreenContentCallback = FullScreenContentCallback(
              // Called when the ad showed the full screen content.
                onAdShowedFullScreenContent: (ad) {},
                // Called when an impression occurs on the ad.
                onAdImpression: (ad) {},
                // Called when the ad failed to show full screen content.
                onAdFailedToShowFullScreenContent: (ad, err) {
                  ad.dispose();
                },
                // Called when the ad dismissed full screen content.
                onAdDismissedFullScreenContent: (ad) {
                  setState(() {
                    tapCount=0;
                  });

                  Navigator.push(context, MaterialPageRoute(builder: (ctx)=>CustomScreen(showButton: false, image:faceSampleList[firsIndex].wallpapers![secondIndex].wallpaperImage.toString(),)));

                  ad.dispose();
                },
                // Called when a click is recorded for an ad.
                onAdClicked: (ad) {});

            // Keep a reference to the ad so you can show it later.

            setState(() {
              _interstitialAd = ad;
              _isInterstitialAdLoading= false;
            });

            _interstitialAd?.show();

          },
          // Called when an ad request failed.
          onAdFailedToLoad: (LoadAdError error) {
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (ctx)=>CustomScreen(showButton: false, image:faceSampleList[firsIndex].wallpapers![secondIndex].wallpaperImage.toString(),)));

            // ignore: avoid_print
            print('InterstitialAd failed to load: $error');
          },
        ));





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


  showInternetDialog(BuildContext context){
    AlertDialog alert=AlertDialog(
      backgroundColor: Color(0xFF1B1B1B),
      content:  Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SizedBox(

          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              widgetUtil.verticalSpace(1.h),
              Text("No Internet Connected" ,style:  TextStyle(color: Colors.white, fontSize: 8 * s)),
              widgetUtil.verticalSpace(2.h),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: Text('OK',style:  TextStyle(color: Colors.blue, fontSize: 8 * s)),
              ),
            ],),
        ),
      ),
    );
    showDialog(barrierDismissible: true,
      context:context,
      builder:(BuildContext context){
        return alert;
      },
    );
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
internetChecker() async{
  bool result = await InternetConnectionChecker().hasConnection;
  if(result == true) {
    print('connected ');
  } else {
    _showAlertDialog(context);

  }
}



shareApp()async{

    await Share.share('https://apps.apple.com/us/app/ai-face-Swap/id6499244231',subject: 'Swap Image with AI Face Swap');

}


}


