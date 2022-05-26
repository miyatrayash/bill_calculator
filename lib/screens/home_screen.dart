import 'package:bill_calculator/models/Item.dart';
import 'package:bill_calculator/providers/items_provider.dart';
import 'package:bill_calculator/screens/add_item_screen.dart';
import 'package:bill_calculator/screens/edit_item_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  static const route = '/home';
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<double> total = [];
  double s = 0;
  ValueNotifier<bool> isDialOpen = ValueNotifier(false);
  List<TextEditingController> controllers = [];

  @override
  Widget build(BuildContext context) {
    List<Item> items = context.watch<ItemsProvider>().items.items;
    // print(items);
    if (context.watch<ItemsProvider>().isDataLoaded) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor:  const Color.fromRGBO(98, 0, 238, 1),
          title: const Text('Calculate Bill'),
          centerTitle: true,
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  s = 0;

                  for (int i = 0; i < total.length; i++) {
                    total[i] = 0;
                    controllers[i].text = '';
                  }
                });
              },
              child: const Text(
                'Clear',
                style: TextStyle(fontSize: 25, color: Colors.white),
              ),
            ),
          ],
        ),
        floatingActionButton: SpeedDial(
          animatedIcon: AnimatedIcons.menu_close,
          openCloseDial: isDialOpen,
          foregroundColor: Colors.black,
          backgroundColor: const Color.fromRGBO(3, 218, 197,1),
          overlayColor: Colors.grey,
          overlayOpacity: 0.5,
          spacing: 15,
          spaceBetweenChildren: 15,
          children: [
            SpeedDialChild(
                child: const Icon(Icons.add_rounded),
                label: 'Add',
                onTap: () {
                  Navigator.pushNamed(context, AddItemScreen.route);
                }),
            SpeedDialChild(
                child: const Icon(Icons.edit_rounded),
                label: 'Edit',
                onTap: () {
                  
                  Navigator.pushNamed(context, EditItemsScreen.route);
                }),
          ],
        ),
        body: Center(
          child: (items.isNotEmpty)
              ? SingleChildScrollView(
                  child: Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height - 150,
                      child: ListView.builder(
                          itemCount: items.length,
                          itemBuilder: (context, index) {
                            total.add(0);
                            controllers.add(TextEditingController());
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 4.0),
                              child: Card(
                                key: Key(items[index].id.toString()),
                                child: InkWell(
                                  onTap: () {},
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                          width: 90,
                                          child: Text(
                                            items[index].name,
                                            style:
                                                const TextStyle(fontSize: 20),
                                          )),
                                      const SizedBox(
                                        width: 30,
                                        child: Center(
                                          child: Text(
                                            'X',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                3,
                                        child: TextField(
                                          controller: controllers[index],
                                          keyboardType: TextInputType.number,
                                          style: const TextStyle(fontSize: 20),
                                          decoration: const InputDecoration(
                                            border: OutlineInputBorder(),
                                          ),
                                          onChanged: (numTxt) {
                                            double t = 0;
                                            if (numTxt.isNotEmpty) {
                                              double quantity =
                                                  double.parse(numTxt);
                                              t = quantity * items[index].price;
                                            }

                                            setState(() {
                                              s -= total[index];
                                              total[index] = t;
                                              s += total[index];
                                            });
                                          },
                                        ),
                                      ),
                                      SizedBox(
                                        width: 100,
                                        child: Center(
                                            child: Text(
                                          '= ${total[index]}',
                                          style: const TextStyle(fontSize: 20),
                                        )),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                    ),
                    SizedBox(
                      height: 50,
                      child: Center(
                          child: Text(
                        'Total: $s',
                        style: const TextStyle(fontSize: 30),
                      )),
                    )
                  ],
                ))
              : const Text(
                  "Please Add Items",
                  style: TextStyle(fontSize: 30),
                ),
        ),
      );
    }

    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
