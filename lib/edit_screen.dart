import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:sqflite_yt_example/db/person_db.dart';
import 'package:sqflite_yt_example/models/person.dart';

class EditScreen extends StatefulWidget {
  Person person;

  EditScreen({this.person});

  @override
  _EditScreenState createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Person person;

  @override
  void initState() {
    person = widget.person != null ? widget.person : Person.fromMap({});
    super.initState();
  }

  void saveValues(BuildContext context) async {
    final FormState form = _formKey.currentState;
    form.save();
    PersonDB db = PersonDB();
    var res = person.id == null ? await db.insert(person: person) : await db.update(newPerson: person);
    print(res);
    Navigator.of(context).pop();
  }

  void delete(Person person) async {
    PersonDB db = PersonDB();
    await db.delete(id: person.id);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.delete),
            tooltip: 'Delete user',
            onPressed: () => delete(person),
          )
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          dragStartBehavior: DragStartBehavior.down,
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                initialValue: person.id != null ? person.firstName : null,
                decoration: InputDecoration(
                  icon: Icon(Icons.person),
                  hintText: 'First Name of person',
                  labelText: 'Firstname',
                ),
                onSaved: (String firstname) {
                  person.firstName = firstname;
                },
              ),
              SizedBox(height: 24),
              TextFormField(
                initialValue: person.id != null ? person.lastName : null,
                decoration: InputDecoration(
                  icon: Icon(Icons.person_outline),
                  hintText: 'Lastname of person',
                  labelText: 'Lastname',
                ),
                onSaved: (String lastname) {
                  person.lastName = lastname;
                },
              ),
              SizedBox(height: 24),
              TextFormField(
                initialValue: person.id != null ? "${person.age}" : null,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  icon: Icon(Icons.language),
                  hintText: 'age of person',
                  labelText: 'Age',
                ),
                onSaved: (String age) {
                  person.age = int.parse(age);
                },
              ),
              SizedBox(height: 24),
              TextFormField(
                initialValue: person.id != null ? person.phoneNumber : null,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  icon: Icon(Icons.phone),
                  hintText: 'Phonenumber',
                  labelText: 'Phonenumber',
                ),
                onSaved: (String number) {
                  person.phoneNumber = number;
                },
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => saveValues(context),
        tooltip: 'Add Person',
        child: Icon(person.id == null ? Icons.save : Icons.update),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
