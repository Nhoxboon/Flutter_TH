import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/order.dart';
import '../utils/shared_preferences_helper.dart';

class CreateOrderScreen extends StatefulWidget {
  final Order? existingOrder; // For editing existing orders

  const CreateOrderScreen({super.key, this.existingOrder});

  @override
  State<CreateOrderScreen> createState() => _CreateOrderScreenState();
}

class _CreateOrderScreenState extends State<CreateOrderScreen> {
  final _formKey = GlobalKey<FormState>();
  SharedPreferencesHelper? _prefsHelper;

  // Controllers
  final _customerNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _notesController = TextEditingController();

  // Form data
  DateTime _selectedDate = DateTime.now();
  String _paymentMethod = 'Tiền mặt';
  List<String> _selectedProducts = [];

  // Product options
  final List<String> _productOptions = [
    'Laptop Dell XPS 13',
    'iPhone 15 Pro Max',
    'Samsung Galaxy S24',
    'iPad Air M2',
    'MacBook Pro M3',
    'AirPods Pro 2',
    'Apple Watch Series 9',
    'Monitor Dell 27 inch',
  ];

  @override
  void initState() {
    super.initState();
    _initializeHelper();
    if (widget.existingOrder != null) {
      _populateExistingData();
    }
  }

  Future<void> _initializeHelper() async {
    _prefsHelper = await SharedPreferencesHelper.getInstance();
  }

