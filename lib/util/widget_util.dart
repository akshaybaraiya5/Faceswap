import 'package:face_ai/util/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:share_plus/share_plus.dart';
double s = 10.h/10.w;
class WidgetUtil {
  Widget CustomTextField(String labelText, String hintText) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: TextStyle(
            color: Color(0xFF4AADC3),
            fontSize: 12.66,
            fontFamily: 'Manrope',
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
            cursorColor: Colors.black,
            decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.circular(10),// Change color here
              ),


                hintText: hintText,
                hintStyle: TextStyle(
                  color: Color(0xFF9E9E9E),
                  fontSize: 12.66,
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.w600,
                  height: 0,
                ),
                filled: true,

                fillColor: Colors.white,
                contentPadding: EdgeInsets.only(left: 3.w),
                border: OutlineInputBorder(

                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),


            ),
          ),
        )
      ],
    );
  }




  Widget customButton(String buttonText,VoidCallback onPressed){
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: double.infinity,
        height: 5.h,
        decoration: ShapeDecoration(
          color: Color(0xFF4AADC3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(9.04),
          ),
        ),
        child: Center(
          child: Text(
            buttonText,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 15.38,
              fontFamily: 'Manrope',
              fontWeight: FontWeight.w900,
              height: 0,
            ),
          ),
        ),
      ),
    );
  }

  Widget devider(){
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Container(
        width: 35.w,
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            side: BorderSide(
              width: 0.45,
              strokeAlign: BorderSide.strokeAlignCenter,
              color: Colors.white,
            ),
          ),
        ),
      ),
      Text(
        'Or With',
        style: TextStyle(
          color: Color(0xFF999EA1),
          fontSize: 12.66,
          fontFamily: 'Manrope',
          fontWeight: FontWeight.w600,
          height: 0,
        ),
      ),
      Container(
        width: 35.w,
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            side: BorderSide(
              width: 0.45,
              strokeAlign: BorderSide.strokeAlignCenter,
              color: Colors.white,
            ),
          ),
        ),
      ),
    ],
  );

  }


  Widget customLogoButton(String buttonText ,String ImagePath ){
    return Container(
     height: 5.h,
     width: 42.w,

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: AppColors.whiteColor,
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 30,
              child: Image.asset(ImagePath),
            ),
            SizedBox(
              width: 3.w,
      
            ),
            Text(
              buttonText,
              style: TextStyle(
                color: Color(0xFF242A31),
                fontSize: 12.66,
                fontFamily: 'Manrope',
                fontWeight: FontWeight.bold,
                height: 0,
              ),
            ),
            horizontalSpace(2.h)
          ],
        ),
      ),
    );
  }

  Widget horizontalSpace(double space ){
    return SizedBox(
      width: space,
    );
  }
  Widget verticalSpace(double space ){
    return SizedBox(
      height: space,
    );
  }

  Widget tabBar() {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 54,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(color: Color(0xFF111212)),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.only(top: 8, left: 8, right: 16, bottom: 8),
                clipBehavior: Clip.antiAlias,
                decoration: ShapeDecoration(
                  color: Color(0xFF17EED4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(19),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 30,
                      height: 30,
                      padding: const EdgeInsets.all(2.40),
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(),
                      child: Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [

                            Image.asset('assets/images/menu.png'),
                          ],
                        ),
                      ),
                    ),
                    Text(
                      'All',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 8*s,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        height: 0.08,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top: 8, left: 8, right: 16, bottom: 8),
                clipBehavior: Clip.antiAlias,
                decoration: ShapeDecoration(
                  color: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(19),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 8.w,
                      height: 40,
                      padding: const EdgeInsets.symmetric(horizontal: 4.20, vertical: 1.80),
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset('assets/images/baby.png'),

                        ],
                      ),
                    ),
                    Text(
                      'Ambient',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 8*s,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        height: 0.08,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top: 8, left: 8, right: 16, bottom: 8),
                clipBehavior: Clip.antiAlias,
                decoration: ShapeDecoration(
                  color: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(19),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 8.w,
                      height: 30,
                      padding: const EdgeInsets.symmetric(horizontal: 1.79, vertical: 1.80),
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset('assets/images/child.png'),
                        ],
                      ),
                    ),
                    Text(
                      'For Kids',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 8*s,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        height: 0.08,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
  Widget logoIconButton(String title,IconData icon,VoidCallback onPressed){
    return  GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 35.w,
        height: 6.h,

        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(60),
          color: Color(0xff00FFE0),
          boxShadow: [
            BoxShadow(
              color: Colors.black,
              offset: Offset(0.0, 3.0), //(x,y)
              blurRadius: 3.0,
            ),
          ],
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon,size: 4.h,),
              SizedBox(
                width: 10,
              ),
              Text(
                title,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 6*s,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                  height: 0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
}

  Widget logoIconButtonLarge(String title,IconData icon,VoidCallback onPressed){
    return  GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 42.w,
        height: 7.h,

        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Color(0xFF262626),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon,size: 4.h,color: AppColors.whiteColor,),
              SizedBox(
                width: 10,
              ),
              Text(
                title,
                style: TextStyle(
                  color: AppColors.whiteColor,
                  fontSize: 5*s,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                  height: 0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
}


Widget customSqureIconButton(String title,IconData icon,VoidCallback onPressed){
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.all(8),
        width: 79,
        height: 79,
        decoration: ShapeDecoration(
          color: Color(0xFF1B1B1B),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            Icon(icon,color: Colors.white,size: 30,),
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 6*s,
                fontFamily: 'Manrope',
                fontWeight: FontWeight.bold,


              ),
            )
          ],
        ),
      ),
    );
}
Widget customCircleIconButton(String title,IconData icon,int fontSize,VoidCallback onPressed){
    return GestureDetector(
      onTap: onPressed,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 15),

            width: 70,
            height: 70,
            decoration: ShapeDecoration(
              color: Color(0xFF1B1B1B),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(60),
              ),
            ),
            child:  Icon(icon,color: Colors.white,size: 30,),
          ),
          verticalSpace(1.h),
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: fontSize.sp,
              fontFamily: 'Manrope',
              fontWeight: FontWeight.bold,


            ),
          )
        ],
      ),
    );
}



