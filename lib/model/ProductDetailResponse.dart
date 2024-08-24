import 'dart:convert';

// Main response class
class ProductDetailResponse {
  final ProductDetail products;

  ProductDetailResponse({
    required this.products,
  });

  factory ProductDetailResponse.fromJson(Map<String, dynamic> json) {
    return ProductDetailResponse(
      products: ProductDetail.fromJson(json['products'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'products': products.toJson(),
    };
  }
}

// Product detail class
class ProductDetail {
  final int id;
  final String productName;
  final String supplierName;
  final int categoryId;
  final String categoryName;
  final String brandName;
  final String productShortDescription;
  final String tax;
  final String productLongDescription;
  final int parentCategoryId;
  final String cbdType;
  final String thcType;
  final int pendingQuantity;
  final int availableQuantity;
  final String plantType;
  final String craft;
  final int newInventory;
  final List<Variant> variants;
  final String image;
  final String parentCategoryName;
  final int favoriteStatus;

  ProductDetail({
    required this.id,
    required this.productName,
    required this.supplierName,
    required this.categoryId,
    required this.categoryName,
    required this.brandName,
    required this.productShortDescription,
    required this.tax,
    required this.productLongDescription,
    required this.parentCategoryId,
    required this.cbdType,
    required this.thcType,
    required this.pendingQuantity,
    required this.availableQuantity,
    required this.plantType,
    required this.craft,
    required this.newInventory,
    required this.variants,
    required this.image,
    required this.parentCategoryName,
    required this.favoriteStatus,
  });

  factory ProductDetail.fromJson(Map<String, dynamic> json) {
    final variantsList = json['variants'] as List<dynamic>? ?? [];
    final variants = variantsList.map((v) => Variant.fromJson(v as Map<String, dynamic>)).toList();

    return ProductDetail(
      id: json['id'] ?? 0,
      productName: json['product_name'] ?? '',
      supplierName: json['supplier_name'] ?? '',
      categoryId: json['category_id'] ?? 0,
      categoryName: json['category_name'] ?? '',
      brandName: json['brand_name'] ?? '',
      productShortDescription: json['product_short_description'] ?? '',
      tax: json['tax'] ?? '',
      productLongDescription: json['product_long_description'] ?? '',
      parentCategoryId: json['parent_category_id'] ?? 0,
      cbdType: json['cbd_type'] ?? '',
      thcType: json['thc_type'] ?? '',
      pendingQuantity: json['pending_quantity'] ?? 0,
      availableQuantity: json['available_quantity'] ?? 0,
      plantType: json['plant_type'] ?? '',
      craft: json['craft'] ?? '',
      newInventory: json['new_inventory'] ?? 0,
      variants: variants,
      image: json['image'] ?? '',
      parentCategoryName: json['parent_category_name'] ?? '',
      favoriteStatus: json['favorite_status'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_name': productName,
      'supplier_name': supplierName,
      'category_id': categoryId,
      'category_name': categoryName,
      'brand_name': brandName,
      'product_short_description': productShortDescription,
      'tax': tax,
      'product_long_description': productLongDescription,
      'parent_category_id': parentCategoryId,
      'cbd_type': cbdType,
      'thc_type': thcType,
      'pending_quantity': pendingQuantity,
      'available_quantity': availableQuantity,
      'plant_type': plantType,
      'craft': craft,
      'new_inventory': newInventory,
      'variants': variants.map((v) => v.toJson()).toList(),
      'image': image,
      'parent_category_name': parentCategoryName,
      'favorite_status': favoriteStatus,
    };
  }
}

// Variant class
class Variant {
  final int id;
  final String size;
  final String price;
  final int pendingQuantity;
  final int availableQuantity;
  final String minimumThcContent;
  final String maximumThcContent;
  final String thcContentPerCapsule;
  final String thcContentPerVolume;
  final String maximumCbdContent;
  final String cbdContentPerCapsule;
  final String cbdContentPerVolume;
  final String minimumCbdContent;
  final String brand;
  final String growMethod;
  final String growMedium;
  final String dryingMethod;
  final String growRegion;
  final String terpenes;
  final String plantType;
  final String image;
  final String? growerSays;
  final String gtin;
  final String? emjaySays;
  final String colour;
  final String tax;
  final String thcMin;
  final String thcMax;
  final String cbdMin;
  final String cbdMax;
  final String cbdType;
  final String thcType;
  final String emjMinThc;
  final String emjMaxThc;
  final String emjMinCbd;
  final String emjMaxCbd;
  final String thc;
  final String cbd;
  final String? deal;

  Variant({
    required this.id,
    required this.size,
    required this.price,
    required this.pendingQuantity,
    required this.availableQuantity,
    required this.minimumThcContent,
    required this.maximumThcContent,
    required this.thcContentPerCapsule,
    required this.thcContentPerVolume,
    required this.maximumCbdContent,
    required this.cbdContentPerCapsule,
    required this.cbdContentPerVolume,
    required this.minimumCbdContent,
    required this.brand,
    required this.growMethod,
    required this.growMedium,
    required this.dryingMethod,
    required this.growRegion,
    required this.terpenes,
    required this.plantType,
    required this.image,
    this.growerSays,
    required this.gtin,
    this.emjaySays,
    required this.colour,
    required this.tax,
    required this.thcMin,
    required this.thcMax,
    required this.cbdMin,
    required this.cbdMax,
    required this.cbdType,
    required this.thcType,
    required this.emjMinThc,
    required this.emjMaxThc,
    required this.emjMinCbd,
    required this.emjMaxCbd,
    required this.thc,
    required this.cbd,
    this.deal,
  });

  factory Variant.fromJson(Map<String, dynamic> json) {
    return Variant(
      id: json['id'] ?? 0,
      size: json['size'] ?? '',
      price: json['price'] ?? '',
      pendingQuantity: json['pending_quantity'] ?? 0,
      availableQuantity: json['available_quantity'] ?? 0,
      minimumThcContent: json['minimum_thc_content'] ?? '',
      maximumThcContent: json['maximum_thc_content'] ?? '',
      thcContentPerCapsule: json['thc_content_per_capsule'] ?? '',
      thcContentPerVolume: json['thc_content_per_volume'] ?? '',
      maximumCbdContent: json['maximum_cbd_content'] ?? '',
      cbdContentPerCapsule: json['cbd_content_per_capsule'] ?? '',
      cbdContentPerVolume: json['cbd_content_per_volume'] ?? '',
      minimumCbdContent: json['minimum_cbd_content'] ?? '',
      brand: json['brand'] ?? '',
      growMethod: json['grow_method'] ?? '',
      growMedium: json['grow_medium'] ?? '',
      dryingMethod: json['drying_method'] ?? '',
      growRegion: json['grow_region'] ?? '',
      terpenes: json['terpenes'] ?? '',
      plantType: json['plant_type'] ?? '',
      image: json['image'] ?? '',
      growerSays: json['grower_says'],
      gtin: json['gtin'] ?? '',
      emjaySays: json['emjay_says'],
      colour: json['colour'] ?? '',
      tax: json['tax'] ?? '',
      thcMin: json['thc_min'] ?? '',
      thcMax: json['thc_max'] ?? '',
      cbdMin: json['cbd_min'] ?? '',
      cbdMax: json['cbd_max'] ?? '',
      cbdType: json['cbd_type'] ?? '',
      thcType: json['thc_type'] ?? '',
      emjMinThc: json['emj_min_thc'] ?? '',
      emjMaxThc: json['emj_max_thc'] ?? '',
      emjMinCbd: json['emj_min_cbd'] ?? '',
      emjMaxCbd: json['emj_max_cbd'] ?? '',
      thc: json['thc'] ?? '',
      cbd: json['cbd'] ?? '',
      deal: json['deal'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'size': size,
      'price': price,
      'pending_quantity': pendingQuantity,
      'available_quantity': availableQuantity,
      'minimum_thc_content': minimumThcContent,
      'maximum_thc_content': maximumThcContent,
      'thc_content_per_capsule': thcContentPerCapsule,
      'thc_content_per_volume': thcContentPerVolume,
      'maximum_cbd_content': maximumCbdContent,
      'cbd_content_per_capsule': cbdContentPerCapsule,
      'cbd_content_per_volume': cbdContentPerVolume,
      'minimum_cbd_content': minimumCbdContent,
      'brand': brand,
      'grow_method': growMethod,
      'grow_medium': growMedium,
      'drying_method': dryingMethod,
      'grow_region': growRegion,
      'terpenes': terpenes,
      'plant_type': plantType,
      'image': image,
      'grower_says': growerSays,
      'gtin': gtin,
      'emjay_says': emjaySays,
      'colour': colour,
      'tax': tax,
      'thc_min': thcMin,
      'thc_max': thcMax,
      'cbd_min': cbdMin,
      'cbd_max': cbdMax,
      'cbd_type': cbdType,
      'thc_type': thcType,
      'emj_min_thc': emjMinThc,
      'emj_max_thc': emjMaxThc,
      'emj_min_cbd': emjMinCbd,
      'emj_max_cbd': emjMaxCbd,
      'thc': thc,
      'cbd': cbd,
      'deal': deal,
    };
  }
}