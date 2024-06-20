import 'dart:io';

import 'package:face_ai/services/zoom_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zoom_widget/zoom_widget.dart';

class FullScreenImage extends StatefulWidget {
  String image;
  bool fileImage;
   FullScreenImage({required this.image,required  this.fileImage});

  @override
  State<FullScreenImage> createState() => _FullScreenImageState();
}

class _FullScreenImageState extends State<FullScreenImage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
      ),
      
      body: Center(
        child: Container(
          width: size.width,
          height: size.height,
          child: Zoom(
            backgroundColor: Colors.black,
            doubleTapZoom: false,
            initTotalZoomOut: true,


            child:  widget.fileImage? Image.file(File(widget.image)): Image.network(widget.image,),
          ),
        ),
      ),



    );
  }
}
