class CartResponse {
  final String response;
  final String conditional;
  final List<CartItem> cartItems;
  final String totalAmount;
  final String totalDealAmount;
  final String totalDiscount;
  final String totalAmountBeforePromo;
  final String promoCodeDiscount;
  final String totalTax;
  final int cartItemCount;
  final dynamic tempOrderId;
  final String grandTotal;
  final String message;
  final String usedPurchaseLimit;
  final String availablePurchaseLimit;
  final List<dynamic> appliedPromoCodes;
  final String barcode;
  final String loyalty;
  final String loyaltyDiscount;

  CartResponse({
    required this.response,
    required this.conditional,
    required this.cartItems,
    required this.totalAmount,
    required this.totalDealAmount,
    required this.totalDiscount,
    required this.totalAmountBeforePromo,
    required this.promoCodeDiscount,
    required this.totalTax,
    required this.cartItemCount,
    this.tempOrderId,
    required this.grandTotal,
    required this.message,
    required this.usedPurchaseLimit,
    required this.availablePurchaseLimit,
    required this.appliedPromoCodes,
    required this.barcode,
    required this.loyalty,
    required this.loyaltyDiscount,
  });

  factory CartResponse.fromJson(Map<String, dynamic> json) {
    return CartResponse(
      response: json['response'] ?? '',
      conditional: json['conditional'] ?? '',
      cartItems: (json['cart_items'] as List<dynamic>)
          .map((item) => CartItem.fromJson(item as Map<String, dynamic>))
          .toList(),
      totalAmount: json['total_amount'] ?? '',
      totalDealAmount: json['total_deal_amount'] ?? '',
      totalDiscount: json['total_discount'] ?? '',
      totalAmountBeforePromo: json['total_amount_before_promo'] ?? '',
      promoCodeDiscount: json['promo_code_discount'] ?? '',
      totalTax: json['total_tax'] ?? '',
      cartItemCount: json['cart_item_count'] ?? 0,
      tempOrderId: json['temp_order_id'],
      grandTotal: json['grand_total'] ?? '',
      message: json['message'] ?? '',
      usedPurchaseLimit: json['used_purchase_limit'] ?? '',
      availablePurchaseLimit: json['available_purchase_limit'] ?? '',
      appliedPromoCodes: json['applied_promo_codes'] ?? [],
      barcode: json['barcode'] ?? '',
      loyalty: json['loyalty'] ?? '',
      loyaltyDiscount: json['loyalty_discount'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'response': response,
      'conditional': conditional,
      'cart_items': cartItems.map((item) => item.toJson()).toList(),
      'total_amount': totalAmount,
      'total_deal_amount': totalDealAmount,
      'total_discount': totalDiscount,
      'total_amount_before_promo': totalAmountBeforePromo,
      'promo_code_discount': promoCodeDiscount,
      'total_tax': totalTax,
      'cart_item_count': cartItemCount,
      'temp_order_id': tempOrderId,
      'grand_total': grandTotal,
      'message': message,
      'used_purchase_limit': usedPurchaseLimit,
      'available_purchase_limit': availablePurchaseLimit,
      'applied_promo_codes': appliedPromoCodes,
      'barcode': barcode,
      'loyalty': loyalty,
      'loyalty_discount': loyaltyDiscount,
    };
  }
}
class CartItem {
  final int id;
  final int userId;
  final String uniqueId;
  final String cartGroupId;
  final int kioskId;
  final int locationId;
  final int productId;
  final int productQuantityId;
  final String minimumThcContent;
  final String maximumThcContent;
  final String minimumCbdContent;
  final String maximumCbdContent;
  final int quantity;
  final String amount;
  final String discount;
  final String dealDiscount;
  final String tax;
  final String total;
  final String createdAt;
  final String updatedAt;
  final String name;
  final String gtin;
  final String size;
  final String image;
  final int variantId;
  final int categoryId;
  final String taxRate;
  final String price;
  final String thcType;
  final String cbdType;
  final String slugUrl;
  final List<dynamic> promocode;
  final String emjMinThc;
  final String emjMaxThc;
  final String emjMinCbd;
  final String emjMaxCbd;
  final dynamic deal;
  final int amountAfterDeal;
  final String amountBeforePromo;
  final String amountAfterPromo;
  final String amountPerUnit;
  final String taxPerUnit;
  final String totalPerUnit;
  final String amountAfterDealDiscount;

