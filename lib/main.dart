// This example shows a [Scaffold] with an [AppBar], a [BottomAppBar] and a
// [FloatingActionButton]. The [body] is a [Text] placed in a [Center] in order
// to center the text within the [Scaffold] and the [FloatingActionButton] is
// centered and docked within the [BottomAppBar] using
// [FloatingActionButtonLocation.centerDocked]. The [FloatingActionButton] is
// connected to a callback that increments a counter.

import 'package:flutter/material.dart';
import 'package:sqflite_yt_example/db/person_db.dart';
import 'package:sqflite_yt_example/edit_screen.dart';
import 'package:sqflite_yt_example/models/person.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Code Sample for material.Scaffold',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: MyStatefulWidget(),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  MyStatefulWidget({Key key}) : super(key: key);

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  void openEditScreen(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => EditScreen()));
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SQFLITE EXAMPLE'),
      ),
      body: Center(
        child: FutureBuilder<List<Person>>(
            future: PersonDB().getAll(),
            initialData: [],
            builder: (context, AsyncSnapshot<List<Person>> snapshot) {
              if (snapshot.hasData && !snapshot.hasError) {
                return buildPersonList(context, snapshot.data);
              } else {
                return Container();
              }
            }),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: 50.0,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => openEditScreen(context),
        tooltip: 'Add Person',
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget buildPersonList(BuildContext context, List<Person> personList) {
    return ListView.builder(
      itemCount: personList.length,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => EditScreen(person: personList[index])));
          },
          child: ListTile(title: Text('${personList[index].firstName} ${personList[index].lastName}')),
        );
      },
    );
  }
}
