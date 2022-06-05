import 'package:awesome_icons/awesome_icons.dart';
import 'package:bill_calculator/helpers/custom_snackbar.dart';
import 'package:bill_calculator/helpers/file_handler.dart';
import 'package:bill_calculator/models/Item.dart';
import 'package:bill_calculator/providers/items_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
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

    if (itemsProvider.items.any((element) => element.name == name)) {
      CustomSnackBar.showSnackBar('$name is already exist', context);
      return;
    }

    itemsProvider
        .add(Item(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            name: name,
            price: price))
        .then((value) {
      _nameController.text = '';
      _priceController.text = '';

      CustomSnackBar.showSnackBar('Item Added Successfully', context);
    });
  }

  ValueNotifier<bool> isDialOpen = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        openCloseDial: isDialOpen,
        foregroundColor: Colors.black,
        backgroundColor: const Color.fromRGBO(3, 218, 197, 1),
        overlayColor: Colors.grey,
        overlayOpacity: 0.5,
        spacing: 15,
        spaceBetweenChildren: 15,
        children: const [
          // SpeedDialChild(
          //     child: const Center(
          //         child: Icon(FontAwesomeIcons.fileImport, size: 20)),
          //     label: 'Import',
          //     onTap: () {
          //       FileHandler.importData().then((value) {
          //         CustomSnackBar.showSnackBar(value, context);
          //       });
          //     })
        ],
      ),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(98, 0, 238, 1),
        centerTitle: true,
        title: const Text('Add Item'),
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.all(10),
              child: SizedBox(
                width: MediaQuery.of(context).size.width -
                    MediaQuery.of(context).size.width / 10,
                child: Center(
                  child: TextField(
                    style: const TextStyle(fontSize: 20),
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
                    style: const TextStyle(fontSize: 20),
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
                    style: ElevatedButton.styleFrom(
                        primary: const Color.fromRGBO(98, 0, 238, 1)),
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
    );
  }
}
