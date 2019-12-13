import 'package:flutter/material.dart';
import 'package:pleos_challenge/services/expenses_services.dart';
import 'package:pleos_challenge/model/post_model.dart';
import 'package:pleos_challenge/services/post_services.dart';

void main() {
  runApp(new MyApp());
//  loadProduct();
//  loadPhotos();
//  loadAddress();
//  loadStudent();
    //loadExpenses();
//  loadBakery();
//  loadPage();
}




class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        home: Home()
    );
  }
}

class Home extends StatelessWidget{

  callAPI(){
    Post post = Post(
        date: 'Testing body body body',
        id: 'Flutter jam6'
    );
    createPost(post).then((response){
      if(response.statusCode > 200)
        print(response.body);
      else
        print(response.statusCode);
    }).catchError((error){
      print('error : $error');
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body : FutureBuilder<Post>(
            future: getPost(),
            builder: (context, snapshot) {
              //callAPI();
              if(snapshot.connectionState == ConnectionState.done) {

                if(snapshot.hasError){
                  return Text('Error 59');
                }

                return Text('Title from Post JSON : ${snapshot.data.merchant[1]}');

              }
              else
                return CircularProgressIndicator();
            }
        )
    );
  }

}