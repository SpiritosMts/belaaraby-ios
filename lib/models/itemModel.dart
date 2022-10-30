import 'package:image_picker/image_picker.dart';

class Item {
  String? name;
  String? price;
  String? newPrice;
  String? desc;
  String? imageUrl;
  String? categ;
  String? promoted;
  String? currency;

  Item({
    this.name,
    this.price,
    this.newPrice,
    this.desc,
    this.imageUrl,
    this.promoted,
    this.categ,
    this.currency,
  });
}
