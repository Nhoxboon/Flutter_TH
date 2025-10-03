class Order {
  final int? id;
  final String customerName;
  final String phoneNumber;
  final String deliveryAddress;
  final String notes;
  final DateTime deliveryDate;
  final String paymentMethod;
  final List<String> products;
  final String orderId;
  final DateTime createdAt;

  Order({
    this.id,
    required this.customerName,
    required this.phoneNumber,
    required this.deliveryAddress,
    required this.notes,
    required this.deliveryDate,
    required this.paymentMethod,
    required this.products,
    required this.orderId,
    required this.createdAt,
  });

  // Convert Order to Map for database storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'customerName': customerName,
      'phoneNumber': phoneNumber,
      'deliveryAddress': deliveryAddress,
      'notes': notes,
      'deliveryDate': deliveryDate.millisecondsSinceEpoch,
      'paymentMethod': paymentMethod,
      'products': products.join(','), // Store as comma-separated string
      'orderId': orderId,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  // Create Order from Map (from database)
  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      id: map['id'],
      customerName: map['customerName'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      deliveryAddress: map['deliveryAddress'] ?? '',
      notes: map['notes'] ?? '',
      deliveryDate: DateTime.fromMillisecondsSinceEpoch(map['deliveryDate']),
      paymentMethod: map['paymentMethod'] ?? '',
      products: (map['products'] as String).split(','),
      orderId: map['orderId'] ?? '',
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
    );
  }

  // Copy with method for updates
  Order copyWith({
    int? id,
    String? customerName,
    String? phoneNumber,
    String? deliveryAddress,
    String? notes,
    DateTime? deliveryDate,
    String? paymentMethod,
    List<String>? products,
    String? orderId,
    DateTime? createdAt,
  }) {
    return Order(
      id: id ?? this.id,
      customerName: customerName ?? this.customerName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      notes: notes ?? this.notes,
      deliveryDate: deliveryDate ?? this.deliveryDate,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      products: products ?? this.products,
      orderId: orderId ?? this.orderId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  // Generate unique order ID
  static String generateOrderId() {
    final now = DateTime.now();
    return 'ORD${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}${now.hour.toString().padLeft(2, '0')}${now.minute.toString().padLeft(2, '0')}${now.second.toString().padLeft(2, '0')}';
  }
}
