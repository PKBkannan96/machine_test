class ProductListResponse {
  final List<Product> products;

  ProductListResponse({
    required this.products,
  });

  factory ProductListResponse.fromJson(Map<String, dynamic> json) {
    if (json['products'] is List) {
      final List<dynamic> productsList = json['products'];
      final products = productsList.map((e) => Product.fromJson(e as Map<String, dynamic>)).toList();
      return ProductListResponse(
        products: products,
      );
    } else {
      throw FormatException('Invalid response format: data is not a List');
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'products': products.map((product) => product.toJson()).toList(),
    };
  }
}
class Product {
  final int productId;
  final String productName;
  final String category;

  final String image;
  final List<Variant> variants; // Add this line to hold variants

  Product({
    required this.productId,
    required this.productName,
    required this.category,
    required this.image,
    required this.variants, // Add this parameter
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    final variantsList = (json['variants'] as List<dynamic>?)
        ?.map((variant) => Variant.fromJson(variant as Map<String, dynamic>))
        .toList() ?? [];

    return Product(
      productId: json['id'] ?? 0,
      productName: json['product_name'] ?? '',
      category: json['category_name'] ?? '',
      image: json['image'] ?? '',
      variants: variantsList, // Initialize variants
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': productId,
      'product_name': productName,
      'category': category,
      'image': image,
      'variants': variants.map((variant) => variant.toJson()).toList(), // Add variants to JSON
    };
  }
}
class Variant {
  final String image_url;
  final String price;

  Variant({
    required this.image_url, required this.price
  });

  factory Variant.fromJson(Map<String, dynamic> json) {
    return Variant(
      image_url: json['image_url'] ?? '',
      price: json['price'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'image_url': image_url,
      'price': price,
    };
  }
}