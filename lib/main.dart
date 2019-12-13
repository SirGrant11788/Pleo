import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';



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
//get
  Map data;
  List userData;

  Future getData() async {
    http.Response response = await http.get("http://10.0.2.2:3000/expenses");
    data = json.decode(response.body);
    setState(() {
      userData = data["expenses"];
    });
  }

//test data //todo
  static final icons = [
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
    getData();
    items.addAll(duplicateItems);
  }
  //camera and gallery end
  //search start
  final duplicateItems = List<String>.generate(icons.length, (i) => icons[i].toString());//TODO fix search
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
                itemCount: userData == null ? 0 : userData.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    child: ListTile(
                      leading: Icon(icons[
                          0]), //todo if pic else pleo default...'backend' cache
                      title: Text('${userData[index]["merchant"]}'), //todo title
                      subtitle: Text(
                          '${userData[index]["user"]["first"]} ${userData[index]["user"]["last"]}'), //todo date and time
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
                                  '${userData[index]["merchant"]}\n${userData[index]["date"]}\n${userData[index]["amount"]["value"]} ${userData[index]["amount"]["currency"]}\n${userData[index]["category"]}\n${userData[index]["user"]["first"]} ${userData[index]["user"]["last"]}\n${userData[index]["user"]["email"]}\n${userData[index]["comment"]} '),
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
                                          title: Text(userData[index]["merchant"]),
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
