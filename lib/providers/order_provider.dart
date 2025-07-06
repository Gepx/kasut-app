import 'package:flutter/foundation.dart';
import '../models/shoe_model.dart';
import '../models/notification_model.dart';

enum OrderStatus { active, completed, cancelled }
enum PaymentMethod { creditCard, bankTransfer, eWallet, cod }
enum EWalletType { gopay, ovo, dana, shopeepay }
enum CardType { visa, mastercard, jcb, amex }

class PaymentMethodDetails {
  final String id;
  final PaymentMethod type;
  final String nickname; // e.g., "My BCA Card", "Work GoPay"
  final bool isDefault;
  
  // For Credit/Debit Cards
  final String? maskedCardNumber; // e.g., "**** **** **** 1234"
  final String? cardHolderName;
  final String? expiryDate;
  final CardType? cardType;
  
  // For E-Wallets
  final EWalletType? eWalletType;
  final String? phoneNumber;
  final String? accountName;
  
  // For Bank Transfer
  final String? bankName;
  final String? accountNumber;
  final String? accountHolderName;

  PaymentMethodDetails({
    required this.id,
    required this.type,
    required this.nickname,
    this.isDefault = false,
    this.maskedCardNumber,
    this.cardHolderName,
    this.expiryDate,
    this.cardType,
    this.eWalletType,
    this.phoneNumber,
    this.accountName,
    this.bankName,
    this.accountNumber,
    this.accountHolderName,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.index,
      'nickname': nickname,
      'isDefault': isDefault,
      'maskedCardNumber': maskedCardNumber,
      'cardHolderName': cardHolderName,
      'expiryDate': expiryDate,
      'cardType': cardType?.index,
      'eWalletType': eWalletType?.index,
      'phoneNumber': phoneNumber,
      'accountName': accountName,
      'bankName': bankName,
      'accountNumber': accountNumber,
      'accountHolderName': accountHolderName,
    };
  }

  factory PaymentMethodDetails.fromJson(Map<String, dynamic> json) {
    return PaymentMethodDetails(
      id: json['id'],
      type: PaymentMethod.values[json['type']],
      nickname: json['nickname'],
      isDefault: json['isDefault'] ?? false,
      maskedCardNumber: json['maskedCardNumber'],
      cardHolderName: json['cardHolderName'],
      expiryDate: json['expiryDate'],
      cardType: json['cardType'] != null ? CardType.values[json['cardType']] : null,
      eWalletType: json['eWalletType'] != null ? EWalletType.values[json['eWalletType']] : null,
      phoneNumber: json['phoneNumber'],
      accountName: json['accountName'],
      bankName: json['bankName'],
      accountNumber: json['accountNumber'],
      accountHolderName: json['accountHolderName'],
    );
  }

  String getDisplayText() {
    switch (type) {
      case PaymentMethod.creditCard:
        return '$nickname - ${_getCardTypeText()} ${maskedCardNumber ?? ""}';
      case PaymentMethod.eWallet:
        return '$nickname - ${_getEWalletTypeText()} ($phoneNumber)';
      case PaymentMethod.bankTransfer:
        return '$nickname - $bankName (${_maskAccountNumber()})';
      case PaymentMethod.cod:
        return 'Cash on Delivery';
    }
  }

  String _getCardTypeText() {
    switch (cardType) {
      case CardType.visa:
        return 'Visa';
      case CardType.mastercard:
        return 'Mastercard';
      case CardType.jcb:
        return 'JCB';
      case CardType.amex:
        return 'American Express';
      default:
        return 'Card';
    }
  }

  String _getEWalletTypeText() {
    switch (eWalletType) {
      case EWalletType.gopay:
        return 'GoPay';
      case EWalletType.ovo:
        return 'OVO';
      case EWalletType.dana:
        return 'DANA';
      case EWalletType.shopeepay:
        return 'ShopeePay';
      default:
        return 'E-Wallet';
    }
  }

  String _maskAccountNumber() {
    if (accountNumber == null || accountNumber!.length <= 4) return accountNumber ?? '';
    return '*' * (accountNumber!.length - 4) + accountNumber!.substring(accountNumber!.length - 4);
  }
}

class DeliveryAddress {
  final String id;
  final String name;
  final String phone;
  final String address;
  final String city;
  final String province;
  final String postalCode;
  final String? notes;
  final bool isDefault;

  DeliveryAddress({
    required this.id,
    required this.name,
    required this.phone,
    required this.address,
    required this.city,
    required this.province,
    required this.postalCode,
    this.notes,
    this.isDefault = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'address': address,
      'city': city,
      'province': province,
      'postalCode': postalCode,
      'notes': notes,
      'isDefault': isDefault,
    };
  }

