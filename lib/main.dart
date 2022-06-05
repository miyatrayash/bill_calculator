import 'package:bill_calculator/Services/database_service.dart';
import 'package:bill_calculator/models/Item.dart';
import 'package:bill_calculator/screens/add_item_screen.dart';
import 'package:bill_calculator/screens/edit_item_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:bill_calculator/providers/items_provider.dart';
import 'package:bill_calculator/screens/home_screen.dart';

void main(){



  runApp(MultiProvider(
    providers: [ChangeNotifierProvider(create: (_) => ItemsProvider())],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.watch<ItemsProvider>().fetchData();
    return  MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Bill Calculator',
        initialRoute: HomeScreen.route,
        routes: {
          HomeScreen.route: (context) => const HomeScreen(),
          AddItemScreen.route: (context) => const AddItemScreen(),
          EditItemsScreen.route: (context) => const EditItemsScreen()
        },
    );
  }
}