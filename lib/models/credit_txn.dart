class CreditTxn {
  final DateTime date;
  final String desc;

  /// Positive value means credit in, negative means credit out.
  final double amount;

  CreditTxn({required this.date, required this.desc, required this.amount});
}

class PointTxn {
  final DateTime date;
  final String desc;

  /// Positive value means points in, negative means points out.
  final int points;

  PointTxn({required this.date, required this.desc, required this.points});
}