  factory DeliveryAddress.fromJson(Map<String, dynamic> json) {
    return DeliveryAddress(
      id: json['id'],
      name: json['name'],
      phone: json['phone'],
      address: json['address'],
      city: json['city'],
      province: json['province'],
      postalCode: json['postalCode'],
      notes: json['notes'],
      isDefault: json['isDefault'] ?? false,
    );
  }

  String get fullAddress => '$address, $city, $province $postalCode';
}

class Order {
  final String id;
  final Shoe shoe;
  final double size;
  final double itemPrice;
  final double shippingCost;
  final double totalPrice;
  final PaymentMethodDetails paymentMethod;
  final DeliveryAddress deliveryAddress;
  final DateTime orderDate;
  final DateTime? deliveryDate;
  final OrderStatus status;
  final String? trackingNumber;

  Order({
    required this.id,
    required this.shoe,
    required this.size,
    required this.itemPrice,
    required this.shippingCost,
    required this.totalPrice,
    required this.paymentMethod,
    required this.deliveryAddress,
    required this.orderDate,
    this.deliveryDate,
    required this.status,
    this.trackingNumber,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'shoe': shoe.toJson(),
      'size': size,
      'itemPrice': itemPrice,
      'shippingCost': shippingCost,
      'totalPrice': totalPrice,
      'paymentMethod': paymentMethod.toJson(),
      'deliveryAddress': deliveryAddress.toJson(),
      'orderDate': orderDate.toIso8601String(),
      'deliveryDate': deliveryDate?.toIso8601String(),
      'status': status.index,
      'trackingNumber': trackingNumber,
    };
  }

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      shoe: Shoe.fromJson(json['shoe']),
      size: json['size'],
      itemPrice: json['itemPrice'],
      shippingCost: json['shippingCost'],
      totalPrice: json['totalPrice'],
      paymentMethod: PaymentMethodDetails.fromJson(json['paymentMethod']),
      deliveryAddress: DeliveryAddress.fromJson(json['deliveryAddress']),
      orderDate: DateTime.parse(json['orderDate']),
      deliveryDate: json['deliveryDate'] != null ? DateTime.parse(json['deliveryDate']) : null,
      status: OrderStatus.values[json['status']],
      trackingNumber: json['trackingNumber'],
    );
  }
}

class OrderProvider with ChangeNotifier {
  final List<Order> _orders = [];
  List<DeliveryAddress> _addresses = [];
  List<PaymentMethodDetails> _paymentMethods = [];
  
  // Callback to notify when orders change
  Function(List<Order>)? _onOrdersChanged;

  List<Order> get orders => _orders;
  List<DeliveryAddress> get addresses => _addresses;
  List<PaymentMethodDetails> get paymentMethods => _paymentMethods;
  
  // Set callback for order changes
  void setOrdersChangedCallback(Function(List<Order>) callback) {
    _onOrdersChanged = callback;
  }
  
  // Notify about order changes
  void _notifyOrdersChanged() {
    _onOrdersChanged?.call(_orders);
  }

  List<Order> get activeOrders => _orders.where((order) => order.status == OrderStatus.active).toList();
  List<Order> get completedOrders => _orders.where((order) => order.status == OrderStatus.completed).toList();
  List<Order> get cancelledOrders => _orders.where((order) => order.status == OrderStatus.cancelled).toList();

  DeliveryAddress? get defaultAddress {
    try {
      return _addresses.firstWhere((addr) => addr.isDefault);
    } catch (e) {
      return _addresses.isNotEmpty ? _addresses.first : null;
    }
  }

  PaymentMethodDetails? get defaultPaymentMethod {
    try {
      return _paymentMethods.firstWhere((payment) => payment.isDefault);
    } catch (e) {
      return _paymentMethods.isNotEmpty ? _paymentMethods.first : null;
    }
  }

