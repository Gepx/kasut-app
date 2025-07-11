import 'package:flutter/foundation.dart';
import '../models/credit_txn.dart';
import '../features/auth/services/auth_service.dart';

class KasutCreditProvider with ChangeNotifier {
  final List<CreditTxn> _transactions = [];
  double _balance = 0;

  KasutCreditProvider() {
    _initializeFromAuth();
  }

  void _initializeFromAuth() {
    final credits = AuthService.getUserCredits();
    _balance = credits['kasutCredit']?.toDouble() ?? 0.0;
  }

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
    // Sync with AuthService
    AuthService.updateUserCredits(kasutCredit: _balance);
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
    // Sync with AuthService
    AuthService.updateUserCredits(kasutCredit: _balance);
    notifyListeners();
  }

  /// Refresh balance from AuthService
  void refreshFromAuth() {
    _initializeFromAuth();
    notifyListeners();
  }
}

class KasutPointsProvider extends ChangeNotifier {
  int _points = 0;
  final List<PointTxn> _transactions = [];

  KasutPointsProvider() {
    _initializeFromAuth();
  }

  void _initializeFromAuth() {
    final credits = AuthService.getUserCredits();
    _points = credits['kasutPoints'] ?? 0;
  }

  int get points => _points;
  List<PointTxn> get transactions => List.unmodifiable(_transactions);
  List<PointTxn> get pointsIn =>
      _transactions.where((t) => t.points > 0).toList();
  List<PointTxn> get pointsOut =>
      _transactions.where((t) => t.points < 0).toList();

  void setPoints(int value) {
    _points = value;
    // Sync with AuthService
    AuthService.updateUserCredits(kasutPoints: _points);
    notifyListeners();
  }

  void addPoints(int value, {String? description}) {
    _points += value;
    _transactions.insert(
      0,
      PointTxn(
        date: DateTime.now(),
        desc: description ?? 'Points earned',
        points: value,
      ),
    );
    // Sync with AuthService
    AuthService.updateUserCredits(kasutPoints: _points);
    notifyListeners();
  }

  void subtractPoints(int value, {String? description}) {
    _points -= value;
    _transactions.insert(
      0,
      PointTxn(
        date: DateTime.now(),
        desc: description ?? 'Points used',
        points: -value,
      ),
    );
    // Sync with AuthService
    AuthService.updateUserCredits(kasutPoints: _points);
    notifyListeners();
  }

  /// Check if user has enough points
  bool hasEnoughPoints(int requiredPoints) {
    return _points >= requiredPoints;
  }

  /// Use points and return the amount used
  int usePoints(int maxPoints, {String? description}) {
    final pointsToUse = _points < maxPoints ? _points : maxPoints;
    if (pointsToUse > 0) {
      subtractPoints(pointsToUse, description: description);
    }
    return pointsToUse;
  }

  /// Refresh points from AuthService
  void refreshFromAuth() {
    _initializeFromAuth();
    notifyListeners();
  }
}
