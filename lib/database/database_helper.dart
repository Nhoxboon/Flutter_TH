import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'btth02.db');
    return await openDatabase(
      path,
      version: 2,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Add orders table for existing databases
      await db.execute('''
        CREATE TABLE orders (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          customerName TEXT NOT NULL,
          phoneNumber TEXT NOT NULL,
          deliveryAddress TEXT NOT NULL,
          notes TEXT NOT NULL,
          deliveryDate INTEGER NOT NULL,
          paymentMethod TEXT NOT NULL,
          products TEXT NOT NULL,
          orderId TEXT NOT NULL UNIQUE,
          createdAt INTEGER NOT NULL
        )
      ''');
    }
  }

  Future<void> _onCreate(Database db, int version) async {
    // Users table for registration
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        fullName TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        phoneNumber TEXT NOT NULL,
        password TEXT NOT NULL,
        birthDate TEXT NOT NULL,
        gender TEXT NOT NULL,
        createdAt TEXT NOT NULL
      )
    ''');

    // Addresses table
    await db.execute('''
      CREATE TABLE addresses (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        recipientName TEXT NOT NULL,
        phoneNumber TEXT NOT NULL,
        province TEXT NOT NULL,
        district TEXT NOT NULL,
        ward TEXT NOT NULL,
        detailAddress TEXT NOT NULL,
        latitude REAL,
        longitude REAL,
        createdAt TEXT NOT NULL
      )
    ''');

    // Products table
    await db.execute('''
      CREATE TABLE products (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        price REAL NOT NULL,
        description TEXT,
        category TEXT NOT NULL,
        isDiscounted INTEGER NOT NULL DEFAULT 0,
        createdAt TEXT NOT NULL
      )
    ''');

    // Product images table
    await db.execute('''
      CREATE TABLE product_images (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        productId INTEGER NOT NULL,
        imagePath TEXT NOT NULL,
        FOREIGN KEY (productId) REFERENCES products (id) ON DELETE CASCADE
      )
    ''');

    // Orders table
    await db.execute('''
      CREATE TABLE orders (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        customerName TEXT NOT NULL,
        phoneNumber TEXT NOT NULL,
        deliveryAddress TEXT NOT NULL,
        notes TEXT NOT NULL,
        deliveryDate INTEGER NOT NULL,
        paymentMethod TEXT NOT NULL,
        products TEXT NOT NULL,
        orderId TEXT NOT NULL UNIQUE,
        createdAt INTEGER NOT NULL
      )
    ''');
  }

  // User operations
  Future<int> insertUser(Map<String, dynamic> user) async {
    final db = await database;
    return await db.insert('users', user);
  }

  Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );
    if (maps.isNotEmpty) {
      return maps.first;
    }
    return null;
  }

  // Address operations
  Future<int> insertAddress(Map<String, dynamic> address) async {
    final db = await database;
    return await db.insert('addresses', address);
  }

  Future<List<Map<String, dynamic>>> getAllAddresses() async {
    final db = await database;
    return await db.query('addresses', orderBy: 'createdAt DESC');
  }

  Future<int> updateAddress(int id, Map<String, dynamic> address) async {
    final db = await database;
    return await db.update(
      'addresses',
      address,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteAddress(int id) async {
    final db = await database;
    return await db.delete('addresses', where: 'id = ?', whereArgs: [id]);
  }

  // Product operations
  Future<int> insertProduct(Map<String, dynamic> product) async {
    final db = await database;
    return await db.insert('products', product);
  }

  Future<List<Map<String, dynamic>>> getAllProducts() async {
    final db = await database;
    return await db.query('products', orderBy: 'createdAt DESC');
  }

  Future<int> updateProduct(int id, Map<String, dynamic> product) async {
    final db = await database;
    return await db.update(
      'products',
      product,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteProduct(int id) async {
    final db = await database;
    // Delete associated images first
    await db.delete('product_images', where: 'productId = ?', whereArgs: [id]);
    // Delete product
    return await db.delete('products', where: 'id = ?', whereArgs: [id]);
  }

  // Product image operations
  Future<int> insertProductImage(int productId, String imagePath) async {
    final db = await database;
    return await db.insert('product_images', {
      'productId': productId,
      'imagePath': imagePath,
    });
  }

  Future<List<Map<String, dynamic>>> getProductImages(int productId) async {
    final db = await database;
    return await db.query(
      'product_images',
      where: 'productId = ?',
      whereArgs: [productId],
    );
  }

  // Order operations
  Future<int> insertOrder(Map<String, dynamic> order) async {
    final db = await database;
    return await db.insert('orders', order);
  }

  Future<List<Map<String, dynamic>>> getAllOrders() async {
    final db = await database;
    return await db.query('orders', orderBy: 'createdAt DESC');
  }

  Future<Map<String, dynamic>?> getOrderById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'orders',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return maps.first;
    }
    return null;
  }

  Future<int> updateOrder(int id, Map<String, dynamic> order) async {
    final db = await database;
    return await db.update('orders', order, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteOrder(int id) async {
    final db = await database;
    return await db.delete('orders', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Map<String, dynamic>>> searchOrdersByCustomer(
    String customerName,
  ) async {
    final db = await database;
    return await db.query(
      'orders',
      where: 'customerName LIKE ?',
      whereArgs: ['%$customerName%'],
      orderBy: 'createdAt DESC',
    );
  }

  Future<List<Map<String, dynamic>>> getOrdersByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    final db = await database;
    return await db.query(
      'orders',
      where: 'deliveryDate BETWEEN ? AND ?',
      whereArgs: [
        startDate.millisecondsSinceEpoch,
        endDate.millisecondsSinceEpoch,
      ],
      orderBy: 'deliveryDate ASC',
    );
  }

  Future<List<Map<String, dynamic>>> getOrdersByPaymentMethod(
    String paymentMethod,
  ) async {
    final db = await database;
    return await db.query(
      'orders',
      where: 'paymentMethod = ?',
      whereArgs: [paymentMethod],
      orderBy: 'createdAt DESC',
    );
  }

  Future<void> close() async {
    final db = await database;
    db.close();
  }
}
