import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

class PointTxn {
  final DateTime date;
  final String desc;
  final int points; // positive in, negative out
  PointTxn({required this.date, required this.desc, required this.points});
}

class KasutPointsScreen extends StatefulWidget {
  static const String routeName = '/kasut-points';
  const KasutPointsScreen({super.key});

  @override
  State<KasutPointsScreen> createState() => _KasutPointsScreenState();
}

class _KasutPointsScreenState extends State<KasutPointsScreen> {
  final List<PointTxn> _txns = [
    PointTxn(date: DateTime.now().subtract(const Duration(days: 1)), desc: 'Purchase Bonus', points: 120),
    PointTxn(date: DateTime.now().subtract(const Duration(days: 2)), desc: 'Referral', points: 50),
    PointTxn(date: DateTime.now().subtract(const Duration(days: 5)), desc: 'Redeem Voucher', points: -80),
  ];

  int get _totalPoints => _txns.fold(0, (p, e) => p + e.points);
  int _nextTierTarget = 1000;

  List<PointTxn> get _in => _txns.where((t) => t.points > 0).toList();
  List<PointTxn> get _out => _txns.where((t) => t.points < 0).toList();

  final _dateFmt = DateFormat('dd MMM');

  @override
  Widget build(BuildContext context) {
    final progress = (_totalPoints / _nextTierTarget).clamp(0.0, 1.0);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('Kasut Points'),
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
              Tab(text: 'Points In'),
              Tab(text: 'Points Out'),
            ],
          ),
        ),
        body: Column(
          children: [
            Container(
              width: double.infinity,
              color: Colors.grey[100],
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Iconsax.coin, size: 32, color: Colors.black),
                      const SizedBox(width: 12),
                      Text('$_totalPoints Points', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  LinearProgressIndicator(value: progress, backgroundColor: Colors.grey[300], color: Colors.black, minHeight: 8),
                  const SizedBox(height: 8),
                  Text('${(_totalPoints).clamp(0, _nextTierTarget)}/$_nextTierTarget to next tier', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildList(_txns),
                  _buildList(_in),
                  _buildList(_out),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildList(List<PointTxn> list) {
    if (list.isEmpty) {
      return const Center(child: Text('No points history', style: TextStyle(color: Colors.grey)));
    }
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: list.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final t = list[index];
        final isIn = t.points > 0;
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.grey[200],
            child: Icon(isIn ? Icons.add : Icons.remove, color: Colors.black),
          ),
          title: Text(t.desc, style: const TextStyle(fontWeight: FontWeight.w600)),
          subtitle: Text(_dateFmt.format(t.date)),
          trailing: Text(
            (isIn ? '+' : '-') + t.points.toString(),
            style: TextStyle(color: isIn ? Colors.green : Colors.red, fontWeight: FontWeight.bold),
          ),
        );
      },
    );
  }
}
