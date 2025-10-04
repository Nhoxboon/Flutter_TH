import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/order.dart';

class SharedPreferencesHelper {
  static const String _ordersKey = 'orders_list';
  static const String _orderCounterKey = 'order_counter';

  static SharedPreferencesHelper? _instance;
  static SharedPreferences? _prefs;

  SharedPreferencesHelper._internal();

  static Future<SharedPreferencesHelper> getInstance() async {
    if (_instance == null) {
      _instance = SharedPreferencesHelper._internal();
      _prefs = await SharedPreferences.getInstance();
    }
    return _instance!;
  }

  // Generate unique ID for orders
  Future<int> _getNextOrderId() async {
    int currentCounter = _prefs?.getInt(_orderCounterKey) ?? 0;
    currentCounter++;
    await _prefs?.setInt(_orderCounterKey, currentCounter);
    return currentCounter;
  }

  // Save order
  Future<bool> insertOrder(Order order) async {
    try {
      List<Order> orders = await getAllOrders();

      // Generate new ID if it doesn't exist
      Order newOrder = order;
      if (order.id == null) {
        int newId = await _getNextOrderId();
        newOrder = order.copyWith(id: newId);
      }

      orders.add(newOrder);
      return await _saveOrdersList(orders);
    } catch (e) {
      print('Error inserting order: $e');
      return false;
    }
  }

  // Get all orders
  Future<List<Order>> getAllOrders() async {
    try {
      String? ordersJson = _prefs?.getString(_ordersKey);
      if (ordersJson == null || ordersJson.isEmpty) {
        return [];
      }

      List<dynamic> ordersList = json.decode(ordersJson);
      return ordersList.map((orderMap) => Order.fromMap(orderMap)).toList();
    } catch (e) {
      print('Error getting orders: $e');
      return [];
    }
  }

  // Get order by ID
  Future<Order?> getOrderById(int id) async {
    try {
      List<Order> orders = await getAllOrders();
      for (Order order in orders) {
        if (order.id == id) {
          return order;
        }
      }
      return null;
    } catch (e) {
      print('Error getting order by ID: $e');
      return null;
    }
  }

  // Update order
  Future<bool> updateOrder(int id, Order updatedOrder) async {
    try {
      List<Order> orders = await getAllOrders();
      for (int i = 0; i < orders.length; i++) {
        if (orders[i].id == id) {
          orders[i] = updatedOrder.copyWith(id: id);
          return await _saveOrdersList(orders);
        }
      }
      return false; // Order not found
    } catch (e) {
      print('Error updating order: $e');
      return false;
    }
  }

  // Delete order
  Future<bool> deleteOrder(int id) async {
    try {
      List<Order> orders = await getAllOrders();
      orders.removeWhere((order) => order.id == id);
      return await _saveOrdersList(orders);
    } catch (e) {
      print('Error deleting order: $e');
      return false;
    }
  }

  // Search orders by customer name
  Future<List<Order>> searchOrdersByCustomer(String customerName) async {
    try {
      List<Order> allOrders = await getAllOrders();
      return allOrders
          .where(
            (order) => order.customerName.toLowerCase().contains(
              customerName.toLowerCase(),
            ),
          )
          .toList();
    } catch (e) {
      print('Error searching orders: $e');
      return [];
    }
  }

  // Get orders by date range
  Future<List<Order>> getOrdersByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      List<Order> allOrders = await getAllOrders();
      return allOrders.where((order) {
        return order.deliveryDate.isAfter(
              startDate.subtract(const Duration(days: 1)),
            ) &&
            order.deliveryDate.isBefore(endDate.add(const Duration(days: 1)));
      }).toList();
    } catch (e) {
      print('Error getting orders by date range: $e');
      return [];
    }
  }

  // Get orders by payment method
  Future<List<Order>> getOrdersByPaymentMethod(String paymentMethod) async {
    try {
      List<Order> allOrders = await getAllOrders();
      return allOrders
          .where((order) => order.paymentMethod == paymentMethod)
          .toList();
    } catch (e) {
      print('Error getting orders by payment method: $e');
      return [];
    }
  }

  // Helper method to save orders list to SharedPreferences
  Future<bool> _saveOrdersList(List<Order> orders) async {
    try {
      List<Map<String, dynamic>> ordersMapList = orders
          .map((order) => order.toMap())
          .toList();
      String ordersJson = json.encode(ordersMapList);
      return await _prefs?.setString(_ordersKey, ordersJson) ?? false;
    } catch (e) {
      print('Error saving orders list: $e');
      return false;
    }
  }

  // Clear all orders (for testing or reset)
  Future<bool> clearAllOrders() async {
    try {
      await _prefs?.remove(_ordersKey);
      await _prefs?.remove(_orderCounterKey);
      return true;
    } catch (e) {
      print('Error clearing orders: $e');
      return false;
    }
  }

  // Get orders count
  Future<int> getOrdersCount() async {
    try {
      List<Order> orders = await getAllOrders();
      return orders.length;
    } catch (e) {
      print('Error getting orders count: $e');
      return 0;
    }
  }

  // Export orders to JSON string (for backup)
  Future<String?> exportOrdersToJson() async {
    try {
      String? ordersJson = _prefs?.getString(_ordersKey);
      return ordersJson;
    } catch (e) {
      print('Error exporting orders: $e');
      return null;
    }
  }

  // Import orders from JSON string (for restore)
  Future<bool> importOrdersFromJson(String jsonString) async {
    try {
      // Validate JSON first
      List<dynamic> ordersList = json.decode(jsonString);
      List<Order> orders = ordersList
          .map((orderMap) => Order.fromMap(orderMap))
          .toList();

      // Save to SharedPreferences
      return await _saveOrdersList(orders);
    } catch (e) {
      print('Error importing orders: $e');
      return false;
    }
  }
}
