import 'package:flutter/material.dart';

class SellerLogic extends StatefulWidget {
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

  void _showItemDialog({int? index}) {
    if (index != null) {
      editingIndex = index;
      _nameController.text = items[index]['name'];
      _priceController.text = items[index]['price'].toString();
    } else {
      editingIndex = null;
      _nameController.clear();
      _priceController.clear();
    }

    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            backgroundColor: Colors.white,
            title: Text(editingIndex == null ? 'Add Item' : 'Edit Item'),
            content: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(labelText: 'Item Name'),
                    validator:
                        (value) =>
                            value!.isEmpty ? 'Please enter a name' : null,
                  ),
                  TextFormField(
                    controller: _priceController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: 'Price'),
                    validator:
                        (value) =>
                            value!.isEmpty ? 'Please enter a price' : null,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel', style: TextStyle(color: Colors.grey)),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final newItem = {
                      'name': _nameController.text,
                      'price': double.parse(_priceController.text),
                    };
                    setState(() {
                      if (editingIndex != null) {
                        items[editingIndex!] = newItem;
                      } else {
                        items.add(newItem);
                      }
                    });
                    Navigator.pop(context);
                  }
                },
                child: Text(
                  editingIndex == null ? 'Add' : 'Update',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
    );
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

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Seller Product', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Column(
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
                      itemCount: items.length,
                      padding: EdgeInsets.all(12),
                      itemBuilder: (context, index) {
                        final item = items[index];
                        return Card(
                          color: Colors.grey[100],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          margin: EdgeInsets.symmetric(vertical: 6),
                          child: ListTile(
                            leading: Checkbox(
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
                            title: Text(
                              item['name'],
                              style: TextStyle(color: Colors.black),
                            ),
                            subtitle: Text(
                              'Rp ${item['price']}',
                              style: TextStyle(color: Colors.black54),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(
                                    Icons.edit,
                                    color: Colors.blueAccent,
                                  ),
                                  onPressed:
                                      () => _showItemDialog(index: index),
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
      ),
    );
  }
}
