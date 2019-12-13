class Expenses{
  SourceAmount amount;
  SourceUser user;
  String id;
  String date;
  String merchant;
  String comment;
  String category;

  Expenses({
    this.amount,
    this.user,
    this.id,
    this.date,
    this.merchant,
    this.comment,
    this.category,
  });

  factory Expenses.fromJson(Map<String, dynamic> parsedJson){
    return Expenses(
        id: parsedJson['id'],
        date: parsedJson['date'],
        merchant: parsedJson['merchant'],
        comment: parsedJson['comment'],
        category: parsedJson['category'],
        amount: SourceAmount.fromJson(parsedJson['amount']),
        user: SourceUser.fromJson(parsedJson['user'])
    );
  }
}

class SourceAmount{
  String value;
  String currency;

  SourceAmount({
    this.value,
    this.currency
  });

  factory SourceAmount.fromJson(Map<String, dynamic> json){
    return SourceAmount(
        value: json['value'],
        currency: json['currency']
    );
  }
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

  factory SourceUser.fromJson(Map<String, dynamic> json){
    return SourceUser(
        first: json['first'],
        last: json['last'],
        email: json['email']
    );
  }
}