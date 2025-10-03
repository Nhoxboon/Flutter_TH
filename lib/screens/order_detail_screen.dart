import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/order.dart';
import '../database/database_helper.dart';
import 'create_order_screen.dart';

class OrderDetailScreen extends StatefulWidget {
  final Order order;

  const OrderDetailScreen({super.key, required this.order});

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  late Order _currentOrder;

  @override
  void initState() {
    super.initState();
    _currentOrder = widget.order;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Chi tiết đơn hàng',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue.shade700,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onSelected: (String value) {
              switch (value) {
                case 'edit':
                  _navigateToEditOrder();
                  break;
                case 'delete':
                  _confirmDeleteOrder();
                  break;
              }
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem<String>(
                value: 'edit',
                child: Row(
                  children: [
                    Icon(Icons.edit, color: Colors.blue),
                    SizedBox(width: 8),
                    Text('Chỉnh sửa'),
                  ],
                ),
              ),
              const PopupMenuItem<String>(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Xóa đơn hàng'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildOrderIdCard(),
            const SizedBox(height: 16),
            _buildCustomerInfoCard(),
            const SizedBox(height: 16),
            _buildDeliveryInfoCard(),
            const SizedBox(height: 16),
            _buildPaymentInfoCard(),
            const SizedBox(height: 16),
            _buildProductsCard(),
            const SizedBox(height: 16),
            _buildNotesCard(),
            const SizedBox(height: 24),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderIdCard() {
    return Card(
      elevation: 4,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          gradient: LinearGradient(
            colors: [Colors.blue.shade600, Colors.blue.shade800],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'MÃ ĐỚN HÀNG',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 12,
                fontWeight: FontWeight.w500,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _currentOrder.orderId,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontFamily: 'monospace',
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.access_time, color: Colors.white70, size: 16),
                const SizedBox(width: 6),
                Text(
                  'Tạo lúc: ${DateFormat('HH:mm dd/MM/yyyy').format(_currentOrder.createdAt)}',
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomerInfoCard() {
    return _buildInfoCard(
      title: 'Thông tin khách hàng',
      icon: Icons.person,
      color: Colors.green,
      children: [
        _buildInfoRow('Tên khách hàng', _currentOrder.customerName),
        _buildInfoRow('Số điện thoại', _currentOrder.phoneNumber),
      ],
    );
  }

  Widget _buildDeliveryInfoCard() {
    return _buildInfoCard(
      title: 'Thông tin giao hàng',
      icon: Icons.local_shipping,
      color: Colors.orange,
      children: [
        _buildInfoRow('Địa chỉ giao hàng', _currentOrder.deliveryAddress),
        _buildInfoRow(
          'Ngày giao dự kiến',
          DateFormat(
            'EEEE, dd/MM/yyyy',
            'vi_VN',
          ).format(_currentOrder.deliveryDate),
        ),
      ],
    );
  }

  Widget _buildPaymentInfoCard() {
    return _buildInfoCard(
      title: 'Thông tin thanh toán',
      icon: Icons.payment,
      color: _currentOrder.paymentMethod == 'Tiền mặt'
          ? Colors.green
          : Colors.blue,
      children: [
        Row(
          children: [
            Expanded(child: _buildInfoRow('Phương thức', '')),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: _currentOrder.paymentMethod == 'Tiền mặt'
                    ? Colors.green.shade50
                    : Colors.blue.shade50,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: _currentOrder.paymentMethod == 'Tiền mặt'
                      ? Colors.green.shade300
                      : Colors.blue.shade300,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _currentOrder.paymentMethod == 'Tiền mặt'
                        ? Icons.money
                        : Icons.credit_card,
                    size: 16,
                    color: _currentOrder.paymentMethod == 'Tiền mặt'
                        ? Colors.green.shade700
                        : Colors.blue.shade700,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    _currentOrder.paymentMethod,
                    style: TextStyle(
                      color: _currentOrder.paymentMethod == 'Tiền mặt'
                          ? Colors.green.shade700
                          : Colors.blue.shade700,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProductsCard() {
    return _buildInfoCard(
      title: 'Danh sách sản phẩm',
      icon: Icons.shopping_basket,
      color: Colors.purple,
      children: [
        ...(_currentOrder.products.asMap().entries.map((entry) {
          int index = entry.key;
          String product = entry.value;
          return Padding(
            padding: EdgeInsets.only(
              bottom: index < _currentOrder.products.length - 1 ? 12 : 0,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: Colors.purple.shade100,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.purple.shade300),
                  ),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.purple.shade700,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    product,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList()),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.purple.shade50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.purple.shade200),
          ),
          child: Row(
            children: [
              Icon(Icons.inventory, size: 16, color: Colors.purple.shade600),
              const SizedBox(width: 8),
              Text(
                'Tổng cộng: ${_currentOrder.products.length} sản phẩm',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.purple.shade700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNotesCard() {
    return _buildInfoCard(
      title: 'Ghi chú',
      icon: Icons.note,
      color: Colors.teal,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Text(
            _currentOrder.notes.isEmpty
                ? 'Không có ghi chú'
                : _currentOrder.notes,
            style: TextStyle(
              fontSize: 16,
              color: _currentOrder.notes.isEmpty
                  ? Colors.grey.shade500
                  : Colors.black87,
              fontStyle: _currentOrder.notes.isEmpty
                  ? FontStyle.italic
                  : FontStyle.normal,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard({
    required String title,
    required IconData icon,
    required Color color,
    required List<Widget> children,
  }) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: color, size: 20),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade600,
              ),
            ),
          ),
          const Text(': '),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: _navigateToEditOrder,
            icon: const Icon(Icons.edit),
            label: const Text('Chỉnh sửa'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade600,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: _confirmDeleteOrder,
            icon: const Icon(Icons.delete),
            label: const Text('Xóa đơn hàng'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade600,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _navigateToEditOrder() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateOrderScreen(existingOrder: _currentOrder),
      ),
    );
    if (result == true && mounted) {
      // Reload order data
      try {
        final updatedOrderMap = await _dbHelper.getOrderById(_currentOrder.id!);
        if (updatedOrderMap != null) {
          setState(() {
            _currentOrder = Order.fromMap(updatedOrderMap);
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Đơn hàng đã được cập nhật'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Lỗi khi tải lại dữ liệu: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  Future<void> _confirmDeleteOrder() async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Xác nhận xóa'),
          content: Text(
            'Bạn có chắc chắn muốn xóa đơn hàng "${_currentOrder.orderId}"?\n\n'
            'Khách hàng: ${_currentOrder.customerName}\n'
            'Thao tác này không thể hoàn tác.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Hủy'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Xóa'),
            ),
          ],
        );
      },
    );

    if (confirmed == true && mounted) {
      await _deleteOrder();
    }
  }

  Future<void> _deleteOrder() async {
    try {
      await _dbHelper.deleteOrder(_currentOrder.id!);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Đơn hàng đã được xóa thành công'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(
          context,
          true,
        ); // Return to previous screen with success flag
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi khi xóa đơn hàng: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
