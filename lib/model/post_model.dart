import 'dart:convert';

Post postFromJson(String str) {
  final jsonData = json.decode(str);
  return Post.fromJson(jsonData);
}

String postToJson(Post data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}


List<Post> allPostsFromJson(String str) {
  final jsonData = json.decode(str);
  return new List<Post>.from(jsonData.map((x) => Post.fromJson(x)));
}

String allPostsToJson(List<Post> data) {
  final dyn = new List<dynamic>.from(data.map((x) => x.toJson()));
  return json.encode(dyn);
}

class Post {
  SourceAmount amount;
  SourceUser user;
  String id;
  String date;
  String merchant;
  String comment;
  String category;

  Post ({
    this.amount,
    this.user,
    this.id,
    this.date,
    this.merchant,
    this.comment,
    this.category,
  });

  factory Post.fromJson(Map<String, dynamic> json) => new Post(
      id: json['id'],
      date: json['date'],
      merchant: json['merchant'],
      comment: json['comment'],
      category: json['category'],
      amount: SourceAmount.fromJson(json['amount']),
      user: SourceUser.fromJson(json['user'])
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "date": date,
    "merchant": merchant,
    "comment": comment,
    "category": category,
    "amount": amount,
    "user": user,
  };
}

class SourceAmount{
  String value;
  String currency;

  SourceAmount({
    this.value,
    this.currency
  });

  factory SourceAmount.fromJson(Map<String, dynamic> json) => new SourceAmount(
        value: json['value'],
        currency: json['currency']
    );
  Map<String, dynamic> toJson() => {
    "value": value,
    "currency": currency,
  };
}

class SourceUser{
  double first;
  double last;
  double email;

  SourceUser({
    this.first,
    this.last,
    this.email
  });

  factory SourceUser.fromJson(Map<String, dynamic> json) => new SourceUser(

        first: json['first'],
        last: json['last'],
        email: json['email']
    );
  Map<String, dynamic> toJson() => {
    "first": first,
    "last": last,
    "email": email,
  };

  }
