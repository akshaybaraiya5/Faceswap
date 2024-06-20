
import 'package:shared_preferences/shared_preferences.dart';

// class MySharedPreferences {
//   static const String keyCounter = 'counter';
//
//   // Function to save an integer value to shared preferences
//   static Future<void> saveCounter(int value) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.setInt(keyCounter, value);
//   }
//
//   // Function to retrieve an integer value from shared preferences
//   static Future<int?> getCounter() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     return prefs.getInt(keyCounter);
//   }
// }

class MySharedPreferences {
  static const String key = 'myList';

  // Function to save the list to shared preferences
  static Future<void> saveList(List<String> myList) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(key, myList);
  }

  // Function to retrieve the list from shared preferences
  static Future<List<String>> getList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? myList = prefs.getStringList(key);
    return myList ?? [];
  }
}