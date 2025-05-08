import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:kasut/features/seller/sellerlogic.dart';
import 'package:kasut/features/auth/services/auth_service.dart';
import 'package:kasut/features/auth/screens/login_screen.dart';
import 'package:kasut/features/seller/seller_service.dart';
import 'package:kasut/main.dart';

class SellerPage extends StatefulWidget {
  const SellerPage({super.key});

  @override
  State<SellerPage> createState() => _SellerPageState();
}

class _SellerPageState extends State<SellerPage> {
  // Controllers to capture seller form inputs
  final TextEditingController _npwpController = TextEditingController();
  final TextEditingController _ktpController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _accountHolderController =
      TextEditingController();
  final TextEditingController _accountNumberController =
      TextEditingController();

  bool hasNpwp = true;
  final _formKey = GlobalKey<FormState>();
  String? selectedBank;
  String? selectedProvince;
  Uint8List? _webImage;
  bool _isLoggedIn = false;

  List<String> banks = ["Bank BCA", "Bank BNI", "Bank BRI"];
  List<String> provinces = [
    "Sumatera Utara",
    "Sumatera Barat",
    "Sumatera Timur",
  ];

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  @override
  void dispose() {
    // Dispose controllers
    _npwpController.dispose();
    _ktpController.dispose();
    _fullNameController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _accountHolderController.dispose();
    _accountNumberController.dispose();
    super.dispose();
  }

  void _checkLoginStatus() {
    // Check if user is logged in
    final currentUser = AuthService.currentUser;
    setState(() {
      _isLoggedIn = currentUser != null;
    });
  }

