class SearchData {
  static const List<String> popularSearches = [
    "Nike Air Max",
    "Adidas Ultraboost",
    "New Balance 574",
    "Puma RS-X",
    "Ortuseight Catalyst",
    "Nike Zoom",
    "Specs Metasala",
    "Adidas Predator",
    "Nike Jordan",
    "Puma Future",
  ];

  static const List<BrandLogo> brandLogos = [
    BrandLogo(name: "Nike", logoPath: "assets/brands/nike.png"),
    BrandLogo(name: "Adidas", logoPath: "assets/brands/adidas.png"),
    BrandLogo(name: "Puma", logoPath: "assets/brands/puma.png"),
    BrandLogo(name: "New Balance", logoPath: "assets/brands/new_balance.png"),
    BrandLogo(name: "Ortuseight", logoPath: "assets/brands/ortuseight.png"),
    BrandLogo(name: "Specs", logoPath: "assets/brands/specs.png"),
    BrandLogo(name: "Mizuno", logoPath: "assets/brands/mizuno.png"),
    BrandLogo(name: "Under Armour", logoPath: "assets/brands/under_armour.png"),
  ];
}

class BrandLogo {
  final String name;
  final String logoPath;

  const BrandLogo({required this.name, required this.logoPath});
}
