import 'package:flutter/material.dart';
import 'package:kasut/features/faq/faq_data.dart';

class FAQPage extends StatefulWidget {
  const FAQPage({super.key});

  @override
  State<FAQPage> createState() => _FAQPageState();
}

class _FAQPageState extends State<FAQPage> {
  String selectedCategory = 'All';
  String searchQuery = '';

  // Ambil semua kategori unik
  List<String> get categories {
    final allCategories =
        faqItems.map((item) => item.category).toSet().toList();
    allCategories.sort();
    return ['All', ...allCategories];
  }

  // Filter berdasarkan kategori & search
  List<FAQItem> get filteredFaqs {
    return faqItems.where((faq) {
      final matchesCategory =
          selectedCategory == 'All' || faq.category == selectedCategory;
      final matchesSearch = faq.question.toLowerCase().contains(
        searchQuery.toLowerCase(),
      );
      return matchesCategory && matchesSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              onChanged: (value) => setState(() => searchQuery = value),
              decoration: InputDecoration(
                hintText: 'Search question, problem and solutions',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              itemBuilder: (context, index) {
                final category = categories[index];
                final isSelected = selectedCategory == category;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: ChoiceChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected:
                        (_) => setState(() => selectedCategory = category),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child:
                filteredFaqs.isEmpty
                    ? const Center(child: Text('No FAQs found.'))
                    : ListView.builder(
                      itemCount: filteredFaqs.length,
                      itemBuilder: (context, index) {
                        final faq = filteredFaqs[index];
                        return ExpansionTile(
                          title: Text(faq.question),
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              child: Text(faq.answer),
                            ),
                          ],
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }
}
