




import 'package:face_ai/services/face_database_helper.dart';

class SwapModel {
  int? id;
  String swapPath;
  String swapFacePath;
  String swapBodyPath;
  String jobId;






  SwapModel({
    // required this.id

    required this.swapPath,
    required this.swapFacePath,
    required this.swapBodyPath,
    required this.jobId,




  });


  SwapModel.fromJson(Map<String, dynamic> result)
      : id = result["id"],
        swapPath = result[DatabaseHelper.swapPath],
        swapFacePath = result[DatabaseHelper.swapFacePath],
        swapBodyPath = result[DatabaseHelper.swapBodyPath],
        jobId = result[DatabaseHelper.jobId];



  Map<String, Object?>  toJson() {
    return {  DatabaseHelper.swapPath: swapPath, DatabaseHelper.swapFacePath: swapFacePath, DatabaseHelper.swapBodyPath: swapBodyPath,DatabaseHelper.jobId: jobId};
  }
}