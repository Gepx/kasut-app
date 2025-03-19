import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

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
          child: CarouselSlider(
            options: CarouselOptions(
              height: 350.0,
              autoPlay: true,
              viewportFraction: 1.0,
              enableInfiniteScroll: true,
            ),
            items: [
              Image.network(
                "https://www.topsandbottomsusa.com/cdn/shop/articles/Air_Jordan_1_Retro_High_OG_Midnight_Navy_Banner-608005.png?v=1739831182&width=1200",
                width: double.infinity,
                height: 350,
                fit: BoxFit.cover,
                alignment: Alignment.center,
              ),
              Image.network(
                "https://images.pexels.com/photos/10963373/pexels-photo-10963373.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2",
                width: double.infinity,
                height: 350,
                fit: BoxFit.cover,
                alignment: Alignment.center,
              ),
              Image.network(
                "https://images.unsplash.com/photo-1552346154-21d32810aba3?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                width: double.infinity,
                height: 350,
                fit: BoxFit.cover,
                alignment: Alignment.center,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
