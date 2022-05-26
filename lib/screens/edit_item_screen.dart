import 'dart:math';

import 'package:bill_calculator/helpers/custom_dialog.dart';
import 'package:bill_calculator/models/Item.dart';
import 'package:bill_calculator/providers/items_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditItemsScreen extends StatefulWidget {
  static const route = '/editItems';
  const EditItemsScreen({Key? key}) : super(key: key);

  @override
  State<EditItemsScreen> createState() => _EditItemsScreenState();
}

class _EditItemsScreenState extends State<EditItemsScreen> {
  @override
  Widget build(BuildContext context) {
    List<Item> items = context.watch<ItemsProvider>().items.items;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Items'),
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(98, 0, 238, 1),
      ),
      body: Center(
        child: (items.isNotEmpty)
            ? SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height - 100,
                      child: ReorderableListView.builder(
                          itemCount: items.length,
                          itemBuilder: (context, index) {
                            return Card(
                              key:  ValueKey(items[index].id),
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15.0))),
                              elevation: 2,
                              margin: const EdgeInsets.all(10.0),
                              child: ExpansionTile(
                                trailing: const Icon(Icons.edit_rounded),
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Name: ${items[index].name}',
                                      style: const TextStyle(fontSize: 20),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text('Price: ${items[index].price}'),
                                  ],
                                ),
                                children: [
                                  EditForm(
                                    items: items,
                                    index: index,
                                  ),
                                ],
                              ),
                            );
                          }, onReorder: (int oldIndex, int newIndex) {
                        setState(() {
                          if(newIndex>oldIndex){
                            newIndex-=1;
                          }
                          final item =items.removeAt(oldIndex);
                          items.insert(newIndex, item);
                          ItemsProvider itemProvider = Provider.of<ItemsProvider>(context,listen: false);
                          itemProvider.update(ItemList(items));
                        });
                      },),
                    ),
                  ],
                ),
              )
            : const Text(
                "Please Add Items",
                style: TextStyle(fontSize: 30),
              ),
      ),
    );
  }
}

class EditForm extends StatefulWidget {
  const EditForm({
    Key? key,
    required this.items,
    required this.index,
  }) : super(key: key);

  final List<Item> items;
  final int index;
  @override
  State<EditForm> createState() => _EditFormState();
}

class _FormData {
  String name = '';
  double price = 0;
}

class _EditFormState extends State<EditForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _FormData _data = _FormData();

  @override
  Widget build(BuildContext context) {
    final items = widget.items;
    final index = widget.index;

    return Form(
      key: _formKey,
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  margin: const EdgeInsets.all(10),
                  width: MediaQuery.of(context).size.width / 2.5,
                  child: TextFormField(
                    initialValue: items[index].name,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Enter The Name';
                      }

                      return null;
                    },
                    onSaved: (String? value) {
                      setState(() {
                        if (value != null) {
                          _data.name = value;
                        } else {
                          _data.name = '';
                        }
                      });
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  width: MediaQuery.of(context).size.width / 2.5,
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    initialValue: items[index].price.toString(),
                    validator: (value) {
                      if (value == null || value.isEmpty || value == '0') {
                        return 'Please Enter The Price';
                      }
                      return null;
                    },
                    onSaved: (String? value) {
                      setState(() {
                        if (value != null) {
                          _data.price = double.parse(value);
                        } else {
                          _data.price = 0;
                        }
                      });
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                    margin: const EdgeInsets.all(10),
                    child: ElevatedButton(
                        onPressed: () {
                          FormState? currentState = _formKey.currentState;
                          print(_data.name);
                          if (currentState == null ||
                              !currentState.validate()) {
                            return;
                          }
                          currentState.save();
                          String name = _data.name;
                          double price = _data.price;

                          if (name.isNotEmpty && price != 0) {
                            items[index].name = name;
                            items[index].price = price;
                            print(items[index].price);
                            ItemsProvider itemProvider =
                                Provider.of<ItemsProvider>(context,
                                    listen: false);

                            items.sort((a, b) => a.name.compareTo(b.name));
                            itemProvider.update(ItemList(items)).then((value) =>
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content:
                                            Text('Item Edited Successfully'))));
                          }
                        },
                        child: const Text('Edit'))),
                Container(
                    margin: const EdgeInsets.all(10),
                    child: ElevatedButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return CustomDialog(
                                items: widget.items,
                                index: widget.index,
                                title:
                                    'Are you Sure You want to Delete This Item',
                                onConfirm: () {
                                  ItemsProvider itemProvider =
                                      Provider.of<ItemsProvider>(context,
                                          listen: false);
                                  widget.items.removeAt(widget.index);
                                  itemProvider
                                      .update(ItemList(widget.items))
                                      .then((value) =>
                                          Navigator.of(context).pop());
                                },
                              );
                            });
                      },
                      style: ElevatedButton.styleFrom(primary: Colors.red),
                      child: const Text('Delete'),
                    )),
              ],
            )
          ],
        ),
      ),
    );
  }
}
