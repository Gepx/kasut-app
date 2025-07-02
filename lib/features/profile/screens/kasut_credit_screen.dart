import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

class CreditTxn {
  final DateTime date;
  final String desc;
  final double amount; // positive for credit in, negative for out
  CreditTxn({required this.date, required this.desc, required this.amount});
}

class KasutCreditScreen extends StatefulWidget {
  static const String routeName = '/kasut-credit';
  const KasutCreditScreen({super.key});

  @override
  State<KasutCreditScreen> createState() => _KasutCreditScreenState();
}

class _KasutCreditScreenState extends State<KasutCreditScreen> {
  final List<CreditTxn> _transactions = [
    CreditTxn(date: DateTime.now().subtract(const Duration(days: 1)), desc: 'Top-Up', amount: 250000),
    CreditTxn(date: DateTime.now().subtract(const Duration(days: 3)), desc: 'Purchase #1234', amount: -180000),
    CreditTxn(date: DateTime.now().subtract(const Duration(days: 6)), desc: 'Cash-Out', amount: -50000),
    CreditTxn(date: DateTime.now().subtract(const Duration(days: 10)), desc: 'Refund', amount: 80000),
  ];

  double get _balance => _transactions.fold(0, (p, e) => p + e.amount);

  List<CreditTxn> get _creditIn => _transactions.where((t) => t.amount > 0).toList();
  List<CreditTxn> get _creditOut => _transactions.where((t) => t.amount < 0).toList();

  final _fmt = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
  final _dateFmt = DateFormat('dd MMM yyyy');

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('Kasut Credit'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
          foregroundColor: Colors.black,
          backgroundColor: Colors.white,
          elevation: 0,
          bottom: const TabBar(
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.black,
            tabs: [
              Tab(text: 'All'),
              Tab(text: 'Credit In'),
              Tab(text: 'Credit Out'),
            ],
          ),
        ),
        body: Column(
          children: [
            _buildBalanceSection(),
            Expanded(
              child: TabBarView(
                children: [
                  _buildTxnList(_transactions),
                  _buildTxnList(_creditIn),
                  _buildTxnList(_creditOut),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBalanceSection() {
    return Container(
      width: double.infinity,
      color: Colors.grey[100],
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Available Balance', style: TextStyle(fontSize: 14, color: Colors.grey)),
          const SizedBox(height: 8),
          Text(_fmt.format(_balance),
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.black, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 14)),
                  onPressed: () => _showActionDialog('Top Up'),
                  icon: const Icon(Iconsax.add_square),
                  label: const Text('Top Up'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(foregroundColor: Colors.black, side: const BorderSide(color: Colors.black), padding: const EdgeInsets.symmetric(vertical: 14)),
                  onPressed: () => _showActionDialog('Cash Out'),
                  icon: const Icon(Iconsax.money_send),
                  label: const Text('Cash Out'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTxnList(List<CreditTxn> list) {
    if (list.isEmpty) {
      return const Center(child: Text('No transactions', style: TextStyle(color: Colors.grey)));
    }
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: list.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final txn = list[index];
        final isIn = txn.amount > 0;
        return ListTile(
          contentPadding: const EdgeInsets.symmetric(vertical: 8),
          leading: CircleAvatar(
            backgroundColor: Colors.grey[200],
            child: Icon(isIn ? Icons.arrow_downward : Icons.arrow_upward, color: Colors.black),
          ),
          title: Text(txn.desc, style: const TextStyle(fontWeight: FontWeight.w600)),
          subtitle: Text(_dateFmt.format(txn.date)),
          trailing: Text(
            (isIn ? '+' : '-') + _fmt.format(txn.amount.abs()),
            style: TextStyle(color: isIn ? Colors.green : Colors.red, fontWeight: FontWeight.bold),
          ),
        );
      },
    );
  }

  void _showActionDialog(String action) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(action),
        content: const Text('This feature is not implemented yet.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Close')),
        ],
      ),
    );
  }
}