  Future<void> _pickImageFromWeb() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true,
    );

    if (result != null && result.files.single.bytes != null) {
      setState(() {
        _webImage = result.files.single.bytes!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // If not logged in, show login prompt
    if (!_isLoggedIn) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Sell With Us"),
          shape: Border(bottom: BorderSide(color: Colors.grey, width: 1)),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.account_circle, size: 80, color: Colors.grey),
              SizedBox(height: 20),
              Text(
                "Please login to continue",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                "You need to be logged in to sell your products",
                style: TextStyle(color: Colors.grey),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                ),
                child: Text("Login Now"),
              ),
            ],
          ),
        ),
      );
    }

    // If seller data already saved, go to seller logic directly
    if (SellerService.currentSeller != null) {
      return SellerLogic();
    }

    // Original seller form content if logged in
    return Scaffold(
      appBar: AppBar(
        title: Text("Sell With Us"),
        shape: Border(bottom: BorderSide(color: Colors.grey, width: 1)),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Do you have NPWP?",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  Expanded(
                    child: RadioListTile<bool>(
                      title: Text("I have NPWP"),
                      value: true,
                      groupValue: hasNpwp,
                      onChanged: (value) => setState(() => hasNpwp = value!),
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<bool>(
                      title: Text("I don't have NPWP"),
                      value: false,
                      groupValue: hasNpwp,
                      onChanged: (value) => setState(() => hasNpwp = value!),
                    ),
                  ),
                ],
              ),
              if (hasNpwp) ...[
                _buildLabel('NPWP Number *'),
                TextFormField(
                  controller: _npwpController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: '00.000.000.0-000.000',
                    errorStyle: TextStyle(color: Colors.red),
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'NPWP Number is required';
                    }
                    final pattern = RegExp(
                      r'^\d{2}\.\d{3}\.\d{3}\.\d-\d{3}\.\d{3}',
                    );
                    if (!pattern.hasMatch(value)) {
                      return 'Invalid NPWP format';
                    }
                    return null;
                  },
                ),
              ] else ...[
                _buildLabel('KTP Number *'),
                TextFormField(
                  controller: _ktpController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: '0000000000000000',
                    errorStyle: TextStyle(color: Colors.red),
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'KTP Number is required';
                    }
                    final pattern = RegExp(r'^\d{16}');
                    if (!pattern.hasMatch(value)) {
                      return 'Invalid KTP format';
                    }
                    return null;
                  },
                ),
              ],
              _buildLabel('Full Name *'),
              TextFormField(
                controller: _fullNameController,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Full Name',
                  errorStyle: TextStyle(color: Colors.red),
                ),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Full Name is required';
                  }
                  if (value.length < 3) {
                    return 'Full Name must be at least 3 characters';
                  }
                  if (!RegExp(r'^[a-zA-Z ]+$').hasMatch(value)) {
                    return 'Full Name can only contain letters and spaces';
                  }
                  return null;
                },
              ),
              _buildLabel('Address *'),
              TextFormField(
                controller: _addressController,
                keyboardType: TextInputType.streetAddress,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Address',
                  errorStyle: TextStyle(color: Colors.red),
                ),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Address is required';
                  }
                  if (value.length < 5) {
                    return 'Address must be at least 5 characters';
                  }
                  return null;
                },
              ),
              _buildLabel(hasNpwp ? 'NPWP Card *' : 'KTP Card *'),
              Container(
                height: 300,
                color: Colors.grey[300],
                child:
                    _webImage == null
                        ? Align(
                          alignment: Alignment.center,
                          child: ElevatedButton(
                            onPressed: _pickImageFromWeb,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.upload_file),
                                SizedBox(width: 8),
                                Text(
                                  "Browse Files",
                                  style: TextStyle(color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                        )
                        : Image.memory(_webImage!, fit: BoxFit.cover),
              ),
              _buildLabel('Mobile Number *'),
              Text(
                'Make sure to input active number connected with SMS or Whatsapp...',
                style: TextStyle(color: Colors.grey),
              ),
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                    ),
                    child: Row(
                      children: [
                        Image.asset(
                          '../assets/seller/indonesia_flag.png',
                          width: 24,
                        ),
                        SizedBox(width: 5),
                        Text('+62'),
                      ],
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Phone Number',
                        errorStyle: TextStyle(color: Colors.red),
                      ),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Phone Number is required';
                        }
                        if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                          return 'Invalid phone number';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              _buildLabel("Account Holder's Name *"),
              TextFormField(
                controller: _accountHolderController,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Account Holder's Name",
                  errorStyle: TextStyle(color: Colors.red),
                ),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Account Holder's Name is required";
                  }
                  if (value.length < 3) {
                    return "Name must be at least 3 characters";
                  }
                  if (!RegExp(r'^[a-zA-Z ]+$').hasMatch(value)) {
                    return "Name can only contain letters and spaces";
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              _buildLabel("Account Number *"),
              TextFormField(
                controller: _accountNumberController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Account Number',
                  errorStyle: TextStyle(color: Colors.red),
                ),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Account Number is required';
                  }
                  if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                    return 'Account Number must be numeric';
                  }
                  if (value.length < 6) {
                    return 'Account Number must be at least 6 digits';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              _buildLabel("Bank Name *"),
              DropdownButtonFormField<String>(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                value: selectedBank,
                hint: Text("Select Bank Name"),
                items:
                    banks
                        .map(
                          (bank) =>
                              DropdownMenuItem(value: bank, child: Text(bank)),
                        )
                        .toList(),
                onChanged: (value) => setState(() => selectedBank = value),
                validator: (value) => value == null ? "Required" : null,
              ),
              SizedBox(height: 16),
              _buildLabel("Seller Location *"),
              DropdownButtonFormField<String>(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                value: selectedProvince,
                hint: Text("Select Province"),
                items:
                    provinces
                        .map(
                          (province) => DropdownMenuItem(
                            value: province,
                            child: Text(province),
                          ),
                        )
                        .toList(),
                onChanged: (value) => setState(() => selectedProvince = value),
                validator: (value) => value == null ? "Required" : null,
              ),
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Ensure file upload
                      if (_webImage == null) {
                        final docType = hasNpwp ? 'NPWP Card' : 'KTP Card';
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Please upload $docType')),
                        );
                        return;
                      }
                      // Save seller data
                      SellerService.saveSeller({
                        'hasNpwp': hasNpwp,
                        'npwp': _npwpController.text,
                        'ktp': _ktpController.text,
                        'fullName': _fullNameController.text,
                        'address': _addressController.text,
                        'phone': _phoneController.text,
                        'accountHolder': _accountHolderController.text,
                        'accountNumber': _accountNumberController.text,
                        'bank': selectedBank,
                        'province': selectedProvince,
                        'imageBytes': _webImage,
                      });

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Form Submitted Successfully")),
                      );

                      Future.delayed(Duration(seconds: 1), () {
                        // Return to main app with Selling tab selected
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Main(initialIndex: 3),
                          ),
                        );
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade400,
                  ),
                  child: Text("Submit"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Text(text, style: TextStyle(fontWeight: FontWeight.bold)),
  );

  Widget _buildTextField(
    String hint, {
    TextInputType type = TextInputType.text,
  }) {
    return TextFormField(
      keyboardType: type,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        hintText: hint,
        errorStyle: TextStyle(color: Colors.red),
      ),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator:
          (value) =>
              (value == null || value.isEmpty) ? "$hint is required" : null,
    );
  }
}
