import 'package:flutter/material.dart';

class EditProductScreen extends StatefulWidget {
  static const route = '/edit-product';

  const EditProductScreen({Key? key}) : super(key: key);

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();

  @override
  void dispose() {
    _priceFocusNode.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Product')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
            child: ListView(
          children: [
            TextFormField(
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(labelText: 'Title'),
              onFieldSubmitted: (_) {
                FocusScope.of(context).requestFocus(_priceFocusNode);
              },
            ),
            TextFormField(
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(labelText: 'Price'),
              keyboardType: TextInputType.number,
              focusNode: _priceFocusNode,
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Description'),
              keyboardType: TextInputType.multiline,
              maxLines: 3,
            ),
            Row(
              children: [
                Container(
                  width: 100,
                  height: 100,
                  margin: const EdgeInsets.only(top: 8, right: 10),
                  decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.grey)),
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
                    decoration: const InputDecoration(labelText: 'Image URL'),
                    keyboardType: TextInputType.url,
                    textInputAction: TextInputAction.done,
                    controller: _imageUrlController,
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
