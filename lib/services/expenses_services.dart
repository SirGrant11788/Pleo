import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'package:pleos_challenge/model/user_model.dart';


Future<String> _loadExpenseseAsset() async {
  return await rootBundle.loadString('http://10.0.2.2:3000/expenses');
}


Future loadExpenses() async {
  String jsonString = await _loadExpenseseAsset();
  final jsonResponse = json.decode(jsonString);
  Expenses expenses = new Expenses.fromJson(jsonResponse);
  print(expenses.user.email);
}