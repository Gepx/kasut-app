import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

/// Category carousel component (micro-frontend)
class CategoryCarousel extends StatelessWidget {
  const CategoryCarousel({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    const double breakpoint = 800.0;

    final List<String> mobileImageUrls = [
      "https://www.topsandbottomsusa.com/cdn/shop/articles/Air_Jordan_1_Retro_High_OG_Midnight_Navy_Banner-608005.png?v=1739831182&width=1200",
      "https://images.pexels.com/photos/10963373/pexels-photo-10963373.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2",
      "https://images.unsplash.com/photo-1552346154-21d32810aba3?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
    ];

    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.shade300,
            width: 2,
          ),
        ),
      ),
      child: Builder(
        builder: (context) {
          final bool isMobile = screenWidth < breakpoint;
          
          if (isMobile) {
            return _buildMobileCarousel(mobileImageUrls);
          } else {
            return _buildDesktopWelcome();
          }
        },
      ),
    );
  }

  Widget _buildMobileCarousel(List<String> imageUrls) {
    final carouselItems = imageUrls.map((url) {
      return Image.network(
        url,
        width: double.infinity,
        height: 350,
        fit: BoxFit.cover,
        alignment: Alignment.center,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                  : null,
            ),
          );
        },
        errorBuilder: (context, exception, stackTrace) {
          return Container(
            width: double.infinity,
            height: 350,
            color: Colors.grey.shade300,
            child: const Center(
              child: Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 50,
              ),
            ),
          );
        },
      );
    }).toList();

    return CarouselSlider(
      options: CarouselOptions(
        height: 350.0,
        autoPlay: true,
        viewportFraction: 1.0,
        enableInfiniteScroll: true,
      ),
      items: carouselItems,
    );
  }

  Widget _buildDesktopWelcome() {
    return CarouselSlider(
      options: CarouselOptions(
        height: 350.0,
        autoPlay: false,
        viewportFraction: 1.0,
        enableInfiniteScroll: false,
      ),
      items: [
        Container(
          width: double.infinity,
          height: 350,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.grey.shade100,
                Colors.grey.shade300,
              ],
            ),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.directions_run,
                    size: 100,
                    color: Colors.redAccent.shade400,
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Welcome to Kasut!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Your destination for authentic sneakers.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
} 