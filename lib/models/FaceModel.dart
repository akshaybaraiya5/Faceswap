




import 'package:face_ai/services/face_database_helper.dart';

class FaceModel {
  int? id;
  String facePath;






  FaceModel({
    // required this.id

    required this.facePath,




  });


  FaceModel.fromJson(Map<String, dynamic> result)
      : id = result["id"],
        facePath = result[DatabaseHelper.facePath];



  Map<String, Object?>  toJson() {
    return {  DatabaseHelper.facePath: facePath };
  }
}