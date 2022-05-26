import 'package:bill_calculator/helpers/file_handler.dart';
import 'package:bill_calculator/models/Item.dart';
import 'package:flutter/material.dart';

class ItemsProvider with ChangeNotifier {
  ItemList _itemList = ItemList([]);
  bool isDataLoaded = false;
  ItemList get items => _itemList;

  Future<void> fetchData() async {
    _itemList = await FileHandler.readData();
    isDataLoaded = true;
    notifyListeners();
  }

  Future<void> update(ItemList itemList) async {
    await  FileHandler.writeData(itemList);
    await fetchData();
  }

}