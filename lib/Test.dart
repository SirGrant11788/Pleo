import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

const baseUrl = "http://10.0.2.2:3000";

class API {
  static Future getUsers() {
    var url = baseUrl + "/expenses";
        return http.get(url);
  }
}

class User {
  SourceAmount amount;
  SourceUser user;
  String id;
  String date;
  String merchant;
  String comment;
  String category;

  User(SourceAmount amount,SourceUser user ,String id, String date, String merchant, String comment, String category) {
    this.amount=amount;
    this.user=user;
    this.id = id;
    this.date=date;
    this.merchant=merchant;
    this.comment=comment;
    this.category=category;
  }

  User.fromJson(Map json)
      : amount= SourceAmount.fromJson(json["amount"]),
        user= SourceUser.fromJson(json["user"]),
        id = json['id'],
        date= json['date'],
        comment= json['comment'],
        merchant= json['merchant'],
        category= json['category'];

  Map toJson() {
    return {'amount':amount,'user':user,'id': id, 'comment': comment, 'merchant': merchant,'category':category};
  }
}
class SourceAmount{
  String value;
  String currency;

  SourceAmount({this.value,this.currency});

  SourceAmount.fromJson(Map json)
  :value=json['value'],
  currency=json['currency'];

  Map toJson(){
    return {'value':value,'currency':currency};
  }
}
class SourceUser{
  String first;
  String last;
  String email;

  SourceUser({this.first,this.last,this.email});

  SourceUser.fromJson(Map json)
      :first=json['first'],
        last=json['last'],
        email=json['email'];

  Map toJson(){
    return {'first':first,'last':last,'email':email};
  }
}

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  build(context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pleo App',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: MyListScreen(),
    );
  }
}

class MyListScreen extends StatefulWidget {
  @override
  createState() => _MyListScreenState();
}

class _MyListScreenState extends State {
  var users = new List<User>();

  _getUsers() {
    API.getUsers().then((response) {
      setState(() {
        //it works//debugPrint('!json.decode(response.body): ${json.decode(response.body)}');
        final dynamic list = json.decode(response.body);//Iterable list
        //debugPrint('!list: ${list.toString()}');it works
        users = list.map((model) => User.fromJson(model)).toList();
        debugPrint('!GOT THIS FAR :P ${users.length}');
        debugPrint('!users[0].merchant: ${users[0].merchant}');
        debugPrint('!users[0].amount.currency: ${users[0].amount.currency}');
      });
    });
  }

  initState() {
    super.initState();
    _getUsers();
  }

  dispose() {
    super.dispose();
  }

  @override
  build(context) {
    debugPrint('user.length: ${users.length}');
    return Scaffold(
        appBar: AppBar(
          title: Text("Pleo"),
        ),
        body: ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            return ListTile(title: Text(users[index].merchant));
          },
        ));
  }
}