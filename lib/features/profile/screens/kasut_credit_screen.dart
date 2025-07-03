import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../providers/credit_provider.dart';
import '../../../providers/order_provider.dart';
import '../../../models/credit_txn.dart';
import 'payment_methods_screen.dart';

class KasutCreditScreen extends StatefulWidget {
  static const String routeName = '/kasut-credit';
  const KasutCreditScreen({super.key});

  @override
  State<KasutCreditScreen> createState() => _KasutCreditScreenState();
}

class _KasutCreditScreenState extends State<KasutCreditScreen> {
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
                  Consumer<KasutCreditProvider>(
                      builder: (_, credit, __) => _buildTxnList(credit.transactions)),
                  Consumer<KasutCreditProvider>(
                      builder: (_, credit, __) => _buildTxnList(credit.creditIn)),
                  Consumer<KasutCreditProvider>(
                      builder: (_, credit, __) => _buildTxnList(credit.creditOut)),
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
          Consumer<KasutCreditProvider>(
            builder: (_, credit, __) => Text(_fmt.format(credit.balance),
                style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.black, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 14)),
                  onPressed: _showTopUpSheet,
                  icon: const Icon(Iconsax.add_square),
                  label: const Text('Top Up'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(foregroundColor: Colors.black, side: const BorderSide(color: Colors.black), padding: const EdgeInsets.symmetric(vertical: 14)),
                  onPressed: _showCashOutDialog,
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

  void _showTopUpSheet() {
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
    final creditProvider = Provider.of<KasutCreditProvider>(context, listen: false);

    final amountController = TextEditingController();
    PaymentMethodDetails? selectedMethod = orderProvider.defaultPaymentMethod;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
            top: 24,
            left: 24,
            right: 24,
          ),
          child: StatefulBuilder(builder: (context, setState) {
            final pmList = orderProvider.paymentMethods;

            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Top Up', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                if (pmList.isEmpty) ...[
                  const Text('No payment methods found. Please add one first.'),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const PaymentMethodsScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.black, foregroundColor: Colors.white),
                    child: const Text('Add Payment Method'),
                  ),
                ] else ...[
                  DropdownButtonFormField<PaymentMethodDetails>(
                    value: selectedMethod,
                    items: pmList
                        .map((pm) => DropdownMenuItem(
                              value: pm,
                              child: Text(pm.nickname),
                            ))
                        .toList(),
                    onChanged: (val) => setState(() => selectedMethod = val),
                    decoration: const InputDecoration(
                      labelText: 'Payment Method',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: amountController,
                    decoration: const InputDecoration(
                      labelText: 'Amount (Rp)',
                      hintText: 'e.g., 100000',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        final raw = amountController.text.replaceAll(RegExp(r'[^0-9]'), '');
                        final amt = double.tryParse(raw);
                        if (amt == null || amt <= 0) {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Enter valid amount')));
                          return;
                        }
                        if (selectedMethod == null) {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Choose payment method')));
                          return;
                        }
                        creditProvider.topUp(amount: amt, description: 'Top-Up via ${selectedMethod!.nickname}');
                        Navigator.pop(ctx);
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.black, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 14)),
                      child: const Text('Confirm Top Up'),
                    ),
                  ),
                ],
                const SizedBox(height: 12),
              ],
            );
          }),
        );
      },
    );
  }

  void _showCashOutDialog() {
    final creditProvider = Provider.of<KasutCreditProvider>(context, listen: false);
    final amountController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Cash Out'),
        content: TextField(
          controller: amountController,
          decoration: const InputDecoration(
            labelText: 'Amount (Rp)',
            hintText: 'e.g., 50000',
          ),
          keyboardType: TextInputType.number,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              final raw = amountController.text.replaceAll(RegExp(r'[^0-9]'), '');
              final amt = double.tryParse(raw);
              if (amt == null || amt <= 0) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Enter valid amount')));
                return;
              }
              try {
                creditProvider.cashOut(amount: amt, description: 'Cash-Out');
                Navigator.pop(ctx);
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Insufficient balance')));
              }
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }
}
