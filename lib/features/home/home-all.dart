import 'package:flutter/material.dart';

class CategoryAll extends StatelessWidget {
  const CategoryAll({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Colors.grey.shade300, width: 2),
            ),
          ),
          child: Image.network(
            "https://images.unsplash.com/photo-1603787081207-362bcef7c144?q=80&w=1965&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
            width: double.infinity,
            height: 500,
            fit: BoxFit.cover,
            alignment: Alignment.center,
          ),
        ),
      ],
    );
  }
}
