
class Item {
  String id;
  int? index;
  String name;
  double price;

  Item({required this.id, required this.name, required this.price,this.index});
  factory Item.fromJson(dynamic json) {

    return Item(id: json['id'] , name: json['name'], price: json['price'], index: json['indx']);
  }

  Map<String,dynamic> toJson() => {
    'id': id,
    'name': name,
    'price': price,
    'indx': index
  };
}