  // Indonesian provinces and cities data
  static const Map<String, List<String>> indonesianLocations = {
    'DKI Jakarta': ['Jakarta Pusat', 'Jakarta Utara', 'Jakarta Selatan', 'Jakarta Timur', 'Jakarta Barat', 'Kepulauan Seribu'],
    'Jawa Barat': ['Bandung', 'Bekasi', 'Bogor', 'Cirebon', 'Depok', 'Sukabumi', 'Tasikmalaya', 'Banjar', 'Cimahi'],
    'Jawa Tengah': ['Semarang', 'Solo', 'Yogyakarta', 'Magelang', 'Pekalongan', 'Purwokerto', 'Tegal', 'Salatiga'],
    'Jawa Timur': ['Surabaya', 'Malang', 'Kediri', 'Blitar', 'Madiun', 'Mojokerto', 'Pasuruan', 'Probolinggo'],
    'Banten': ['Tangerang', 'Tangerang Selatan', 'Serang', 'Cilegon', 'Pandeglang', 'Lebak'],
    'Bali': ['Denpasar', 'Badung', 'Gianyar', 'Tabanan', 'Klungkung', 'Bangli', 'Karangasem', 'Buleleng', 'Jembrana'],
    'Sumatera Utara': ['Medan', 'Binjai', 'Pematangsiantar', 'Tanjungbalai', 'Sibolga', 'Tebing Tinggi', 'Padangsidimpuan'],
    'Sumatera Barat': ['Padang', 'Bukittinggi', 'Padang Panjang', 'Payakumbuh', 'Sawahlunto', 'Solok', 'Pariaman'],
    'Riau': ['Pekanbaru', 'Dumai', 'Kampar', 'Rokan Hulu', 'Bengkalis', 'Indragiri Hulu', 'Kuantan Singingi'],
  };

  List<String> get provinces => indonesianLocations.keys.toList();
  
  List<String> getCitiesByProvince(String province) {
    return indonesianLocations[province] ?? [];
  }

  // Add sample data for demo
  OrderProvider() {
    _initializeSampleData();
  }

  void _initializeSampleData() {
    _addresses = [
      DeliveryAddress(
        id: '1',
        name: 'John Doe',
        phone: '+6281234567890',
        address: 'Jl. Sudirman No. 123, Apartment ABC, Unit 45',
        city: 'Jakarta Selatan',
        province: 'DKI Jakarta',
        postalCode: '12190',
        notes: 'Ring the bell twice',
        isDefault: true,
      ),
      DeliveryAddress(
        id: '2',
        name: 'John Doe',
        phone: '+6281234567890',
        address: 'Jl. Gatot Subroto No. 456, Office Building XYZ',
        city: 'Jakarta Pusat',
        province: 'DKI Jakarta',
        postalCode: '10270',
        notes: 'Office hours: 9 AM - 6 PM',
        isDefault: false,
      ),
    ];

    _paymentMethods = [
      PaymentMethodDetails(
        id: '1',
        type: PaymentMethod.creditCard,
        nickname: 'My BCA Card',
        isDefault: true,
        maskedCardNumber: '**** **** **** 1234',
        cardHolderName: 'JOHN DOE',
        expiryDate: '12/25',
        cardType: CardType.visa,
      ),
      PaymentMethodDetails(
        id: '2',
        type: PaymentMethod.eWallet,
        nickname: 'Work GoPay',
        isDefault: false,
        eWalletType: EWalletType.gopay,
        phoneNumber: '+6281234567890',
        accountName: 'John Doe',
      ),
    ];
  }

  void addOrder(Order order) {
    _orders.insert(0, order);
    notifyListeners();
    _notifyOrdersChanged();
  }

  void updateOrderStatus(String orderId, OrderStatus newStatus) {
    final orderIndex = _orders.indexWhere((order) => order.id == orderId);
    if (orderIndex != -1) {
      final order = _orders[orderIndex];
      _orders[orderIndex] = Order(
        id: order.id,
        shoe: order.shoe,
        size: order.size,
        itemPrice: order.itemPrice,
        shippingCost: order.shippingCost,
        totalPrice: order.totalPrice,
        paymentMethod: order.paymentMethod,
        deliveryAddress: order.deliveryAddress,
        orderDate: order.orderDate,
        deliveryDate: newStatus == OrderStatus.completed ? DateTime.now() : order.deliveryDate,
        status: newStatus,
        trackingNumber: order.trackingNumber,
      );
      notifyListeners();
      _notifyOrdersChanged();
    }
  }

  // Address management
  void addAddress(DeliveryAddress address) {
    if (address.isDefault) {
      _addresses = _addresses.map((addr) => DeliveryAddress(
        id: addr.id,
        name: addr.name,
        phone: addr.phone,
        address: addr.address,
        city: addr.city,
        province: addr.province,
        postalCode: addr.postalCode,
        notes: addr.notes,
        isDefault: false,
      )).toList();
    }
    _addresses.add(address);
    notifyListeners();
  }

  void updateAddress(DeliveryAddress updatedAddress) {
    final index = _addresses.indexWhere((addr) => addr.id == updatedAddress.id);
    if (index != -1) {
      if (updatedAddress.isDefault) {
        _addresses = _addresses.map((addr) => addr.id != updatedAddress.id ? DeliveryAddress(
          id: addr.id,
          name: addr.name,
          phone: addr.phone,
          address: addr.address,
          city: addr.city,
          province: addr.province,
          postalCode: addr.postalCode,
          notes: addr.notes,
          isDefault: false,
        ) : addr).toList();
      }
      _addresses[index] = updatedAddress;
      notifyListeners();
    }
  }

