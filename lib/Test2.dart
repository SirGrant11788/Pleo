import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

final idList = [];
final valueList = [];
final currencyList = [];
final dateList = [];
final merchantList = [];
final receiptsList = [];
final commentList = [];
final categoryList = [];
final firstList = [];
final lastList = [];
final emailList = [];

Future<Post> fetchPost() async {

  final response = await http.get('http://10.0.2.2:3000/expenses');

  //perform check//todo
  if (Platform.isAndroid) {
    final response =  http.get("http://10.0.2.2:3000/expenses");
  } else // for iOS simulator
      {
    final response =  http.get("http://localhost:3000/expenses");
  }

  if (response.statusCode == 200) {
    // If the call to the server was successful, parse the JSON.
    //debugPrint("fetchPost if ran: "+json.decode(response.body).toString());
    var json = jsonDecode(response.body) as Map<String, dynamic>;
    var post = Post.fromJson(json);
    print(post.data.length);

    for (final element in post.data) {
      //print(element.id);
      idList.add(element.id);
      //print(element.merchant);
    }
    //debugPrint('test id at 1: ${id[1]}');//test to del 5b99606474ab17b7820b3922 (second id)
    return post;
//    return Post.fromJson(json.decode(response.body));
  } else {
    // If that call was not successful, throw an error.
    debugPrint("fetchPost else ran");
    throw Exception('Failed to load post');
  }

}

class Data {
  final String comment;
  final String id;
  final String date;
  final String merchant;

  Data({this.comment, this.id, this.date, this.merchant});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      comment: json['comment'],
      id: json['id'],
      date: json['date'],
      merchant: json['merchant'],

    );
  }
  Map<String, dynamic> toJson() {

    return {
      'comment': comment,
      'id': id,
      'date': date,
      'merchant': merchant,
    };
  }
}
class Post {
  final List<Data> data;

  Post({this.data});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      data: _toObjectList(json['expenses'], (e) => Data.fromJson(e)),
    );

}
//  Map<String, dynamic> toJson() {
//    return {
//      'expenses': _fromList(data, (e) => e.toJson()),
//    };
//  }
}

//List _fromList(data, Function(dynamic) toJson) {
//  if (data == null) {
//    return null;
//  }
//  var result = [];
//  for (var element in data) {
//    var value;
//    if (element != null) {
//      value = toJson(element);
//    }
//    result.add(value);
//  }
//  return result;
//}

List<T> _toObjectList<T>(data, T Function(Map<String, dynamic>) fromJson) {
  if (data == null) {
    return null;
  }
  var result = <T>[];
  for (var element in data) {
    T value;
    if (element != null) {
      value = fromJson(element as Map<String, dynamic>);
    }
    result.add(value);
  }
  return result;
}

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<Post> post;

  @override
  void initState() {
    super.initState();
    post = fetchPost();
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fetch Data Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Fetch Data Example'),
        ),
        body: Center(
//          child: FutureBuilder<Post>(
//            future: post,//post
//
//            builder: (context, snapshot) {
////            builder: (context, snapshot) {
////              debugPrint("CATCH ME merchant: "+snapshot.data.merchant.toString());
////              debugPrint("CATCH ME id: "+snapshot.data.id.toString());
////              debugPrint("CATCH ME comment: "+snapshot.data.comment.toString());
////              debugPrint("CATCH ME date: "+snapshot.data.date.toString());
////              debugPrint("CATCH ME state: "+snapshot.connectionState.toString());
////              debugPrint("CATCH ME data: "+snapshot.data.toString());
//              debugPrint("CATCH ME data: "+map["Merchant"]);
//
//              if (snapshot.hasData) {
//                return Text(id[1]);
//              } else if (snapshot.hasError) {
//                return Text("${snapshot.error.toString()} oh snap NO DATA!");
//              }
//
//              // By default, show a loading spinner.
//              return CircularProgressIndicator();
//            },
//          ),
        child: new ListView.builder(
    shrinkWrap: true,
    itemCount: idList.length,
    itemBuilder: (context, index) {
    return Card(
    child: ListTile(
    title: Text('${idList[index]}'), //todo title
    subtitle:
    Text('test'), //todo date and time


    ),
    );
    },
    ),
    ),
    ),
    );
  }
}