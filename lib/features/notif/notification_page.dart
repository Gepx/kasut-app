import 'package:flutter/material.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Halaman Notifikasi"),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          bottom: const TabBar(
            tabs: [
              Tab(text: "Semua"),
              Tab(text: "Pembelian"),
              Tab(text: "Penjualan"),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            NotificationContent(),
            NotificationContent(),
            NotificationContent(),
          ],
        ),
      ),
    );
  }
}

class NotificationContent extends StatelessWidget {
  const NotificationContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check, size: 100, color: Colors.black),
            const SizedBox(height: 16),
            const Text(
              "Tidak Ada Notifikasi",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              "Notifikasi kamu akan ditampilkan di sini. Kamu dapat "
              "mengatur notifikasi berdasarkan preferensi kamu kapan saja.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
