import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/product.dart';
import 'package:shop_app/providers/products.dart';

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
  var _isInit = true;
  var edit = false;
  var _isLoading = false;
  var _initialProduct = {
    "id": ' ',
    "title": ' ',
    "description": ' ',
    "price": "0",
    "isFavorited": false
  };
  var _editedProduct =
      Product(id: 'p5', description: "", title: "", price: 0, imageUrl: "");

  final _form = GlobalKey<FormState>();

  @override
  void initState() async {
    _urlFocus.addListener(updateListener);
    await Future.delayed(Duration(milliseconds: 2), ()=>{
      
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      final productId = ModalRoute.of(context).settings.arguments;
      if (productId != null) {
        _editedProduct =
            Provider.of<Products>(context, listen: false).findById(productId);
        _initialProduct['id'] = _editedProduct.id;
        _initialProduct["title"] = _editedProduct.title;
        _initialProduct["description"] = _editedProduct.description;
        _initialProduct['price'] = _editedProduct.price.toString();
        _initialProduct['isFavorite'] = _editedProduct.isFavorite;
        _urlController.text = _editedProduct.imageUrl;
        edit = true;
      }
    }
    _isInit = false;
    return;
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

  void _saveForm() async {
    setState(() {
      _isLoading = true;
    });
    var _final = _form.currentState.validate();
    if (!_final) {
      setState(() {
        _isLoading = false;
      });
      return;
    }
    _form.currentState.save();
    if (!edit) {
      try {
        await Provider.of<Products>(context, listen: false)
            .addProduct(_editedProduct);
        setState(() {
          _isLoading = false;
        });
      } catch (err) {
        setState(() {
          _isLoading = false;
        });
      }
      // await Provider.of<Products>(context, listen: false)
      //     .addProduct(_editedProduct)
      //     .then((_) {
      //   setState(() {
      //     _isLoading = false;
      //   });
      // });
    } else {
      try {
        setState(() {
          _isLoading = true;
        });
        await Provider.of<Products>(context, listen: false)
            .updateProduct(_editedProduct.id, _editedProduct);
        setState(() {
          _isLoading = false;
        });
      } catch (err) {
        setState(() {
          _isLoading = false;
        });
      }
      // Provider.of<Products>(context, listen: false)
      //     .updateProduct(_editedProduct.id, _editedProduct);
      // setState(() {
      //   _isLoading = true;
      // });
    }

    Navigator.of(context).pop();
    // print(_editedProduct);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Edit Product'), actions: [
          IconButton(onPressed: _saveForm, icon: Icon(Icons.save))
        ]),
        body: _isLoading
            ? Center(child: CircularProgressIndicator())
            : Padding(
                padding: EdgeInsets.all(8),
                child: Form(
                    key: _form,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          TextFormField(
                            validator: (val) {
                              if (val.isEmpty) {
                                return "Please provide a Title";
                              }
                              return null;
                            },
                            initialValue: _initialProduct["title"],
                            decoration: InputDecoration(
                                hintText: "Enter", labelText: "Title"),
                            keyboardType: TextInputType.name,
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (_) {
                              FocusScope.of(context)
                                  .requestFocus(_priceFocusNode);
                            },
                            onSaved: (value) {
                              _editedProduct = Product(
                                  description: _editedProduct.description,
                                  price: _editedProduct.price,
                                  title: value,
                                  id: _editedProduct.id,
                                  imageUrl: _editedProduct.imageUrl,
                                  isFavorite: _editedProduct.isFavorite);
                            },
                          ),
                          TextFormField(
                              initialValue: _initialProduct["price"],
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
                                    id: _editedProduct.id,
                                    imageUrl: _editedProduct.imageUrl,
                                    isFavorite: _editedProduct.isFavorite);
                              },
                              focusNode: _priceFocusNode),
                          TextFormField(
                              initialValue: _initialProduct["description"],
                              decoration: InputDecoration(
                                  hintText: "Enter", labelText: "Description"),
                              keyboardType: TextInputType.multiline,
                              onSaved: (value) {
                                _editedProduct = Product(
                                    description: value,
                                    price: _editedProduct.price,
                                    title: _editedProduct.title,
                                    id: _editedProduct.id,
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
                                        child:
                                            Image.network(_urlController.text),
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
                                        id: _editedProduct.id,
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
