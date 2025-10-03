import 'package:flutter/material.dart';
import '../models/product.dart';
import 'my_home_page.dart';

class ProductListScreen extends StatelessWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'DANH SÁCH SẢN PHẨM',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.home, color: Colors.white),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      const MyHomePage(title: 'Hồ sơ giảng viên'),
                ),
              );
            },
          ),
        ],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(8.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.7,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
        ),
        itemCount: _products.length,
        itemBuilder: (context, index) {
          return ProductCard(product: _products[index]);
        },
      ),
    );
  }

  static final List<Product> _products = [
    Product(
      name: 'Ví nam mini dung thẻ VS22',
      description: 'chất da Saffiano bền đẹp chỗ...',
      price: '255.000 VNĐ',
      views: '12 views',
      rating: 4.0,
      imagePath: 'assets/images/wallet.jpg',
      isHot: true,
    ),
    Product(
      name: 'Túi đeo chéo LEACAT polyester',
      description: 'chống thấm nước thời trang c...',
      price: '315.000 VNĐ',
      views: '1.3k views',
      rating: 4.0,
      imagePath: 'assets/images/bag.jpg',
    ),
    Product(
      name: 'Phin cafe Trung Nguyên - Phin',
      description: 'pha cà phê truyền thống',
      price: '28.000 VNĐ',
      views: '12.2k views',
      rating: 4.5,
      imagePath: 'assets/images/coffee_filter.jpg',
      isNew: true,
    ),
    Product(
      name: 'Ví da cầm tay nhóm mại có lót',
      description: 'thiết kế thời trang cho nam',
      price: '610.000 VNĐ',
      views: '56 views',
      rating: 5.0,
      imagePath: 'assets/images/leather_wallet.jpg',
      isNew: true,
    ),
    Product(
      name: 'Giày cao gót nữ',
      description: 'Giày cao gót thời trang',
      price: '350.000 VNĐ',
      views: '89 views',
      rating: 4.2,
      imagePath: 'assets/images/shoes.jpg',
    ),
    Product(
      name: 'Tai nghe bluetooth M10',
      description: 'Tai nghe không dây chất lượng cao',
      price: '450.000 VNĐ',
      views: '234 views',
      rating: 4.8,
      imagePath: 'assets/images/earphones.jpg',
      isHot: true,
    ),
  ];
}

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(4),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(4),
                    ),
                    child: Image.asset(
                      product.imagePath,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[300],
                          child: const Icon(
                            Icons.image,
                            size: 50,
                            color: Colors.grey,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                if (product.isHot)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'HOT',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                if (product.isNew)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'MỚI',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tên sản phẩm - cố định chiều cao cho 2 dòng
                  SizedBox(
                    height: 28, // Đủ cho 2 dòng text với fontSize 12
                    child: Text(
                      product.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        height: 1.2, // Line height để tính toán chính xác
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 2),
                  // Mô tả sản phẩm
                  SizedBox(
                    height: 12, // Chiều cao cố định cho 1 dòng
                    child: Text(
                      product.description,
                      style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Rating
                  SizedBox(
                    height: 16, // Chiều cao cố định cho rating
                    child: Row(
                      children: [
                        Row(
                          children: List.generate(5, (index) {
                            return Icon(
                              index < product.rating.floor()
                                  ? Icons.star
                                  : Icons.star_border,
                              size: 12,
                              color: Colors.orange,
                            );
                          }),
                        ),
                        Text(
                          ' ${product.rating}',
                          style: const TextStyle(fontSize: 10),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Giá và views
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          product.price,
                          style: const TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          product.views,
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
