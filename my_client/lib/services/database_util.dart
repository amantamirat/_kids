import 'dart:convert';

import 'package:abdu_kids/model/kind.dart';
import 'package:abdu_kids/model/util/cart_item.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class CartDataBase {
  static late final Future<Database> database;

  static Future<void> init() async {
    database = openDatabase(
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
    final db = await database;
    return await db.insert(
      CartItem.tableName,
      item.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<CartItem>> cartItems() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(CartItem.tableName);
    return List.generate(maps.length, (i) {
      return CartItem(
        id: maps[i][CartItem.attributeId],
        
        quantity: maps[i][CartItem.attributeQuantity],
      );
    });
  }

  static Future<void> updateCartItem(CartItem item) async {
    final db = await database;
    await db.update(
      CartItem.tableName,
      item.toMap(),
      where: '${CartItem.attributeId} = ?',
      whereArgs: [item.id],
    );
  }

  static Future<void> deleteItem(int id) async {
    final db = await database;
    await db.delete(
      CartItem.tableName,
      where: '${CartItem.attributeId} = ?',
      whereArgs: [id],
    );
  }
}
