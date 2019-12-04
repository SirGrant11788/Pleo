////import 'dart:async';
////import 'dart:convert';
////
////import 'package:flutter/material.dart';
////import 'package:http/http.dart' as http;
////
////Future<Post> fetchPost() async {
////  final response =
////  await http.get('https://jsonplaceholder.typicode.com/expenses');
////
////  if (response.statusCode == 200) {
////    // If the call to the server was successful, parse the JSON.
////    return Post.fromJson(json.decode(response.body));
////  } else {
////    // If that call was not successful, throw an error.
////    throw Exception('Failed to load post1');
////  }
////}
//import 'dart:convert';
//
//import 'package:http/http.dart' as http;
//class Info {
//   String id;
////   String amount;
////   String value;
////   String currency;
//   String date;
//   String merchant;
//   String comment;
////   String category;
////   String user;
////   String first;
////   String last;
////   String email;
//
////  Info(String id, String amount, String value, String currency,String date,String merchant,String comment,String category,String email,String first,String last,String user){
////  Info(String id, String date,String merchant,String comment){
////    this.id=id;
//////    this.amount=amount;
//////    this.value=value;
//////    this.currency=currency;
////    this.date=date;
////    this.merchant=merchant;
////    this.comment=comment;
//////    this.category=category;
//////    this.email=email;
//////    this.first=first;
//////    this.last=last;
//////    this.user=user;
////
////  }
//Info({this.id,this.comment,this.merchant,this.date});
//  factory Info.fromJson(Map<String, dynamic> json) {
//    return Info(
//      id: json['id'],
//      date: json['date'],
//      merchant: json['merchant'],
//      comment: json['comment'],
//    );
//  }
//
////Info.fromJson(Map jsonMap)
////   :    id = jsonMap['id'],
//////        amount = jsonMap['amount'],
//////        value = jsonMap['value'],
//////        currency = jsonMap['currency'],
////        date = jsonMap['date'],
////        merchant = jsonMap['merchant'],
////        comment = jsonMap['comment']//,
//////        category = jsonMap['category'],
//////        user = jsonMap['user'],
//////        first = jsonMap['first'],
//////        last = jsonMap['last'],
//////        email = jsonMap['email']
////        ;
////
////   Map toJson() {
////     return {'id': id,  'date': date, 'merchant': merchant, 'comment': comment};
//////     return {'id': id, 'amount': amount, 'value': value, 'currency': currency, 'date': date, 'merchant': merchant, 'comment': comment, 'category': category, 'user': user, 'first': first, 'last': last, 'email': email};
////   }
//}
////Future<http.Response> fetchPost() {
////  return http.get('https://jsonplaceholder.typicode.com/posts/1');
////}
//
//Future<Info> fetchPost() async {
//  final response =
//  await http.get('http://10.0.2.2:3000/expenses');
//
//  if (response.statusCode == 200) {
//    // If server returns an OK response, parse the JSON.
//    return Info.fromJson(json.decode(response.body));
//  } else {
//    // If that response was not OK, throw an error.
//    throw Exception('Failed to load post');
//  }
//}
//
