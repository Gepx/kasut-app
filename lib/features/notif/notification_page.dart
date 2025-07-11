import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../models/notification_model.dart';
import '../../providers/notification_provider.dart';
import '../../providers/order_provider.dart';
import '../../widgets/image_loader.dart';
import '../profile/screens/buying_screen.dart';
import '../seller/seller.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  DateTime? _fromDate;
  DateTime? _toDate;
  final _dateFormat = DateFormat('MMM dd, yyyy');

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadNotifications();
    });
  }

  void _loadNotifications() {
    final notificationProvider = Provider.of<NotificationProvider>(
      context,
      listen: false,
    );
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);

    // Generate notifications from existing orders
    notificationProvider.generateNotificationsFromOrders(orderProvider.orders);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          title: const Text(
            "Notifications",
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          actions: [
            // Date filter button
            IconButton(
              icon: const Icon(Icons.date_range),
              onPressed: _showDateFilterDialog,
              tooltip: 'Filter by date',
            ),
            Consumer<NotificationProvider>(
              builder: (context, notificationProvider, child) {
                if (notificationProvider.unreadCount > 0) {
                  return TextButton(
                    onPressed: () {
                      notificationProvider.markAllAsRead();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('All notifications marked as read'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                    child: const Text(
                      'Read All',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(100),
            child: Column(
              children: [
                // Date filter display
                if (_fromDate != null || _toDate != null)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    color: Colors.blue[50],
                    child: Row(
                      children: [
                        Icon(
                          Icons.filter_list,
                          size: 16,
                          color: Colors.blue[600],
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Filtered: ${_fromDate != null ? _dateFormat.format(_fromDate!) : 'Any'} - ${_toDate != null ? _dateFormat.format(_toDate!) : 'Any'}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.blue[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: _clearDateFilter,
                          child: Text(
                            'Clear',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.blue[600],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                // Tab bar
                Consumer<NotificationProvider>(
                  builder: (context, notificationProvider, child) {
                    return TabBar(
                      labelColor: Colors.black,
                      unselectedLabelColor: Colors.grey,
                      indicatorColor: Colors.black,
                      indicatorWeight: 3,
                      tabs: [
                        Tab(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("All"),
                              if (notificationProvider.unreadCount > 0) ...[
                                const SizedBox(width: 4),
                                Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Text(
                                    notificationProvider.unreadCount.toString(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        Tab(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("Purchase"),
                              if (notificationProvider.unreadPurchaseCount >
                                  0) ...[
                                const SizedBox(width: 4),
                                Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Text(
                                    notificationProvider.unreadPurchaseCount
                                        .toString(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        Tab(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("Sales"),
                              if (notificationProvider.unreadSellerCount >
                                  0) ...[
                                const SizedBox(width: 4),
                                Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Text(
                                    notificationProvider.unreadSellerCount
                                        .toString(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        body: TabBarView(
          children: [
            NotificationContent(
              category: NotificationCategory.all,
              fromDate: _fromDate,
              toDate: _toDate,
            ),
            NotificationContent(
              category: NotificationCategory.purchase,
              fromDate: _fromDate,
              toDate: _toDate,
            ),
            NotificationContent(
              category: NotificationCategory.seller,
              fromDate: _fromDate,
              toDate: _toDate,
            ),
          ],
        ),
      ),
    );
  }

  void _showDateFilterDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Filter by Date'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // From Date
                ListTile(
                  leading: const Icon(Icons.calendar_today),
                  title: const Text('From Date'),
                  subtitle: Text(
                    _fromDate != null
                        ? _dateFormat.format(_fromDate!)
                        : 'Select start date',
                  ),
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate:
                          _fromDate ??
                          DateTime.now().subtract(const Duration(days: 30)),
                      firstDate: DateTime(2020),
                      lastDate: DateTime.now(),
                      builder: (context, child) {
                        return Theme(
                          data: Theme.of(context).copyWith(
                            colorScheme: const ColorScheme.light(
                              primary: Colors.black,
                              onPrimary: Colors.white,
                              surface: Colors.white,
                              onSurface: Colors.black,
                            ),
                          ),
                          child: child!,
                        );
                      },
                    );
                    if (date != null) {
                      setState(() {
                        _fromDate = date;
                      });
                      Navigator.pop(context);
                      _showDateFilterDialog();
                    }
                  },
                ),
                // To Date
                ListTile(
                  leading: const Icon(Icons.event),
                  title: const Text('To Date'),
                  subtitle: Text(
                    _toDate != null
                        ? _dateFormat.format(_toDate!)
                        : 'Select end date',
                  ),
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: _toDate ?? DateTime.now(),
                      firstDate: _fromDate ?? DateTime(2020),
                      lastDate: DateTime.now(),
                      builder: (context, child) {
                        return Theme(
                          data: Theme.of(context).copyWith(
                            colorScheme: const ColorScheme.light(
                              primary: Colors.black,
                              onPrimary: Colors.white,
                              surface: Colors.white,
                              onSurface: Colors.black,
                            ),
                          ),
                          child: child!,
                        );
                      },
                    );
                    if (date != null) {
                      setState(() {
                        _toDate = date;
                      });
                      Navigator.pop(context);
                      _showDateFilterDialog();
                    }
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  _clearDateFilter();
                  Navigator.pop(context);
                },
                child: const Text('Clear Filter'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Done'),
              ),
            ],
          ),
    );
  }

  void _clearDateFilter() {
    setState(() {
      _fromDate = null;
      _toDate = null;
    });
  }
}

class NotificationContent extends StatelessWidget {
  final NotificationCategory category;
  final DateTime? fromDate;
  final DateTime? toDate;

  const NotificationContent({
    super.key,
    required this.category,
    this.fromDate,
    this.toDate,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<NotificationProvider>(
      builder: (context, notificationProvider, child) {
        List<AppNotification> notifications;

        switch (category) {
          case NotificationCategory.all:
            notifications = notificationProvider.allNotifications;
            break;
          case NotificationCategory.purchase:
            notifications = notificationProvider.purchaseNotifications;
            break;
          case NotificationCategory.seller:
            notifications = notificationProvider.sellerNotifications;
            break;
        }

        // Apply date filtering
        if (fromDate != null || toDate != null) {
          notifications =
              notifications.where((notification) {
                final notificationDate = notification.timestamp;
                bool passesFromDate =
                    fromDate == null ||
                    notificationDate.isAfter(fromDate!) ||
                    notificationDate.isAtSameMomentAs(fromDate!);
                bool passesToDate =
                    toDate == null ||
                    notificationDate.isBefore(
                      toDate!.add(const Duration(days: 1)),
                    ) ||
                    notificationDate.isAtSameMomentAs(toDate!);
                return passesFromDate && passesToDate;
              }).toList();
        }

        if (notifications.isEmpty) {
          return _buildEmptyState();
        }

        return RefreshIndicator(
          onRefresh: () async {
            final orderProvider = Provider.of<OrderProvider>(
              context,
              listen: false,
            );
            notificationProvider.generateNotificationsFromOrders(
              orderProvider.orders,
            );
          },
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final notification = notifications[index];
              return _buildNotificationCard(
                context,
                notification,
                notificationProvider,
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    String message;
    String description;
    IconData icon;

    switch (category) {
      case NotificationCategory.all:
        message = 'No Notifications';
        description = 'All your notifications will appear here';
        icon = Icons.notifications_outlined;
        break;
      case NotificationCategory.purchase:
        message = 'No Purchase Notifications';
        description = 'Order and payment notifications will appear here';
        icon = Icons.shopping_bag_outlined;
        break;
      case NotificationCategory.seller:
        message = 'No Sales Notifications';
        description = 'Sales and product notifications will appear here';
        icon = Icons.store_outlined;
        break;
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 48, color: Colors.grey[400]),
            ),
            const SizedBox(height: 16),
            Text(
              message,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationCard(
    BuildContext context,
    AppNotification notification,
    NotificationProvider notificationProvider,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: notification.isRead ? Colors.white : Colors.blue[50],
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border:
            notification.isRead
                ? null
                : Border.all(color: Colors.blue[200]!, width: 1),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            if (!notification.isRead) {
              notificationProvider.markAsRead(notification.id);
            }
            _handleNotificationTap(context, notification);
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Notification image or icon
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[200]!),
                  ),
                  child:
                      notification.imageUrl != null
                          ? ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: AssetImageLoader(
                              imagePath: notification.imageUrl!,
                              fit: BoxFit.cover,
                            ),
                          )
                          : Icon(
                            _getNotificationIcon(notification.type),
                            color: _getNotificationColor(notification.type),
                            size: 28,
                          ),
                ),

                const SizedBox(width: 12),

                // Notification content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              notification.title,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight:
                                    notification.isRead
                                        ? FontWeight.w500
                                        : FontWeight.w600,
                                color: Colors.black,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (!notification.isRead)
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: Colors.blue,
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),

                      const SizedBox(height: 4),

                      Text(
                        notification.message,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                          height: 1.4,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                      const SizedBox(height: 8),

                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 14,
                            color: Colors.grey[500],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            notification.timeAgo,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[500],
                            ),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: _getNotificationColor(
                                notification.type,
                              ).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              _getNotificationTypeLabel(notification.type),
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                                color: _getNotificationColor(notification.type),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleNotificationTap(
    BuildContext context,
    AppNotification notification,
  ) {
    switch (notification.actionRoute) {
      case '/buying':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const BuyingScreen()),
        );
        break;
      case '/seller-dashboard':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SellerPage()),
        );
        break;
      default:
        // Handle other routes or show details
        break;
    }
  }

  IconData _getNotificationIcon(NotificationType type) {
    switch (type) {
      case NotificationType.purchaseConfirmed:
        return Icons.shopping_cart_outlined;
      case NotificationType.orderShipped:
        return Icons.local_shipping_outlined;
      case NotificationType.orderDelivered:
        return Icons.check_circle_outline;
      case NotificationType.orderCancelled:
        return Icons.cancel_outlined;
      case NotificationType.paymentReceived:
        return Icons.payment_outlined;
      case NotificationType.newOrder:
        return Icons.add_shopping_cart_outlined;
      case NotificationType.productListed:
        return Icons.inventory_2_outlined;
      case NotificationType.productViewed:
        return Icons.visibility_outlined;
      case NotificationType.lowInventory:
        return Icons.warning_outlined;
      case NotificationType.priceAlert:
        return Icons.local_offer_outlined;
      case NotificationType.system:
        return Icons.info_outline;
    }
  }

  Color _getNotificationColor(NotificationType type) {
    switch (type) {
      case NotificationType.purchaseConfirmed:
        return Colors.green;
      case NotificationType.orderShipped:
        return Colors.blue;
      case NotificationType.orderDelivered:
        return Colors.green;
      case NotificationType.orderCancelled:
        return Colors.red;
      case NotificationType.paymentReceived:
        return Colors.green;
      case NotificationType.newOrder:
        return Colors.orange;
      case NotificationType.productListed:
        return Colors.blue;
      case NotificationType.productViewed:
        return Colors.purple;
      case NotificationType.lowInventory:
        return Colors.orange;
      case NotificationType.priceAlert:
        return Colors.green;
      case NotificationType.system:
        return Colors.grey;
    }
  }

  String _getNotificationTypeLabel(NotificationType type) {
    switch (type) {
      case NotificationType.purchaseConfirmed:
        return 'Order';
      case NotificationType.orderShipped:
        return 'Shipping';
      case NotificationType.orderDelivered:
        return 'Order';
      case NotificationType.orderCancelled:
        return 'Order';
      case NotificationType.paymentReceived:
        return 'Payment';
      case NotificationType.newOrder:
        return 'New Order';
      case NotificationType.productListed:
        return 'Product';
      case NotificationType.productViewed:
        return 'Product';
      case NotificationType.lowInventory:
        return 'Stock';
      case NotificationType.priceAlert:
        return 'Price';
      case NotificationType.system:
        return 'System';
    }
  }
}
