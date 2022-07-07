import 'dart:io';
//[product List]--select items-->[cart]--checkout-->[Order complete]
//ecommmerce website --1.UI  2.Business Logic(this project will cover) 3.RemoteDB(server)
//Command Line application
//Entities
//Product(-id,-name,-price)      //product one to one item
//item(-product,-quantity,-price)
//Cart(-items,-total)            //item many to one cart

class Product {
  const Product({required this.id, required this.name, required this.price});
  final int id;
  final String name;
  final double price;
  String get displayName => '($intial)${name.substring(1)}:\$$price';
  String get intial => name.substring(0, 1);
}

class Item {
  const Item({required this.product, this.quantity = 1});
  final Product product;
  final int quantity;
  double get price => quantity * product.price;
  @override
  String toString() => '$quantity x ${product.name}:\$$price';
}

class Cart {
  final Map<int, Item> _items = {};
  void addProduct(Product product) {
    final item = _items[product.id];
    if (item == null) {
      _items[product.id] = Item(product: product, quantity: 1);
    } else {
      _items[product.id] = Item(product: product, quantity: item.quantity + 1);
    }
  }

  bool get isEmpty => _items.isEmpty;

  double total() => _items.values
      .map((item) => item.price)
      .reduce((value, element) => value + element);

  @override
  String toString() {
    if (_items.isEmpty) {
      return 'cart is empty';
    }
    final itemizedList =
        _items.values.map((item) => item.toString()).join('\n');
    return '------\n$itemizedList\nTotal:\$${total()}\n------';
  }
}

const allProducts = [
  Product(id: 1, name: 'apples', price: 1.60),
  Product(id: 2, name: 'bananas', price: 0.70),
  Product(id: 3, name: 'courgettes', price: 1.0),
  Product(id: 4, name: 'grapes', price: 2.00),
  Product(id: 5, name: 'mushrooms', price: 0.80),
  Product(id: 6, name: 'potatoes', price: 1.50),
];

//Adding interactive prompt
//loop
//prompt:view cart /add items /checkout
//if selection==add item
//choose a product
//add it to the cart
//print cart
//else if selection==view cart
//print cart
//else if selection==checkout
//do checkout
//exit
//end
void main() {
  final cart = Cart();
  while (true) {
    stdout.write('what do you want to do? (v)iew items,(a)dd item,(c)heckout:');

    final line = stdin.readLineSync();
    if (line == 'a') {
      final product = chooseProduct();
      if (product != null) {
        cart.addProduct(product);
        print(cart);
      }
    } else if (line == 'v') {
      print(cart);
    } else if (line == 'c') {
      if (checkout(cart)) {
        break;
      }
    }
  }
}

Product? chooseProduct() {
  final productsList = allProducts
      .map((product) => product.displayName)
      .join('\n'); //making it nullable type
  stdout.write('Available products:\n$productsList\nYour choice:');
  final line = stdin.readLineSync();
  for (var product in allProducts) {
    if (product.intial == line) {
      return product;
    }
  }
  print('Not Found');
  return null;
}

bool checkout(Cart cart) {
  if (cart.isEmpty) {
    print('Cart is Empty');
    return false;
  }
  final total = cart.total();
  print('Total:\$$total');
  stdout.write('Payment in Cash');
  final line = stdin.readLineSync();
  if (line == null || line.isEmpty) {
    return false;
  }
  final paid = double.tryParse(line);
  if (paid == null) {
    return false;
  }
  if (paid >= total) {
    final change = paid - total;
    print('Change:\$${change.toStringAsFixed(2)}');
    return true;
  } else {
    print('Not enough cash ');
    return false;
  }
}
