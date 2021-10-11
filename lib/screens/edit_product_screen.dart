import 'package:flutter/material.dart';
import 'package:shop_app/providers/product.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';
  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descNode = FocusNode();
  final _urlController = TextEditingController();
  final _urlFocus = FocusNode();
  var _editedProduct =
      Product(id: null, description: "", title: "", price: 0, imageUrl: "");

  final _form = GlobalKey<FormState>();

  void initState() {
    _urlFocus.addListener(updateListener);
  }

  void updateListener() {
    if (!_urlFocus.hasFocus) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _urlFocus.removeListener(updateListener);
    _priceFocusNode.dispose();
    _descNode.dispose();
    _urlController.dispose();
    _urlFocus.dispose();
    super.dispose();
  }

  void _saveForm() {
    _form.currentState.save();
    print(_editedProduct.title);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Edit Product'), actions: [
          IconButton(onPressed: _saveForm, icon: Icon(Icons.save))
        ]),
        body: Padding(
            padding: EdgeInsets.all(8),
            child: Form(
                key: _form,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: InputDecoration(
                            hintText: "Enter", labelText: "Title"),
                        keyboardType: TextInputType.name,
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_priceFocusNode);
                        },
                        onSaved: (value) {
                          _editedProduct = Product(
                              description: _editedProduct.description,
                              price: _editedProduct.price,
                              title: value,
                              id: null,
                              imageUrl: _editedProduct.imageUrl,
                              isFavorite: _editedProduct.isFavorite);
                        },
                      ),
                      TextFormField(
                          decoration: InputDecoration(
                              hintText: "Enter", labelText: "Price"),
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context).requestFocus(_descNode);
                          },
                          onSaved: (value) {
                            _editedProduct = Product(
                                description: _editedProduct.description,
                                price: double.parse(value),
                                title: _editedProduct.title,
                                id: null,
                                imageUrl: _editedProduct.imageUrl,
                                isFavorite: _editedProduct.isFavorite);
                          },
                          focusNode: _priceFocusNode),
                      TextFormField(
                          decoration: InputDecoration(
                              hintText: "Enter", labelText: "Description"),
                          keyboardType: TextInputType.multiline,
                          onSaved: (value) {
                            _editedProduct = Product(
                                description: value,
                                price: _editedProduct.price,
                                title: _editedProduct.title,
                                id: null,
                                imageUrl: _editedProduct.imageUrl,
                                isFavorite: _editedProduct.isFavorite);
                          },
                          maxLines: 3,
                          textInputAction: TextInputAction.next,
                          focusNode: _descNode),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            child: _urlController.text.isEmpty
                                ? Text("No Image")
                                : (FittedBox(
                                    child: Image.network(_urlController.text),
                                  )),
                            margin: EdgeInsets.only(top: 8.0, right: 10.0),
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.black, width: 2.0)),
                          ),
                          Expanded(
                            child: TextFormField(
                              decoration: InputDecoration(
                                  hintText: "Enter URL",
                                  labelText: "Image URL"),
                              keyboardType: TextInputType.url,
                              onSaved: (value) {
                                _editedProduct = Product(
                                    description: _editedProduct.description,
                                    price: _editedProduct.price,
                                    title: _editedProduct.title,
                                    id: null,
                                    imageUrl: value,
                                    isFavorite: _editedProduct.isFavorite);
                              },
                              textInputAction: TextInputAction.done,
                              controller: _urlController,
                              focusNode: _urlFocus,
                              onFieldSubmitted: (_) {
                                _saveForm();
                              },
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ))));
  }
}
