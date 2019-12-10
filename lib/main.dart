import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

final idList = [];
final valueList = [];
final currencyList = [];
final dateList = [];
final merchantList = [];
//final receiptsList = [];
final commentList = [];
final categoryList = [];
final firstList = [];
final lastList = [];
final emailList = [];

Future<Post> fetchPost() async {
  final response = await http.get('http://10.0.2.2:3000/expenses');

//  //perform check//todo
//  if (Platform.isAndroid) {
//    final response = http.get("http://10.0.2.2:3000/expenses");
//  } else // for iOS simulator
//  {
//    final response = http.get("http://localhost:3000/expenses");
//  }

  if (response.statusCode == 200) {
    var json = jsonDecode(response.body) as Map<String, dynamic>;
    var post = Post.fromJson(json);
    print(post.data.length);//confirm number of users

    for (final element in post.data) {
      debugPrint(element.merchant);//
      idList.add(element.id);
      valueList.add(element.value);
      currencyList.add(element.currency);
      dateList.add(element.date);
      merchantList.add(element.merchant);
      commentList.add(element.comment);
      categoryList.add(element.category);
      firstList.add(element.first);
      lastList.add(element.last);
      emailList.add(element.email);
      //todo
      debugPrint(element.first);//
      //debugPrint('test id at 1: ${idList[1]}');
    }

    return post;
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
  final String value;
  final String currency;
  final String category;
  final String first;
  final String last;
  final String email;
  //final String receipts; //

  Data(
      {this.value,
      this.currency,
      this.category,
      this.first,
      this.last,
      this.email,
      //this.receipts,
      this.comment,
      this.id,
      this.date,
      this.merchant});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      comment: json['comment'],
      id: json['id'],
      date: json['date'],
      merchant: json['merchant'],
      value: json['value'],
      currency: json['currency'],
      category: json['category'],
      first: json['first'],
      last: json['last'],
      email: json['email'],
      //receipts: json['receipts'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'comment': comment,
      'id': id,
      'date': date,
      'merchant': merchant,
      'value': value,
      'currency': currency,
      'category': category,
      'first': first,
      'last': last,
      'email': email,
      //'receipts': receipts,
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
}

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

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'by Grant Verheul',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController editingController = TextEditingController();
  Future<Post> post;


//test data //todo
  final icons = [
    Icons.directions_bike,
  ];

  //camera and gallery start//todo
  File _cameraImage;
  File _image;
  _pickImageFromCamera() async {
    File image = await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 50);

    setState(() {
      _cameraImage = image;
    });
  }

  _pickImageFromGallery() async {
    File image = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50);

    setState(() {
      _image = image;

    });
  }
  @override
  void initState() {
    super.initState();
    post = fetchPost();
    items.addAll(duplicateItems);
    debugPrint("OVER HERE! "+duplicateItems[1]);
  }
  //camera and gallery end
  //search start
  final duplicateItems = List<String>.generate(merchantList.length, (i) => merchantList[i]);
  var items = List<String>();



  void filterSearchResults(String query) {
    List<String> dummySearchList = List<String>();
    dummySearchList.addAll(duplicateItems);

    if (query.isNotEmpty) {
      List<String> dummyListData = List<String>();
      dummySearchList.forEach((item) {
        if (item.contains(query)) {
          dummyListData.add(item);
        }
      });
      setState(() {
        items.clear();
        items.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        items.clear();
        items.addAll(duplicateItems);
      });
    }
  }

  //search end
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Pleo's Challange by Grant Verheul"),
      ),

      //body:
      body: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onChanged: (value) {
                  filterSearchResults(value);
                },
                controller: editingController, //todo fix
                decoration: InputDecoration(
                    labelText: "Search",
                    hintText: "Search",
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25.0)))),
              ),
            ),
            Expanded(
              child: new ListView.builder(
                shrinkWrap: true,
                itemCount: items.length,//idList.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      leading: Icon(icons[
                          0]), //todo if pic else pleo default...'backend' cache
//                      title: Text('${merchantList[index]}'), //todo title
                      title: Text('${merchantList[items.indexOf('${items[index]}')]}'), //todo title
//                      title: Text('${items[index]}'), //todo title
                      subtitle: Text(
//                          '${dateList[index]}'), //todo date and time
                          '${dateList[items.indexOf('${items[index]}')]}'), //todo date and time
                      trailing: Icon(Icons.keyboard_arrow_right),
                      onTap: () {
                        return showDialog<void>(
                          context: context,
                          barrierDismissible: true,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Image.asset('assets/pleo.png',
                                  height: 200, width: 200),
                              //title: Text(titles[index]),
                              //todo add image and note sizing
                              content: Text(//const
//                                  '${merchantList[index]} \n${dateList[index]}\n${valueList[index]} ${currencyList[index]} \n${categoryList[index]} \n${firstList[index]} ${lastList[index]} \n${emailList[index]}\n${commentList[index]}'),
                                  '${merchantList[items.indexOf('${items[index]}')]} \n${dateList[items.indexOf('${items[index]}')]}\n${valueList[items.indexOf('${items[index]}')]} ${currencyList[items.indexOf('${items[index]}')]} \n${categoryList[items.indexOf('${items[index]}')]} \n${firstList[items.indexOf('${items[index]}')]} ${lastList[items.indexOf('${items[index]}')]} \n${emailList[items.indexOf('${items[index]}')]}\n${commentList[items.indexOf('${items[index]}')]}'),
                              actions: <Widget>[
                                FlatButton(
                                  child: Text('Comment'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    String commentVar = '';
                                    return showDialog<String>(
                                      context: context,
                                      barrierDismissible: false,
                                      // dialog is dismissible with a tap on the barrier
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text(merchantList[index]),
                                          content: new Row(
                                            children: <Widget>[
                                              new Expanded(
                                                  child: new TextField(
                                                autofocus: true,
                                                decoration: new InputDecoration(
                                                    labelText: 'Enter Comment',
                                                    hintText:
                                                        "eg. Starbucks for stand-up meeting."),
                                                onChanged: (value) {
                                                  commentVar = value;
                                                },
                                              ))
                                            ],
                                          ),
                                          actions: <Widget>[
                                            FlatButton(
                                              child: Text('Ok'),
                                              onPressed: () {
                                                Navigator.of(context)
                                                    .pop(commentVar);
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                    //end comment
                                  },
                                ),
                                FlatButton(
                                  child: Text('Add Photo'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    //TODO do something with receipt image
                                    _pickImageFromGallery();
                                  },
                                ),
                                FlatButton(
                                  child: Text('Take Photo'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    //TODO do something with receipt image
                                    _pickImageFromCamera();
                                  },
                                ),
                              ],
                            );
                          },
                        ); //
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
//  } else {
//    return ListView.separated(
//      itemCount: europeanCountries.length,
//      itemBuilder: (context, index) {
//        return ListTile(
//          leading: CircleAvatar(
//            backgroundImage: AssetImage('assets/sun.jpg'),
//          ),
//          title: Text(europeanCountries[index]),
//          subtitle: Text('test'),
//        );
//      },
//      separatorBuilder: (context, index) {
//        return Divider();
//      },
//    );
//  } //else
