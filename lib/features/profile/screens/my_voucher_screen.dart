import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../providers/voucher_provider.dart';

class MyVoucherScreen extends StatefulWidget {
  static const String routeName = '/my-voucher';
  const MyVoucherScreen({super.key});

  @override
  State<MyVoucherScreen> createState() => _MyVoucherScreenState();
}

class _MyVoucherScreenState extends State<MyVoucherScreen> {
  final _dateFmt = DateFormat('dd MMM yyyy');

  void _showVoucherInfo(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Iconsax.ticket_discount,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Voucher Information',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                ),
              ],
            ),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildInfoSection('How to Use Vouchers', [
                    'Tap "Use" button on any active voucher',
                    'Vouchers are automatically applied to your next purchase',
                    'Only one voucher can be used per order',
                    'Vouchers cannot be combined with other offers',
                  ], Iconsax.info_circle),
                  const SizedBox(height: 16),
                  _buildInfoSection('Getting More Vouchers', [
                    'Complete your first purchase (WELCOME50)',
                    'Follow our social media for flash sales',
                    'Refer friends to earn discount vouchers',
                    'Join our loyalty program for exclusive offers',
                  ], Iconsax.gift),
                  const SizedBox(height: 16),
                  _buildInfoSection('Important Notes', [
                    'Vouchers expire on the date shown',
                    'Used vouchers cannot be reactivated',
                    'Swipe left on active vouchers to remove them',
                    'Minimum purchase amount may apply',
                  ], Iconsax.warning_2),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[200]!),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Iconsax.message_question,
                          color: Colors.grey[600],
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Need more help? Contact our customer support team.',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                style: TextButton.styleFrom(foregroundColor: Colors.grey[600]),
                child: const Text('Close'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  // Navigate to support or contact page
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text(
                        'Contact support feature coming soon!',
                      ),
                      backgroundColor: Colors.black,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Contact Support'),
              ),
            ],
          ),
    );
  }

  Widget _buildInfoSection(String title, List<String> points, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 18, color: Colors.black),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ...points
            .map(
              (point) => Padding(
                padding: const EdgeInsets.only(left: 26, bottom: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 6),
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[400],
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        point,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('My Vouchers'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
          foregroundColor: Colors.black,
          backgroundColor: Colors.white,
          elevation: 0,
          actions: [
            IconButton(
              icon: const Icon(Iconsax.message_question),
              onPressed: () => _showVoucherInfo(context),
            ),
          ],
          bottom: const TabBar(
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.black,
            tabs: [Tab(text: 'Active'), Tab(text: 'Expired')],
          ),
        ),
        body: Consumer<VoucherProvider>(
          builder: (context, voucherProvider, child) {
            return TabBarView(
              children: [
                _buildTab(voucherProvider.activeVouchers, isActive: true),
                _buildTab(voucherProvider.expiredVouchers, isActive: false),
              ],
            );
          },
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
            Text(
              'No ${isActive ? 'active' : 'expired'} vouchers',
              style: const TextStyle(color: Colors.grey),
            ),
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
                final voucherProvider = Provider.of<VoucherProvider>(
                  context,
                  listen: false,
                );
                voucherProvider.removeVoucher(v.id);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Voucher removed'),
                    backgroundColor: Colors.black,
                  ),
                );
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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Colors.black),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Iconsax.ticket_discount, size: 28, color: Colors.black),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    v.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    v.amount != null
                        ? 'IDR ${v.amount!.toInt() ~/ 1000}K'
                        : '${v.percent}% OFF',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              v.desc,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Expires ${_dateFmt.format(v.expiry)}',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                if (isActive)
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 10,
                      ),
                    ),
                    onPressed: () {
                      final voucherProvider = Provider.of<VoucherProvider>(
                        context,
                        listen: false,
                      );
                      voucherProvider.useVoucher(v.id);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Voucher applied'),
                          backgroundColor: Colors.black,
                        ),
                      );
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
