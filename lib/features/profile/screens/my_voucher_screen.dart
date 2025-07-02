import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

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
}

class MyVoucherScreen extends StatefulWidget {
  static const String routeName = '/my-voucher';
  const MyVoucherScreen({super.key});

  @override
  State<MyVoucherScreen> createState() => _MyVoucherScreenState();
}

class _MyVoucherScreenState extends State<MyVoucherScreen> {
  final List<Voucher> _vouchers = [
    Voucher(id: 'v1', title: 'WELCOME50', desc: 'IDR 50K off for new users', expiry: DateTime.now().add(const Duration(days: 5)), amount: 50000),
    Voucher(id: 'v2', title: 'FLASH20', desc: '20% off flash sale', expiry: DateTime.now().add(const Duration(days: 1)), percent: 20),
    Voucher(id: 'v3', title: 'OLD10', desc: '10% expired voucher', expiry: DateTime.now().subtract(const Duration(days: 2)), percent: 10),
  ];

  final _dateFmt = DateFormat('dd MMM yyyy');

  List<Voucher> get _active => _vouchers.where((v) => v.expiry.isAfter(DateTime.now()) && !v.isUsed).toList();
  List<Voucher> get _expired => _vouchers.where((v) => v.expiry.isBefore(DateTime.now()) || v.isUsed).toList();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('My Vouchers'),
          leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.of(context).pop()),
          foregroundColor: Colors.black,
          backgroundColor: Colors.white,
          elevation: 0,
          actions: [
            IconButton(icon: const Icon(Iconsax.message_question), onPressed: () {/* help */}),
          ],
          bottom: const TabBar(
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.black,
            tabs: [Tab(text: 'Active'), Tab(text: 'Expired')],
          ),
        ),
        body: TabBarView(
          children: [
            _buildTab(_active, isActive: true),
            _buildTab(_expired, isActive: false),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(List<Voucher> list, {required bool isActive}) {
    if (list.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Iconsax.ticket_discount, size: 60, color: Colors.grey),
            const SizedBox(height: 16),
            Text('No ${isActive ? 'active' : 'expired'} vouchers', style: const TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: list.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final v = list[index];
        final card = _buildVoucherCard(v, isActive);
        return isActive
            ? Dismissible(
                key: ValueKey(v.id),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  color: Colors.red,
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                onDismissed: (_) {
                  setState(() => _vouchers.removeWhere((e) => e.id == v.id));
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Voucher removed'), backgroundColor: Colors.black));
                },
                child: card,
              )
            : card;
      },
    );
  }

  Widget _buildVoucherCard(Voucher v, bool isActive) {
    return Card(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: const BorderSide(color: Colors.black)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Iconsax.ticket_discount, size: 28, color: Colors.black),
                const SizedBox(width: 8),
                Expanded(child: Text(v.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(8)),
                  child: Text(
                    v.amount != null ? 'IDR ${v.amount!.toInt() ~/ 1000}K' : '${v.percent}% OFF',
                    style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
            const SizedBox(height: 8),
            Text(v.desc, style: const TextStyle(fontSize: 12, color: Colors.grey)),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Expires ${_dateFmt.format(v.expiry)}', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                if (isActive)
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.black, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10)),
                    onPressed: () {
                      setState(() => v.isUsed = true);
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Voucher applied'), backgroundColor: Colors.black));
                    },
                    child: const Text('Use'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
