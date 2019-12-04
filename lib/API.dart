//import 'dart:async';
//import 'dart:io';
//import 'package:http/http.dart' as http;
//import 'package:http/http.dart';
//
////todo
////fixme
//const baseUrlAndroid = 'http://10.0.2.2:3000';
//const baseUrliOS = 'http://localhost:3000';
//
//class API {
//
//  static Future getExpenses() {
//
//    var urlAndroid = baseUrlAndroid + "/expenses";
//    var urliOS = baseUrliOS + "/expenses";
//    //return http.get(url);
//      if (Platform.isAndroid)
//    return http.get(urlAndroid);
//  else // for iOS simulator
//    return http.get(urliOS);
//
//  }
////  String serverResponse = 'Server response';
////   getExpenses() async {
////  Response response = await get(_localhost());
////  //setState(() {
////  serverResponse = response.body;
////  //});
////}
////String _localhost() {
////  if (Platform.isAndroid)
////    return 'http://10.0.2.2:3000';
////  else // for iOS simulator
////    return 'http://localhost:3000';
////}
//
//}
