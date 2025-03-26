class Product {
  final String id;
  final String brand;
  final String name;
  final List<String> images;
  final double price;
  final String sku;
  final String color;
  final DateTime releaseDate;
  final String description;
  final List<int> sizes;
  final bool isFavorite;

  Product({
    required this.id,
    required this.brand,
    required this.name,
    required this.images,
    required this.price,
    required this.sku,
    required this.color,
    required this.releaseDate,
    required this.description,
    required this.sizes,
    this.isFavorite = false,
  });
}

// Dummy data
final dummyProduct = Product(
  id: '1',
  brand: 'Adidas',
  name: 'Ultraboost Light Running Shoes',
  images: [
    // 'assets/brand-products/adidas/Adidas-Ultraboost-Light-Running-Shoes-1.png',
    // 'assets/brand-products/adidas/Adidas-Ultraboost-Light-Running-Shoes-2.png',
    // 'assets/brand-products/adidas/Adidas-Ultraboost-Light-Running-Shoes-3.png',
    'assets/brand-products/adidas/Adidas-Yeezy-Slide-Granite.png',
    'assets/brand-products/adidas/Adidas-Gazelle-CLOT-Linen-Khaki.png',
    'assets/brand-products/adidas/Adidas-Supernova-Core-Black.png',
  ],
  price: 1090000,
  sku: 'GX3028',
  color: 'CLOUD WHITE',
  releaseDate: DateTime(2025, 3, 22),
  description:
      'Experience extraordinary comfort with the Adidas Ultraboost Light. '
      'Featuring our lightest Boost midsole ever, these running shoes deliver '
      'incredible energy return while maintaining the plush cushioning you love. '
      'The Primeknit+ upper adapts to your foot\'s movement and provides '
      'targeted support where you need it most.',
  sizes: [40, 41, 42, 43],
);

// Dummy related products
final List<Product> relatedProducts = [
  Product(
    id: '2',
    brand: 'Adidas',
    name: 'Samba OG Cloud White',
    images: [
      'assets/brand-products/adidas/Adidas-Samba-OG-Cloud-White-Core-Black.png',
    ],
    price: 1090000,
    sku: 'B75806',
    color: 'CLOUD WHITE/CORE BLACK',
    releaseDate: DateTime(2025, 3, 22),
    description: '',
    sizes: [40, 41, 42, 43],
  ),
  Product(
    id: '3',
    brand: 'Adidas',
    name: 'NMD R Core Black Red',
    images: ['assets/brand-products/adidas/Adidas-NMD-R-Core-Black-Red.png'],
    price: 1090000,
    sku: 'EF4267',
    color: 'CORE BLACK/RED',
    releaseDate: DateTime(2025, 3, 22),
    description: '',
    sizes: [40, 41, 42, 43],
  ),
  Product(
    id: '4',
    brand: 'Adidas',
    name: 'Gazelle CLOT Linen',
    images: [
      'assets/brand-products/adidas/Adidas-Gazelle-CLOT-Linen-Khaki.png',
    ],
    price: 1090000,
    sku: 'GX9770',
    color: 'LINEN KHAKI',
    releaseDate: DateTime(2025, 3, 22),
    description: '',
    sizes: [40, 41, 42, 43],
  ),
];
