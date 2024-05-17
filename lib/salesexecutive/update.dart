import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class UpdateDataPage extends StatefulWidget {
  final String id;

  UpdateDataPage({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  _UpdateDataPageState createState() => _UpdateDataPageState();
}

class _UpdateDataPageState extends State<UpdateDataPage> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final mobileController = TextEditingController();
  List<String> productsOfInterest = [];
  List<String> _availableProducts = ['Product A', 'Product B', 'Product C'];

  CollectionReference leaddata =
      FirebaseFirestore.instance.collection('leaddata');

  Future<void> updatePlace(
    String id,
    String name,
    String email,
    String mobile,
    List<String> productsOfInterest,
  ) {
    return leaddata.doc(id).update({
      'name': name,
      'email': email,
      'mobile': mobile,
      'products_of_interest': productsOfInterest,
    }).then((value) {
      print("Data Updated");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Form submitted successfully')),
      );
    }).catchError((error) {
      print("Failed to update data: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to submit form: $error')),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text(
          "Update Data",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.purple,
      ),
      body: Form(
          key: _formKey,
          // Getting Specific Data by ID
          child: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            future: FirebaseFirestore.instance
                .collection('leaddata')
                .doc(widget.id)
                .get(),
            builder: (_, snapshot) {
              if (snapshot.hasError) {
                print('Something Went Wrong');
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              var data = snapshot.data!.data();
              nameController.text = data!['name'];
              emailController.text = data['email'];
              mobileController.text = data['mobile'];
              productsOfInterest =
                  List<String>.from(data['products_of_interest']);

              return Padding(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                child: ListView(
                  children: [
                    Card(
                      elevation: 10.0,
                      margin: EdgeInsets.symmetric(vertical: 10.0),
                      child: TextFormField(
                        controller: nameController,
                        autofocus: false,
                        decoration: const InputDecoration(
                          labelText: 'Name: ',
                          labelStyle: TextStyle(fontSize: 20.0),
                          border: OutlineInputBorder(),
                          errorStyle:
                              TextStyle(color: Colors.redAccent, fontSize: 15),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please Enter Name';
                          }
                          return null;
                        },
                      ),
                    ),
                    Card(
                      elevation: 10.0,
                      margin: EdgeInsets.symmetric(vertical: 10.0),
                      child: TextFormField(
                        controller: emailController,
                        autofocus: false,
                        decoration: const InputDecoration(
                          labelText: 'Email: ',
                          labelStyle: TextStyle(fontSize: 20.0),
                          border: OutlineInputBorder(),
                          errorStyle:
                              TextStyle(color: Colors.redAccent, fontSize: 15),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter an email';
                          }
                          if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                            return 'Please enter a valid email address';
                          }
                          return null;
                        },
                      ),
                    ),
                    Card(
                      elevation: 10.0,
                      margin: EdgeInsets.symmetric(vertical: 10.0),
                      child: TextFormField(
                        controller: mobileController,
                        autofocus: false,
                        decoration: const InputDecoration(
                          labelText: 'Mobile: ',
                          labelStyle: TextStyle(fontSize: 20.0),
                          border: OutlineInputBorder(),
                          errorStyle:
                              TextStyle(color: Colors.redAccent, fontSize: 15),
                        ),
                        keyboardType: TextInputType.phone,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(10),
                        ],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a mobile number';
                          }
                          if (value.length != 10) {
                            return 'Mobile number must be 10 digits';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Products of Interest',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Column(
                      children: _availableProducts.map((product) {
                        return CheckboxListTile(
                          title: Text(product),
                          value: productsOfInterest.contains(product),
                          onChanged: (bool? value) {
                            setState(() {
                              if (value == true) {
                                productsOfInterest.add(product);
                              } else {
                                productsOfInterest.remove(product);
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              // Validate returns true if the form is valid, otherwise false.
                              if (_formKey.currentState!.validate()) {
                                updatePlace(
                                  widget.id,
                                  nameController.text,
                                  emailController.text,
                                  mobileController.text,
                                  productsOfInterest,
                                );
                                Navigator.pop(context);
                              }
                            },
                            child: const Text(
                              'Update',
                              style: TextStyle(fontSize: 18.0),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              );
            },
          )),
    );
  }
}
