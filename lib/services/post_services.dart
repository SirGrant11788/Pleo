import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:pleos_challenge/model/post_model.dart';
import 'dart:io';

String url = 'http://10.0.2.2:3000';

Future<List<Post>> getAllPosts() async {
  final response = await http.get(url);
  print(response.body);
  return allPostsFromJson(response.body);
}

Future<Post> getPost() async{
  final response = await http.get('$url/expenses');
  debugPrint('getPost(): ${postFromJson(response.body)}');
  return postFromJson(response.body);
}

Future<http.Response> createPost(Post post) async{
  final response = await http.post('$url',
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader : ''
      },
      body: postToJson(post)
  );
  return response;
}