  CartItem({
    required this.id,
    required this.userId,
    required this.uniqueId,
    required this.cartGroupId,
    required this.kioskId,
    required this.locationId,
    required this.productId,
    required this.productQuantityId,
    required this.minimumThcContent,
    required this.maximumThcContent,
    required this.minimumCbdContent,
    required this.maximumCbdContent,
    required this.quantity,
    required this.amount,
    required this.discount,
    required this.dealDiscount,
    required this.tax,
    required this.total,
    required this.createdAt,
    required this.updatedAt,
    required this.name,
    required this.gtin,
    required this.size,
    required this.image,
    required this.variantId,
    required this.categoryId,
    required this.taxRate,
    required this.price,
    required this.thcType,
    required this.cbdType,
    required this.slugUrl,
    required this.promocode,
    required this.emjMinThc,
    required this.emjMaxThc,
    required this.emjMinCbd,
    required this.emjMaxCbd,
    this.deal,
    required this.amountAfterDeal,
    required this.amountBeforePromo,
    required this.amountAfterPromo,
    required this.amountPerUnit,
    required this.taxPerUnit,
    required this.totalPerUnit,
    required this.amountAfterDealDiscount,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      uniqueId: json['unique_id'] ?? '',
      cartGroupId: json['cart_group_id'] ?? '',
      kioskId: json['kiosk_id'] ?? 0,
      locationId: json['location_id'] ?? 0,
      productId: json['product_id'] ?? 0,
      productQuantityId: json['product_quantity_id'] ?? 0,
      minimumThcContent: json['minimum_thc_content'] ?? '',
      maximumThcContent: json['maximum_thc_content'] ?? '',
      minimumCbdContent: json['minimum_cbd_content'] ?? '',
      maximumCbdContent: json['maximum_cbd_content'] ?? '',
      quantity: json['quantity'] ?? 0,
      amount: json['amount'] ?? '',
      discount: json['discount'] ?? '',
      dealDiscount: json['deal_discount'] ?? '',
      tax: json['tax'] ?? '',
      total: json['total'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      name: json['name'] ?? '',
      gtin: json['gtin'] ?? '',
      size: json['size'] ?? '',
      image: json['image'] ?? '',
      variantId: json['variant_id'] ?? 0,
      categoryId: json['category_id'] ?? 0,
      taxRate: json['tax_rate'] ?? '',
      price: json['price'] ?? '',
      thcType: json['thc_type'] ?? '',
      cbdType: json['cbd_type'] ?? '',
      slugUrl: json['slug_url'] ?? '',
      promocode: json['promocode'] ?? [],
      emjMinThc: json['emj_min_thc'] ?? '',
      emjMaxThc: json['emj_max_thc'] ?? '',
      emjMinCbd: json['emj_min_cbd'] ?? '',
      emjMaxCbd: json['emj_max_cbd'] ?? '',
      deal: json['deal'],
      amountAfterDeal: json['amount_after_deal'] ?? 0,
      amountBeforePromo: json['amount_before_promo'] ?? '',
      amountAfterPromo: json['amount_after_promo'] ?? '',
      amountPerUnit: json['amount_per_unit'] ?? '',
      taxPerUnit: json['tax_per_unit'] ?? '',
      totalPerUnit: json['total_per_unit'] ?? '',
      amountAfterDealDiscount: json['amount_after_deal_discount'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'unique_id': uniqueId,
      'cart_group_id': cartGroupId,
      'kiosk_id': kioskId,
      'location_id': locationId,
      'product_id': productId,
      'product_quantity_id': productQuantityId,
      'minimum_thc_content': minimumThcContent,
      'maximum_thc_content': maximumThcContent,
      'minimum_cbd_content': minimumCbdContent,
      'maximum_cbd_content': maximumCbdContent,
      'quantity': quantity,
      'amount': amount,
      'discount': discount,
      'deal_discount': dealDiscount,
      'tax': tax,
      'total': total,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'name': name,
      'gtin': gtin,
      'size': size,
      'image': image,
      'variant_id': variantId,
      'category_id': categoryId,
      'tax_rate': taxRate,
      'price': price,
      'thc_type': thcType,
      'cbd_type': cbdType,
      'slug_url': slugUrl,
      'promocode': promocode,
      'emj_min_thc': emjMinThc,
      'emj_max_thc': emjMaxThc,
      'emj_min_cbd': emjMinCbd,
      'emj_max_cbd': emjMaxCbd,
      'deal': deal,
      'amount_after_deal': amountAfterDeal,
      'amount_before_promo': amountBeforePromo,
      'amount_after_promo': amountAfterPromo,
      'amount_per_unit': amountPerUnit,
      'tax_per_unit': taxPerUnit,
      'total_per_unit': totalPerUnit,
      'amount_after_deal_discount': amountAfterDealDiscount,
    };
  }
}