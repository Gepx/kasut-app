import 'package:flutter/material.dart';

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

  List<String> banks = ["Bank BCA", "Bank BNI", "Bank BRI"];
  List<String> provinces = [
    "Sumatera Utara",
    "Sumatera Barat",
    "Sumatera Timur",
  ];

  void _showUploadOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(leading: Icon(Icons.camera_alt), title: Text("Camera")),
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text("Gallery"),
              ),
            ],
          ),
        );
      },
    );
  }

  // void _submitForm() {
  //   if (_formKey.currentState!.validate()) {
  //     ScaffoldMessenger.of(
  //       context,
  //     ).showSnackBar(SnackBar(content: Text('Form Submitted Successfully!')));
  //   }
  // }

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
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  Expanded(
                    child: RadioListTile<bool>(
                      title: Text("I have NPWP"),
                      value: true,
                      groupValue: hasNpwp,
                      onChanged: (value) {
                        setState(() {
                          hasNpwp = value!;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<bool>(
                      title: Text("I don't have NPWP"),
                      value: false,
                      groupValue: hasNpwp,
                      onChanged: (value) {
                        setState(() {
                          hasNpwp = value!;
                        });
                      },
                    ),
                  ),
                ],
              ),
              if (hasNpwp) ...[
                Text(
                  'NPWP Number *',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: '00.000.000.0-000.000',
                    errorStyle: TextStyle(color: Colors.red),
                  ),
                  keyboardType: TextInputType.number,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator:
                      (value) =>
                          (value == null || value.isEmpty)
                              ? 'NPWP Number is required'
                              : null,
                ),
              ] else ...[
                Text(
                  'KTP Number *',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: '0000000000000000',
                    errorStyle: TextStyle(color: Colors.red),
                  ),
                  keyboardType: TextInputType.number,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator:
                      (value) =>
                          (value == null || value.isEmpty)
                              ? 'KTP Number is required'
                              : null,
                ),
              ],
              Text(
                'Full Name *',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Full Name',
                  errorStyle: TextStyle(color: Colors.red),
                ),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator:
                    (value) =>
                        (value == null || value.isEmpty)
                            ? 'Full Name is required'
                            : null,
              ),
              Text('Address *', style: TextStyle(fontWeight: FontWeight.bold)),
              TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Address',
                  errorStyle: TextStyle(color: Colors.red),
                ),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator:
                    (value) =>
                        (value == null || value.isEmpty)
                            ? 'Address is required'
                            : null,
              ),
              Text(
                "NPWP Card *",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Container(
                height: 300,
                color: Colors.grey[300],
                child: Align(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    onPressed: _showUploadOptions,
                    child: Row(
                      mainAxisSize:
                          MainAxisSize
                              .min, // Ensures the row takes only needed space
                      children: [
                        Icon(Icons.upload_file),
                        SizedBox(width: 8), // Space between icon and text
                        Text(
                          "Browse Files",
                          style: TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Text(
                'Mobile Number *',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                'Make sure to input active number connected with SMS or Whatsapp to receive any updates regarding to your products.',
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
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        hintText: 'Phone Number',
                        border: OutlineInputBorder(),
                        errorStyle: TextStyle(color: Colors.red),
                      ),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator:
                          (value) =>
                              (value == null || value.isEmpty)
                                  ? 'Phone Number is required'
                                  : null,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Text(
                "Account Holder's Name *",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                'Input the bank account you would like to be associated with all transaction occured in this platform',
                style: TextStyle(color: Colors.grey),
              ),
              TextFormField(
                decoration: InputDecoration(
                  hintText: "Input account holder's name",
                  border: OutlineInputBorder(),
                  errorStyle: TextStyle(color: Colors.red),
                ),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator:
                    (value) =>
                        (value == null || value.isEmpty)
                            ? "Account Holder's Name is required"
                            : null,
              ),
              SizedBox(height: 16),
              Text(
                "Account Number *",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(hintText: "Account Number"),
                validator: (value) {
                  if (value == null || value.isEmpty) return "Required";
                  return null;
                },
              ),
              SizedBox(height: 16),
              Text(
                "Bank Name *",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              DropdownButtonFormField<String>(
                value: selectedBank,
                hint: Text("Select Bank Name"),
                items:
                    banks.map((bank) {
                      return DropdownMenuItem(value: bank, child: Text(bank));
                    }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedBank = value;
                  });
                },
                validator: (value) => value == null ? "Required" : null,
              ),
              SizedBox(height: 16),
              Text(
                "Seller Location *",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              DropdownButtonFormField<String>(
                value: selectedProvince,
                hint: Text("Select Province"),
                items:
                    provinces.map((province) {
                      return DropdownMenuItem(
                        value: province,
                        child: Text(province),
                      );
                    }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedProvince = value;
                  });
                },
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
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade400, // Disabled color
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
}
