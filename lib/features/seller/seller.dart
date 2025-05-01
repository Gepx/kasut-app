import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:kasut/features/seller/sellerlogic.dart';

class SellerPage extends StatefulWidget {
  const SellerPage({super.key});

  @override
  State<SellerPage> createState() => _SellerPageState();
}

class _SellerPageState extends State<SellerPage> {
  bool hasNpwp = true;
  final _formKey = GlobalKey<FormState>();
  String? selectedBank;
  String? selectedProvince;
  Uint8List? _webImage;

  List<String> banks = ["Bank BCA", "Bank BNI", "Bank BRI"];
  List<String> provinces = [
    "Sumatera Utara",
    "Sumatera Barat",
    "Sumatera Timur",
  ];

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
                _buildTextField('00.000.000.0-000.000'),
              ] else ...[
                _buildLabel('KTP Number *'),
                _buildTextField('0000000000000000'),
              ],
              _buildLabel('Full Name *'),
              _buildTextField('Full Name'),
              _buildLabel('Address *'),
              _buildTextField('Address'),
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
                    child: _buildTextField(
                      'Phone Number',
                      type: TextInputType.phone,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              _buildLabel("Account Holder's Name *"),
              _buildTextField("Input account holder's name"),
              SizedBox(height: 16),
              _buildLabel("Account Number *"),
              _buildTextField("Account Number", type: TextInputType.number),
              SizedBox(height: 16),
              _buildLabel("Bank Name *"),
              DropdownButtonFormField<String>(
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
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Form Submitted Successfully")),
                      );

                      Future.delayed(Duration(seconds: 1), () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SellerLogic(),
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
