//
// import 'dart:io';
// import 'dart:typed_data';
//
// import 'package:flutter_image_compress/flutter_image_compress.dart';
// import 'package:image_cropper/image_cropper.dart';
// import 'package:native_image_cropper/native_image_cropper.dart';
// import 'package:path_provider/path_provider.dart';
//
// class CropImage {
// static cropImage (Uint8List file) async{
//
//
//   // CroppedFile? cropFile =  await  ImageCropper().cropImage(sourcePath:file.path );
//   final cropFile = await NativeImageCropper.cropRect(
//     bytes: file,
//     x: 0,
//     y: 0,
//     width: 500,
//     height: 500,
//   );
//
//
//   return File(await saveUint8ListAsFile(cropFile, cropFile.toString()));
//
// }
//
//
// static Future<String> saveUint8ListAsFile(Uint8List uint8List, String fileName) async {
//   // Get the directory where you want to save the file
//   Directory directory = await getApplicationDocumentsDirectory();
//   String filePath = '${directory.path}/$fileName.png';
//
//   // Write the Uint8List data to a file
//   await File(filePath).writeAsBytes(uint8List);
//
//   return filePath;
// }
// }

