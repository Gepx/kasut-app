import 'package:flutter/foundation.dart';
import 'dart:math';
import '../models/notification_model.dart';
import '../providers/order_provider.dart';
import '../providers/seller_provider.dart';
import '../features/seller/seller_service.dart';
import '../features/auth/services/auth_service.dart';

class NotificationProvider extends ChangeNotifier {
  final List<AppNotification> _notifications = [];
  final Random _random = Random();
  
  List<AppNotification> get notifications => _notifications;
  
  // Filter notifications by category
  List<AppNotification> get allNotifications => _notifications;
  List<AppNotification> get purchaseNotifications => 
      _notifications.where((n) => n.category == NotificationCategory.purchase).toList();
  List<AppNotification> get sellerNotifications => 
      _notifications.where((n) => n.category == NotificationCategory.seller).toList();
  
  // Get unread count
  int get unreadCount => _notifications.where((n) => !n.isRead).length;
  int get unreadPurchaseCount => purchaseNotifications.where((n) => !n.isRead).length;
  int get unreadSellerCount => sellerNotifications.where((n) => !n.isRead).length;
  
  // Generate notifications from order data
  void generateNotificationsFromOrders(List<Order> orders) {
    _notifications.clear();
    
    for (final order in orders) {
      _generateOrderNotifications(order);
    }
    
    // Add some mock seller notifications if user is a seller
    if (SellerService.currentSeller != null) {
      _generateMockSellerNotifications();
    }
    
    // Sort by timestamp (newest first)
    _notifications.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    notifyListeners();
  }
  
  void _generateOrderNotifications(Order order) {
    // Generate notifications based on order status and timeline
    
    // 1. Purchase confirmation (always exists)
    _addNotification(AppNotification(
      id: 'purchase_${order.id}',
      type: NotificationType.purchaseConfirmed,
      category: NotificationCategory.purchase,
      title: 'Pesanan Dikonfirmasi',
      message: 'Pesanan ${order.shoe.name} berhasil dikonfirmasi',
      timestamp: order.orderDate,
      orderId: order.id,
      imageUrl: order.shoe.firstPict,
      actionRoute: '/buying',
      actionData: {'orderId': order.id},
    ));
    
    // 2. Payment received (shortly after order)
    _addNotification(AppNotification(
      id: 'payment_${order.id}',
      type: NotificationType.paymentReceived,
      category: NotificationCategory.purchase,
      title: 'Pembayaran Diterima',
      message: 'Pembayaran untuk ${order.shoe.name} telah diterima',
      timestamp: order.orderDate.add(Duration(minutes: 5 + _random.nextInt(30))),
      orderId: order.id,
      imageUrl: order.shoe.firstPict,
      actionRoute: '/buying',
      actionData: {'orderId': order.id},
    ));
    
    // 3. Order shipped (for active orders, some time after payment)
    if (order.status == OrderStatus.active) {
      _addNotification(AppNotification(
        id: 'shipped_${order.id}',
        type: NotificationType.orderShipped,
        category: NotificationCategory.purchase,
        title: 'Pesanan Dikirim',
        message: '${order.shoe.name} sedang dalam perjalanan',
        timestamp: order.orderDate.add(Duration(
          hours: 2 + _random.nextInt(24),
          minutes: _random.nextInt(60),
        )),
        orderId: order.id,
        imageUrl: order.shoe.firstPict,
        actionRoute: '/buying',
        actionData: {'orderId': order.id},
      ));
    }
    
    // 4. Order delivered (for completed orders)
    if (order.status == OrderStatus.completed && order.deliveryDate != null) {
      _addNotification(AppNotification(
        id: 'delivered_${order.id}',
        type: NotificationType.orderDelivered,
        category: NotificationCategory.purchase,
        title: 'Pesanan Sampai',
        message: '${order.shoe.name} telah sampai di tujuan',
        timestamp: order.deliveryDate!,
        orderId: order.id,
        imageUrl: order.shoe.firstPict,
        actionRoute: '/buying',
        actionData: {'orderId': order.id},
      ));
    }
    
    // 5. Order cancelled (for cancelled orders)
    if (order.status == OrderStatus.cancelled) {
      _addNotification(AppNotification(
        id: 'cancelled_${order.id}',
        type: NotificationType.orderCancelled,
        category: NotificationCategory.purchase,
        title: 'Pesanan Dibatalkan',
        message: 'Pesanan ${order.shoe.name} telah dibatalkan',
        timestamp: order.orderDate.add(Duration(hours: 1 + _random.nextInt(6))),
        orderId: order.id,
        imageUrl: order.shoe.firstPict,
        actionRoute: '/buying',
        actionData: {'orderId': order.id},
      ));
    }
  }
  
