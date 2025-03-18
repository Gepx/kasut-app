import 'package:flutter/material.dart';

class SellerPage extends StatefulWidget {
  @override
  _SellerPageState createState() => _SellerPageState();
}

class _SellerPageState extends State<SellerPage> {
  bool hasNpwp = true;

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

  // final _formKey = GlobalKey<FormState>();
  // TextEditingController npwpController = TextEditingController();
  // TextEditingController ktpController = TextEditingController();
  // TextEditingController nameController = TextEditingController();
  // TextEditingController addressController = TextEditingController();

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
      appBar: AppBar(title: Text("Sell With Us")),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
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
                      title: Text("I don’t have NPWP"),
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
            ],
          ),
        ),
      ),
    );
  }
}
