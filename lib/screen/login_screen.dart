import 'package:face_ai/screen/home_screen.dart';
import 'package:face_ai/screen/sign_up_screen.dart';
import 'package:face_ai/util/app_colors.dart';
import 'package:face_ai/util/string_utils.dart';
import 'package:face_ai/util/widget_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  WidgetUtil widgetUtil = WidgetUtil();
  bool hidePassword = true;
  bool checkedValue = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Center(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              widgetUtil.verticalSpace(15.h),

              Text(
                StringUtils.loginWelcomeText,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22.61,
                  fontFamily: StringUtils.manropeFonts,
                  fontWeight: FontWeight.w600,
                  height: 0,
                ),
              ),
              Text(
                StringUtils.loginGratingText,
                style: TextStyle(
                  color: Color(0xFF999EA1),
                  fontSize: 12.66,
                  fontFamily: StringUtils.manropeFonts,
                  fontWeight: FontWeight.w600,
                  height: 0,
                ),
              ),
              widgetUtil.verticalSpace(8.h),
              widgetUtil.CustomTextField(
                  StringUtils.emailLabel, StringUtils.emailHint),
              widgetUtil.verticalSpace(1.h),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    StringUtils.passwordText,
                    style: TextStyle(
                      color: Color(0xFF4AADC3),
                      fontSize: 12.66,
                      fontFamily: StringUtils.manropeFonts,
                      fontWeight: FontWeight.w600,
                      height: 0,
                    ),
                  ),
                  SizedBox(
                    height: 0.6.h,
                  ),
                  SizedBox(
                    height: 5.h,
                    child: TextFormField(
                      obscureText: hidePassword,
                      cursorColor: Colors.black,
                      decoration: InputDecoration(
                        hintText: StringUtils.passwordHint,
                        hintStyle: TextStyle(
                          color: Color(0xFF9E9E9E),
                          fontSize: 12.66,
                          fontFamily: StringUtils.manropeFonts,
                          fontWeight: FontWeight.w600,
                          height: 0,
                        ),
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              hidePassword = !hidePassword;
                            });
                          },
                          child: Padding(
                            padding: EdgeInsets.only(right: 20),
                            child: hidePassword
                                ? Icon(
                                    Icons.visibility,
                                    size: 20,
                                  )
                                : Icon(
                                    Icons.visibility_off,
                                    size: 20,
                                  ),
                          ),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: EdgeInsets.only(left: 3.w),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                          borderRadius:
                              BorderRadius.circular(10), // Change color here
                        ),
                      ),
                    ),
                  )
                ],
              ),
              widgetUtil.verticalSpace(1.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      GestureDetector(
                          onTap: () {
                            setState(() {
                              checkedValue = !checkedValue;
                            });
                          },
                          child: checkedValue
                              ? Icon(
                                  Icons.check_box,
                                  color: Colors.white,
                                )
                              : Icon(
                                  Icons.square_outlined,
                                  color: Colors.white,
                                )),
                      widgetUtil.horizontalSpace(1.h),
                      Text(
                        StringUtils.rememberText,
                        style: TextStyle(
                          color: Color(0xFF4AADC3),
                          fontSize: 14,
                          fontFamily: StringUtils.manropeFonts,
                          fontWeight: FontWeight.w600,
                          height: 0,
                        ),
                      ),
                    ],
                  ),
                  widgetUtil.horizontalSpace(21.w),
                  GestureDetector(
                    onTap: () {},
                    child: Text(
                      StringUtils.forgotPasswordText,
                      style: TextStyle(
                        color: Color(0xFF5F5F5F),
                        fontSize: 12.66,
                        fontFamily: StringUtils.manropeFonts,
                        fontWeight: FontWeight.w600,
                        height: 0,
                      ),
                    ),
                  )
                ],
              ),
              widgetUtil.verticalSpace(3.h),
              widgetUtil.customButton(
                  StringUtils.loginText,
                  () => Navigator.push(context,
                      // MaterialPageRoute(builder: (_) => HomeScreen()))),
                      MaterialPageRoute(builder: (_) => HomeScreen()))),
              widgetUtil.verticalSpace(3.h),
              // widgetUtil.devider(),
              Row(children: <Widget>[
                Expanded(child: Divider()),
                Text(
                  StringUtils.orWithText,
                  style: TextStyle(
                    color: Color(0xFF999EA1),
                    fontSize: 12.66,
                    fontFamily: 'Manrope',
                    fontWeight: FontWeight.w600,
                    height: 0,
                  ),
                ),
                Expanded(child: Divider()),
              ]),

              widgetUtil.verticalSpace(3.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  widgetUtil.customLogoButton(
                      StringUtils.facebookText, 'assets/images/google.webp'),
                  widgetUtil.horizontalSpace(1.w),
                  widgetUtil.customLogoButton(
                      StringUtils.googleText, 'assets/images/facebook.webp'),
                ],
              ),
              widgetUtil.verticalSpace(23.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.w),
                child: Center(
                  child: GestureDetector(
                    onTap: () => Navigator.push(context,
                        MaterialPageRoute(builder: (_) => SignUpScreen())),
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: StringUtils.haveNotAccount,
                            style: TextStyle(
                              color: Color(0xFF999EA1),
                              fontSize: 12.66,
                              fontFamily: StringUtils.manropeFonts,
                              fontWeight: FontWeight.w600,
                              height: 0,
                            ),
                          ),
                          TextSpan(
                            text: StringUtils.signUpText,
                            style: TextStyle(
                              color: Color(0xFF4AADC3),
                              fontSize: 12.66,
                              fontFamily: StringUtils.manropeFonts,
                              fontWeight: FontWeight.w600,
                              height: 0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          )),
        ),
      ),
    );
  }
}