  void deleteAddress(String addressId) {
    _addresses.removeWhere((addr) => addr.id == addressId);
    if (_addresses.isNotEmpty && !_addresses.any((addr) => addr.isDefault)) {
      updateAddress(DeliveryAddress(
        id: _addresses.first.id,
        name: _addresses.first.name,
        phone: _addresses.first.phone,
        address: _addresses.first.address,
        city: _addresses.first.city,
        province: _addresses.first.province,
        postalCode: _addresses.first.postalCode,
        notes: _addresses.first.notes,
        isDefault: true,
      ));
    }
    notifyListeners();
  }

  // Payment method management
  void addPaymentMethod(PaymentMethodDetails paymentMethod) {
    if (_paymentMethods.length >= 3) {
      throw Exception('Maximum 3 payment methods allowed');
    }
    
    if (paymentMethod.isDefault) {
      _paymentMethods = _paymentMethods.map((method) => PaymentMethodDetails(
        id: method.id,
        type: method.type,
        nickname: method.nickname,
        isDefault: false,
        maskedCardNumber: method.maskedCardNumber,
        cardHolderName: method.cardHolderName,
        expiryDate: method.expiryDate,
        cardType: method.cardType,
        eWalletType: method.eWalletType,
        phoneNumber: method.phoneNumber,
        accountName: method.accountName,
        bankName: method.bankName,
        accountNumber: method.accountNumber,
        accountHolderName: method.accountHolderName,
      )).toList();
    }
    _paymentMethods.add(paymentMethod);
    notifyListeners();
  }

  void updatePaymentMethod(PaymentMethodDetails updatedPaymentMethod) {
    final index = _paymentMethods.indexWhere((method) => method.id == updatedPaymentMethod.id);
    if (index != -1) {
      if (updatedPaymentMethod.isDefault) {
        _paymentMethods = _paymentMethods.map((method) => method.id != updatedPaymentMethod.id ? PaymentMethodDetails(
          id: method.id,
          type: method.type,
          nickname: method.nickname,
          isDefault: false,
          maskedCardNumber: method.maskedCardNumber,
          cardHolderName: method.cardHolderName,
          expiryDate: method.expiryDate,
          cardType: method.cardType,
          eWalletType: method.eWalletType,
          phoneNumber: method.phoneNumber,
          accountName: method.accountName,
          bankName: method.bankName,
          accountNumber: method.accountNumber,
          accountHolderName: method.accountHolderName,
        ) : method).toList();
      }
      _paymentMethods[index] = updatedPaymentMethod;
      notifyListeners();
    }
  }

  void deletePaymentMethod(String paymentMethodId) {
    _paymentMethods.removeWhere((method) => method.id == paymentMethodId);
    if (_paymentMethods.isNotEmpty && !_paymentMethods.any((method) => method.isDefault)) {
      updatePaymentMethod(PaymentMethodDetails(
        id: _paymentMethods.first.id,
        type: _paymentMethods.first.type,
        nickname: _paymentMethods.first.nickname,
        isDefault: true,
        maskedCardNumber: _paymentMethods.first.maskedCardNumber,
        cardHolderName: _paymentMethods.first.cardHolderName,
        expiryDate: _paymentMethods.first.expiryDate,
        cardType: _paymentMethods.first.cardType,
        eWalletType: _paymentMethods.first.eWalletType,
        phoneNumber: _paymentMethods.first.phoneNumber,
        accountName: _paymentMethods.first.accountName,
        bankName: _paymentMethods.first.bankName,
        accountNumber: _paymentMethods.first.accountNumber,
        accountHolderName: _paymentMethods.first.accountHolderName,
      ));
    }
    notifyListeners();
  }

  String generateOrderId() {
    return 'KST${DateTime.now().millisecondsSinceEpoch}';
  }

  String generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  String getPaymentMethodName(PaymentMethod method) {
    switch (method) {
      case PaymentMethod.creditCard:
        return 'Credit/Debit Card';
      case PaymentMethod.bankTransfer:
        return 'Bank Transfer';
      case PaymentMethod.eWallet:
        return 'E-Wallet';
      case PaymentMethod.cod:
        return 'Cash on Delivery';
    }
  }

  String getStatusName(OrderStatus status) {
    switch (status) {
      case OrderStatus.active:
        return 'Processing';
      case OrderStatus.completed:
        return 'Delivered';
      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }

  static String maskCardNumber(String cardNumber) {
    if (cardNumber.length <= 4) return cardNumber;
    return '**** **** **** ${cardNumber.substring(cardNumber.length - 4)}';
  }
} 