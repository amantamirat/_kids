import 'package:abdu_kids/model/util/cart_item.dart';
import 'package:abdu_kids/services/my_service.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';


class CartDataBase {
  
  static late final Future<Database> _database;

  static Future<void> init() async {
    _database = openDatabase(
      join(await getDatabasesPath(), 'cart_database.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE ${CartItem.tableName}(${CartItem.attributeId} TEXT PRIMARY KEY, ${CartItem.attributeQuantity}  INTEGER )',
        );
      },
      version: 1,
    );
  }

  static Future<int> insertItem(CartItem item) async {
    final db = await _database;
    return await db.insert(
      CartItem.tableName,
      item.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<CartItem>> cartItems() async {
    final db = await _database;
    final List<Map<String, dynamic>> maps = await db.query(CartItem.tableName);
    return List.generate(maps.length, (i) {
      return CartItem(
        id: maps[i][CartItem.attributeId],
        quantity: maps[i][CartItem.attributeQuantity],
        selectedKind: MyService.findKindById(maps[i][CartItem.attributeId]),
      );
    });
  }

  static Future<int> updateCartItem(CartItem item) async {
    final db = await _database;
    return await db.update(
      CartItem.tableName,
      item.toMap(),
      where: '${CartItem.attributeId} = ?',
      whereArgs: [item.id],
    );
  }

  static Future<int> deleteItem(String id) async {
    final db = await _database;
    return await db.delete(
      CartItem.tableName,
      where: '${CartItem.attributeId} = ?',
      whereArgs: [id],
    );
  }
}