Widget customBottomItems(IconData icon,String title){
    return Container(

      width: 10.h,
      height: 10.h,

      decoration: BoxDecoration(
          color:    Color(0xFF262626),
          borderRadius: BorderRadius.circular(60)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon,color: Colors.white,size: 25,),
          verticalSpace(0.7.h),
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 7*s,
              fontFamily: 'Manrope',
              fontWeight: FontWeight.bold,
              height: 0,
            ),
          )
        ],
      ),
    );
}


  Widget planItems(String title,IconData icon){
    return Row(
      children: [
        Container(
          width: 5.w,
          height: 22,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(),
          child: Stack(children: [
              Icon(icon,color:  Color(0xFF66F2FE),size: 20,),

              ]),
        ),
        horizontalSpace(10),
        Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 9*s,
            fontFamily: 'Rambla',
            fontWeight: FontWeight.w400,
            height: 0,
          ),
        )
      ],
    );
  }
  Widget choosePlanButton(String title,IconData icon,bool index){
    return  Container(
      width: double.infinity,
      height: 7.h,

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),

          border: Border.all(color:index ? Color(0xFF69F6FF):Color( 0xff5A5A5A),width: 2.0,),


      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          horizontalSpace(5.w),
          Icon(icon,color: Colors.white,),
          horizontalSpace(5.w),
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 10*s,
              fontFamily: 'Rambla',
              fontWeight: FontWeight.w400,
              height: 0,
            ),
          )
        ],
      ),

    );
  }


  Widget gradientButton(String text, VoidCallback Onclick){
   return GestureDetector(
     onTap: Onclick,
     child: Container(
        width: double.infinity,
         height: 7.h,
         decoration: ShapeDecoration(
           gradient: LinearGradient(
             begin: Alignment(1.00, -0.04),
             end: Alignment(-1, 0.04),
             colors: [Color(0xFF00FFE0), Color(0xFF0093FF)],
           ),
           shape: RoundedRectangleBorder(
             borderRadius: BorderRadius.circular(10),
           ),
         ),
       child: Center(
         child: Text(
           'Continue',
           style: TextStyle(
             color: Colors.black,
             fontSize: 10*s,
             fontFamily: 'Rambla',
             fontWeight: FontWeight.w700,
             height: 0,
           ),
         ),
       ),
      ),
   );
  }

  Widget planDialog(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Stack(
        children: [
          Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/dialoge.png'),
                  fit: BoxFit.cover),
            ),
          ),
          Positioned(
              right: 2,
              child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(
                  Icons.close,
                  color: Colors.grey,
                ),
              )),
        ],
      ),
    );
  }
}





