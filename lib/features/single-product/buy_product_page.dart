import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../models/shoe_model.dart';
import '../../widgets/image_loader.dart';
import '../../providers/order_provider.dart';
import '../profile/screens/addresses_screen.dart';
import '../profile/screens/payment_methods_screen.dart';
import '../../providers/credit_provider.dart';
import '../../providers/voucher_provider.dart';

class BuyProductPage extends StatefulWidget {
  final Shoe shoe;
  final double selectedSize;

  const BuyProductPage({
    super.key,
    required this.shoe,
    required this.selectedSize,
  });

  @override
  State<BuyProductPage> createState() => _BuyProductPageState();
}

class _BuyProductPageState extends State<BuyProductPage> {
  final PageController _pageController = PageController();
  int _currentStep = 0;

  DeliveryAddress? _selectedAddress;
  PaymentMethodDetails? _selectedPaymentMethodDetails;
  bool _isProcessing = false;
  bool _useKasutPoints = false;
  int _pointsToUse = 0;
  String? _selectedVoucherId;

  final currencyFormat = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'IDR ',
    decimalDigits: 0,
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final orderProvider = Provider.of<OrderProvider>(context, listen: false);
      _selectedAddress = orderProvider.defaultAddress;
      _selectedPaymentMethodDetails = orderProvider.defaultPaymentMethod;
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  double get itemPrice => widget.shoe.discountPrice ?? widget.shoe.price;
  double get shippingCost =>
      widget.shoe.tags.contains('Free Delivery') ? 0 : 50000;
  double get subtotalPrice => itemPrice + shippingCost;
  double get pointsDiscount => _useKasutPoints ? _pointsToUse.toDouble() : 0.0;
  double get voucherDiscount {
    if (_selectedVoucherId != null) {
      final voucherProvider = Provider.of<VoucherProvider>(
        context,
        listen: false,
      );
      final voucher = voucherProvider.getVoucherById(_selectedVoucherId!);
      return voucher?.calculateDiscount(subtotalPrice - pointsDiscount) ?? 0.0;
    }
    return 0.0;
  }

  double get totalPrice => (subtotalPrice - pointsDiscount - voucherDiscount)
      .clamp(0.0, double.infinity);

  void _nextStep() {
    if (_currentStep < 2) {
      // Validate address and payment method requirements before proceeding
      final orderProvider = Provider.of<OrderProvider>(context, listen: false);

      if (_currentStep == 0) {
        // Check if user has any addresses
        if (orderProvider.addresses.isEmpty) {
          _showAddAddressDialog();
          return;
        }
      } else if (_currentStep == 1) {
        // Check if user has any payment methods
        if (orderProvider.paymentMethods.isEmpty) {
          _showAddPaymentMethodDialog();
          return;
        }
      }

      setState(() => _currentStep++);
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _placeOrder() async {
    if (_selectedAddress == null || _selectedPaymentMethodDetails == null)
      return;

    setState(() => _isProcessing = true);

    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
    final creditProvider = Provider.of<KasutCreditProvider>(
      context,
      listen: false,
    );
    final pointsProvider = Provider.of<KasutPointsProvider>(
      context,
      listen: false,
    );

    // Check if using Kasut Credit and validate balance
    if (_selectedPaymentMethodDetails!.id == 'kasut_credit') {
      if (creditProvider.balance < totalPrice) {
        setState(() => _isProcessing = false);
        _showInsufficientCreditDialog();
        return;
      }
    }

    // Simulate processing delay
    await Future.delayed(const Duration(seconds: 2));

    final order = Order(
      id: orderProvider.generateOrderId(),
      shoe: widget.shoe,
      size: widget.selectedSize,
      itemPrice: itemPrice,
      shippingCost: shippingCost,
      totalPrice: totalPrice,
      paymentMethod: _selectedPaymentMethodDetails!,
      deliveryAddress: _selectedAddress!,
      orderDate: DateTime.now(),
      status: OrderStatus.active,
    );

    try {
      // Use points if selected
      if (_useKasutPoints && _pointsToUse > 0) {
        pointsProvider.subtractPoints(
          _pointsToUse,
          description: 'Used for purchase: ${widget.shoe.name}',
        );
      }

      // Use voucher if selected
      if (_selectedVoucherId != null) {
        final voucherProvider = Provider.of<VoucherProvider>(
          context,
          listen: false,
        );
        voucherProvider.useVoucher(_selectedVoucherId!);
      }

      // Calculate payment amount after all discounts
      final paymentAmount = totalPrice;

      // If using Kasut Credit, deduct from balance
      if (_selectedPaymentMethodDetails!.id == 'kasut_credit') {
        if (paymentAmount > 0) {
          creditProvider.cashOut(
            amount: paymentAmount,
            description: 'Purchase: ${widget.shoe.name}',
          );
        }
      }

      // Award points (price divided by 100) regardless of payment method
      // Base points on original subtotal, not discounted price
      final pointsEarned = (subtotalPrice / 100).round();
      pointsProvider.addPoints(
        pointsEarned,
        description: 'Purchase: ${widget.shoe.name}',
      );

      orderProvider.addOrder(order);

      setState(() => _isProcessing = false);

      if (mounted) {
        _showOrderSuccessDialog();
      }
    } catch (e) {
      setState(() => _isProcessing = false);
      if (_selectedPaymentMethodDetails!.id == 'kasut_credit') {
        _showInsufficientCreditDialog();
      } else {
        // Show generic error for other payment methods
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Payment failed. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showOrderSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check_circle,
                    color: Colors.green[600],
                    size: 48,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Order Placed!',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Your order has been successfully placed. Thank you for shopping with Kasut!',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
            actions: [
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close dialog
                    Navigator.of(context).pop(); // Close buy page
                    Navigator.of(context).pop(); // Close product page
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('OK'),
                ),
              ),
            ],
          ),
    );
  }

