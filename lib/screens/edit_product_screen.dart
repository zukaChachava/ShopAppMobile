import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/product_model.dart';
import 'package:shop_app/providers/products_provider.dart';

class EditProductScreen extends StatefulWidget {
  static const route = '/edit-product';

  const EditProductScreen({Key? key}) : super(key: key);

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _form = GlobalKey<FormState>();
  bool _isLoading = false;
  Product _editedProduct =
      Product(id: '', title: '', description: '', imageUrl: '', price: 0);

  @override
  void dispose() {
    _priceFocusNode.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  Future<void> _saveForm() async {
    final provider = Provider.of<ProductsProvider>(context, listen: false);
    final isValid = _form.currentState?.validate();
    if (isValid == null || !isValid) return;
    _form.currentState?.save();

    setState(() {
      _isLoading = true;
    });

    if (_editedProduct.id != '') {
      await provider.updateProduct(_editedProduct.id, _editedProduct);
      setState(() {
        _isLoading = false;
      });
    } else {
      await provider.addProduct(_editedProduct);
      setState(() {
        _isLoading = false;
      });
    }
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  void _loadProduct(BuildContext context) {
    final productId = ModalRoute.of(context)!.settings.arguments as String?;
    if (productId != null) {
      _editedProduct = Provider.of<ProductsProvider>(context, listen: false)
          .findById(productId);

      _imageUrlController.text = _editedProduct.imageUrl;
    }
  }

  @override
  Widget build(BuildContext context) {
    _loadProduct(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Product'),
        actions: [
          IconButton(onPressed: _saveForm, icon: const Icon(Icons.save))
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                  key: _form,
                  child: ListView(
                    children: [
                      TextFormField(
                        initialValue: _editedProduct.title != ''
                            ? _editedProduct.title
                            : null,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(labelText: 'Title'),
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_priceFocusNode);
                        },
                        validator: (value) {
                          if (value == null || value == '') return 'Fill this';
                          return null;
                        },
                        onSaved: (value) {
                          if (value == null) return;
                          _editedProduct = Product(
                              id: _editedProduct.id,
                              description: _editedProduct.description,
                              imageUrl: _editedProduct.imageUrl,
                              price: _editedProduct.price,
                              title: value);
                        },
                      ),
                      TextFormField(
                        initialValue: _editedProduct.price != 0
                            ? _editedProduct.price.toString()
                            : null,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(labelText: 'Price'),
                        keyboardType: TextInputType.number,
                        focusNode: _priceFocusNode,
                        validator: (value) {
                          if (value == null || value == '') return 'Fill this';
                          var number = double.tryParse(value);
                          if (number == null) return 'Invalid number';
                          if (number <= 0) return 'Enter above 0';
                          return null;
                        },
                        onSaved: (value) {
                          if (value == null) return;
                          _editedProduct = Product(
                              id: _editedProduct.id,
                              description: _editedProduct.description,
                              imageUrl: _editedProduct.imageUrl,
                              price: double.parse(value),
                              title: _editedProduct.title);
                        },
                      ),
                      TextFormField(
                        initialValue: _editedProduct.description != ''
                            ? _editedProduct.description
                            : null,
                        decoration:
                            const InputDecoration(labelText: 'Description'),
                        keyboardType: TextInputType.multiline,
                        maxLines: 3,
                        validator: (value) {
                          if (value == null || value == '') return 'Fill this';
                          return null;
                        },
                        onSaved: (value) {
                          if (value == null) return;
                          _editedProduct = Product(
                              id: _editedProduct.id,
                              description: value,
                              imageUrl: _editedProduct.imageUrl,
                              price: _editedProduct.price,
                              title: _editedProduct.title);
                        },
                      ),
                      Row(
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            margin: const EdgeInsets.only(top: 8, right: 10),
                            decoration: BoxDecoration(
                                border:
                                    Border.all(width: 1, color: Colors.grey)),
                            child: _imageUrlController.text.isEmpty
                                ? const Text('Enter a URL')
                                : FittedBox(
                                    child: Image.network(
                                      _imageUrlController.text,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                          ),
                          Expanded(
                            child: TextFormField(
                              decoration:
                                  const InputDecoration(labelText: 'Image URL'),
                              keyboardType: TextInputType.url,
                              textInputAction: TextInputAction.done,
                              controller: _imageUrlController,
                              onFieldSubmitted: (_) => _saveForm(),
                              validator: (value) {
                                if (value == null || value == '') {
                                  return 'Fill this';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                if (value == null) return;
                                _editedProduct = Product(
                                    id: _editedProduct.id,
                                    description: _editedProduct.description,
                                    imageUrl: value,
                                    price: _editedProduct.price,
                                    title: _editedProduct.title);
                              },
                            ),
                          )
                        ],
                      ),
                    ],
                  )),
            ),
    );
  }
}