  void _populateExistingData() {
    final order = widget.existingOrder!;
    _customerNameController.text = order.customerName;
    _phoneController.text = order.phoneNumber;
    _addressController.text = order.deliveryAddress;
    _notesController.text = order.notes;
    _selectedDate = order.deliveryDate;
    _paymentMethod = order.paymentMethod;
    _selectedProducts = List.from(order.products);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.existingOrder == null ? 'Tạo đơn hàng' : 'Chỉnh sửa đơn hàng',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue.shade700,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('Thông tin khách hàng'),
              _buildCustomerNameField(),
              const SizedBox(height: 16),
              _buildPhoneNumberField(),
              const SizedBox(height: 20),

              _buildSectionTitle('Thông tin giao hàng'),
              _buildAddressField(),
              const SizedBox(height: 16),
              _buildDeliveryDateField(),
              const SizedBox(height: 20),

              _buildSectionTitle('Thông tin thanh toán'),
              _buildPaymentMethodField(),
              const SizedBox(height: 20),

              _buildSectionTitle('Danh sách sản phẩm'),
              _buildProductsField(),
              const SizedBox(height: 20),

              _buildSectionTitle('Ghi chú'),
              _buildNotesField(),
              const SizedBox(height: 30),

              _buildSaveButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.blue.shade700,
        ),
      ),
    );
  }

  Widget _buildCustomerNameField() {
    return TextFormField(
      controller: _customerNameController,
      decoration: const InputDecoration(
        labelText: 'Tên khách hàng',
        hintText: 'Nhập tên khách hàng',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.person),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Vui lòng nhập tên khách hàng';
        }
        return null;
      },
    );
  }

  Widget _buildPhoneNumberField() {
    return TextFormField(
      controller: _phoneController,
      decoration: const InputDecoration(
        labelText: 'Số điện thoại',
        hintText: 'Nhập số điện thoại (10 chữ số)',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.phone),
      ),
      keyboardType: TextInputType.phone,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Vui lòng nhập số điện thoại';
        }
        if (value.length != 10 || !RegExp(r'^[0-9]+$').hasMatch(value)) {
          return 'Số điện thoại phải có đúng 10 chữ số';
        }
        return null;
      },
    );
  }

  Widget _buildAddressField() {
    return TextFormField(
      controller: _addressController,
      decoration: const InputDecoration(
        labelText: 'Địa chỉ giao hàng',
        hintText: 'Nhập địa chỉ giao hàng đầy đủ',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.location_on),
      ),
      maxLines: 3,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Vui lòng nhập địa chỉ giao hàng';
        }
        return null;
      },
    );
  }

  Widget _buildDeliveryDateField() {
    return InkWell(
      onTap: _selectDate,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_today, color: Colors.grey),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Ngày giao dự kiến',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  Text(
                    DateFormat('dd/MM/yyyy').format(_selectedDate),
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethodField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Phương thức thanh toán',
          style: TextStyle(fontSize: 14, color: Colors.grey),
        ),
        const SizedBox(height: 8),
        RadioListTile<String>(
          title: const Text('Tiền mặt'),
          value: 'Tiền mặt',
          groupValue: _paymentMethod,
          onChanged: (value) {
            setState(() {
              _paymentMethod = value!;
            });
          },
        ),
        RadioListTile<String>(
          title: const Text('Chuyển khoản'),
          value: 'Chuyển khoản',
          groupValue: _paymentMethod,
          onChanged: (value) {
            setState(() {
              _paymentMethod = value!;
            });
          },
        ),
      ],
    );
  }

  Widget _buildProductsField() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
            child: const Text(
              'Chọn sản phẩm (bắt buộc chọn ít nhất 1)',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ),
          const Divider(height: 1, thickness: 1),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _productOptions.length,
            itemBuilder: (context, index) {
              final product = _productOptions[index];
              return CheckboxListTile(
                title: Text(product),
                value: _selectedProducts.contains(product),
                onChanged: (bool? value) {
                  setState(() {
                    if (value == true) {
                      _selectedProducts.add(product);
                    } else {
                      _selectedProducts.remove(product);
                    }
                  });
                },
              );
            },
          ),
          if (_selectedProducts.isEmpty)
            Container(
              padding: const EdgeInsets.all(12),
              child: const Text(
                'Vui lòng chọn ít nhất một sản phẩm',
                style: TextStyle(color: Colors.red, fontSize: 12),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildNotesField() {
    return TextFormField(
      controller: _notesController,
      decoration: const InputDecoration(
        labelText: 'Ghi chú',
        hintText: 'Nhập ghi chú cho đơn hàng (tùy chọn)',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.note),
      ),
      maxLines: 3,
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: _saveOrder,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green.shade600,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Text(
          widget.existingOrder == null ? 'Lưu đơn hàng' : 'Cập nhật đơn hàng',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _saveOrder() async {
    if (!_formKey.currentState!.validate() || _selectedProducts.isEmpty) {
      if (_selectedProducts.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Vui lòng chọn ít nhất một sản phẩm'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    try {
      final Order order;
      if (widget.existingOrder == null) {
        // Create new order
        order = Order(
          customerName: _customerNameController.text.trim(),
          phoneNumber: _phoneController.text.trim(),
          deliveryAddress: _addressController.text.trim(),
          notes: _notesController.text.trim(),
          deliveryDate: _selectedDate,
          paymentMethod: _paymentMethod,
          products: _selectedProducts,
          orderId: Order.generateOrderId(),
          createdAt: DateTime.now(),
        );
        if (_prefsHelper == null) {
          _prefsHelper = await SharedPreferencesHelper.getInstance();
        }
        await _prefsHelper!.insertOrder(order);
      } else {
        // Update existing order
        order = widget.existingOrder!.copyWith(
          customerName: _customerNameController.text.trim(),
          phoneNumber: _phoneController.text.trim(),
          deliveryAddress: _addressController.text.trim(),
          notes: _notesController.text.trim(),
          deliveryDate: _selectedDate,
          paymentMethod: _paymentMethod,
          products: _selectedProducts,
        );
        if (_prefsHelper == null) {
          _prefsHelper = await SharedPreferencesHelper.getInstance();
        }
        await _prefsHelper!.updateOrder(order.id!, order);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.existingOrder == null
                  ? 'Đơn hàng đã được tạo thành công!'
                  : 'Đơn hàng đã được cập nhật thành công!',
            ),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true); // Return true to indicate success
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  void dispose() {
    _customerNameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _notesController.dispose();
    super.dispose();
  }
}
