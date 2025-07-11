import 'package:flutter/foundation.dart';

class Voucher {
  final String id;
  final String title;
  final String desc;
  final DateTime expiry;
  final double? amount; // fixed discount
  final int? percent; // percentage discount
  bool isUsed;

  Voucher({
    required this.id,
    required this.title,
    required this.desc,
    required this.expiry,
    this.amount,
    this.percent,
    this.isUsed = false,
  });

  bool get isActive => !isUsed && expiry.isAfter(DateTime.now());
  bool get isExpired => expiry.isBefore(DateTime.now());

  double calculateDiscount(double totalPrice) {
    if (!isActive) return 0.0;

    if (amount != null) {
      return amount!;
    } else if (percent != null) {
      return totalPrice * (percent! / 100);
    }
    return 0.0;
  }

  String get displayValue {
    if (amount != null) {
      return 'IDR ${(amount! / 1000).toInt()}K';
    } else if (percent != null) {
      return '${percent}% OFF';
    }
    return '';
  }
}

class VoucherProvider extends ChangeNotifier {
  final List<Voucher> _vouchers = [
    Voucher(
      id: 'v1',
      title: 'WELCOME50',
      desc: 'IDR 50K off for new users',
      expiry: DateTime.now().add(const Duration(days: 30)),
      amount: 50000,
    ),
    Voucher(
      id: 'v2',
      title: 'FLASH20',
      desc: '20% off flash sale',
      expiry: DateTime.now().add(const Duration(days: 7)),
      percent: 20,
    ),
    Voucher(
      id: 'v3',
      title: 'EXPIRED10',
      desc: '10% expired voucher',
      expiry: DateTime.now().subtract(const Duration(days: 2)),
      percent: 10,
    ),
  ];

  List<Voucher> get vouchers => _vouchers;
  List<Voucher> get activeVouchers =>
      _vouchers.where((v) => v.isActive).toList();
  List<Voucher> get expiredVouchers =>
      _vouchers.where((v) => v.isExpired || v.isUsed).toList();

  void useVoucher(String voucherId) {
    final voucher = _vouchers.firstWhere((v) => v.id == voucherId);
    voucher.isUsed = true;
    notifyListeners();
  }

  void removeVoucher(String voucherId) {
    _vouchers.removeWhere((v) => v.id == voucherId);
    notifyListeners();
  }

  Voucher? getVoucherById(String voucherId) {
    try {
      return _vouchers.firstWhere((v) => v.id == voucherId);
    } catch (e) {
      return null;
    }
  }
}