  void _generateMockSellerNotifications() {
    final now = DateTime.now();
    final sellerData = SellerService.currentSeller;
    
    if (sellerData == null) return;
    
    // Mock seller notifications
    final mockSellerNotifications = [
      AppNotification(
        id: 'seller_${_random.nextInt(1000)}',
        type: NotificationType.newOrder,
        category: NotificationCategory.seller,
        title: 'Pesanan Baru!',
        message: 'Anda mendapat pesanan baru untuk Nike Air Max 270',
        timestamp: now.subtract(Duration(hours: 2)),
        sellerId: sellerData['id'] ?? 'seller_1',
        actionRoute: '/seller-dashboard',
      ),
      
      AppNotification(
        id: 'seller_${_random.nextInt(1000)}',
        type: NotificationType.productListed,
        category: NotificationCategory.seller,
        title: 'Produk Terdaftar',
        message: 'Adidas Ultraboost 22 berhasil didaftarkan',
        timestamp: now.subtract(Duration(hours: 5)),
        sellerId: sellerData['id'] ?? 'seller_1',
        actionRoute: '/seller-dashboard',
      ),
      
      AppNotification(
        id: 'seller_${_random.nextInt(1000)}',
        type: NotificationType.productViewed,
        category: NotificationCategory.seller,
        title: 'Produk Dilihat',
        message: '12 orang melihat produk New Balance 574 Anda',
        timestamp: now.subtract(Duration(hours: 8)),
        sellerId: sellerData['id'] ?? 'seller_1',
        actionRoute: '/seller-dashboard',
      ),
      
      AppNotification(
        id: 'seller_${_random.nextInt(1000)}',
        type: NotificationType.paymentReceived,
        category: NotificationCategory.seller,
        title: 'Pembayaran Diterima',
        message: 'Pembayaran untuk Puma RS-X telah diterima',
        timestamp: now.subtract(Duration(days: 1)),
        sellerId: sellerData['id'] ?? 'seller_1',
        actionRoute: '/seller-dashboard',
      ),
      
      AppNotification(
        id: 'seller_${_random.nextInt(1000)}',
        type: NotificationType.lowInventory,
        category: NotificationCategory.seller,
        title: 'Stok Menipis',
        message: 'Stok Converse Chuck Taylor 70s hampir habis',
        timestamp: now.subtract(Duration(days: 2)),
        sellerId: sellerData['id'] ?? 'seller_1',
        actionRoute: '/seller-dashboard',
      ),
    ];
    
    _notifications.addAll(mockSellerNotifications);
  }
  
  void _addNotification(AppNotification notification) {
    _notifications.add(notification);
  }
  
  // Add a new notification manually
  void addNotification(AppNotification notification) {
    _notifications.insert(0, notification);
    notifyListeners();
  }
  
  // Mark notification as read
  void markAsRead(String notificationId) {
    final index = _notifications.indexWhere((n) => n.id == notificationId);
    if (index != -1) {
      _notifications[index] = _notifications[index].copyWith(isRead: true);
      notifyListeners();
    }
  }
  
  // Mark all notifications as read
  void markAllAsRead() {
    for (int i = 0; i < _notifications.length; i++) {
      _notifications[i] = _notifications[i].copyWith(isRead: true);
    }
    notifyListeners();
  }
  
  // Mark all notifications in a category as read
  void markCategoryAsRead(NotificationCategory category) {
    for (int i = 0; i < _notifications.length; i++) {
      if (_notifications[i].category == category) {
        _notifications[i] = _notifications[i].copyWith(isRead: true);
      }
    }
    notifyListeners();
  }
  
  // Remove a notification
  void removeNotification(String notificationId) {
    _notifications.removeWhere((n) => n.id == notificationId);
    notifyListeners();
  }
  
  // Clear all notifications
  void clearAllNotifications() {
    _notifications.clear();
    notifyListeners();
  }
  
  // Generate sample notifications (for testing)
  void generateSampleNotifications() {
    final now = DateTime.now();
    
    final sampleNotifications = [
      AppNotification(
        id: 'sample_1',
        type: NotificationType.purchaseConfirmed,
        category: NotificationCategory.purchase,
        title: 'Pesanan Dikonfirmasi',
        message: 'Pesanan Nike Air Force 1 berhasil dikonfirmasi',
        timestamp: now.subtract(Duration(minutes: 30)),
        imageUrl: 'assets/brand-products/Nike/Nike Air Force 1 Low \'07 Triple White (2021) - 1.png',
      ),
      
      AppNotification(
        id: 'sample_2',
        type: NotificationType.orderShipped,
        category: NotificationCategory.purchase,
        title: 'Pesanan Dikirim',
        message: 'Adidas Ultraboost 22 sedang dalam perjalanan',
        timestamp: now.subtract(Duration(hours: 2)),
        imageUrl: 'assets/brand-products/Adidas/Adidas Ultraboost 22 Cloud White Core Black - 1.png',
      ),
      
      AppNotification(
        id: 'sample_3',
        type: NotificationType.newOrder,
        category: NotificationCategory.seller,
        title: 'Pesanan Baru!',
        message: 'Anda mendapat pesanan baru untuk New Balance 574',
        timestamp: now.subtract(Duration(hours: 4)),
        imageUrl: 'assets/brand-products/New Balance/New Balance 574 Gray White - 1.png',
      ),
      
      AppNotification(
        id: 'sample_4',
        type: NotificationType.orderDelivered,
        category: NotificationCategory.purchase,
        title: 'Pesanan Sampai',
        message: 'Puma RS-X telah sampai di tujuan',
        timestamp: now.subtract(Duration(days: 1)),
        imageUrl: 'assets/brand-products/Puma/PUMA RS-X Mix White Black - 1.png',
      ),
      
      AppNotification(
        id: 'sample_5',
        type: NotificationType.productListed,
        category: NotificationCategory.seller,
        title: 'Produk Terdaftar',
        message: 'Converse Chuck Taylor 70s berhasil didaftarkan',
        timestamp: now.subtract(Duration(days: 2)),
        imageUrl: 'assets/brand-products/Converse/Converse Chuck Taylor 70s Black - 1.png',
      ),
    ];
    
    _notifications.clear();
    _notifications.addAll(sampleNotifications);
    _notifications.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    notifyListeners();
  }
} 