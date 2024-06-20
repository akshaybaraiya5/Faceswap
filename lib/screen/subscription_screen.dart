import 'package:face_ai/util/string_utils.dart';
import 'package:face_ai/util/widget_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

import '../util/app_colors.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  int currentIndex = 0;
  double s = 10.h / 10.w;
  WidgetUtil widgetUtil = WidgetUtil();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        actions: [
          IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(
                Icons.cancel,
                size: 30,
              )),
          widgetUtil.horizontalSpace(2.w)
        ],
      ),
      backgroundColor: AppColors.backgroundColor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                widgetUtil.verticalSpace(13.h),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: StringUtils.faceText,
                        style: TextStyle(
                          color: Color(0xFF66F2FE),
                          fontSize: 16 * s,
                          fontFamily: StringUtils.padalomaFonts,
                          fontWeight: FontWeight.w400,
                          height: 0,
                        ),
                      ),
                      WidgetSpan(
                        child: SizedBox(width: 2.w),
                      ),
                      TextSpan(
                        text: StringUtils.hubText,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16 * s,
                          fontFamily: StringUtils.padalomaFonts,
                          fontWeight: FontWeight.w400,
                          height: 0,
                        ),
                      ),
                    ],
                  ),
                ),
                widgetUtil.verticalSpace(3.h),
                widgetUtil.planItems(StringUtils.planItem1Text,Icons.check_circle),
                widgetUtil.verticalSpace(1.h),
                widgetUtil.planItems(StringUtils.planItem2Text,Icons.check_circle),
                widgetUtil.verticalSpace(1.h),
                widgetUtil.planItems(StringUtils.planItem3Text,Icons.check_circle),
                widgetUtil.verticalSpace(1.h),
                widgetUtil.planItems(StringUtils.planItem4Text,Icons.check_circle),
                widgetUtil.verticalSpace(4.h),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      currentIndex = 0;
                    });
                  },
                  child: widgetUtil.choosePlanButton(
                      StringUtils.planPrice1Text,
                      currentIndex == 0
                          ? Icons.check_circle
                          : Icons.circle_outlined,
                      currentIndex == 0 ? true : false),
                ),
                widgetUtil.verticalSpace(2.h),
                GestureDetector(
                    onTap: () {
                      setState(() {
                        currentIndex = 1;
                      });
                    },
                    child: widgetUtil.choosePlanButton(
                        StringUtils.planPrice2Text,
                        currentIndex == 1
                            ? Icons.check_circle
                            : Icons.circle_outlined,
                        currentIndex == 1 ? true : false)),
                widgetUtil.verticalSpace(4.h),
                widgetUtil.gradientButton(StringUtils.continueText, () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return widgetUtil.planDialog(context);
                    },
                  );
                }),
                widgetUtil.verticalSpace(5.h),
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    StringUtils.subscriptionBottomText,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 5.6 * s,
                      fontFamily: StringUtils.ramblaFonts,
                      fontWeight: FontWeight.w400,
                      height: 0,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

