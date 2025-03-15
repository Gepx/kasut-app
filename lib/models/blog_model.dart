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
    authorName: 'Warren Buffet',
    authorImage: 'assets/blog/profile.png',
    title: 'Apple Is Now Worth \$3 Trillion, Boosted By The Halo Of Beat',
    images: ['assets/blog/content.png', 'assets/blog/content2.png'],
    content: '''
    In a remarkable milestone for the technology industry, Apple Inc. has achieved a 
    market capitalization of \$3 trillion, marking a historic moment in corporate 
    valuation. This unprecedented achievement comes as the company continues to 
    demonstrate strong performance across its product lines and services...
    
    The company's success can be attributed to several factors, including its 
    innovative product lineup, growing services revenue, and strong brand loyalty 
    among consumers. The iPhone, in particular, continues to be a major driver of 
    Apple's growth, with the latest models showcasing advanced features and 
    capabilities that maintain the company's competitive edge in the smartphone market...
    ''',
    publishTime: DateTime.now(),
  ),
  // Add more blog posts as needed
]; 