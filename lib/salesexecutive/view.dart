import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ViewDataPage extends StatelessWidget {
  final String id;
  static const routeName = "/view";

  ViewDataPage({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "View Data",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.purple,
      ),
      body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        future: FirebaseFirestore.instance.collection('leaddata').doc(id).get(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Something went wrong'),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          var data = snapshot.data!.data();
          if (data == null) {
            return Center(
              child: Text('No data found'),
            );
          }

          var name = data['name'];
          var email = data['email'];
          var mobile = data['mobile'];
          var productsOfInterest =
              List<String>.from(data['products_of_interest']);

          return Padding(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
            child: ListView(
              children: [
                Card(
                  elevation: 10.0,
                  margin: EdgeInsets.symmetric(vertical: 10.0),
                  child: ListTile(
                    title: Text('Name: '),
                    subtitle: Text(name),
                  ),
                ),
                Card(
                  elevation: 10.0,
                  margin: EdgeInsets.symmetric(vertical: 10.0),
                  child: ListTile(
                    title: Text('Email: '),
                    subtitle: Text(email),
                  ),
                ),
                Card(
                  elevation: 10.0,
                  margin: EdgeInsets.symmetric(vertical: 10.0),
                  child: ListTile(
                    title: Text('Mobile: '),
                    subtitle: Text(mobile),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Products of Interest',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                ...productsOfInterest.map((product) {
                  return Card(
                    elevation: 10.0,
                    margin: EdgeInsets.symmetric(vertical: 10.0),
                    child: ListTile(
                      title: Text(product),
                    ),
                  );
                }).toList(),
              ],
            ),
          );
        },
      ),
    );
  }
}
