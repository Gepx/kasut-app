import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class SellerLogic extends StatefulWidget {
  const SellerLogic({super.key});

  @override
  _SellerLogicState createState() => _SellerLogicState();
}

class _SellerLogicState extends State<SellerLogic> {
  List<Map<String, dynamic>> items = [];
  Set<int> selectedIndexes = {};

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  int? editingIndex;

  /// Show dialog to add or edit an item; returns new item data
  Future<void> _showItemDialog({int? index}) async {
    String itemCondition = 'New';
    Uint8List? itemImage;
    if (index != null) {
      editingIndex = index;
      final existing = items[index];
      _nameController.text = existing['name'];
      _priceController.text = existing['price'].toString();
      itemCondition = existing['condition'] as String;
      itemImage = existing['image'] as Uint8List?;
    } else {
      editingIndex = null;
      _nameController.clear();
      _priceController.clear();
    }
    // Show dialog and await new item data
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              title: Text(editingIndex == null ? 'Add Item' : 'Edit Item'),
              content: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(labelText: 'Item Name'),
                        validator:
                            (value) =>
                                (value == null || value.isEmpty)
                                    ? 'Enter a name'
                                    : null,
                      ),
                      TextFormField(
                        controller: _priceController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(labelText: 'Price'),
                        validator:
                            (value) =>
                                (value == null || value.isEmpty)
                                    ? 'Enter a price'
                                    : null,
                      ),
                      SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: RadioListTile<String>(
                              title: Text('New'),
                              value: 'New',
                              groupValue: itemCondition,
                              onChanged: (val) {
                                setState(() => itemCondition = val!);
                              },
                            ),
                          ),
                          Expanded(
                            child: RadioListTile<String>(
                              title: Text('Used'),
                              value: 'Used',
                              groupValue: itemCondition,
                              onChanged: (val) {
                                setState(() => itemCondition = val!);
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      itemImage != null
                          ? Image.memory(
                            itemImage!,
                            height: 100,
                            fit: BoxFit.cover,
                          )
                          : ElevatedButton.icon(
                            onPressed: () async {
                              final res = await FilePicker.platform.pickFiles(
                                type: FileType.image,
                                withData: true,
                              );
                              if (res != null &&
                                  res.files.single.bytes != null) {
                                setState(() {
                                  itemImage = res.files.single.bytes!;
                                });
                              }
                            },
                            icon: Icon(Icons.upload_file),
                            label: Text('Upload Image'),
                          ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: Text('Cancel', style: TextStyle(color: Colors.grey)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                  ),
                  onPressed: () {
                    if (!(_formKey.currentState?.validate() ?? false)) return;
                    if (itemImage == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Please upload an image')),
                      );
                      return;
                    }
                    final map = {
                      'name': _nameController.text,
                      'price': double.parse(_priceController.text),
                      'condition': itemCondition,
                      'image': itemImage,
                    };
                    Navigator.pop(dialogContext, map);
                  },
                  child: Text(
                    editingIndex == null ? 'Add' : 'Update',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
    // After dialog closes, update the list if result exists
    if (result != null) {
      setState(() {
        if (editingIndex != null) {
          items[editingIndex!] = result;
        } else {
          items.add(result);
        }
      });
    }
  }

  void _deleteItem(int index) {
    setState(() {
      items.removeAt(index);
      selectedIndexes.remove(index);
    });
  }

  void _deleteSelectedItems() {
    setState(() {
      items = [
        for (int i = 0; i < items.length; i++)
          if (!selectedIndexes.contains(i)) items[i],
      ];
      selectedIndexes.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    bool allSelected =
        selectedIndexes.length == items.length && items.isNotEmpty;

    return Column(
      children: [
        if (items.isNotEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Checkbox(
                      value: allSelected,
                      onChanged: (value) {
                        setState(() {
                          if (value == true) {
                            selectedIndexes = Set.from(
                              List.generate(items.length, (i) => i),
                            );
                          } else {
                            selectedIndexes.clear();
                          }
                        });
                      },
                      activeColor: Colors.black,
                    ),
                    Text(
                      "Select All",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                if (selectedIndexes.isNotEmpty)
                  IconButton(
                    icon: Icon(Icons.delete_forever, color: Colors.redAccent),
                    onPressed: _deleteSelectedItems,
                    tooltip: 'Delete selected',
                  ),
              ],
            ),
          ),
        Expanded(
          child:
              items.isEmpty
                  ? Center(
                    child: Text(
                      'No items yet. Tap below to add.',
                      style: TextStyle(color: Colors.black54),
                    ),
                  )
                  : ListView.builder(
                    padding: EdgeInsets.all(12),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return Card(
                        color: Colors.grey[100],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        margin: EdgeInsets.symmetric(vertical: 6),
                        child: ListTile(
                          isThreeLine: true,
                          leading:
                              item['image'] != null
                                  ? Image.memory(
                                    item['image'] as Uint8List,
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                  )
                                  : Icon(Icons.image_not_supported, size: 50),
                          title: Text(
                            item['name'],
                            style: TextStyle(color: Colors.black),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Rp ${item['price']}',
                                style: TextStyle(color: Colors.black54),
                              ),
                              Text(
                                'Condition: ${item['condition']}',
                                style: TextStyle(color: Colors.black54),
                              ),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Checkbox(
                                value: selectedIndexes.contains(index),
                                activeColor: Colors.black,
                                onChanged: (value) {
                                  setState(() {
                                    if (value == true) {
                                      selectedIndexes.add(index);
                                    } else {
                                      selectedIndexes.remove(index);
                                    }
                                  });
                                },
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.edit,
                                  color: Colors.blueAccent,
                                ),
                                onPressed: () => _showItemDialog(index: index),
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.delete,
                                  color: Colors.redAccent,
                                ),
                                onPressed: () => _deleteItem(index),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () => _showItemDialog(),
              child: Text(
                'Add Item',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