  void _showInsufficientCreditDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.warning_amber_outlined,
                    color: Colors.red[600],
                    size: 48,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Insufficient Balance!',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'You do not have enough Kasut credit to complete this purchase. Please try other payment methods or add more credit to your account.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
            actions: [
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close dialog
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('OK'),
                ),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: const Text(
          'Checkout',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_outlined,
            color: Colors.black,
          ),
          onPressed:
              _currentStep > 0 ? _previousStep : () => Navigator.pop(context),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(80),
          child: _buildStepIndicator(),
        ),
      ),
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          _buildDeliveryStep(),
          _buildPaymentStep(),
          _buildConfirmationStep(),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildStepIndicator() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          _buildStepIcon(0, 'Delivery', Icons.location_on),
          _buildStepConnector(0),
          _buildStepIcon(1, 'Payment', Icons.payment),
          _buildStepConnector(1),
          _buildStepIcon(2, 'Confirm', Icons.check_circle),
        ],
      ),
    );
  }

  Widget _buildStepIcon(int stepIndex, String label, IconData icon) {
    final isActive = _currentStep >= stepIndex;
    return Expanded(
      child: Column(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: isActive ? Colors.black : Colors.grey[300],
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: isActive ? Colors.white : Colors.grey[600],
              size: 16,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isActive ? Colors.black : Colors.grey[500],
              fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepConnector(int stepIndex) {
    final isActive = _currentStep > stepIndex;
    return Expanded(
      child: Container(
        height: 2,
        margin: const EdgeInsets.only(bottom: 24),
        color: isActive ? Colors.black : Colors.grey[300],
      ),
    );
  }

  Widget _buildDeliveryStep() {
    return Consumer<OrderProvider>(
      builder: (context, orderProvider, child) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Delivery Address',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              ...orderProvider.addresses.map(
                (address) => _buildAddressCard(address),
              ),

              const SizedBox(height: 16),
              _buildAddNewAddressButton(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAddressCard(DeliveryAddress address) {
    final isSelected = _selectedAddress?.id == address.id;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        border: Border.all(
          color: isSelected ? Colors.black : Colors.grey[300]!,
          width: isSelected ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => setState(() => _selectedAddress = address),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Radio<String>(
                  value: address.id,
                  groupValue: _selectedAddress?.id,
                  onChanged: (_) => setState(() => _selectedAddress = address),
                  activeColor: Colors.black,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            address.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                          if (address.isDefault) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.blue[100],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                'Default',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.blue[700],
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        address.phone,
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${address.address}\n${address.city}, ${address.postalCode}',
                        style: TextStyle(color: Colors.grey[700], fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAddNewAddressButton() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!, style: BorderStyle.solid),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddressesScreen()),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add, color: Colors.grey[600]),
                const SizedBox(width: 8),
                Text(
                  'Add New Address',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentStep() {
    return Consumer<OrderProvider>(
      builder: (context, orderProvider, child) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Payment Method',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PaymentMethodsScreen(),
                        ),
                      );
                    },
                    child: const Text('Manage'),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              if (orderProvider.paymentMethods.isEmpty) ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: Column(
                    children: [
                      const Icon(Icons.payment, size: 48, color: Colors.grey),
                      const SizedBox(height: 12),
                      const Text(
                        'No payment methods found',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Add a payment method to continue',
                        style: TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => const PaymentMethodsScreen(),
                            ),
                          );
                        },
                        child: const Text('Add Payment Method'),
                      ),
                    ],
                  ),
                ),
              ] else ...[
                // Add Kasut Credit option first
                Consumer<KasutCreditProvider>(
                  builder: (context, creditProvider, child) {
                    return _buildKasutCreditCard(creditProvider.balance);
                  },
                ),

                ...orderProvider.paymentMethods.map((paymentMethod) {
                  return _buildPaymentMethodCard(paymentMethod);
                }),

                // Add Cash on Delivery option
                _buildPaymentMethodCard(
                  PaymentMethodDetails(
                    id: 'cod',
                    type: PaymentMethod.cod,
                    nickname: 'Cash on Delivery',
                  ),
                ),
              ],

              const SizedBox(height: 20),

              // Kasut Points Usage Section
              Consumer<KasutPointsProvider>(
                builder: (context, pointsProvider, child) {
                  if (pointsProvider.points > 0) {
                    return _buildKasutPointsSection(pointsProvider);
                  }
                  return const SizedBox.shrink();
                },
              ),

              const SizedBox(height: 20),

              // Voucher Selection Section
              Consumer<VoucherProvider>(
                builder: (context, voucherProvider, child) {
                  if (voucherProvider.activeVouchers.isNotEmpty) {
                    return _buildVoucherSection(voucherProvider);
                  }
                  return const SizedBox.shrink();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildKasutPointsSection(KasutPointsProvider pointsProvider) {
    final maxPointsUsable =
        pointsProvider.points < subtotalPrice.toInt()
            ? pointsProvider.points
            : subtotalPrice.toInt();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.star, color: Colors.blue[600], size: 20),
              const SizedBox(width: 8),
              const Text(
                'Use Kasut Points',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Checkbox(
                value: _useKasutPoints,
                onChanged: (value) {
                  setState(() {
                    _useKasutPoints = value ?? false;
                    if (_useKasutPoints) {
                      _pointsToUse = maxPointsUsable;
                    } else {
                      _pointsToUse = 0;
                    }
                  });
                },
                activeColor: Colors.blue[600],
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Use ${maxPointsUsable} points (${currencyFormat.format(maxPointsUsable)} discount)',
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    Text(
                      'Available: ${pointsProvider.points} points',
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVoucherSection(VoucherProvider voucherProvider) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.purple[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.purple[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.local_offer, color: Colors.purple[600], size: 20),
              const SizedBox(width: 8),
              const Text(
                'Select Voucher',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (_selectedVoucherId != null) ...[
            _buildSelectedVoucherCard(voucherProvider),
            const SizedBox(height: 12),
          ],
          ElevatedButton(
            onPressed: () => _showVoucherSelection(context, voucherProvider),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple[600],
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 45),
            ),
            child: Text(
              _selectedVoucherId != null ? 'Change Voucher' : 'Select Voucher',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedVoucherCard(VoucherProvider voucherProvider) {
    final voucher = voucherProvider.getVoucherById(_selectedVoucherId!);
    if (voucher == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.purple[300]!),
      ),
      child: Row(
        children: [
          Icon(Icons.local_offer, color: Colors.purple[600], size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  voucher.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                Text(
                  voucher.desc,
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.purple[600],
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              voucher.displayValue,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () => setState(() => _selectedVoucherId = null),
            child: Icon(Icons.close, color: Colors.grey[600], size: 16),
          ),
        ],
      ),
    );
  }

  void _showVoucherSelection(
    BuildContext context,
    VoucherProvider voucherProvider,
  ) {
    showModalBottomSheet(
      context: context,
      builder:
          (context) => Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Select Voucher',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                ...voucherProvider.activeVouchers.map((voucher) {
                  final isSelected = _selectedVoucherId == voucher.id;
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.purple[50] : Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color:
                            isSelected
                                ? Colors.purple[600]!
                                : Colors.grey[300]!,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: ListTile(
                      leading: Icon(
                        Icons.local_offer,
                        color: Colors.purple[600],
                      ),
                      title: Text(
                        voucher.title,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text(voucher.desc),
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.purple[600],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          voucher.displayValue,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      onTap: () {
                        setState(() => _selectedVoucherId = voucher.id);
                        Navigator.pop(context);
                      },
                    ),
                  );
                }).toList(),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                ),
              ],
            ),
          ),
    );
  }

  Widget _buildPaymentMethodCard(PaymentMethodDetails paymentMethod) {
    final isSelected = _selectedPaymentMethodDetails?.id == paymentMethod.id;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        border: Border.all(
          color: isSelected ? Colors.black : Colors.grey[300]!,
          width: isSelected ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap:
              () =>
                  setState(() => _selectedPaymentMethodDetails = paymentMethod),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Radio<String>(
                  value: paymentMethod.id,
                  groupValue: _selectedPaymentMethodDetails?.id,
                  onChanged:
                      (_) => setState(
                        () => _selectedPaymentMethodDetails = paymentMethod,
                      ),
                  activeColor: Colors.black,
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    _getPaymentMethodIcon(paymentMethod.type),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            paymentMethod.nickname,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                          if (paymentMethod.isDefault) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Text(
                                'Default',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _getPaymentMethodDisplay(paymentMethod),
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _getPaymentMethodIcon(PaymentMethod type) {
    switch (type) {
      case PaymentMethod.creditCard:
        return Icons.credit_card;
      case PaymentMethod.eWallet:
        return Icons.account_balance_wallet;
      case PaymentMethod.bankTransfer:
        return Icons.account_balance;
      case PaymentMethod.cod:
        return Icons.money;
    }
  }

  String _getPaymentMethodDisplay(PaymentMethodDetails paymentMethod) {
    switch (paymentMethod.type) {
      case PaymentMethod.creditCard:
        return '${paymentMethod.cardType?.name.toUpperCase() ?? 'Card'} ${paymentMethod.maskedCardNumber ?? ''}';
      case PaymentMethod.eWallet:
        return '${paymentMethod.eWalletType?.name.toUpperCase() ?? 'E-Wallet'} - ${paymentMethod.phoneNumber ?? ''}';
      case PaymentMethod.bankTransfer:
        return '${paymentMethod.bankName ?? 'Bank Transfer'} - ${paymentMethod.accountNumber != null ? OrderProvider.maskCardNumber(paymentMethod.accountNumber!) : ''}';
      case PaymentMethod.cod:
        return 'Pay when item arrives';
    }
  }

  Widget _buildKasutCreditCard(double balance) {
    final isSelected = _selectedPaymentMethodDetails?.id == 'kasut_credit';
    final currencyFormat = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'IDR ',
      decimalDigits: 0,
    );
    final hasEnoughBalance = balance >= totalPrice;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        border: Border.all(
          color: isSelected ? Colors.black : Colors.grey[300]!,
          width: isSelected ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap:
              () => setState(
                () =>
                    _selectedPaymentMethodDetails = PaymentMethodDetails(
                      id: 'kasut_credit',
                      type: PaymentMethod.creditCard,
                      nickname: 'Kasut Credit',
                    ),
              ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Radio<String>(
                  value: 'kasut_credit',
                  groupValue: _selectedPaymentMethodDetails?.id,
                  onChanged:
                      (_) => setState(
                        () =>
                            _selectedPaymentMethodDetails =
                                PaymentMethodDetails(
                                  id: 'kasut_credit',
                                  type: PaymentMethod.creditCard,
                                  nickname: 'Kasut Credit',
                                ),
                      ),
                  activeColor: Colors.black,
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.account_balance_wallet,
                    size: 24,
                    color: Colors.orange[600],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Kasut Credit',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Balance: ${currencyFormat.format(balance)}',
                        style: TextStyle(
                          color:
                              hasEnoughBalance
                                  ? Colors.green[600]
                                  : Colors.red[600],
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (!hasEnoughBalance)
                        const Text(
                          'Insufficient balance for this purchase',
                          style: TextStyle(color: Colors.red, fontSize: 12),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildConfirmationStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Order Summary',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),

          // Product Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: AssetImageLoader(
                    imagePath: widget.shoe.firstPict,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.shoe.brand,
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.shoe.name,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 2,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Size: ${widget.selectedSize.toString().endsWith('.0') ? widget.selectedSize.toInt() : widget.selectedSize}',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Delivery Address
          _buildSummarySection(
            'Delivery Address',
            _selectedAddress != null
                ? '${_selectedAddress!.name}\n${_selectedAddress!.address}\n${_selectedAddress!.city}, ${_selectedAddress!.postalCode}'
                : 'No address selected',
          ),

          const SizedBox(height: 16),

          // Payment Method
          _buildSummarySection(
            'Payment Method',
            _selectedPaymentMethodDetails != null
                ? _selectedPaymentMethodDetails!.getDisplayText()
                : 'No payment method selected',
          ),

          const SizedBox(height: 20),

          // Price Breakdown
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                _buildPriceRow('Item Price', itemPrice),
                const SizedBox(height: 8),
                _buildPriceRow('Shipping', shippingCost),
                if (_useKasutPoints && _pointsToUse > 0) ...[
                  const SizedBox(height: 8),
                  _buildPriceRow(
                    'Points Discount',
                    -pointsDiscount,
                    isDiscount: true,
                  ),
                ],
                if (_selectedVoucherId != null && voucherDiscount > 0) ...[
                  const SizedBox(height: 8),
                  _buildPriceRow(
                    'Voucher Discount',
                    -voucherDiscount,
                    isDiscount: true,
                  ),
                ],
                const Divider(),
                _buildPriceRow('Total', totalPrice, isTotal: true),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummarySection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            content,
            style: TextStyle(color: Colors.grey[700], fontSize: 14),
          ),
        ),
      ],
    );
  }

  Widget _buildPriceRow(
    String label,
    double amount, {
    bool isTotal = false,
    bool isDiscount = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            color:
                isTotal
                    ? Colors.black
                    : (isDiscount ? Colors.green[600] : Colors.grey[700]),
          ),
        ),
        Text(
          amount == 0 ? 'Free' : currencyFormat.format(amount),
          style: TextStyle(
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
            color:
                isTotal
                    ? Colors.black
                    : (amount == 0
                        ? Colors.green
                        : (isDiscount ? Colors.green[600] : Colors.black)),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomBar() {
    String buttonText;
    VoidCallback? onPressed;

    switch (_currentStep) {
      case 0:
        buttonText = 'Continue to Payment';
        onPressed = _selectedAddress != null ? _nextStep : null;
        break;
      case 1:
        buttonText = 'Review Order';
        onPressed = _selectedPaymentMethodDetails != null ? _nextStep : null;
        break;
      case 2:
        buttonText = _isProcessing ? 'Processing...' : 'Place Order';
        onPressed = _isProcessing ? null : _placeOrder;
        break;
      default:
        buttonText = 'Continue';
        onPressed = null;
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_currentStep == 2) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total Payment',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                Text(
                  currencyFormat.format(totalPrice),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                disabledBackgroundColor: Colors.grey[300],
              ),
              child:
                  _isProcessing
                      ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                      : Text(
                        buttonText,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddAddressDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Text('No Delivery Address'),
            content: const Text(
              'Please add a delivery address before proceeding to payment.',
            ),
            actions: [
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close dialog
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AddressesScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Add Address'),
                ),
              ),
            ],
          ),
    );
  }

  void _showAddPaymentMethodDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Text('No Payment Method'),
            content: const Text(
              'Please add a payment method before proceeding to payment.',
            ),
            actions: [
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close dialog
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PaymentMethodsScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Add Payment Method'),
                ),
              ),
            ],
          ),
    );
  }
}
