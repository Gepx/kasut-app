import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/order_provider.dart';

class PaymentMethodsScreen extends StatefulWidget {
  const PaymentMethodsScreen({super.key});

  @override
  State<PaymentMethodsScreen> createState() => _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends State<PaymentMethodsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Methods'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Consumer<OrderProvider>(
        builder: (context, orderProvider, child) {
          if (orderProvider.paymentMethods.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.payment,
                    size: 64,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'No payment methods found',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Add your first payment method',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: orderProvider.paymentMethods.length,
            itemBuilder: (context, index) {
              final paymentMethod = orderProvider.paymentMethods[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: CircleAvatar(
                    backgroundColor: _getPaymentMethodColor(paymentMethod.type),
                    child: Icon(
                      _getPaymentMethodIcon(paymentMethod.type),
                      color: Colors.white,
                    ),
                  ),
                  title: Row(
                    children: [
                      Text(
                        paymentMethod.nickname,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
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
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text(
                        _getPaymentMethodSubtitle(paymentMethod),
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                  trailing: PopupMenuButton(
                    onSelected: (value) async {
                      switch (value) {
                        case 'edit':
                          await _showPaymentMethodForm(context, paymentMethod);
                          break;
                        case 'default':
                          if (!paymentMethod.isDefault) {
                            final updatedPaymentMethod = PaymentMethodDetails(
                              id: paymentMethod.id,
                              type: paymentMethod.type,
                              nickname: paymentMethod.nickname,
                              isDefault: true,
                              maskedCardNumber: paymentMethod.maskedCardNumber,
                              cardHolderName: paymentMethod.cardHolderName,
                              expiryDate: paymentMethod.expiryDate,
                              cardType: paymentMethod.cardType,
                              eWalletType: paymentMethod.eWalletType,
                              phoneNumber: paymentMethod.phoneNumber,
                              accountName: paymentMethod.accountName,
                              bankName: paymentMethod.bankName,
                              accountNumber: paymentMethod.accountNumber,
                              accountHolderName: paymentMethod.accountHolderName,
                            );
                            orderProvider.updatePaymentMethod(updatedPaymentMethod);
                          }
                          break;
                        case 'delete':
                          final confirmed = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Delete Payment Method'),
                              content: const Text(
                                'Are you sure you want to delete this payment method?',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context, false),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  child: const Text('Delete'),
                                ),
                              ],
                            ),
                          );
                          if (confirmed == true) {
                            orderProvider.deletePaymentMethod(paymentMethod.id);
                          }
                          break;
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'edit',
                        child: ListTile(
                          leading: Icon(Icons.edit),
                          title: Text('Edit'),
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                      if (!paymentMethod.isDefault)
                        const PopupMenuItem(
                          value: 'default',
                          child: ListTile(
                            leading: Icon(Icons.star),
                            title: Text('Set as Default'),
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: ListTile(
                          leading: Icon(Icons.delete, color: Colors.red),
                          title: Text('Delete', style: TextStyle(color: Colors.red)),
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: Consumer<OrderProvider>(
        builder: (context, orderProvider, child) {
          final canAdd = orderProvider.paymentMethods.length < 3;
          return FloatingActionButton(
            onPressed: canAdd 
                ? () => _showPaymentMethodForm(context, null)
                : null,
            backgroundColor: canAdd ? null : Colors.grey,
            child: const Icon(Icons.add),
          );
        },
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

  Color _getPaymentMethodColor(PaymentMethod type) {
    switch (type) {
      case PaymentMethod.creditCard:
        return Colors.blue;
      case PaymentMethod.eWallet:
        return Colors.green;
      case PaymentMethod.bankTransfer:
        return Colors.orange;
      case PaymentMethod.cod:
        return Colors.purple;
    }
  }

  String _getPaymentMethodSubtitle(PaymentMethodDetails paymentMethod) {
    switch (paymentMethod.type) {
      case PaymentMethod.creditCard:
        return '${paymentMethod.cardType?.name.toUpperCase() ?? 'Card'} ${paymentMethod.maskedCardNumber ?? ''}';
      case PaymentMethod.eWallet:
        return '${paymentMethod.eWalletType?.name.toUpperCase() ?? 'E-Wallet'} - ${paymentMethod.phoneNumber ?? ''}';
      case PaymentMethod.bankTransfer:
        return '${paymentMethod.bankName ?? 'Bank'} - ${paymentMethod.accountNumber != null ? OrderProvider.maskCardNumber(paymentMethod.accountNumber!) : ''}';
      case PaymentMethod.cod:
        return 'Cash on Delivery';
    }
  }

  Future<void> _showPaymentMethodForm(BuildContext context, PaymentMethodDetails? existingPaymentMethod) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => PaymentMethodFormSheet(existingPaymentMethod: existingPaymentMethod),
    );
  }
}

class PaymentMethodFormSheet extends StatefulWidget {
  final PaymentMethodDetails? existingPaymentMethod;

  const PaymentMethodFormSheet({super.key, this.existingPaymentMethod});

  @override
  State<PaymentMethodFormSheet> createState() => _PaymentMethodFormSheetState();
}

class _PaymentMethodFormSheetState extends State<PaymentMethodFormSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nicknameController = TextEditingController();
  final _cardNumberController = TextEditingController();
  final _cardHolderController = TextEditingController();
  final _expiryController = TextEditingController();
  final _phoneController = TextEditingController();
  final _accountNameController = TextEditingController();
  final _accountNumberController = TextEditingController();
  final _accountHolderController = TextEditingController();

  PaymentMethod _selectedType = PaymentMethod.creditCard;
  CardType? _selectedCardType;
  EWalletType? _selectedEWalletType;
  String? _selectedBank;
  bool _isDefault = false;

  final List<String> _bankNames = [
    'BCA',
    'Mandiri',
    'BNI',
    'BRI',
    'CIMB Niaga',
    'Danamon',
    'Permata',
    'Maybank',
    'OCBC NISP',
    'Panin',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.existingPaymentMethod != null) {
      final paymentMethod = widget.existingPaymentMethod!;
      _selectedType = paymentMethod.type;
      _nicknameController.text = paymentMethod.nickname;
      _isDefault = paymentMethod.isDefault;

      switch (paymentMethod.type) {
        case PaymentMethod.creditCard:
          _cardNumberController.text = paymentMethod.maskedCardNumber?.replaceAll('*', '').replaceAll(' ', '') ?? '';
          _cardHolderController.text = paymentMethod.cardHolderName ?? '';
          _expiryController.text = paymentMethod.expiryDate ?? '';
          _selectedCardType = paymentMethod.cardType;
          break;
        case PaymentMethod.eWallet:
          _phoneController.text = paymentMethod.phoneNumber ?? '';
          _accountNameController.text = paymentMethod.accountName ?? '';
          _selectedEWalletType = paymentMethod.eWalletType;
          break;
        case PaymentMethod.bankTransfer:
          _accountNumberController.text = paymentMethod.accountNumber ?? '';
          _accountHolderController.text = paymentMethod.accountHolderName ?? '';
          _selectedBank = paymentMethod.bankName;
          break;
        case PaymentMethod.cod:
          break;
      }
    }
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    _cardNumberController.dispose();
    _cardHolderController.dispose();
    _expiryController.dispose();
    _phoneController.dispose();
    _accountNameController.dispose();
    _accountNumberController.dispose();
    _accountHolderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.existingPaymentMethod != null ? 'Edit Payment Method' : 'Add Payment Method',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          ),
          const Divider(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Payment Type',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    ...PaymentMethod.values.where((type) => type != PaymentMethod.cod).map((type) {
                      return RadioListTile<PaymentMethod>(
                        title: Row(
                          children: [
                            Icon(_getPaymentMethodIcon(type)),
                            const SizedBox(width: 8),
                            Text(_getPaymentMethodName(type)),
                          ],
                        ),
                        value: type,
                        groupValue: _selectedType,
                        onChanged: (value) {
                          setState(() {
                            _selectedType = value!;
                          });
                        },
                      );
                    }).toList(),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _nicknameController,
                      decoration: const InputDecoration(
                        labelText: 'Nickname',
                        border: OutlineInputBorder(),
                        hintText: 'e.g., My BCA Card, Work GoPay',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a nickname';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    ..._buildPaymentMethodFields(),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Checkbox(
                          value: _isDefault,
                          onChanged: (value) {
                            setState(() {
                              _isDefault = value ?? false;
                            });
                          },
                        ),
                        const Text('Set as default payment method'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _savePaymentMethod,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  widget.existingPaymentMethod != null ? 'Update Payment Method' : 'Save Payment Method',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildPaymentMethodFields() {
    switch (_selectedType) {
      case PaymentMethod.creditCard:
        return [
          DropdownButtonFormField<CardType>(
            value: _selectedCardType,
            decoration: const InputDecoration(
              labelText: 'Card Type',
              border: OutlineInputBorder(),
            ),
            items: CardType.values
                .map((type) => DropdownMenuItem(
                      value: type,
                      child: Text(type.name.toUpperCase()),
                    ))
                .toList(),
            onChanged: (value) {
              setState(() {
                _selectedCardType = value;
              });
            },
            validator: (value) {
              if (value == null) {
                return 'Please select card type';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _cardNumberController,
            decoration: const InputDecoration(
              labelText: 'Card Number',
              border: OutlineInputBorder(),
              hintText: '1234 5678 9012 3456',
            ),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter card number';
              }
              if (value.replaceAll(' ', '').length < 13) {
                return 'Please enter a valid card number';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _cardHolderController,
            decoration: const InputDecoration(
              labelText: 'Card Holder Name',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter card holder name';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _expiryController,
            decoration: const InputDecoration(
              labelText: 'Expiry Date',
              border: OutlineInputBorder(),
              hintText: 'MM/YY',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter expiry date';
              }
              if (!RegExp(r'^\d{2}/\d{2}$').hasMatch(value)) {
                return 'Please enter valid expiry date (MM/YY)';
              }
              return null;
            },
          ),
        ];

      case PaymentMethod.eWallet:
        return [
          DropdownButtonFormField<EWalletType>(
            value: _selectedEWalletType,
            decoration: const InputDecoration(
              labelText: 'E-Wallet Provider',
              border: OutlineInputBorder(),
            ),
            items: EWalletType.values
                .map((type) => DropdownMenuItem(
                      value: type,
                      child: Text(_getEWalletTypeName(type)),
                    ))
                .toList(),
            onChanged: (value) {
              setState(() {
                _selectedEWalletType = value;
              });
            },
            validator: (value) {
              if (value == null) {
                return 'Please select e-wallet provider';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _phoneController,
            decoration: const InputDecoration(
              labelText: 'Phone Number',
              border: OutlineInputBorder(),
              prefixText: '+62 ',
            ),
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter phone number';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _accountNameController,
            decoration: const InputDecoration(
              labelText: 'Account Name',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter account name';
              }
              return null;
            },
          ),
        ];

      case PaymentMethod.bankTransfer:
        return [
          DropdownButtonFormField<String>(
            value: _selectedBank,
            decoration: const InputDecoration(
              labelText: 'Bank',
              border: OutlineInputBorder(),
            ),
            items: _bankNames
                .map((bank) => DropdownMenuItem(
                      value: bank,
                      child: Text(bank),
                    ))
                .toList(),
            onChanged: (value) {
              setState(() {
                _selectedBank = value;
              });
            },
            validator: (value) {
              if (value == null) {
                return 'Please select bank';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _accountNumberController,
            decoration: const InputDecoration(
              labelText: 'Account Number',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter account number';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _accountHolderController,
            decoration: const InputDecoration(
              labelText: 'Account Holder Name',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter account holder name';
              }
              return null;
            },
          ),
        ];

      case PaymentMethod.cod:
        return [];
    }
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

  String _getPaymentMethodName(PaymentMethod type) {
    switch (type) {
      case PaymentMethod.creditCard:
        return 'Credit/Debit Card';
      case PaymentMethod.eWallet:
        return 'E-Wallet';
      case PaymentMethod.bankTransfer:
        return 'Bank Transfer';
      case PaymentMethod.cod:
        return 'Cash on Delivery';
    }
  }

  String _getEWalletTypeName(EWalletType type) {
    switch (type) {
      case EWalletType.gopay:
        return 'GoPay';
      case EWalletType.ovo:
        return 'OVO';
      case EWalletType.dana:
        return 'DANA';
      case EWalletType.shopeepay:
        return 'ShopeePay';
    }
  }

  void _savePaymentMethod() {
    if (_formKey.currentState!.validate()) {
      final orderProvider = Provider.of<OrderProvider>(context, listen: false);
      
      try {
        PaymentMethodDetails paymentMethod;

        switch (_selectedType) {
          case PaymentMethod.creditCard:
            paymentMethod = PaymentMethodDetails(
              id: widget.existingPaymentMethod?.id ?? orderProvider.generateId(),
              type: _selectedType,
              nickname: _nicknameController.text,
              isDefault: _isDefault,
              maskedCardNumber: OrderProvider.maskCardNumber(_cardNumberController.text),
              cardHolderName: _cardHolderController.text,
              expiryDate: _expiryController.text,
              cardType: _selectedCardType,
            );
            break;

          case PaymentMethod.eWallet:
            paymentMethod = PaymentMethodDetails(
              id: widget.existingPaymentMethod?.id ?? orderProvider.generateId(),
              type: _selectedType,
              nickname: _nicknameController.text,
              isDefault: _isDefault,
              eWalletType: _selectedEWalletType,
              phoneNumber: _phoneController.text.startsWith('+62') 
                  ? _phoneController.text 
                  : '+62${_phoneController.text}',
              accountName: _accountNameController.text,
            );
            break;

          case PaymentMethod.bankTransfer:
            paymentMethod = PaymentMethodDetails(
              id: widget.existingPaymentMethod?.id ?? orderProvider.generateId(),
              type: _selectedType,
              nickname: _nicknameController.text,
              isDefault: _isDefault,
              bankName: _selectedBank,
              accountNumber: _accountNumberController.text,
              accountHolderName: _accountHolderController.text,
            );
            break;

          case PaymentMethod.cod:
            paymentMethod = PaymentMethodDetails(
              id: widget.existingPaymentMethod?.id ?? orderProvider.generateId(),
              type: _selectedType,
              nickname: _nicknameController.text,
              isDefault: _isDefault,
            );
            break;
        }

        if (widget.existingPaymentMethod != null) {
          orderProvider.updatePaymentMethod(paymentMethod);
        } else {
          orderProvider.addPaymentMethod(paymentMethod);
        }
        
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.existingPaymentMethod != null 
                  ? 'Payment method updated successfully' 
                  : 'Payment method added successfully',
            ),
            backgroundColor: Colors.green,
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
} 