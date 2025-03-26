class BlogPost {
  final String id;
  final String authorName;
  final String authorImage;
  final String title;
  final List<String> images;
  final String content;
  final DateTime publishTime;

  BlogPost({
    required this.id,
    required this.authorName,
    required this.authorImage,
    required this.title,
    required this.images,
    required this.content,
    required this.publishTime,
  });
}

// Sample static data
final List<BlogPost> blogPosts = [
  BlogPost(
    id: '1',
    authorName: 'Nike',
    authorImage: 'assets/blog/profile.png',
    title: 'Nike Unveils Latest Air Max Innovation',
    images: ['assets/blog/content.png', 'assets/blog/content2.png'],
    content: '''
        Nike has once again pushed the boundaries of sneaker technology with the launch of its latest Air Max model. This revolutionary design incorporates cutting-edge materials and innovative cushioning, making it one of the most comfortable and stylish sneakers ever produced.

        The new Air Max features an advanced sole unit that enhances responsiveness and energy return. Designed for both casual wearers and athletes, this model is engineered to provide maximum comfort and durability.

        One of the standout features of the new Air Max is its redesigned air cushioning system. By using next-generation materials, Nike has been able to increase the air volume while maintaining a lightweight feel. This innovation ensures a smoother and more responsive ride with every step.

        The sneaker also introduces a bold aesthetic, with a variety of colorways and materials that cater to different fashion tastes. Whether you prefer a minimalist look or a vibrant statement piece, the latest Air Max has something for everyone.

        Nike’s commitment to sustainability is evident in this release, with the shoe utilizing eco-friendly materials and a production process that reduces waste. This aligns with the company’s goal of reducing its environmental footprint while maintaining high-performance footwear.

        The new Air Max has already generated significant buzz in the sneaker community, with collectors and athletes alike eager to get their hands on a pair. As Nike continues to innovate, this latest release proves why the brand remains at the forefront of sneaker culture.
    ''',
    publishTime: DateTime.now(),
  ),
  BlogPost(
    id: '2',
    authorName: 'Adidas',
    authorImage: 'assets/blog/profile.png',
    title: 'Adidas Boost Series Gets a Major Upgrade',
    images: ['assets/blog/content.png', 'assets/blog/content2.png'],
    content: '''
        Adidas has introduced an exciting update to its beloved Boost series, bringing a fresh wave of comfort, performance, and style to sneaker enthusiasts worldwide. The new iteration, packed with advanced cushioning technology, aims to redefine everyday wear and athletic performance.

        The most notable enhancement in this latest Boost model is the redesigned midsole. Using cutting-edge energy return technology, Adidas has managed to make this sneaker even more comfortable and responsive. Whether you’re hitting the gym or strolling through the city, this shoe adapts to your movement effortlessly.

        Adidas has also improved the upper construction by integrating breathable Primeknit fabric that ensures a snug yet comfortable fit. This not only enhances aesthetics but also contributes to improved flexibility and support, making the shoe perfect for extended wear.

        Another highlight of this release is its eco-friendly design. Adidas continues its commitment to sustainability by incorporating recycled materials into the Boost series, reducing plastic waste without compromising performance.

        The new Boost series is set to hit stores soon, with multiple colorways and limited-edition releases expected. With its superior comfort, innovative design, and sustainability focus, this latest addition to the Boost family is bound to be a favorite among sneaker lovers.
    ''',
    publishTime: DateTime.now(),
  ),
  BlogPost(
    id: '3',
    authorName: 'Puma',
    authorImage: 'assets/blog/profile.png',
    title: 'Puma’s Running Shoes Revolutionize Performance',
    images: ['assets/blog/content.png', 'assets/blog/content2.png'],
    content: '''
        Puma has unveiled its latest running shoe lineup, designed to provide unmatched performance for athletes and casual runners alike. The new collection combines state-of-the-art technology with sleek design, offering a perfect balance of comfort, durability, and style.

        One of the key highlights of this collection is the introduction of Puma’s Nitro Foam midsole. This innovative cushioning system delivers incredible energy return while maintaining lightweight construction, allowing runners to move effortlessly with each stride.

        The upper design has been reengineered with breathable mesh, ensuring optimal airflow and flexibility. Additionally, Puma’s new traction outsole provides superior grip on various terrains, making these running shoes ideal for all conditions.

        Beyond performance, Puma has focused on aesthetics, offering a wide range of colorways and collaborations with top athletes. These running shoes not only feel great but also make a bold fashion statement on the streets.

        As running enthusiasts eagerly anticipate the release, Puma continues to solidify its place as a leader in athletic footwear innovation. Whether you’re training for a marathon or just looking for a stylish everyday sneaker, this new collection has something for everyone.
    ''',
    publishTime: DateTime.now(),
  ),
  BlogPost(
    id: '4',
    authorName: 'New Balance',
    authorImage: 'assets/blog/profile.png',
    title: 'New Balance Expands Its Lifestyle Sneaker Line',
    images: ['assets/blog/content.png', 'assets/blog/content2.png'],
    content: '''
        New Balance has announced an exciting expansion of its lifestyle sneaker lineup, blending retro aesthetics with modern comfort technology. This latest collection caters to both sneakerheads and everyday wearers, proving that style and functionality can go hand in hand.

        The highlight of the new lineup is the redesigned 990 series, featuring premium materials and enhanced cushioning for all-day wearability. New Balance has taken inspiration from classic silhouettes while infusing contemporary elements to make the designs more appealing to today’s audience.

        Sustainability plays a major role in this collection, as New Balance incorporates eco-friendly materials into its shoes. From recycled rubber soles to vegan leather uppers, the brand’s commitment to reducing its carbon footprint is evident.

        The lifestyle sneaker market has been growing rapidly, and New Balance is capitalizing on this trend with a range of collaborations and exclusive releases. The brand’s timeless appeal combined with innovative craftsmanship ensures that this collection will be a hit among fashion-conscious consumers.

        Whether you’re a longtime fan or new to the New Balance family, this latest collection offers something unique for everyone. Keep an eye out for upcoming limited drops and special edition colorways in the months ahead.
    ''',
    publishTime: DateTime.now(),
  ),
  BlogPost(
    id: '5',
    authorName: 'Shoe Trends',
    authorImage: 'assets/blog/profile.png',
    title: 'Top Sneaker Trends for 2025',
    images: ['assets/blog/content.png', 'assets/blog/content2.png'],
    content: '''
        The sneaker industry continues to evolve, and 2025 is set to bring exciting new trends. From sustainable materials to futuristic designs, sneaker enthusiasts can expect fresh styles that redefine casual footwear.

        Key trends include eco-friendly sneakers, chunky soles making a comeback, and smart sneakers with built-in tracking technology.
    ''',
    publishTime: DateTime.now(),
  ),
  BlogPost(
    id: '6',
    authorName: 'Shoe Care Tips',
    authorImage: 'assets/blog/profile.png',
    title: 'How to Take Care of Your Sneakers',
    images: ['assets/blog/content.png', 'assets/blog/content2.png'],
    content: '''
        Keeping your sneakers fresh and clean is essential for longevity. Learn the best methods to clean different types of materials, store your sneakers properly, and maintain their shape over time.

        Simple steps like using shoe trees, avoiding excessive moisture, and cleaning stains immediately can help extend the life of your favorite pairs.
    ''',
    publishTime: DateTime.now(),
  ),
  BlogPost(
    id: '7',
    authorName: 'Ortuseight',
    authorImage: 'assets/blog/profile.png',
    title: 'Ortuseight Introduces Next-Gen Football Boots',
    images: ['assets/blog/content.png', 'assets/blog/content2.png'],
    content: '''
        Indonesian sports brand Ortuseight has launched its latest football boot series, featuring cutting-edge technology designed for ultimate performance on the pitch. The new boots incorporate lightweight materials, improved traction, and a snug fit for enhanced ball control.

        The new release also highlights Ortuseight’s commitment to local craftsmanship and innovation, making it a strong competitor in the global football footwear market.
    ''',
    publishTime: DateTime.now(),
  ),
  BlogPost(
    id: '8',
    authorName: 'Ortuseight',
    authorImage: 'assets/blog/profile.png',
    title: 'Why Ortuseight is the Rising Star in Sportswear',
    images: ['assets/blog/content.png'],
    content: '''
        Ortuseight has quickly become a household name in Indonesia’s sportswear industry, gaining recognition for its high-quality and affordable athletic shoes. Founded with a vision to support local athletes, the brand offers products that combine style, comfort, and functionality.

        The company’s commitment to research and development has led to innovations such as OrtShox technology, enhancing shock absorption and energy return. This makes Ortuseight footwear ideal for both professional athletes and casual wearers.

        Another key factor behind Ortuseight’s success is its strong focus on affordability. Unlike global brands, Ortuseight provides premium-quality sports shoes at competitive prices, making performance footwear more accessible to a wider audience.

        Collaborations with Indonesian athletes and teams further strengthen Ortuseight’s presence in the market. By actively engaging with the local sports community, the brand ensures that its products meet the needs of real athletes.

        With its rapid growth and expanding international presence, Ortuseight is poised to become a major player in the global sportswear industry. As it continues to innovate and cater to diverse athletic needs, the brand’s future looks promising.
    ''',
    publishTime: DateTime.now(),
  ),
];
