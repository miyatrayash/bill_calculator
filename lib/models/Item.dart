
class Item {
  String id;
  String name;
  double price;

  Item({required this.id, required this.name, required this.price});
  factory Item.fromJson(dynamic json) {
    return Item(id: json['id'] , name: json['name'] as String, price: json['price']);
  }

  Map toJson() => {
    'id': id,
    'name': name,
    'price': price
  };
}

class ItemList {
  List<Item> items = [];

  ItemList(this.items);
  factory ItemList.fromJson(dynamic json) {

    var objJson = json['items'] as List;

    List<Item> tmp = objJson.map((item) => Item.fromJson(item)).toList();

    return ItemList(tmp);
  }

  Map toJson()  {
    List<Map> items =  this.items.map((e) => e.toJson()).toList();

    return {
      'items': items
    };
  }

}