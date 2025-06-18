import 'package:intl/intl.dart';

/// Indonesian localization utilities for Kasut app
class IndonesianUtils {
  
  /// Format price in Indonesian Rupiah
  static String formatRupiah(double price) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return formatter.format(price);
  }

  /// Format price in shorter format (e.g., "Rp 1,5 Juta")
  static String formatRupiahShort(double price) {
    if (price >= 1000000) {
      final millions = price / 1000000;
      if (millions == millions.round()) {
        return 'Rp ${millions.round()} Juta';
      } else {
        return 'Rp ${millions.toStringAsFixed(1)} Juta';
      }
    } else if (price >= 1000) {
      final thousands = price / 1000;
      if (thousands == thousands.round()) {
        return 'Rp ${thousands.round()}K';
      } else {
        return 'Rp ${thousands.toStringAsFixed(1)}K';
      }
    } else {
      return 'Rp ${price.round()}';
    }
  }

  /// Validate Indonesian phone number
  static bool isValidIndonesianPhone(String phone) {
    // Remove any non-digits
    final digitsOnly = phone.replaceAll(RegExp(r'[^\d]'), '');
    
    // Check if starts with 62 (country code) or 0 (local)
    if (digitsOnly.startsWith('62')) {
      return digitsOnly.length >= 10 && digitsOnly.length <= 15;
    } else if (digitsOnly.startsWith('0')) {
      return digitsOnly.length >= 10 && digitsOnly.length <= 14;
    } else if (digitsOnly.length >= 9 && digitsOnly.length <= 13) {
      // Assume it's missing the leading 0
      return true;
    }
    
    return false;
  }

  /// Format Indonesian phone number
  static String formatIndonesianPhone(String phone) {
    final digitsOnly = phone.replaceAll(RegExp(r'[^\d]'), '');
    
    if (digitsOnly.startsWith('62')) {
      return '+${digitsOnly.substring(0, 2)} ${digitsOnly.substring(2, 5)} ${digitsOnly.substring(5)}';
    } else if (digitsOnly.startsWith('0')) {
      return '${digitsOnly.substring(0, 4)} ${digitsOnly.substring(4)}';
    } else {
      return '0${digitsOnly.substring(0, 3)} ${digitsOnly.substring(3)}';
    }
  }
}

/// Indonesian UI text constants
class IndonesianText {
  // Common actions
  static const String beli = 'Beli';
  static const String jual = 'Jual';
  static const String tambahKeranjang = 'Tambah ke Keranjang';
  static const String beliSekarang = 'Beli Sekarang';
  static const String cari = 'Cari';
  static const String filter = 'Filter';
  static const String urutkan = 'Urutkan';
  
  // Product conditions
  static const String brandNew = 'Brand New';
  static const String bekas = 'Bekas';
  static const String denganBox = 'Dengan Box';
  static const String tanpaBox = 'Tanpa Box';
  static const String lainnya = 'Lainnya';
  
  // Product info
  static const String ukuran = 'Ukuran';
  static const String warna = 'Warna';
  static const String kondisi = 'Kondisi';
  static const String harga = 'Harga';
  static const String stok = 'Stok';
  static const String deskripsi = 'Deskripsi';
  
  // Categories
  static const String pria = 'Pria';
  static const String wanita = 'Wanita';
  static const String anak = 'Anak';
  static const String semua = 'Semua';
  
  // Account
  static const String masuk = 'Masuk';
  static const String daftar = 'Daftar';
  static const String keluar = 'Keluar';
  static const String profil = 'Profil';
  static const String wishlist = 'Wishlist';
  static const String riwayat = 'Riwayat';
  static const String pengaturan = 'Pengaturan';
  
  // Payment & Credits
  static const String topUp = 'Top Up';
  static const String saldo = 'Saldo';
  static const String poin = 'Poin';
  static const String voucher = 'Voucher';
  static const String pembayaran = 'Pembayaran';
  static const String transfer = 'Transfer';
  
  // Status
  static const String tersedia = 'Tersedia';
  static const String habis = 'Habis';
  static const String terjual = 'Terjual';
  static const String menunggu = 'Menunggu';
  static const String selesai = 'Selesai';
  static const String dibatalkan = 'Dibatalkan';
  
  // Messages
  static const String berhasil = 'Berhasil';
  static const String gagal = 'Gagal';
  static const String loading = 'Memuat...';
  static const String tidakAda = 'Tidak ada';
  static const String coba = 'Coba Lagi';
  
  // Seller
  static const String jualSepatu = 'Jual Sepatu';
  static const String pilihProduk = 'Pilih Produk';
  static const String uploadFoto = 'Upload Foto';
  static const String tentukanharga = 'Tentukan Harga';
  static const String catatanKondisi = 'Catatan Kondisi';
  static const String maksHarga = 'Harga tidak boleh melebihi harga brand new';
}

/// Product condition enum with Indonesian labels
enum ProductCondition {
  brandNew(IndonesianText.brandNew),
  denganBox(IndonesianText.denganBox),
  tanpaBox(IndonesianText.tanpaBox),
  lainnya(IndonesianText.lainnya);

  const ProductCondition(this.label);
  final String label;
} 