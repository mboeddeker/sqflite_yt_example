import 'package:meta/meta.dart';

class Person {
  String id;
  String firstName;
  String lastName;
  int age;
  String phoneNumber;

  Person({@required this.firstName, @required this.lastName, @required this.age, @required this.phoneNumber});

  Person.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        firstName = map['first_name'],
        lastName = map['last_name'],
        age = map['age'],
        phoneNumber = map['phone_number'];

  Map<String, dynamic> toMap() =>
      {"id": id, "first_name": firstName, "last_name": lastName, "age": age, "phone_number": phoneNumber};
}
