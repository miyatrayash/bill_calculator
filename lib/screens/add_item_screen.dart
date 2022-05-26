import 'package:bill_calculator/models/Item.dart';
import 'package:bill_calculator/providers/items_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddItemScreen extends StatefulWidget {
  static const route = '/addItem';
  const AddItemScreen({Key? key}) : super(key: key);
  @override
  State<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  final _nameController = TextEditingController();
  final _nameFocusNode = FocusNode();
  final _priceController = TextEditingController();
  final _priceFocusNode = FocusNode();

  void handleSubmit() {
    String name = _nameController.text;
    if (name.isEmpty) {
      _nameFocusNode.requestFocus();
      return;
    }

    if (_priceController.text.isEmpty) {
      _priceFocusNode.requestFocus();
      return;
    }

    _nameFocusNode.unfocus();
    _priceFocusNode.unfocus();
    double price = double.parse(_priceController.text);

    ItemsProvider itemsProvider =
        Provider.of<ItemsProvider>(context, listen: false);

    if (itemsProvider.items.items.any((element) => element.name == name)) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('$name already exists please choose different name')));
      return;
    }

    itemsProvider.items.items.add(
        Item(id: DateTime.now().millisecondsSinceEpoch.toString(), name: name, price: price));

    itemsProvider.items.items.sort((a, b) => a.name.compareTo(b.name));
    itemsProvider.update(itemsProvider.items).then((value) {
      _nameController.text = "";
      _priceController.text = "";
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Item Added Successfully')));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(98, 0, 238, 1),
        centerTitle: true,
        title: const Text('Add Item'),
      ),
      body: Center(
        child: Card(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  margin: const EdgeInsets.all(10),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width -
                        MediaQuery.of(context).size.width / 10,
                    child: Center(
                      child: TextField(
                        onSubmitted: (txt) => _priceFocusNode.requestFocus(),
                        focusNode: _nameFocusNode,
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Item Name',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width -
                        MediaQuery.of(context).size.width / 10,
                    child: Center(
                      child: TextField(
                        focusNode: _priceFocusNode,
                        controller: _priceController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Item Price',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      margin: const EdgeInsets.all(10),
                      child: ElevatedButton(
                        onPressed: handleSubmit,
                        child: const Text('Add Item'),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(10),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(primary: Colors.red),
                        child: const Text('Cancel'),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
