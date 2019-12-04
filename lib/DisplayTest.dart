//import 'dart:html';
import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Test Display',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: 'Users Test'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<List<User>> _getUsers() async {
    // var data = await http.get("http://10.0.2.2:3000/expenses");//default Android. should null after testing
    var data;
    //perform check
    if (Platform.isAndroid) {
      data = await http.get("http://10.0.2.2:3000/expenses");
    } else // for iOS simulator
    {
      data = await http.get("http://localhost:3000/expenses");
    }

    var jsonData = json.decode(data.body);
//print("jsonData: "+jsonData.toString());
    List<User> users = [];
    debugPrint("out for loop1");
    for (var u in jsonData) {
      debugPrint("in for loop");
      User user = User(
          u["id"],
          u["value"],
          u["currency"],
          u["date"],
          u["merchant"],
          u["receipts"],
          u["comment"],
          u["category"],
          u["first"],
          u["last"],
          u["email"]);

      users.add(user);
      debugPrint("user: " + user.toString());
    }
    debugPrint("out for loop2");
    print("user.length: " + users.length.toString());

    return users;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: Container(
        child: FutureBuilder(
          future: _getUsers(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            print("snapshot.data: " + snapshot.data.toString()); //check
//            if(!snapshot.hasData){
            if (snapshot.data == null) {
              return Container(
                  child: Center(
                child: CircularProgressIndicator(),
              ));
            } else {
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
//                    leading: CircleAvatar(
//                      backgroundImage: NetworkImage(
//                          snapshot.data[index].picture
//                      ),
//                    ),
                    title: Text(snapshot.data[index].first),
                    subtitle: Text(snapshot.data[index].date),
                    onTap: () {
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) =>
                                  DetailPage(snapshot.data[index])));
                    },
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}

class DetailPage extends StatelessWidget {
  final User user;

  DetailPage(this.user);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
      title: Text(user.first),
    ));
  }
}

class User {
  final String id;
  //final String amount;
  final String value;
  final String currency;
  final String date;
  final String receipts;
  final String merchant;
  final String comment;
  final String category;
  //final String user;
  final String first;
  final String last;
  final String email;

  User(
      this.id,
      this.value,
      this.currency,
      this.date,
      this.receipts,
      this.merchant,
      this.comment,
      this.category,
      this.first,
      this.last,
      this.email);
}
//
//import 'dart:async';
//import 'dart:convert';
//
//import 'package:flutter/material.dart';
//import 'package:http/http.dart' as http;
//
//Future<Post> fetchPost() async {
//  final response = await http.get('http://10.0.2.2:3000/expenses');
//  debugPrint("fetchPost before if else");
//  if (response.statusCode == 200) {
//    // If the call to the server was successful, parse the JSON.
//    debugPrint("fetchPost if ran: "+json.decode(response.body).toString());
//    return Post.fromJson(json.decode(response.body));
//  } else {
//    // If that call was not successful, throw an error.
//    debugPrint("fetchPost else ran");
//    throw Exception('Failed to load post');
//  }
//}
//
//class Post {
//  final String comment;
//  final String id;
//  final String date;
//  final String merchant;
//
//  Post({this.comment, this.id, this.date, this.merchant});
//
//  factory Post.fromJson(Map<String, dynamic> json) {
//    return Post(
//      comment: json['comment'],
//      id: json['id'],
//      date: json['date'],
//      merchant: json['merchant'],
//
//    );
//  }
//}
//
//void main() => runApp(MyApp());
//
//class MyApp extends StatefulWidget {
//  MyApp({Key key}) : super(key: key);
//
//  @override
//  _MyAppState createState() => _MyAppState();
//}
//
//class _MyAppState extends State<MyApp> {
//  Future<Post> post;
//
//  @override
//  void initState() {
//    super.initState();
//    post = fetchPost();
//  }
//
//
//  @override
//  Widget build(BuildContext context) {
//    return MaterialApp(
//      title: 'Fetch Data Example',
//      theme: ThemeData(
//        primarySwatch: Colors.blue,
//      ),
//      home: Scaffold(
//        appBar: AppBar(
//          title: Text('Fetch Data Example'),
//        ),
//        body: Center(
//          child: FutureBuilder<Post>(
//            future: post,
//            builder: (context, snapshot) {
//              debugPrint("CATCH ME merchant: "+snapshot.data.merchant.toString());
//              debugPrint("CATCH ME id: "+snapshot.data.id.toString());
//              debugPrint("CATCH ME comment: "+snapshot.data.comment.toString());
//              debugPrint("CATCH ME date: "+snapshot.data.date.toString());
//              debugPrint("CATCH ME state: "+snapshot.connectionState.toString());
//              debugPrint("CATCH ME data: "+snapshot.data.toString());
//              debugPrint("CATCH ME snap: "+snapshot.toString());
//              //debugPrint("CATCH ME ?: "+snapshot.data.merchant);
//              if (snapshot.hasData) {
//                return Text(snapshot.data.merchant.toString());
//              } else if (snapshot.hasError) {
//                return Text("${snapshot.error.toString()} oh snap!");
//              }
//
//              // By default, show a loading spinner.
//              return CircularProgressIndicator();
//            },
//          ),
//        ),
//
//      ),
//    );
//  }
//}
