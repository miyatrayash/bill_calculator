import 'dart:math';

import 'package:bill_calculator/Services/database_service.dart';
import 'package:bill_calculator/models/Item.dart';
import 'package:flutter/material.dart';

class ItemsProvider with ChangeNotifier {
  List<Item> _itemList = [];
  bool isDataLoaded = false;
  List<Item> get items => _itemList;

  Future<void> fetchData() async {
    _itemList = await DatabaseService.databaseServiceInstance.items;

    isDataLoaded = true;
    notifyListeners();
  }

  Future<void> add(Item item) async {
    await DatabaseService.databaseServiceInstance.addItem(item);
    await fetchData();
  }

  Future<void> update(Item item) async {

    await DatabaseService.databaseServiceInstance.updateItem(item);

    await fetchData();
  }

  Future<void> delete(String id) async {

    await DatabaseService.databaseServiceInstance.deleteItem(id);
    await fetchData();
  }

  Future<void> deleteAll() async {
    await DatabaseService.databaseServiceInstance.deleteAll();
    await fetchData();
  }

  Future<void> updateIndex(List<Item> items,int oldIndex,int newIndex) async {
    int sm = min(oldIndex,newIndex);
    int big = max(oldIndex,newIndex);
    for(int i = sm;i<=big;i++)
    {
        items[i].index = i;
        await DatabaseService.databaseServiceInstance.updateItem(items[i]);
    }
    await fetchData();
  }

}