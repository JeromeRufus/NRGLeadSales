import 'package:flutter/material.dart';
import 'package:sales/salesexecutive/create_data.dart';
import 'package:sales/salesexecutive/listdata.dart';

class SalesExecutiveScreen extends StatefulWidget {
  @override
  State<SalesExecutiveScreen> createState() => _SalesExecutiveScreenState();
  static const routeName = '/salesExecutive';
}

class _SalesExecutiveScreenState extends State<SalesExecutiveScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Sales Executive',
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
          child: ListDataPage(),
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
