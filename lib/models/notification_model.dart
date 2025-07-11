enum NotificationType {
  purchaseConfirmed,
  orderShipped,
  orderDelivered,
  orderCancelled,
  paymentReceived,
  newOrder,
  productListed,
  productViewed,
  lowInventory,
  priceAlert,
  system,
}

enum NotificationCategory { all, purchase, seller }

class AppNotification {
  final String id;
  final NotificationType type;
  final NotificationCategory category;
  final String title;
  final String message;
  final DateTime timestamp;
  final bool isRead;
  final String? orderId;
  final String? sellerId;
  final String? productId;
  final String? imageUrl;
  final String? actionRoute;
  final Map<String, dynamic>? actionData;

  AppNotification({
    required this.id,
    required this.type,
    required this.category,
    required this.title,
    required this.message,
    required this.timestamp,
    this.isRead = false,
    this.orderId,
    this.sellerId,
    this.productId,
    this.imageUrl,
    this.actionRoute,
    this.actionData,
  });

  // Get icon for notification type
  String get iconPath {
    switch (type) {
      case NotificationType.purchaseConfirmed:
        return 'assets/icons/cart_check.png';
      case NotificationType.orderShipped:
        return 'assets/icons/shipping.png';
      case NotificationType.orderDelivered:
        return 'assets/icons/delivered.png';
      case NotificationType.orderCancelled:
        return 'assets/icons/cancelled.png';
      case NotificationType.paymentReceived:
        return 'assets/icons/payment.png';
      case NotificationType.newOrder:
        return 'assets/icons/new_order.png';
      case NotificationType.productListed:
        return 'assets/icons/product_listed.png';
      case NotificationType.productViewed:
        return 'assets/icons/eye.png';
      case NotificationType.lowInventory:
        return 'assets/icons/warning.png';
      case NotificationType.priceAlert:
        return 'assets/icons/price_tag.png';
      case NotificationType.system:
        return 'assets/icons/system.png';
    }
  }

  // Get time ago string
  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minutes ago';
    } else {
      return 'Just now';
    }
  }

  // Create copy with updated fields
  AppNotification copyWith({
    String? id,
    NotificationType? type,
    NotificationCategory? category,
    String? title,
    String? message,
    DateTime? timestamp,
    bool? isRead,
    String? orderId,
    String? sellerId,
    String? productId,
    String? imageUrl,
    String? actionRoute,
    Map<String, dynamic>? actionData,
  }) {
    return AppNotification(
      id: id ?? this.id,
      type: type ?? this.type,
      category: category ?? this.category,
      title: title ?? this.title,
      message: message ?? this.message,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
      orderId: orderId ?? this.orderId,
      sellerId: sellerId ?? this.sellerId,
      productId: productId ?? this.productId,
      imageUrl: imageUrl ?? this.imageUrl,
      actionRoute: actionRoute ?? this.actionRoute,
      actionData: actionData ?? this.actionData,
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.index,
      'category': category.index,
      'title': title,
      'message': message,
      'timestamp': timestamp.toIso8601String(),
      'isRead': isRead,
      'orderId': orderId,
      'sellerId': sellerId,
      'productId': productId,
      'imageUrl': imageUrl,
      'actionRoute': actionRoute,
      'actionData': actionData,
    };
  }

  // Create from JSON
  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      id: json['id'],
      type: NotificationType.values[json['type']],
      category: NotificationCategory.values[json['category']],
      title: json['title'],
      message: json['message'],
      timestamp: DateTime.parse(json['timestamp']),
      isRead: json['isRead'] ?? false,
      orderId: json['orderId'],
      sellerId: json['sellerId'],
      productId: json['productId'],
      imageUrl: json['imageUrl'],
      actionRoute: json['actionRoute'],
      actionData:
          json['actionData'] != null
              ? Map<String, dynamic>.from(json['actionData'])
              : null,
    );
  }
}
