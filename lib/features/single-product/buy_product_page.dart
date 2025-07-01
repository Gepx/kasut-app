import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../models/shoe_model.dart';
import '../../widgets/image_loader.dart';
import '../../providers/order_provider.dart';
import '../profile/screens/addresses_screen.dart';
import '../profile/screens/payment_methods_screen.dart';

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
  double get shippingCost => widget.shoe.tags.contains('Free Delivery') ? 0 : 50000;
  double get totalPrice => itemPrice + shippingCost;

  void _nextStep() {
    if (_currentStep < 2) {
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
    if (_selectedAddress == null || _selectedPaymentMethodDetails == null) return;

    setState(() => _isProcessing = true);

    // Simulate processing delay
    await Future.delayed(const Duration(seconds: 2));

    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
    
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

    orderProvider.addOrder(order);

    setState(() => _isProcessing = false);

    if (mounted) {
      _showOrderSuccessDialog();
    }
  }

  void _showOrderSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
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
          onPressed: _currentStep > 0 ? _previousStep : () => Navigator.pop(context),
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
              
              ...orderProvider.addresses.map((address) => _buildAddressCard(address)),
              
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
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
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
              MaterialPageRoute(
                builder: (context) => const AddressesScreen(),
              ),
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
                      const Icon(
                        Icons.payment,
                        size: 48,
                        color: Colors.grey,
                      ),
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
                              builder: (context) => const PaymentMethodsScreen(),
                            ),
                          );
                        },
                        child: const Text('Add Payment Method'),
                      ),
                    ],
                  ),
                ),
              ] else ...[
                ...orderProvider.paymentMethods.map((paymentMethod) {
                  return _buildPaymentMethodCard(paymentMethod);
                }).toList(),
                
                // Add Cash on Delivery option
                _buildPaymentMethodCard(
                  PaymentMethodDetails(
                    id: 'cod',
                    type: PaymentMethod.cod,
                    nickname: 'Cash on Delivery',
                  ),
                ),
              ],
            ],
          ),
        );
      },
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
          onTap: () => setState(() => _selectedPaymentMethodDetails = paymentMethod),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Radio<String>(
                  value: paymentMethod.id,
                  groupValue: _selectedPaymentMethodDetails?.id,
                  onChanged: (_) => setState(() => _selectedPaymentMethodDetails = paymentMethod),
                  activeColor: Colors.black,
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(_getPaymentMethodIcon(paymentMethod.type), size: 24),
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
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
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
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
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
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
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
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
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
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPriceRow(String label, double amount, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            color: isTotal ? Colors.black : Colors.grey[700],
          ),
        ),
        Text(
          amount == 0 ? 'Free' : currencyFormat.format(amount),
          style: TextStyle(
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
            color: isTotal ? Colors.black : (amount == 0 ? Colors.green : Colors.black),
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
              child: _isProcessing
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
}
