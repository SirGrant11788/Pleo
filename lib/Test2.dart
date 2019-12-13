
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ListViewJsonapi extends StatefulWidget {
  _ListViewJsonapiState createState() => _ListViewJsonapiState();
}

class _ListViewJsonapiState extends State<ListViewJsonapi> {
  final String uri = 'http://10.0.2.2:3000/expenses';

  Future<List<Users>> _fetchUsers() async {
    var response = await http.get(uri);
    if (response.statusCode == 200) {

      final items = jsonDecode(response.body).cast<Map<String, dynamic>>();
      debugPrint(items);
      List<Users> listOfUsers = items.map<Users>((json) {
          debugPrint('in json: ${Users.fromJson(json)}');
          return Users.fromJson(json);
      }).toList();

      return listOfUsers;
    } else {
      debugPrint('thrown exception');
      throw Exception('Failed to load');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Testing Pleo'),
      ),
      body: FutureBuilder<List<Users>>(
        future: _fetchUsers(),
        builder: (context, snapshot) {
          debugPrint('has data: ${snapshot.hasData}');
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

          return ListView(
            children: snapshot.data
                .map((user) => ListTile(
              title: Text(user.merchant),
              subtitle: Text(user.user.email),
              leading: CircleAvatar(
                backgroundColor: Colors.red,
                child: Text(user.user.first[0],
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.white,
                    )),
              ),
            ))
                .toList(),
          );
        },
      ),
    );
  }
}

class Users {
  SourceAmount amount;
  SourceUser user;
  int id;
  String date;
  String merchant;
  String comment;
  String category;

  Users({
    this.amount,
    this.user,
    this.id,
    this.date,
    this.merchant,
    this.comment,
    this.category,
  });

  factory Users.fromJson(Map<String, dynamic> json) {
    return Users(
      amount: SourceAmount.fromJson(json["amount"]),
      user: SourceUser.fromJson(json["user"]),
      id: json['id'],
      date: json['date'],
      comment: json['comment'],
      merchant: json['merchant'],
      category: json['category'],
    );
  }
}
class SourceAmount{
  String value;
  String currency;

  SourceAmount({this.value,this.currency});

  factory SourceAmount.fromJson(Map<String, dynamic> json) {
    return SourceAmount(
      value: json["value"] as String,
      currency: json["currency"] as String,
    );
  }
}
class SourceUser{
  String first;
  String last;
  String email;

  SourceUser({this.first,this.last,this.email});

  factory SourceUser.fromJson(Map<String, dynamic> json) {
    return SourceUser(
      first: json["first"] as String,
      last: json["last"] as String,
      email: json["email"] as String,
    );
  }
}
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // Root Widget
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ListViewJsonapi(),
    );
  }
}