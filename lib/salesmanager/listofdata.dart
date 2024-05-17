import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sales/salesexecutive/update.dart';
import 'package:sales/salesexecutive/view.dart';
import 'package:sales/salesmanager/viewdata.dart';

class ListOfData extends StatefulWidget {
  ListOfData({Key? key}) : super(key: key);

  @override
  _ListOfDataState createState() => _ListOfDataState();
}

class _ListOfDataState extends State<ListOfData> {
  final Stream<QuerySnapshot> dataStream = FirebaseFirestore.instance
      .collection('leaddata')
      .orderBy('name', descending: false)
      .snapshots();

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // For Deleting User
  CollectionReference data = FirebaseFirestore.instance.collection('leaddata');
  Future<void> deletePlace(id) {
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
    return Material(
      child: Column(
        children: [
          SizedBox(
            height: 15,
          ),
          Container(
            width: 380,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.grey[350],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    labelText: 'Search by Name',
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.search),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {
                                _searchQuery = '';
                              });
                            },
                          )
                        : null,
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value.toLowerCase();
                    });
                  },
                ),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: dataStream,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasError) {
                  print('Something went Wrong');
                  return Center(child: Text('Something went wrong'));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final List storedocs = [];
                snapshot.data?.docs.map((DocumentSnapshot document) {
                  Map a = document.data() as Map<String, dynamic>;
                  if (_searchQuery.isEmpty ||
                      a['name']
                          .toString()
                          .toLowerCase()
                          .contains(_searchQuery)) {
                    storedocs.add(a);
                    a['id'] = document.id;
                  }
                }).toList();

                return Padding(
                  padding: EdgeInsets.only(top: 18.0),
                  child: ListView.separated(
                    separatorBuilder: (context, index) => SizedBox(
                      height: 16.0,
                    ),
                    itemCount: storedocs.length,
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
                                  ViewManager(id: storedocs[index]['id']),
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
            ),
          ),
        ],
      ),
    );
  }
}
