import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class ViewManager extends StatefulWidget {
  const ViewManager({super.key, required this.id});
  final String id;
  @override
  State<ViewManager> createState() => _ViewManagerState();
}

class _ViewManagerState extends State<ViewManager> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "View Data",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.purple,
      ),
      body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        future: FirebaseFirestore.instance
            .collection('leaddata')
            .doc(widget.id)
            .get(),
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
          var addedBy = data['user']; // Retrieve added by user name
          var timestamp = data['timestamp'] as Timestamp;

          var dateTime = DateTime.fromMillisecondsSinceEpoch(
              timestamp.millisecondsSinceEpoch);
          var date = '${dateTime.day}/${dateTime.month}/${dateTime.year}';
          var time = '${dateTime.hour}:${dateTime.minute}';

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
                Card(
                  elevation: 10.0,
                  margin: EdgeInsets.symmetric(vertical: 10.0),
                  child: ListTile(
                    title:
                        Text('Data added by: '), // Display added by user name
                    subtitle: Text(addedBy),
                  ),
                ),
                Card(
                  elevation: 10.0,
                  margin: EdgeInsets.symmetric(vertical: 10.0),
                  child: ListTile(
                    title: Text('Date: '),
                    subtitle: Text(date),
                  ),
                ),
                Card(
                  elevation: 10.0,
                  margin: EdgeInsets.symmetric(vertical: 10.0),
                  child: ListTile(
                    title: Text('Time: '),
                    subtitle: Text(time),
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
