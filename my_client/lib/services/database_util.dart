import 'package:abdu_kids/model/util/cart_item.dart';
import 'package:abdu_kids/services/my_service.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class CartDataBase {
  static late final Future<Database> _database;

  static Future<void> init() async {
    _database = openDatabase(
      join(await getDatabasesPath(), "cart_database.db"),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE ${CartItem.tableName} (${CartItem.attributeId} TEXT PRIMARY KEY, ${CartItem.attributeQuantity}  INTEGER,  ${CartItem.attributePrice}  DOUBLE, ${CartItem.attributeCategoryId} TEXT, ${CartItem.attributeTypeId}  TEXT, ${CartItem.attributeBrandId}  TEXT, ${CartItem.attributeProductId} TEXT)",
        );
      },
      version: 1,
    );
    //deleteDatabase(join(await getDatabasesPath(), "cart_database.db"));
  }

  static Future<int> insertItem(CartItem item) async {
    final db = await _database;
    return await db.insert(
      CartItem.tableName,
      item.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<CartItem>> cartItems() async {
    final db = await _database;
    final List<Map<String, dynamic>> maps = await db.query(CartItem.tableName);
    List<CartItem> items = List.empty(growable: true);
    for (int i = 0; i < maps.length; i++) {
      final cartItem = CartItem(
        kindId: maps[i][CartItem.attributeId],
        quantity: maps[i][CartItem.attributeQuantity],
        categoryId: maps[i][CartItem.attributeCategoryId],
        typeId: maps[i][CartItem.attributeTypeId],
        brandId: maps[i][CartItem.attributeBrandId],
        productId: maps[i][CartItem.attributeProductId],
        price: maps[i][CartItem.attributePrice],
      );
      cartItem.selectedKind = MyService.findKind(cartItem);

      if (cartItem.selectedKind != null) {
        if (cartItem.selectedKind!.product!.price != cartItem.price) {
          cartItem.price = cartItem.selectedKind!.product!.price;
          updateCartItem(cartItem);
        }
        if (cartItem.selectedKind!.quantity! < cartItem.quantity) {
          deleteItem(cartItem);
          continue;
        }
        items.add(cartItem);
      }
    }
    /*
    return List.generate(maps.length, (i) {
      return cartItem;
    });
    */
    return items;
  }

  static Future<int> updateCartItem(CartItem item) async {
    final db = await _database;
    return await db.update(
      CartItem.tableName,
      item.toJson(),
      where: '${CartItem.attributeId} = ?',
      whereArgs: [item.kindId],
    );
  }

  static Future<int> deleteItem(CartItem item) async {
    final db = await _database;
    return await db.delete(
      CartItem.tableName,
      where: '${CartItem.attributeId} = ?',
      whereArgs: [item.kindId],
    );
  }
}
