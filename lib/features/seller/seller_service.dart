class SellerService {
  // Static map to hold the current seller's data
  static Map<String, dynamic>? currentSeller;

  /// Save seller data to memory
  static void saveSeller(Map<String, dynamic> data) {
    currentSeller = data;
  }
}
