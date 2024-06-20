import 'dart:io';
import 'package:face_ai/models/swap_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';


import '../models/FaceModel.dart';
import 'package:flutter/material.dart';


class DatabaseHelper {
  static const int _version = 3;
  static const String _dbName = "Face.db";

  // face table columns
  static const String faceTable = 'Face';
  static const String faceId = 'id';
  static const String facePath = 'facePath';



  // swaped face table

  static const String swapTable = 'swap';
  static const String swapId = 'id';
  static const String jobId = 'jobId';
  static const String swapPath = 'swapPath';
  static const String swapFacePath = 'swapFacePath';
  static const String swapBodyPath = 'swapBodyPath';








  static Future<Database> _initializeDB() async {
    return openDatabase(join(await getDatabasesPath(), _dbName),
        onCreate: (db, version) async {
       await   db.execute(
              " CREATE TABLE $faceTable ( $faceId INTEGER PRIMARY KEY AUTOINCREMENT , $facePath text  ) ;");

       await  db.execute(
           " CREATE TABLE $swapTable( $swapId INTEGER PRIMARY KEY AUTOINCREMENT , $swapPath text , $swapFacePath text ,$swapBodyPath text , $jobId text) ;");
        },



        onUpgrade: (db, oldVersion, newVersion) async {
          // Perform data deletion during upgrade

          if (newVersion > oldVersion) {
            if(Platform.isIOS){
              await db.execute('DELETE FROM $faceTable');
              await db.execute('DELETE FROM $swapTable');
            }

          }
    },


        version: _version);
  }




  // face table methods
 static Future<int> insertFace( FaceModel mart) async {
    final db = await _initializeDB();
    print('faces insert succesfull');
    return await db.insert(faceTable, mart.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

static Future<List<Map<String, dynamic>>> getFace() async {
    final db = await _initializeDB();
    return db.query(faceTable, orderBy: faceId);
  }

 static Future<int> updateFaceItem(
      int id, FaceModel mart) async {
    final db = await _initializeDB();

    final result =
    await db.update(faceTable, mart.toJson(), where: "$faceId = ?", whereArgs: [id]);
    return result;
  }
  static Future<FaceModel> getSingleFace(int userId)async{
    Database db = await _initializeDB();
    List<Map<String, dynamic>> user = await db.rawQuery("SELECT * FROM $faceTable WHERE id = $userId");

      return FaceModel(facePath: facePath);

  }


 static Future<void> deleteFace(int id) async {
    final db = await _initializeDB();
    try {
      await db.delete(faceTable, where: "$faceId = ?", whereArgs: [id]);
    } catch (err) {
      print("Something went wrong when deleting an item: $err");
    }
  }






  // swap table methods
  static Future<int> insertSwapFace( SwapModel mart) async {
    final db = await _initializeDB();
    return await db.insert(swapTable, mart.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<List<Map<String, dynamic>>> getSwapFace() async {
    final db = await _initializeDB();
    return db.query(swapTable, orderBy: swapId);
  }

  static Future<int> updateSwapItem(
      int id, SwapModel mart) async {
    final db = await _initializeDB();

    final result =
    await db.update(swapTable, mart.toJson(), where: "$swapId = ?", whereArgs: [id]);
    return result;
  }
  static Future<SwapModel> getSingleSwap(int userId)async{
    Database db = await _initializeDB();
    List<Map<String, dynamic>> user = await db.rawQuery("SELECT * FROM $faceTable WHERE id = $userId");

    return SwapModel(swapPath: swapPath, swapFacePath: swapFacePath, swapBodyPath: swapBodyPath,jobId: jobId);

  }


  static Future<void> deleteSwap(int id) async {
    print('file deleted :::::::::::::::::::::::');
    final db = await _initializeDB();
    try {
      await db.delete(swapTable, where: "$swapId = ?", whereArgs: [id]);
    } catch (err) {
      print("Something went wrong when deleting an item: $err");
    }
  }

// download image


}
