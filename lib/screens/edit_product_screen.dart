import 'package:flutter/material.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';
  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Edit Product'),
        ),
        body: Padding(
            padding: EdgeInsets.all(8),
            child: Form(
                child: ListView(
              children: [
                TextFormField(
                  decoration: InputDecoration(
                      hintText: "Enter", labelText: "Please Enter"),
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                )
              ],
            ))));
  }
}
