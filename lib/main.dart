import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import 'package:carousel_pro/carousel_pro.dart';

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
  String filter;
  String comment;
  String index;
//get
  Map data;
  List userData;
  Map test;

  Future getData() async {
    if (Platform.isAndroid) {
      http.Response response = await http.get("http://10.0.2.2:3000/expenses");
      data = json.decode(response.body);
    } else {
      http.Response response = await http.get("http://localhost:3000/expenses");
      data = json.decode(response.body);
    }

    setState(() {
      userData = data["expenses"];
   });
  }

//issue:Connection closed before full header was received
  Future postComment() async {
    try {
//    if (Platform.isAndroid) {
      Map<String, String> headers = {"Content-type": "application/json"};
      //print('\nTESTING DATA\n ${data['expenses'][0]} \nTESTING DATA\n ');// ¯\_(ツ)_/¯ it works. receives updated comment
      String dataAll = json.encode(data); //list of all data
      debugPrint('postComment ran before http.post');
      http.Response response = await http.post(
          "http://10.0.2.2:3000/expenses/:id",
          headers: headers,
          body: dataAll);
      debugPrint('postComment ran past http.post');
      if (response.statusCode == 200) {
        print("Comment Updated: " + response.statusCode.toString());
      } else {
        throw "Comment NOT Updated: " +
            response.statusCode.toString() +
            "\n\n" +
            response.body +
            "\n\n";
      }

//    } else {
//      //todo IOS localhost
//    }
    } catch (e) {
      print('ERROR postComment!: $e');
    }
  }


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
    getData();
    editingController.addListener(() {
      setState(() {
        filter = editingController.text;
      });
    });
  }

  @override
  void dispose() {
    editingController.dispose();
    super.dispose();
  }
//camera and gallery end

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
                  //filterSearchResults(value);
                },
                controller: editingController,
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
                itemCount: userData.length,
                itemBuilder: (BuildContext context, int index) {
                  if (userData.length == 0 || userData.length == null)
                    return Center(
                        child:
                            CircularProgressIndicator()); //if there is no data
                  return filter == null || filter == ""
                      ? new Card(
                          child: new ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.red,
                              child: Text(userData[index]["merchant"][0],
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    color: Colors.white,
                                  )),
                            ),
                            title: Text('${userData[index]["merchant"]}'),
                            subtitle: Text(
                                '${userData[index]["user"]["first"]} ${userData[index]["user"]["last"]}'),
                            trailing: Icon(Icons.keyboard_arrow_right),
                            onTap: () {
                              return showDialog<void>(
                                context: context,
                                barrierDismissible: true,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: //todo touch to enlarge image
                                        Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        SizedBox(
                                            height: 200.0,
                                            width: 200.0,
                                            child: Carousel(
                                              images: [
                                                //ExactAssetImage('assets/pleo.png'),//round corner
                                                Image.asset('assets/pleo.png'),
                                                Image.asset('assets/sun.jpg'),
                                                Image.asset('assets/pleo.png')
                                              ],
                                              dotSize: 4.0,
                                              dotSpacing: 15.0,
                                              dotColor: Colors.pink,
                                              indicatorBgPadding: 5.0,
                                              dotBgColor:
                                                  Colors.red.withOpacity(0.5),
                                            )),
                                      ],
                                    ),

                                    //todo add image and note sizing
                                    content: Text(//const
                                        '${userData[index]["merchant"]}\n${userData[index]["date"]}\n${userData[index]["amount"]["value"]} ${userData[index]["amount"]["currency"]}\n${userData[index]["category"]}\n${userData[index]["user"]["first"]} ${userData[index]["user"]["last"]}\n${userData[index]["user"]["email"]}\n${userData[index]["comment"]} '),
                                    actions: <Widget>[
                                      FlatButton(
                                        child: Text('Comment'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          String commentVar = '';
                                          return showDialog<String>(
                                            context: context,
                                            barrierDismissible: true,
                                            // dialog is dismissible with a tap on the barrier
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Text(userData[index]
                                                    ["merchant"]),
                                                content: new Row(
                                                  children: <Widget>[
                                                    new Expanded(
                                                        child: new TextField(
                                                      autofocus: true,
                                                      decoration: new InputDecoration(
                                                          labelText:
                                                              'Enter Comment',
                                                          hintText:
                                                              "eg. Starbucks for stand-up meeting."),
                                                      onChanged: (value) {
                                                        commentVar = value;
                                                        //todo cleanup and repeat in searched
                                                        userData[index]
                                                            ["comment"] = value;

                                                        //debugPrint(jsonData.toString());
//                                                        comment = value;
                                                      },
                                                    ))
                                                  ],
                                                ),
                                                actions: <Widget>[
                                                  FlatButton(
                                                    child: Text('Ok'),
                                                    onPressed: () {
                                                      postComment(); //
                                                      Navigator.of(context)
                                                          .pop();
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
                        )
                      : userData[index]["merchant"] //redisplay searched
                              .toLowerCase()
                              .contains(filter.toLowerCase())
                          ? new Card(
                              child: new ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: Colors.red,
                                  child: Text(userData[index]["merchant"][0],
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        color: Colors.white,
                                      )),
                                ),
                                title: Text('${userData[index]["merchant"]}'),
                                subtitle: Text(
                                    '${userData[index]["user"]["first"]} ${userData[index]["user"]["last"]}'),
                                trailing: Icon(Icons.keyboard_arrow_right),
                                onTap: () {
                                  return showDialog<void>(
                                    context: context,
                                    barrierDismissible: true,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            SizedBox(
                                                height: 200.0,
                                                width: 200.0,
                                                child: Carousel(
                                                  images: [
                                                    Image.asset(
                                                        'assets/pleo.png'),
                                                    Image.asset(
                                                        'assets/pleo.png'),
                                                    Image.asset(
                                                        'assets/pleo.png')
                                                  ],
                                                  dotSize: 4.0,
                                                  dotSpacing: 15.0,
                                                  dotColor: Colors.pink,
                                                  indicatorBgPadding: 5.0,
                                                  dotBgColor: Colors.red
                                                      .withOpacity(0.5),
                                                  borderRadius: true,
                                                )),
                                          ],
                                        ),
                                        //todo add image and note sizing
                                        content: Text(//const
                                            '${userData[index]["merchant"]}\n${userData[index]["date"]}\n${userData[index]["amount"]["value"]} ${userData[index]["amount"]["currency"]}\n${userData[index]["category"]}\n${userData[index]["user"]["first"]} ${userData[index]["user"]["last"]}\n${userData[index]["user"]["email"]}\n${userData[index]["comment"]} '),
                                        actions: <Widget>[
                                          FlatButton(
                                            child: Text('Comment'),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                              String commentVar = '';
                                              return showDialog<String>(
                                                context: context,
                                                barrierDismissible: true,
                                                // dialog is dismissible with a tap on the barrier
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    title: Text(userData[index]
                                                        ["merchant"]),
                                                    content: new Row(
                                                      children: <Widget>[
                                                        new Expanded(
                                                            child:
                                                                new TextField(
                                                          autofocus: true,
                                                          decoration: new InputDecoration(
                                                              labelText:
                                                                  'Enter Comment',
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
                            )
                          : new Container();
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
