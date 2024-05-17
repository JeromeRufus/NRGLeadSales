import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final user = _auth.currentUser;

void getCurrentUser() async {
  try {
    final uid = user?.uid;
    print("uid is " + uid!);
    if (user != null) {
      print(user?.email);
    }
  } catch (e) {
    print(e);
  }
}

class AddData extends StatefulWidget {
  const AddData({super.key});

  static const routeName = '/add';

  @override
  State<AddData> createState() => _AddDataState();
}

class _AddDataState extends State<AddData> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _mobileController = TextEditingController();
  List<String> _productsOfInterest = [];
  List<String> _availableProducts = ['Product A', 'Product B', 'Product C'];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    final cuser = await _auth.currentUser; //takeing user
    if (_formKey.currentState!.validate() && _productsOfInterest.isNotEmpty) {
      // Form is valid and products are selected
      try {
        await FirebaseFirestore.instance.collection('leaddata').add({
          'user': cuser?.email,
          'name': _nameController.text,
          'email': _emailController.text,
          'mobile': _mobileController.text,
          'products_of_interest': _productsOfInterest,
          'timestamp': FieldValue.serverTimestamp(),
        });
        // Clear the form after successful submission
        _formKey.currentState!.reset();
        setState(() {
          _productsOfInterest.clear();
          _nameController.clear();
          _emailController.clear();
          _mobileController.clear();
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Form submitted successfully')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to submit form: $e')),
        );
      }
    } else {
      // Display error if no product is selected
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Please select at least one product of interest.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Lead Data Entry',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.purple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              Card(
                margin: EdgeInsets.symmetric(vertical: 10.0),
                child: TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    labelStyle: TextStyle(fontSize: 20.0),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
              ),
              Card(
                margin: EdgeInsets.symmetric(vertical: 10.0),
                child: TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(fontSize: 20.0),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                ),
              ),
              Card(
                margin: EdgeInsets.symmetric(vertical: 10.0),
                child: TextFormField(
                  controller: _mobileController,
                  decoration: InputDecoration(
                    labelText: 'Mobile',
                    labelStyle: TextStyle(fontSize: 20.0),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your mobile number';
                    }
                    if (value.length != 10) {
                      return 'Mobile number must be 10 digits';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Text(
                  'Product of Interest',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              Column(
                children: _availableProducts.map((product) {
                  return CheckboxListTile(
                    title: Text(product),
                    value: _productsOfInterest.contains(product),
                    onChanged: (bool? value) {
                      setState(() {
                        if (value == true) {
                          _productsOfInterest.add(product);
                        } else {
                          _productsOfInterest.remove(product);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
