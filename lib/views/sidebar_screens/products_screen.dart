import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class ProductsScreen extends StatefulWidget {
  ProductsScreen({super.key});

  static const String id = "\ProductsScreen";

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {

  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  TextEditingController _sizeEdititingController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _discountController = TextEditingController();
  TextEditingController _quantityController = TextEditingController();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List<String> _categoryList = [];

  List<Uint8List> _images = [];
  bool showSizeButton = false;
  List<String> _sizeValues = [];
  List<String> _imagesUrls = [];

  String? _selectedCategory;
  String? productName;
  var productPrice;
  var discount;
  var quantity;
  String? description;

  _getCategories() {
    return _firebaseFirestore
        .collection('categories')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        setState(() {
          _categoryList.add(doc['categoryName']);
        });
      }
    });
  }

  _chooseImage() async {
    final pickedImages = await FilePicker.platform
        .pickFiles(allowMultiple: true, type: FileType.image);
    if (pickedImages != null) {
      setState(() {
        for (var image in pickedImages.files) {
          _images.add(image.bytes!);
        }
      });
    }
  }

  uploadProductImageToStorage() async {
    for (var img in _images) {
      Reference ref =
          _firebaseStorage.ref().child('productImages').child(Uuid().v4());
      await ref.putData(img).whenComplete(() async {
        await ref.getDownloadURL().then((value) {
          setState(() {
            _imagesUrls.add(value);
          });
        });
      });
    }
  }

  uploadProductsToCloudFirestore() async {
    await uploadProductImageToStorage();
    if (_imagesUrls.isNotEmpty) {
      final productId = Uuid().v4();
      await _firebaseFirestore.collection('products').doc(productId).set({
        'productId': productId,
        'productName': productName,
        'productPrice': productPrice,
        'productSize': _sizeValues,
        'category': _selectedCategory,
        'description': description,
        'discount': discount,
        'quantity': quantity,
        'productImages': _imagesUrls,
      }).whenComplete(() {
        setState(() {
          _formKey.currentState!.reset();
          _priceController.text = "";
          _discountController.text = "";
          _quantityController.text = "";
          _sizeValues.clear();
          _images.clear();
        });
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    _getCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        width: 400,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Product Information',
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                onChanged: (value) {
                  productName = value;
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Enter Field';
                  } else {
                    return null;
                  }
                },
                decoration: InputDecoration(
                    labelText: 'Enter Product Name',
                    fillColor: Colors.grey.shade200,
                    filled: true,
                    border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10.0))),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Flexible(
                    child: TextFormField(
                      controller: _priceController,
                      onChanged: (value) {
                        productPrice = double.parse(_priceController.text);
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter Field';
                        } else {
                          return null;
                        }
                      },
                      decoration: InputDecoration(
                          labelText: 'Enter Price',
                          fillColor: Colors.grey.shade200,
                          filled: true,
                          border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(10.0))),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Flexible(
                    child: DropdownButtonFormField(
                      decoration: InputDecoration(
                          labelText: 'Select a Category',
                          filled: true,
                          fillColor: Colors.grey.shade200,
                          border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(10.0))),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _selectedCategory = value;
                          });
                        }
                      },
                      items: _categoryList.map((e) {
                        return DropdownMenuItem(value: e, child: Text(e));
                      }).toList(),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: _discountController,
                onChanged: (value) {
                  discount = double.parse(_discountController.text);
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Enter Field';
                  } else {
                    return null;
                  }
                },
                decoration: InputDecoration(
                    labelText: 'Discount',
                    fillColor: Colors.grey.shade200,
                    filled: true,
                    border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10.0))),
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: _quantityController,
                onChanged: (value) {
                  quantity = int.parse(_quantityController.text);
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Enter Field';
                  } else {
                    return null;
                  }
                },
                decoration: InputDecoration(
                    labelText: 'Quantity',
                    fillColor: Colors.grey.shade200,
                    filled: true,
                    border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10.0))),
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                maxLength: 800,
                maxLines: 4,
                onChanged: (value) {
                  description = value;
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Enter Field';
                  } else {
                    return null;
                  }
                },
                decoration: InputDecoration(
                    labelText: 'Description',
                    fillColor: Colors.grey.shade200,
                    filled: true,
                    border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10.0))),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      width: 200,
                      child: TextFormField(
                        controller: _sizeEdititingController,
                        onChanged: (value) {
                          setState(() {
                            if (value.isNotEmpty) {
                              showSizeButton = true;
                            } else {
                              showSizeButton = false;
                            }
                          });
                        },
                        decoration: InputDecoration(
                            labelText: 'Add a Size',
                            fillColor: Colors.grey.shade200,
                            filled: true,
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(10.0))),
                      ),
                    ),
                  ),
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: showSizeButton
                        ? ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                            ),
                            onPressed: () {
                              setState(() {
                                _sizeValues.add(_sizeEdititingController.text);
                                _sizeEdititingController.clear();
                              });
                            },
                            child: Text('Add'),
                          )
                        : null,
                  )),
                ],
              ),
              _sizeValues.isNotEmpty
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        height: 50,
                        child: ListView.builder(
                          itemCount: _sizeValues.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                setState(() {
                                  _sizeValues.removeAt(index);
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.blue.shade800,
                                      borderRadius:
                                          BorderRadius.circular(10.0)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      _sizeValues[index],
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    )
                  : Text(''),
              SizedBox(
                height: 40,
              ),
              GridView.builder(
                itemCount: _images.length + 1,
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, mainAxisSpacing: 8, crossAxisSpacing: 8),
                itemBuilder: (context, index) {
                  return index == 0
                      ? Center(
                          child: IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () {
                              _chooseImage();
                            },
                          ),
                        )
                      : Image.memory(_images[index - 1]);
                },
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    //Upload product to CloudFirestore
                    uploadProductsToCloudFirestore();
                  }
                },
                child: Text('Add Product'),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    minimumSize: Size(double.infinity, 60),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0))),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ProductInputTextFormField extends StatelessWidget {
  ProductInputTextFormField({
    super.key,
    required this.text,
  });

  final TextEditingController _controller = TextEditingController();

  final String text;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (value) {
        if (value!.isNotEmpty) {
          return 'Enter Field';
        } else {
          return null;
        }
      },
      decoration: InputDecoration(
          labelText: text,
          fillColor: Colors.grey.shade200,
          filled: true,
          border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(10.0))),
    );
  }
}
