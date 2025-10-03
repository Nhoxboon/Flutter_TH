class Product {
  final String name;
  final String description;
  final String price;
  final String views;
  final double rating;
  final String imagePath;
  final bool isHot;
  final bool isNew;

  Product({
    required this.name,
    required this.description,
    required this.price,
    required this.views,
    required this.rating,
    required this.imagePath,
    this.isHot = false,
    this.isNew = false,
  });
}