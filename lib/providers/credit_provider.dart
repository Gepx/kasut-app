import 'package:flutter/foundation.dart';
import '../models/credit_txn.dart';

class KasutCreditProvider with ChangeNotifier {
  final List<CreditTxn> _transactions = [];
  double _balance = 0;

  List<CreditTxn> get transactions => List.unmodifiable(_transactions);
  List<CreditTxn> get creditIn =>
      _transactions.where((t) => t.amount > 0).toList();
  List<CreditTxn> get creditOut =>
      _transactions.where((t) => t.amount < 0).toList();
  double get balance => _balance;

  /// Add credit to the wallet (top-up)
  void topUp({required double amount, required String description}) {
    if (amount <= 0) return;
    _transactions.insert(
      0,
      CreditTxn(date: DateTime.now(), desc: description, amount: amount),
    );
    _balance += amount;
    notifyListeners();
  }

  /// Remove credit from the wallet (cash-out or spend)
  /// Throws [ArgumentError] if amount exceeds balance.
  void cashOut({required double amount, required String description}) {
    if (amount <= 0) return;
    if (amount > _balance) {
      throw ArgumentError('Insufficient balance');
    }
    _transactions.insert(
      0,
      CreditTxn(date: DateTime.now(), desc: description, amount: -amount),
    );
    _balance -= amount;
    notifyListeners();
  }
}

class KasutPointsProvider extends ChangeNotifier {
  int _points = 0;
  int get points => _points;

  void setPoints(int value) {
    _points = value;
    notifyListeners();
  }

  void addPoints(int value) {
    _points += value;
    notifyListeners();
  }

  void subtractPoints(int value) {
    _points -= value;
    notifyListeners();
  }
}
