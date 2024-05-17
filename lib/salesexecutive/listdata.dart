import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sales/salesexecutive/update.dart';
import 'package:sales/salesexecutive/view.dart';

class ListDataPage extends StatefulWidget {
  ListDataPage({Key? key}) : super(key: key);

  @override
  _ListDataPageState createState() => _ListDataPageState();
}

class _ListDataPageState extends State<ListDataPage> {
  final Stream<QuerySnapshot> dataStream =
      FirebaseFirestore.instance.collection('leaddata').snapshots();

  // For Deleting User
  CollectionReference data = FirebaseFirestore.instance.collection('leaddata');
  Future<void> deletePlace(id) {
    // print("User Deleted $id");
    return data.doc(id).delete().then((value) {
      print("Data Deleted");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Form delete successfully')),
      );
    }).catchError((error) {
      print("Failed to delete data: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to submit form: $error')),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: dataStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasError) {
          print('Something went Wrong');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        final List storedocs = [];
        snapshot.data?.docs.map((DocumentSnapshot document) {
          Map a = document.data() as Map<String, dynamic>;
          storedocs.add(a);
          a['id'] = document.id;
        }).toList();

        return Padding(
          padding: EdgeInsets.only(top: 18.0),
          child: ListView.separated(
            separatorBuilder: (context, index) => SizedBox(
              height: 16.0,
            ),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              String name = storedocs[index]['name'];
              String email = storedocs[index]['email'];

              return Ink(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          ViewDataPage(id: storedocs[index]['id']),
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => UpdateDataPage(
                                id: storedocs[index]['id'],
                              ),
                            ),
                          );
                          print("clicked");
                        },
                        icon: Icon(
                          Icons.edit,
                          color: Colors.black,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          deletePlace(storedocs[index]['id']);
                        },
                        icon: Icon(
                          Icons.delete,
                          size: 25.0,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                  title: Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    email,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
