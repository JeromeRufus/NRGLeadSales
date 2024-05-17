import 'package:flutter/material.dart';
import 'package:sales/salesexecutive/create_data.dart';
import 'package:sales/salesmanager/listofdata.dart';

import '../salesexecutive/listdata.dart';

class SalesManagerScreen extends StatefulWidget {
  @override
  State<SalesManagerScreen> createState() => _SalesManagerScreenState();
  static const routeName = '/salesmanager';
}

class _SalesManagerScreenState extends State<SalesManagerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Sales Manager',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.purple,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 20.0),
          child: ListOfData(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => AddData()));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
