import 'package:flutter/material.dart';
import 'package:kasut/features/seller/seller_service.dart';
import 'package:kasut/features/seller/add_listing_screen.dart';
import 'package:kasut/models/seller_listing_model.dart';
import 'package:kasut/services/seller_listing_service.dart';
import 'package:kasut/features/auth/services/auth_service.dart';
import 'package:kasut/utils/indonesian_utils.dart';
import 'package:kasut/utils/responsive_utils.dart';
import 'package:provider/provider.dart';
import 'package:kasut/providers/seller_provider.dart';
import 'package:kasut/features/profile/screens/selling_screen.dart';

class SellerLogic extends StatefulWidget {
  const SellerLogic({super.key});

  @override
  State<SellerLogic> createState() => _SellerLogicState();
}

class _SellerLogicState extends State<SellerLogic> {
  @override
  void initState() {
    super.initState();
    _loadSellerData();
  }

  void _loadSellerData() async {
    final currentUser = AuthService.currentUser;
    if (currentUser != null) {
      final sellerProfile = SellerService.currentSeller;
      final myListings = SellerListingService.getListingsBySeller(
        currentUser['email'],
      );

      if (mounted) {
        // Defer provider updates to the end of the current frame to avoid
        // "setState() or markNeedsBuild() called during build" assertions.
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          final sellerProvider = Provider.of<SellerProvider>(
            context,
            listen: false,
          );
          if (sellerProfile != null) {
            sellerProvider.setProfile(sellerProfile);
          }
          sellerProvider.replaceListings(myListings);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SellerProvider>(
      builder: (context, sellerProvider, child) {
        final sellerData = sellerProvider.profile;
        final myListings = sellerProvider.listings;

        if (sellerData == null) {
          return const Scaffold(
            body: Center(child: Text('No seller data found')),
          );
        }

        return ResponsiveBuilder(
          builder: (context, deviceType, width) {
            final padding = ResponsiveUtils.getResponsivePadding(width);

            return Scaffold(
              appBar: AppBar(
                title: const Text(
                  'Seller Dashboard',
                  style: TextStyle(color: Colors.black),
                ),
                iconTheme: const IconThemeData(color: Colors.black),
                backgroundColor: Colors.white,
                elevation: 0,
                shape: const Border(
                  bottom: BorderSide(color: Colors.black, width: 1),
                ),
              ),
              body: RefreshIndicator(
                onRefresh: () async {
                  _loadSellerData();
                },
                child: SingleChildScrollView(
                  padding: padding,
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Welcome Section
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.black, width: 1),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Selamat datang, ${sellerData['fullName']}!',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Akun seller Anda sudah aktif. Mulai jual sepatu Anda sekarang.',
                              style: TextStyle(color: Colors.black87),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Quick Stats
                      Row(
                        children: [
                          Expanded(
                            child: _buildStatCard(
                              'Produk Aktif',
                              '${myListings.length}',
                              Icons.inventory,
                              Colors.black,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildStatCard(
                              'Total Penjualan',
                              'Rp ${IndonesianText.formatPriceWithoutSymbol(sellerProvider.totalSales)}',
                              Icons.monetization_on,
                              Colors.black,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Action Buttons
                      const Text(
                        'Aksi Cepat',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildActionButton(
                        context,
                        IndonesianText.jualSepatu,
                        'Tambahkan sepatu baru untuk dijual',
                        Icons.add_box,
                        Colors.black,
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AddListingScreen(),
                            ),
                          ).then((_) => _loadSellerData());
                        },
                      ),
                      const SizedBox(height: 12),
                      _buildActionButton(
                        context,
                        'Produk Saya',
                        'Lihat dan kelola produk yang sedang dijual',
                        Icons.list_alt,
                        Colors.black,
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SellingScreen(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 12),
                      _buildActionButton(
                        context,
                        'Riwayat Penjualan',
                        'Lihat penjualan yang sudah selesai',
                        Icons.history,
                        Colors.black,
                        () {
                          print('Navigate to sales history');
                        },
                      ),
                      const SizedBox(height: 24),

                      // Recent Listings
                      if (myListings.isNotEmpty) ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Produk Terbaru',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const SellingScreen(),
                                  ),
                                );
                              },
                              child: const Text('Lihat Semua'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 200,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: myListings.take(5).length,
                            itemBuilder: (context, index) {
                              final listing = myListings[index];
                              return Container(
                                width: width * 0.7,
                                margin: const EdgeInsets.only(right: 12),
                                child: _buildListingCard(listing),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],

                      // Information Section
                      const Text(
                        'Informasi Akun',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildInfoCard(sellerData),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: Colors.black, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.black, size: 24),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: Colors.black, width: 1),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.white,
          child: Icon(icon, color: Colors.black),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }

  Widget _buildInfoRow(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(child: Text(value?.toString() ?? '-')),
        ],
      ),
    );
  }

  Widget _buildListingCard(SellerListing listing) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: Colors.black, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                listing.originalProduct.firstPict,
                height: 80,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder:
                    (context, error, stackTrace) => Container(
                      height: 80,
                      color: Colors.grey[300],
                      child: const Icon(Icons.image_not_supported),
                    ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              listing.originalProduct.name,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              '${listing.conditionText} • Size ${listing.selectedSize}',
              style: TextStyle(fontSize: 10, color: Colors.grey[600]),
            ),
            const SizedBox(height: 4),
            Text(
              listing.shortPrice,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showMyListings(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SellingScreen()),
    );
  }

  Widget _buildInfoCard(Map<String, dynamic> sellerData) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: Colors.black, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Seller Information',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                IconButton(
                  onPressed: () => _showEditSellerInfoDialog(sellerData),
                  icon: const Icon(Icons.edit_outlined),
                  style: IconButton.styleFrom(
                    foregroundColor: Colors.blue[600],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildInfoRow('Nama Lengkap', sellerData['fullName']),
            _buildInfoRow('Telepon', '+62 ${sellerData['phone'] ?? '-'}'),
            _buildInfoRow('Bank', sellerData['bank'] ?? '-'),
            _buildInfoRow('No. Rekening', sellerData['accountNumber'] ?? '-'),
          ],
        ),
      ),
    );
  }

  void _showEditSellerInfoDialog(Map<String, dynamic> sellerData) {
    final nameController = TextEditingController(
      text: sellerData['fullName'] ?? '',
    );
    final phoneController = TextEditingController(
      text: sellerData['phone'] ?? '',
    );
    final accountController = TextEditingController(
      text: sellerData['accountNumber'] ?? '',
    );
    String? selectedBank = sellerData['bank'];

    final banks = [
      'Bank BCA',
      'Bank BNI',
      'Bank BRI',
      'Bank Mandiri',
      'Bank CIMB Niaga',
    ];

    showDialog(
      context: context,
      builder:
          (context) => StatefulBuilder(
            builder:
                (context, setState) => AlertDialog(
                  title: const Text('Edit Seller Information'),
                  content: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: nameController,
                          decoration: const InputDecoration(
                            labelText: 'Full Name',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: phoneController,
                          decoration: const InputDecoration(
                            labelText: 'Phone Number',
                            border: OutlineInputBorder(),
                            prefixText: '+62 ',
                          ),
                          keyboardType: TextInputType.phone,
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          value: selectedBank,
                          decoration: const InputDecoration(
                            labelText: 'Bank',
                            border: OutlineInputBorder(),
                          ),
                          items:
                              banks
                                  .map(
                                    (bank) => DropdownMenuItem(
                                      value: bank,
                                      child: Text(bank),
                                    ),
                                  )
                                  .toList(),
                          onChanged:
                              (value) => setState(() => selectedBank = value),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: accountController,
                          decoration: const InputDecoration(
                            labelText: 'Account Number',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Update seller data
                        final updatedData = {
                          ...sellerData,
                          'fullName': nameController.text.trim(),
                          'phone': phoneController.text.trim(),
                          'bank': selectedBank,
                          'accountNumber': accountController.text.trim(),
                        };

                        SellerService.saveSeller(updatedData);
                        final sellerProvider = Provider.of<SellerProvider>(
                          context,
                          listen: false,
                        );
                        sellerProvider.setProfile(updatedData);

                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Seller information updated successfully',
                            ),
                            backgroundColor: Colors.green,
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Update'),
                    ),
                  ],
                ),
          ),
    );
  }
}
