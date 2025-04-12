class Shoe {
  final String name;
  final String brand;
  final double price;
  final String imageUrl;
  final double? oldPrice; // Added optional old price

  const Shoe({
    required this.name,
    required this.brand,
    required this.price,
    required this.imageUrl,
    this.oldPrice, // Added to constructor
  });
}

class ShoeData {
  static final List<Shoe> shoes = [
    // Nike Shoes
    Shoe(
      name: "Nike Air Force 1 '07",
      brand: "Nike",
      price: 1599000,
      imageUrl: "assets/shoes/nike_air_force.png",
    ),
    Shoe(
      name: "Nike Air Max 90",
      brand: "Nike",
      price: 2099000,
      imageUrl: "assets/shoes/nike_air_max.png",
    ),
    Shoe(
      name: "Nike Dunk Low",
      brand: "Nike",
      price: 1799000,
      imageUrl: "assets/shoes/nike_dunk.png",
    ),
    Shoe(
      name: "Nike Air Jordan 1",
      brand: "Nike",
      price: 2899000,
      imageUrl: "assets/shoes/nike_jordan.png",
    ),
    Shoe(
      name: "Nike Zoom Fly 5",
      brand: "Nike",
      price: 2599000,
      imageUrl: "assets/shoes/nike_zoom.png",
    ),

    // Adidas Shoes
    Shoe(
      name: "Adidas Samba OG",
      brand: "Adidas",
      price: 1499000,
      imageUrl: "assets/shoes/adidas_samba.png",
    ),
    Shoe(
      name: "Adidas Stan Smith",
      brand: "Adidas",
      price: 1299000,
      imageUrl: "assets/shoes/adidas_stan.png",
    ),
    Shoe(
      name: "Adidas Superstar",
      brand: "Adidas",
      price: 1599000,
      imageUrl: "assets/shoes/adidas_superstar.png",
    ),
    Shoe(
      name: "Adidas Ultraboost 21",
      brand: "Adidas",
      price: 2899000,
      imageUrl: "assets/shoes/adidas_ultraboost.png",
    ),
    Shoe(
      name: "Adidas Yeezy Boost 350",
      brand: "Adidas",
      price: 3299000,
      imageUrl: "assets/shoes/adidas_yeezy.png",
    ),

    // Puma Shoes
    Shoe(
      name: "Puma RS-X",
      brand: "Puma",
      price: 1499000,
      imageUrl: "assets/shoes/puma_rsx.png",
    ),
    Shoe(
      name: "Puma Suede Classic",
      brand: "Puma",
      price: 1299000,
      imageUrl: "assets/shoes/puma_suede.png",
    ),
    Shoe(
      name: "Puma Future Rider",
      brand: "Puma",
      price: 1399000,
      imageUrl: "assets/shoes/puma_future.png",
    ),
    Shoe(
      name: "Puma Softride",
      brand: "Puma",
      price: 1699000,
      imageUrl: "assets/shoes/puma_softride.png",
    ),
    Shoe(
      name: "Puma Speedcat",
      brand: "Puma",
      price: 1299000,
      imageUrl: "assets/shoes/puma_speedcat.png",
    ),

    // On Cloud Shoes
    Shoe(
      name: "On Cloud X",
      brand: "onCloud",
      price: 2499000,
      imageUrl: "assets/shoes/on_cloud_x.png",
    ),
    Shoe(
      name: "On Cloudflow",
      brand: "onCloud",
      price: 2599000,
      imageUrl: "assets/shoes/on_cloudflow.png",
    ),
    Shoe(
      name: "On Cloudventure",
      brand: "onCloud",
      price: 2799000,
      imageUrl: "assets/shoes/on_cloudventure.png",
    ),
    Shoe(
      name: "On Cloudace",
      brand: "onCloud",
      price: 2899000,
      imageUrl: "assets/shoes/on_cloudace.png",
    ),
    Shoe(
      name: "On Cloudflyer",
      brand: "onCloud",
      price: 3099000,
      imageUrl: "assets/shoes/on_cloudflyer.png",
    ),

    // Asics Shoes
    Shoe(
      name: "Asics Gel-Nimbus 24",
      brand: "Asics",
      price: 2599000,
      imageUrl: "assets/shoes/asics_gel_nimbus.png",
    ),
    Shoe(
      name: "Asics Gel-Kayano 28",
      brand: "Asics",
      price: 2799000,
      imageUrl: "assets/shoes/asics_gel_kayano.png",
    ),
    Shoe(
      name: "Asics GT-2000 10",
      brand: "Asics",
      price: 2199000,
      imageUrl: "assets/shoes/asics_gt2000.png",
    ),
    Shoe(
      name: "Asics Gel-Quantum 360",
      brand: "Asics",
      price: 2899000,
      imageUrl: "assets/shoes/asics_gel_quantum.png",
    ),
    Shoe(
      name: "Asics Gel-Lyte III",
      brand: "Asics",
      price: 1999000,
      imageUrl: "assets/shoes/asics_gel_lyte.png",
    ),

    // Salomon Shoes
    Shoe(
      name: "Salomon Speedcross 5",
      brand: "Salomon",
      price: 2199000,
      imageUrl: "assets/shoes/salomon_speedcross.png",
    ),
    Shoe(
      name: "Salomon XA Pro 3D",
      brand: "Salomon",
      price: 2299000,
      imageUrl: "assets/shoes/salomon_xa_pro.png",
    ),
    Shoe(
      name: "Salomon Ultra Glide",
      brand: "Salomon",
      price: 2499000,
      imageUrl: "assets/shoes/salomon_ultra_glide.png",
    ),
    Shoe(
      name: "Salomon Sense Ride 4",
      brand: "Salomon",
      price: 1999000,
      imageUrl: "assets/shoes/salomon_sense_ride.png",
    ),
    Shoe(
      name: "Salomon Outline",
      brand: "Salomon",
      price: 1799000,
      imageUrl: "assets/shoes/salomon_outline.png",
    ),

    // Onitsuka Tiger Shoes
    Shoe(
      name: "Onitsuka Tiger Mexico 66",
      brand: "Onitsuka Tiger",
      price: 1499000,
      imageUrl: "assets/shoes/onitsuka_mexico.png",
    ),
    Shoe(
      name: "Onitsuka Tiger Serrano",
      brand: "Onitsuka Tiger",
      price: 1699000,
      imageUrl: "assets/shoes/onitsuka_serrano.png",
    ),
    Shoe(
      name: "Onitsuka Tiger Ultimate 81",
      brand: "Onitsuka Tiger",
      price: 1799000,
      imageUrl: "assets/shoes/onitsuka_ultimate.png",
    ),
    Shoe(
      name: "Onitsuka Tiger Colorado 85",
      brand: "Onitsuka Tiger",
      price: 1999000,
      imageUrl: "assets/shoes/onitsuka_colorado.png",
    ),
    Shoe(
      name: "Onitsuka Tiger Corsair",
      brand: "Onitsuka Tiger",
      price: 2199000,
      imageUrl: "assets/shoes/onitsuka_corsair.png",
    ),
  ];
}
